// Courier delivery screen (/courier/orders/:id) in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/app_router.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/courier/presentation/courier_delivery_screen.dart';
import 'package:davidan_prototype/features/courier/presentation/courier_orders_screen.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/l10n/l10n.dart';
import 'package:davidan_prototype/staff/staff_build.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(
    () async =>
        container = await createTestContainer(overrides: staffBuildOverrides),
  );

  OrderStatus statusOf(String orderId) =>
      container.read(orderByIdProvider(orderId))!.status;

  Finder onDeliveryScreen(Finder finder) =>
      find.descendant(of: find.byType(CourierDeliveryScreen), matching: finder);

  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('from the list, the courier takes the order and hands it over', (
    tester,
  ) async {
    final order = placeTestOrder(container);
    advanceOrderTo(container, order.id, OrderStatus.ready);
    await pumpApp(tester, container, Routes.courierOrders);
    await tapVisible(tester, find.text(order.id));

    expect(onDeliveryScreen(find.text('str. Ismail 88')), findsOneWidget);
    expect(
      onDeliveryScreen(
        find.text(
          ro.amountToCollect('138 lei', ro.paymentMethod(PaymentMethod.cash)),
        ),
      ),
      findsOneWidget,
    );
    expect(
      onDeliveryScreen(find.text(ro.lineItem(2, 'Kurtos cu fistic'))),
      findsOneWidget,
    );

    await tapAndSettle(tester, find.text(ro.advanceTo(OrderStatus.onTheWay)));
    expect(statusOf(order.id), OrderStatus.onTheWay);
    expect(
      onDeliveryScreen(find.text(ro.orderStatus(OrderStatus.onTheWay))),
      findsOneWidget,
    );

    await tapAndSettle(tester, find.text(ro.advanceTo(OrderStatus.completed)));
    expect(statusOf(order.id), OrderStatus.completed);
    expect(find.text(ro.deliveryCompleted), findsOneWidget);

    await tapAndSettle(tester, find.text(ro.backToDeliveries));
    expect(find.byType(CourierOrdersScreen), findsOneWidget);
    expect(find.text(ro.courierEmptyTitle), findsOneWidget);
  });

  testWidgets('opened from a link, back returns to the list', (tester) async {
    final order = placeTestOrder(container);
    advanceOrderTo(container, order.id, OrderStatus.ready);
    await pumpApp(tester, container, Routes.courierDelivery(order.id));
    expect(find.byType(CourierDeliveryScreen), findsOneWidget);

    await tapAndSettle(tester, find.byIcon(Icons.arrow_back_rounded));

    expect(find.byType(CourierDeliveryScreen), findsNothing);
    expect(find.byType(CourierOrdersScreen), findsOneWidget);
    expect(find.text(order.id), findsOneWidget);
  });

  testWidgets('until the shop marks it ready, the courier can only wait', (
    tester,
  ) async {
    final order = placeTestOrder(container);
    advanceOrderTo(container, order.id, OrderStatus.preparing);
    await pumpApp(tester, container, Routes.courierDelivery(order.id));

    expect(find.text(ro.courierWaitingForStore), findsOneWidget);
    expect(find.byType(AppButton), findsNothing);
  });

  testWidgets('pickup orders and unknown ids are not deliveries', (
    tester,
  ) async {
    final pickup = placeTestOrder(
      container,
      fulfilment: const StorePickup(locationId: 'centru'),
    );
    advanceOrderTo(container, pickup.id, OrderStatus.ready);

    await pumpApp(tester, container, Routes.courierDelivery(pickup.id));
    expect(find.text(ro.deliveryNotFound), findsOneWidget);

    container.read(appRouterProvider).go(Routes.courierDelivery('DD-9999'));
    await tester.pumpAndSettle();
    expect(find.text(ro.deliveryNotFound), findsOneWidget);
  });

  testWidgets('fits a 360 x 640 phone with a long address', (tester) async {
    final order = placeTestOrder(
      container,
      fulfilment: const HomeDelivery(
        address:
            'bd. Ștefan cel Mare și Sfânt 126, bloc 3, scara 2, etajul 9, '
            'apartamentul 214, interfon 214K, Chișinău',
      ),
      payment: PaymentMethod.card,
    );
    advanceOrderTo(container, order.id, OrderStatus.ready);
    await pumpApp(
      tester,
      container,
      Routes.courierDelivery(order.id),
      size: const Size(360, 640),
    );

    expect(find.byType(CourierDeliveryScreen), findsOneWidget);
  });
}
