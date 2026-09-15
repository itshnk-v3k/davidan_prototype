// Courier order list (/courier/orders) in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/courier/presentation/courier_delivery_screen.dart';
import 'package:davidan_prototype/features/courier/presentation/courier_orders_screen.dart';
import 'package:davidan_prototype/features/courier/presentation/widgets/courier_order_card.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  List<String> listedOrderIds(WidgetTester tester) => [
    for (final card in tester.widgetList<CourierOrderCard>(
      find.byType(CourierOrderCard),
    ))
      card.order.id,
  ];

  testWidgets('with nothing to deliver the list says so', (tester) async {
    await pumpApp(tester, container, Routes.courierOrders);
    expect(find.text(AppStrings.courierEmptyTitle), findsOneWidget);
  });

  testWidgets('the launcher opens the courier app', (tester) async {
    await pumpApp(tester, container, Routes.launcher);
    await tapVisible(tester, find.text(AppStrings.launcherCourier));
    expect(find.byType(CourierOrdersScreen), findsOneWidget);
  });

  testWidgets(
    'lists only deliveries that are ready or on the way, on the way first',
    (tester) async {
      placeTestOrder(container); // Still with the shop.
      final ready = placeTestOrder(container);
      advanceOrderTo(container, ready.id, OrderStatus.ready);
      final readyPickup = placeTestOrder(
        container,
        fulfilment: const StorePickup(locationId: 'centru'),
      );
      advanceOrderTo(container, readyPickup.id, OrderStatus.ready);
      final onTheWay = placeTestOrder(container);
      advanceOrderTo(container, onTheWay.id, OrderStatus.onTheWay);
      final delivered = placeTestOrder(container);
      advanceOrderTo(container, delivered.id, OrderStatus.completed);

      await pumpApp(tester, container, Routes.courierOrders);

      expect(listedOrderIds(tester), [onTheWay.id, ready.id]);
    },
  );

  testWidgets('a card shows the address, time and what to collect', (
    tester,
  ) async {
    final order = placeTestOrder(
      container,
      payment: PaymentMethod.card,
      scheduledFor: DateTime(2026, 9, 15, 11),
    );
    advanceOrderTo(container, order.id, OrderStatus.ready);
    await pumpApp(tester, container, Routes.courierOrders);

    final card = find.byType(CourierOrderCard);
    Finder inCard(String text) =>
        find.descendant(of: card, matching: find.text(text));
    expect(inCard(order.id), findsOneWidget);
    expect(inCard(AppStrings.orderStatus(OrderStatus.ready)), findsOneWidget);
    expect(inCard('str. Ismail 88'), findsOneWidget);
    expect(inCard('11:00'), findsOneWidget);
    expect(
      inCard(
        AppStrings.amountToCollect(
          '138 lei',
          AppStrings.paymentMethod(PaymentMethod.card),
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('tapping a card opens that delivery', (tester) async {
    final order = placeTestOrder(container);
    advanceOrderTo(container, order.id, OrderStatus.ready);
    await pumpApp(tester, container, Routes.courierOrders);

    await tapVisible(tester, find.byType(CourierOrderCard));

    expect(find.byType(CourierDeliveryScreen), findsOneWidget);
    expect(find.text(AppStrings.deliveryTitle(order.id)), findsOneWidget);
  });

  testWidgets('fits a 360 px wide phone with a long address', (tester) async {
    final order = placeTestOrder(
      container,
      fulfilment: const HomeDelivery(
        address:
            'bd. Ștefan cel Mare și Sfânt 126, bloc 3, scara 2, etajul 9, '
            'apartamentul 214, interfon 214K, Chișinău',
      ),
      scheduledFor: DateTime(2026, 9, 15, 19, 30),
    );
    advanceOrderTo(container, order.id, OrderStatus.onTheWay);
    await pumpApp(
      tester,
      container,
      Routes.courierOrders,
      size: const Size(360, 640),
    );

    expect(find.byType(CourierOrderCard), findsOneWidget);
  });
}
