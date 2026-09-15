// Runs in Chrome against real localStorage, the storage the demo uses:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';
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
      items: const [
        OrderItem(productId: 'espresso', quantity: 2, priceBani: 1500),
        OrderItem(
          productId: 'croissant-ciocolata',
          quantity: 1,
          priceBani: 1900,
        ),
      ],
      fulfilment: const HomeDelivery(address: 'str. Ismail 88'),
      payment: PaymentMethod.card,
      scheduledFor: DateTime(2026, 9, 15, 11),
    );

Order placePickup(ProviderContainer app) => app
    .read(ordersProvider.notifier)
    .place(
      items: const [
        OrderItem(productId: 'americano', quantity: 1, priceBani: 2000),
      ],
      fulfilment: const StorePickup(locationId: 'botanica'),
      payment: PaymentMethod.cash,
    );

/// Advances the order [times] times and returns its status after each step.
List<OrderStatus> advance(ProviderContainer app, String orderId, int times) {
  final statuses = <OrderStatus>[];
  for (var step = 0; step < times; step++) {
    app.read(ordersProvider.notifier).advance(orderId);
    statuses.add(app.read(orderByIdProvider(orderId))!.status);
  }
  return statuses;
}

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

  test('items keep their price; the total is summed from them', () async {
    final app = await startApp();
    addTearDown(app.dispose);

    final order = placeDelivery(app);

    expect([for (final item in order.items) item.priceBani], [1500, 1900]);
    expect(order.totalBani, 2 * 1500 + 1900);
  });

  test('delivery orders go through the courier step to completed', () async {
    final app = await startApp();
    addTearDown(app.dispose);
    final order = placeDelivery(app);

    expect(advance(app, order.id, 6), [
      OrderStatus.accepted,
      OrderStatus.preparing,
      OrderStatus.ready,
      OrderStatus.onTheWay,
      OrderStatus.completed,
      OrderStatus.completed, // Nothing comes after completed.
    ]);
  });

  test('pickup orders skip the courier step', () async {
    final app = await startApp();
    addTearDown(app.dispose);
    final order = placePickup(app);

    expect(advance(app, order.id, 5), [
      OrderStatus.accepted,
      OrderStatus.preparing,
      OrderStatus.ready,
      OrderStatus.completed,
      OrderStatus.completed,
    ]);
  });

  test('status changes survive a restart and touch only that order', () async {
    final session = await startApp();
    final delivery = placeDelivery(session);
    final pickup = placePickup(session);
    advance(session, pickup.id, 2);
    await flushWrites();
    session.dispose();

    final restarted = await startApp();
    addTearDown(restarted.dispose);
    expect(
      restarted.read(orderByIdProvider(pickup.id))?.status,
      OrderStatus.preparing,
    );
    expect(
      restarted.read(orderByIdProvider(delivery.id))?.status,
      OrderStatus.placed,
    );
  });

  test('advancing an unknown order changes nothing', () async {
    final app = await startApp();
    addTearDown(app.dispose);
    final order = placeDelivery(app);

    app.read(ordersProvider.notifier).advance('DD-9999');

    expect(
      [for (final saved in app.read(ordersProvider)) saved.toJson()],
      [order.toJson()],
    );
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
