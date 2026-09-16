// Cross-role sync, in Chrome:
//   flutter test --platform chrome
//
// The customer's tracking screen, the store panel, the courier list and the
// courier delivery screen are all on screen at once, sharing one
// ProviderContainer as they do in the app. Each role's action must show up on
// the other screens in the very next frame, with no navigation or reload.
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_theme.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/client/presentation/orders/order_confirmation_screen.dart';
import 'package:davidan_prototype/features/courier/presentation/courier_delivery_screen.dart';
import 'package:davidan_prototype/features/courier/presentation/courier_orders_screen.dart';
import 'package:davidan_prototype/features/kds/presentation/kds_screen.dart';
import 'package:davidan_prototype/features/kds/presentation/widgets/kds_order_card.dart';
import 'package:davidan_prototype/staff/staff_build.dart';

import '../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(
    () async =>
        container = await createTestContainer(overrides: staffBuildOverrides),
  );

  Future<void> pumpAllRoles(WidgetTester tester, String orderId) async {
    tester.view.physicalSize = const Size(2160, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 400,
                child: OrderConfirmationScreen(orderId: orderId),
              ),
              const Expanded(child: KdsScreen()),
              const SizedBox(width: 400, child: CourierOrdersScreen()),
              SizedBox(
                width: 400,
                child: CourierDeliveryScreen(orderId: orderId),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder customer(Finder finder) => find.descendant(
    of: find.byType(OrderConfirmationScreen),
    matching: finder,
  );
  Finder store(Finder finder) =>
      find.descendant(of: find.byType(KdsScreen), matching: finder);
  // The panel's "Gata" column title matches the ready status label too, so
  // status checks look inside the order ticket.
  Finder storeTicket(Finder finder) =>
      find.descendant(of: find.byType(KdsOrderCard), matching: finder);
  Finder courierList(Finder finder) =>
      find.descendant(of: find.byType(CourierOrdersScreen), matching: finder);
  Finder courierDelivery(Finder finder) =>
      find.descendant(of: find.byType(CourierDeliveryScreen), matching: finder);

  /// Taps, then renders exactly one frame: whatever changed elsewhere must
  /// already be visible.
  Future<void> tapOnce(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pump();
  }

  Finder statusLabel(OrderStatus status) =>
      find.text(AppStrings.orderStatus(status));

  testWidgets(
    'a delivery goes from store panel to courier, and the customer and '
    'courier screens follow every step live',
    (tester) async {
      final order = placeTestOrder(container);
      await pumpAllRoles(tester, order.id);

      expect(customer(statusLabel(OrderStatus.placed)), findsOneWidget);
      expect(store(find.text(order.id)), findsOneWidget);
      expect(courierList(find.text(order.id)), findsNothing);
      expect(
        courierDelivery(find.text(AppStrings.courierWaitingForStore)),
        findsOneWidget,
      );

      // Store panel: accept, prepare, mark ready.
      for (final status in [
        OrderStatus.accepted,
        OrderStatus.preparing,
        OrderStatus.ready,
      ]) {
        await tapOnce(tester, store(find.text(AppStrings.advanceTo(status))));
        expect(customer(statusLabel(status)), findsOneWidget);
        expect(courierDelivery(statusLabel(status)), findsOneWidget);
        expect(storeTicket(statusLabel(status)), findsOneWidget);
      }
      expect(store(find.text(AppStrings.waitingForCourier)), findsOneWidget);
      expect(courierList(find.text(order.id)), findsOneWidget);

      // Courier: take the order from the shop.
      await tapOnce(
        tester,
        courierDelivery(find.text(AppStrings.advanceTo(OrderStatus.onTheWay))),
      );
      expect(customer(statusLabel(OrderStatus.onTheWay)), findsOneWidget);
      expect(courierList(statusLabel(OrderStatus.onTheWay)), findsOneWidget);
      expect(store(find.text(order.id)), findsNothing);

      // Courier: hand it over.
      await tapOnce(
        tester,
        courierDelivery(find.text(AppStrings.advanceTo(OrderStatus.completed))),
      );
      expect(customer(statusLabel(OrderStatus.completed)), findsOneWidget);
      expect(
        courierDelivery(find.text(AppStrings.deliveryCompleted)),
        findsOneWidget,
      );
      expect(courierList(find.text(order.id)), findsNothing);
    },
  );

  testWidgets(
    'a pickup order is finished on the store panel and never reaches the '
    'courier',
    (tester) async {
      final order = placeTestOrder(
        container,
        fulfilment: const StorePickup(locationId: 'botanica'),
      );
      await pumpAllRoles(tester, order.id);

      for (final status in [
        OrderStatus.accepted,
        OrderStatus.preparing,
        OrderStatus.ready,
        OrderStatus.completed,
      ]) {
        await tapOnce(tester, store(find.text(AppStrings.advanceTo(status))));
        expect(customer(statusLabel(status)), findsOneWidget);
        expect(courierList(find.text(order.id)), findsNothing);
      }
      expect(store(find.text(order.id)), findsNothing);
      expect(
        courierDelivery(find.text(AppStrings.deliveryNotFound)),
        findsOneWidget,
      );
    },
  );
}
