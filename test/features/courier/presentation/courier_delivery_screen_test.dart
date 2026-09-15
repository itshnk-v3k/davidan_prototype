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
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/courier/presentation/courier_delivery_screen.dart';
import 'package:davidan_prototype/features/courier/presentation/courier_orders_screen.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

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
          AppStrings.amountToCollect(
            '138 lei',
            AppStrings.paymentMethod(PaymentMethod.cash),
          ),
        ),
      ),
      findsOneWidget,
    );
    expect(
      onDeliveryScreen(find.text(AppStrings.lineItem(2, 'Kurtos cu fistic'))),
      findsOneWidget,
    );

    await tapAndSettle(
      tester,
      find.text(AppStrings.advanceTo(OrderStatus.onTheWay)),
    );
    expect(statusOf(order.id), OrderStatus.onTheWay);
    expect(
      onDeliveryScreen(find.text(AppStrings.orderStatus(OrderStatus.onTheWay))),
      findsOneWidget,
    );

    await tapAndSettle(
      tester,
      find.text(AppStrings.advanceTo(OrderStatus.completed)),
    );
    expect(statusOf(order.id), OrderStatus.completed);
    expect(find.text(AppStrings.deliveryCompleted), findsOneWidget);

    await tapAndSettle(tester, find.text(AppStrings.backToDeliveries));
    expect(find.byType(CourierOrdersScreen), findsOneWidget);
    expect(find.text(AppStrings.courierEmptyTitle), findsOneWidget);
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

    expect(find.text(AppStrings.courierWaitingForStore), findsOneWidget);
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
    expect(find.text(AppStrings.deliveryNotFound), findsOneWidget);

    container.read(appRouterProvider).go(Routes.courierDelivery('DD-9999'));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.deliveryNotFound), findsOneWidget);
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
