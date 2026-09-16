// The order simulation's timings and catch-up, against real localStorage:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/orders/application/order_simulation.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;
  late DateTime now;

  setUp(() async {
    now = testNow;
    container = await createTestContainer(clock: () => now);
  });

  Order order(String id) => container.read(orderByIdProvider(id))!;

  void simulateUntil(Duration sincePlaced) {
    now = testNow.add(sincePlaced);
    container
        .read(ordersProvider.notifier)
        .advanceDue(now, simulatedNextStepAt);
  }

  test('a delivery is accepted, prepared, collected and handed over, each '
      'step timed from the one before', () {
    final placed = placeTestOrder(container);
    const accepted = SimulatedTimings.accept;
    final preparing = accepted + SimulatedTimings.startPreparing;
    final ready = preparing + SimulatedTimings.prepare;
    final onTheWay = ready + SimulatedTimings.collect;
    final completed =
        onTheWay + courierTripDuration + SimulatedTimings.handOver;

    for (final (sincePlaced, status) in [
      (accepted - const Duration(seconds: 1), OrderStatus.placed),
      (accepted, OrderStatus.accepted),
      (preparing, OrderStatus.preparing),
      (ready, OrderStatus.ready),
      (onTheWay, OrderStatus.onTheWay),
      // The courier has arrived but is still at the door.
      (onTheWay + courierTripDuration, OrderStatus.onTheWay),
      (completed, OrderStatus.completed),
    ]) {
      simulateUntil(sincePlaced);
      expect(order(placed.id).status, status, reason: '$sincePlaced');
    }
    expect(order(placed.id).statusSince, testNow.add(completed));
  });

  test('a pickup order waits for the customer after it is ready', () {
    final placed = placeTestOrder(
      container,
      fulfilment: const StorePickup(locationId: 'botanica'),
    );
    final ready =
        SimulatedTimings.accept +
        SimulatedTimings.startPreparing +
        SimulatedTimings.prepare;

    simulateUntil(ready + SimulatedTimings.pickUp - const Duration(seconds: 1));
    expect(order(placed.id).status, OrderStatus.ready);

    simulateUntil(ready + SimulatedTimings.pickUp);
    expect(order(placed.id).status, OrderStatus.completed);
  });

  test('an order left while the app was closed catches up at once, each step '
      'recorded when it fell due', () {
    final placed = placeTestOrder(container);

    simulateUntil(const Duration(seconds: 40));

    // Accepted at 15 s, preparing since 35 s.
    expect(order(placed.id).status, OrderStatus.preparing);
    expect(
      order(placed.id).statusSince,
      testNow.add(SimulatedTimings.accept + SimulatedTimings.startPreparing),
    );

    simulateUntil(const Duration(hours: 1));
    expect(order(placed.id).status, OrderStatus.completed);
  });

  test('a scheduled delivery starts preparing in time to arrive at its hour, '
      'not straight away', () {
    // Placed at 10:07 for 11:00.
    final scheduledFor = DateTime(2026, 9, 15, 11);
    final placed = placeTestOrder(container, scheduledFor: scheduledFor);
    final startsPreparing = scheduledFor.subtract(
      SimulatedTimings.prepare +
          SimulatedTimings.collect +
          courierTripDuration +
          SimulatedTimings.handOver,
    );

    simulateUntil(
      startsPreparing.difference(testNow) - const Duration(seconds: 1),
    );
    expect(order(placed.id).status, OrderStatus.accepted);

    simulateUntil(startsPreparing.difference(testNow));
    expect(order(placed.id).status, OrderStatus.preparing);

    simulateUntil(scheduledFor.difference(testNow));
    expect(order(placed.id).status, OrderStatus.completed);
  });

  test('nothing due leaves the orders untouched', () {
    placeTestOrder(container);
    final before = container.read(ordersProvider);

    simulateUntil(const Duration(seconds: 5));

    expect(container.read(ordersProvider), same(before));
  });
}
