import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/app.dart';
import 'package:davidan_prototype/core/location/location_result.dart';
import 'package:davidan_prototype/core/location/location_service.dart';
import 'package:davidan_prototype/core/router/app_router.dart';
import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/data/mock/bakery/bakery_shops.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/chisinau_sector.dart';
import 'package:davidan_prototype/data/models/customer_account.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/account/application/account_notifier.dart';
import 'package:davidan_prototype/features/account/application/nearby.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

import 'fake_location_service.dart';

/// The app's text in Romanian, its default language, for finding widgets by
/// what they say.
final ro = lookupAppLocalizations(const Locale('ro'));

/// "Now" in widget tests: 15 September 2026, 10:07.
final testNow = DateTime(2026, 9, 15, 10, 7);

/// Providers wired the way bootstrap() wires them, on emptied local storage
/// and with [clock] as the time source ([testNow], standing still, by
/// default). The phone's location comes from [locationService], a fake that
/// reports it unavailable unless a test passes another. Pass an entry point's
/// [overrides] (e.g. staffBuildOverrides) to test that build. Call from setUp;
/// disposed on tear down.
Future<ProviderContainer> createTestContainer({
  DateTime Function()? clock,
  LocationService? locationService,
  List<Override> overrides = const [],
}) async {
  final prefs = await LocalStore.openPreferences();
  await prefs.clear();
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      clockProvider.overrideWithValue(clock ?? () => testNow),
      locationServiceProvider.overrideWithValue(
        locationService ??
            FakeLocationService.failing(LocationFailure.unavailable),
      ),
      ...overrides,
    ],
  );
  addTearDown(container.dispose);
  return container;
}

/// Boots providers the way main() does, on whatever storage already holds.
/// Each call reads storage from scratch, like reloading the page. Pass an
/// entry point's [overrides] to boot that build. Dispose the container when
/// done.
Future<ProviderContainer> startApp({
  List<Override> overrides = const [],
}) async {
  final prefs = await LocalStore.openPreferences();
  return ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      locationServiceProvider.overrideWithValue(
        FakeLocationService.failing(LocationFailure.unavailable),
      ),
      ...overrides,
    ],
  );
}

/// Lets fire-and-forget storage writes finish.
Future<void> flushWrites() => Future<void>.delayed(Duration.zero);

/// Pumps the real app (router, screens, Notifiers) at [location]. The default
/// viewport is phone-sized, so the app renders without the desktop frame.
Future<void> pumpApp(
  WidgetTester tester,
  ProviderContainer container,
  String location, {
  Size size = const Size(400, 900),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const DaviDanApp()),
  );
  container.read(appRouterProvider).go(location);
  await tester.pumpAndSettle();
}

Finder inScreen<T>(Finder finder) =>
    find.descendant(of: find.byType(T), matching: finder);

/// Scrolls [finder] to the middle of its scroll view, clear of any header
/// pinned at the top, then taps it.
Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await Scrollable.ensureVisible(tester.element(finder), alignment: 0.5);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Signs in the way the demo sign-in would, without its screens: +373 69 123
/// 456, with the shop nearest [sector].
CustomerAccount signInTestAccount(
  ProviderContainer container, {
  String name = 'Ana Popescu',
  ChisinauSector sector = ChisinauSector.botanica,
}) {
  final account = CustomerAccount(
    phone: '69123456',
    name: name,
    sector: sector,
    nearestLocationId: nearestLocationToSector(sector, bakeryShops).id,
    matchedBy: ShopMatch.sector,
  );
  container.read(accountProvider.notifier).register(account);
  return account;
}

/// Places an order the way checkout does, without going through its screen.
/// The default items total 138 lei.
Order placeTestOrder(
  ProviderContainer container, {
  Fulfilment fulfilment = const HomeDelivery(address: 'str. Ismail 88'),
  PaymentMethod payment = PaymentMethod.cash,
  DateTime? scheduledFor,
}) => container
    .read(ordersProvider.notifier)
    .place(
      brand: Brand.bakery,
      items: const [
        OrderItem(productId: 'kurtos-fistic', quantity: 2, priceBani: 5900),
        OrderItem(productId: 'americano', quantity: 1, priceBani: 2000),
      ],
      fulfilment: fulfilment,
      payment: payment,
      scheduledFor: scheduledFor,
    );

/// Advances the order until it has [status], as the shop and courier would.
void advanceOrderTo(
  ProviderContainer container,
  String orderId,
  OrderStatus status,
) {
  for (var step = 0; step <= OrderStatus.values.length; step++) {
    if (container.read(orderByIdProvider(orderId))!.status == status) return;
    container.read(ordersProvider.notifier).advance(orderId);
  }
  throw StateError('Order $orderId never reaches $status');
}
