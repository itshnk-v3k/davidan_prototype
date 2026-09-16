// The pretend courier map, on the customer's order screen and the courier's
// delivery screen, in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/courier_route_map.dart';
import 'package:davidan_prototype/l10n/l10n.dart';
import 'package:davidan_prototype/staff/staff_build.dart';

import '../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;
  late DateTime now;

  setUp(() async {
    now = testNow;
    // The courier app shows the map too, and nothing may move the order on
    // by itself while the clock does.
    container = await createTestContainer(
      clock: () => now,
      overrides: staffBuildOverrides,
    );
  });

  Offset centerOf(WidgetTester tester, IconData icon) => tester.getCenter(
    find.descendant(
      of: find.byType(CourierRouteMap),
      matching: find.byIcon(icon),
    ),
  );
  Offset courier(WidgetTester tester) =>
      centerOf(tester, Icons.delivery_dining_rounded);
  Offset shop(WidgetTester tester) =>
      centerOf(tester, Icons.storefront_rounded);
  Offset customer(WidgetTester tester) => centerOf(tester, Icons.home_rounded);

  /// Moves the clock on, lets the map's once-a-second tick notice, and waits
  /// for the courier to finish gliding.
  Future<void> passTime(WidgetTester tester, Duration duration) async {
    now = now.add(duration);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  }

  Order deliveryOnTheWay({
    Fulfilment fulfilment = const HomeDelivery(address: 'str. Ismail 88'),
  }) {
    final order = placeTestOrder(container, fulfilment: fulfilment);
    advanceOrderTo(container, order.id, OrderStatus.onTheWay);
    return order;
  }

  testWidgets(
    'the customer sees the map only while the courier has the order',
    (tester) async {
      final order = placeTestOrder(container);
      advanceOrderTo(container, order.id, OrderStatus.ready);
      await pumpApp(tester, container, Routes.clientOrder(order.id));
      expect(find.byType(CourierRouteMap), findsNothing);

      container.read(ordersProvider.notifier).advance(order.id);
      await tester.pumpAndSettle();

      expect(find.byType(CourierRouteMap), findsOneWidget);
      expect(find.text(ro.courierArrivesIn(2)), findsOneWidget);
      expect((courier(tester) - shop(tester)).distance, lessThan(1));

      container.read(ordersProvider.notifier).advance(order.id);
      await tester.pumpAndSettle();
      expect(find.byType(CourierRouteMap), findsNothing);
    },
  );

  testWidgets(
    'the courier moves along the route as time passes and waits at the door '
    'once the trip is over',
    (tester) async {
      final order = deliveryOnTheWay();
      await pumpApp(tester, container, Routes.clientOrder(order.id));
      final start = courier(tester);

      await passTime(tester, const Duration(minutes: 1));
      expect(courier(tester), isNot(start));
      expect(find.text(ro.courierArrivesIn(1)), findsOneWidget);

      await passTime(tester, const Duration(minutes: 1));
      expect(find.text(ro.courierArrived), findsOneWidget);
      expect((courier(tester) - customer(tester)).distance, lessThan(1));

      await passTime(tester, const Duration(minutes: 5));
      expect((courier(tester) - customer(tester)).distance, lessThan(1));
    },
  );

  testWidgets('opened later, the map shows where the courier already is', (
    tester,
  ) async {
    final order = deliveryOnTheWay();
    now = now.add(const Duration(seconds: 90));
    await pumpApp(tester, container, Routes.clientOrder(order.id));

    expect(find.text(ro.courierArrivesIn(1)), findsOneWidget);
    expect((courier(tester) - shop(tester)).distance, greaterThan(1));
    expect((courier(tester) - customer(tester)).distance, greaterThan(1));
  });

  testWidgets('the courier sees the same map after taking the order', (
    tester,
  ) async {
    final order = placeTestOrder(container);
    advanceOrderTo(container, order.id, OrderStatus.ready);
    await pumpApp(tester, container, Routes.courierDelivery(order.id));
    expect(find.byType(CourierRouteMap), findsNothing);

    await tapVisible(tester, find.text(ro.advanceTo(OrderStatus.onTheWay)));

    expect(find.byType(CourierRouteMap), findsOneWidget);
    expect(find.text(ro.courierArrivesIn(2)), findsOneWidget);
  });

  testWidgets('fits a 360 x 640 phone on both screens', (tester) async {
    final order = deliveryOnTheWay(
      fulfilment: const HomeDelivery(
        address:
            'bd. Ștefan cel Mare și Sfânt 126, bloc 3, scara 2, etajul 9, '
            'apartamentul 214, interfon 214K, Chișinău',
      ),
    );
    const phone = Size(360, 640);

    await pumpApp(tester, container, Routes.clientOrder(order.id), size: phone);
    expect(find.byType(CourierRouteMap), findsOneWidget);

    await pumpApp(
      tester,
      container,
      Routes.courierDelivery(order.id),
      size: phone,
    );
    expect(find.byType(CourierRouteMap), findsOneWidget);
  });
}
