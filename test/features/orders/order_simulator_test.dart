// Orders moving on by themselves in the customer app build, which has no
// store panel or courier app, in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/orders/application/order_simulation.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/features/orders/presentation/order_confirmation_screen.dart';
import 'package:davidan_prototype/features/orders/presentation/order_simulator.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/courier_route_map.dart';
import 'package:davidan_prototype/l10n/l10n.dart';
import 'package:davidan_prototype/staff/staff_build.dart';

import '../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late DateTime now;

  setUp(() => now = testNow);

  /// Moves the clock to [sincePlaced] after the order was placed and lets the
  /// simulator's once-a-second tick notice.
  Future<void> passTimeTo(WidgetTester tester, Duration sincePlaced) async {
    now = testNow.add(sincePlaced);
    await tester.pump(OrderSimulator.interval);
    await tester.pumpAndSettle();
  }

  Finder status(OrderStatus status) =>
      inScreen<OrderConfirmationScreen>(find.text(ro.orderStatus(status)));

  testWidgets(
    'the customer watches a delivery go through every status, with the '
    'courier map while it is on the way',
    (tester) async {
      final container = await createTestContainer(clock: () => now);
      final order = placeTestOrder(container);
      await pumpApp(tester, container, Routes.clientOrder(order.id));
      expect(status(OrderStatus.placed), findsOneWidget);

      const accepted = SimulatedTimings.accept;
      final preparing = accepted + SimulatedTimings.startPreparing;
      final ready = preparing + SimulatedTimings.prepare;
      final onTheWay = ready + SimulatedTimings.collect;
      final completed =
          onTheWay + courierTripDuration + SimulatedTimings.handOver;

      for (final (sincePlaced, expected) in [
        (accepted, OrderStatus.accepted),
        (preparing, OrderStatus.preparing),
        (ready, OrderStatus.ready),
        (onTheWay, OrderStatus.onTheWay),
      ]) {
        await passTimeTo(tester, sincePlaced);
        expect(status(expected), findsOneWidget, reason: '$sincePlaced');
      }
      expect(find.byType(CourierRouteMap), findsOneWidget);

      // At the door: the map says the courier has arrived.
      await passTimeTo(tester, onTheWay + courierTripDuration);
      expect(find.text(ro.courierArrived), findsOneWidget);

      await passTimeTo(tester, completed);
      expect(status(OrderStatus.completed), findsOneWidget);
      expect(find.byType(CourierRouteMap), findsNothing);
    },
  );

  testWidgets(
    'in the staff build orders wait for the store panel and the courier',
    (tester) async {
      final container = await createTestContainer(
        clock: () => now,
        overrides: staffBuildOverrides,
      );
      final order = placeTestOrder(container);
      await pumpApp(tester, container, Routes.clientOrder(order.id));

      await passTimeTo(tester, const Duration(hours: 1));

      expect(find.byType(OrderSimulator), findsNothing);
      expect(
        container.read(orderByIdProvider(order.id))!.status,
        OrderStatus.placed,
      );
      expect(status(OrderStatus.placed), findsOneWidget);
    },
  );
}
