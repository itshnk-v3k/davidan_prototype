// Runs in Chrome against real localStorage, the storage the demo uses:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/data/models/cart_item.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/launcher/application/demo_reset_notifier.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';

/// Boots providers the way main() does. Each call reads storage from scratch,
/// like reloading the page.
Future<ProviderContainer> startApp() async {
  final prefs = await LocalStore.openPreferences();
  return ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
}

/// Lets fire-and-forget storage writes finish.
Future<void> flushWrites() => Future<void>.delayed(Duration.zero);

Order placeDelivery(ProviderContainer app) => app
    .read(ordersProvider.notifier)
    .place(
      items: const [CartItem(productId: 'espresso', quantity: 2)],
      totalBani: 3000,
      fulfilment: const HomeDelivery(address: 'str. Ismail 88'),
      payment: PaymentMethod.card,
      scheduledFor: DateTime(2026, 9, 15, 11),
    );

Order placePickup(ProviderContainer app) => app
    .read(ordersProvider.notifier)
    .place(
      items: const [CartItem(productId: 'americano', quantity: 1)],
      totalBani: 2000,
      fulfilment: const StorePickup(locationId: 'botanica'),
      payment: PaymentMethod.cash,
    );

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  setUp(() async {
    final app = await startApp();
    await app.read(localStoreProvider).clearAll();
    app.dispose();
  });

  test(
    'orders survive an app restart, newest first, field for field',
    () async {
      final session = await startApp();
      final delivery = placeDelivery(session);
      final pickup = placePickup(session);
      await flushWrites();
      session.dispose();

      final restarted = await startApp();
      addTearDown(restarted.dispose);
      expect(
        [for (final order in restarted.read(ordersProvider)) order.toJson()],
        [pickup.toJson(), delivery.toJson()],
      );
    },
  );

  test('new orders are numbered from DD-1001 and start as placed', () async {
    final app = await startApp();
    addTearDown(app.dispose);

    final first = placeDelivery(app);
    final second = placePickup(app);

    expect([first.id, second.id], ['DD-1001', 'DD-1002']);
    expect(first.status, OrderStatus.placed);
    expect(
      app.read(orderByIdProvider('DD-1002'))?.fulfilment,
      isA<StorePickup>(),
    );
    expect(app.read(orderByIdProvider('DD-9999')), isNull);
  });

  test('demo reset removes orders now and after a restart', () async {
    final session = await startApp();
    placeDelivery(session);
    await flushWrites();

    await session.read(demoResetProvider.notifier).reset();
    expect(session.read(ordersProvider), isEmpty);
    session.dispose();

    final restarted = await startApp();
    addTearDown(restarted.dispose);
    expect(restarted.read(ordersProvider), isEmpty);
  });

  test('unreadable saved orders fall back to an empty list', () async {
    final prefs = await LocalStore.openPreferences();
    await prefs.setString(
      'davidan.v${LocalStore.schemaVersion}.${StorageKeys.orders}',
      '[{"id": 42}]',
    );

    final app = await startApp();
    addTearDown(app.dispose);
    expect(app.read(ordersProvider), isEmpty);
  });
}
