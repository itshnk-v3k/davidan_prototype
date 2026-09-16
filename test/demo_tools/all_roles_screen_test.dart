// Internal all-roles demo board (/demo/roles), in Chrome:
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
import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/demo_tools/all_roles_screen.dart';
import 'package:davidan_prototype/demo_tools/demo_tool_strings.dart';
import 'package:davidan_prototype/features/courier/presentation/courier_delivery_screen.dart';
import 'package:davidan_prototype/features/courier/presentation/courier_orders_screen.dart';
import 'package:davidan_prototype/features/kds/presentation/kds_screen.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/features/orders/presentation/order_confirmation_screen.dart';
import 'package:davidan_prototype/staff/staff_build.dart';

import '../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  Finder customer(Finder finder) => find.descendant(
    of: find.byType(OrderConfirmationScreen),
    matching: finder,
  );
  Finder store(Finder finder) =>
      find.descendant(of: find.byType(KdsScreen), matching: finder);
  Finder courierList(Finder finder) =>
      find.descendant(of: find.byType(CourierOrdersScreen), matching: finder);
  Finder courierDelivery(Finder finder) =>
      find.descendant(of: find.byType(CourierDeliveryScreen), matching: finder);
  Finder chip(String label) => find.widgetWithText(AppChip, label);
  Finder statusLabel(OrderStatus status) =>
      find.text(AppStrings.orderStatus(status));

  group('the customer app build (lib/main.dart)', () {
    setUp(() async => container = await createTestContainer());

    testWidgets('has no board: no launcher entry, and its URL is not found', (
      tester,
    ) async {
      await pumpApp(tester, container, Routes.launcher);
      expect(find.text(DemoToolStrings.allRolesTitle), findsNothing);

      container.read(appRouterProvider).go(AllRolesScreen.path);
      await tester.pumpAndSettle();
      expect(find.byType(AllRolesScreen), findsNothing);
    });
  });

  group('the staff build (lib/main_staff.dart)', () {
    const desktop = Size(1920, 1080);

    setUp(
      () async =>
          container = await createTestContainer(overrides: staffBuildOverrides),
    );

    testWidgets('the launcher links to the board', (tester) async {
      await pumpApp(tester, container, Routes.launcher);
      await tapVisible(tester, find.text(DemoToolStrings.allRolesTitle));
      expect(find.byType(AllRolesScreen), findsOneWidget);
    });

    testWidgets(
      'a test delivery goes through store and courier, and every panel '
      'follows live',
      (tester) async {
        await pumpApp(tester, container, AllRolesScreen.path, size: desktop);
        // Customer and courier delivery panels. (The store panel's own empty
        // state shares the title, so match the board's message.)
        expect(find.text(DemoToolStrings.noOrderMessage), findsNWidgets(2));

        await tester.tap(chip(DemoToolStrings.testDelivery));
        await tester.pumpAndSettle();
        final [order] = container.read(ordersProvider);
        expect(tester.widget<AppChip>(chip(order.id)).selected, isTrue);
        expect(customer(statusLabel(OrderStatus.placed)), findsOneWidget);
        expect(store(find.text(order.id)), findsOneWidget);

        // One frame after each tap, the other panels already show it.
        for (final status in [
          OrderStatus.accepted,
          OrderStatus.preparing,
          OrderStatus.ready,
        ]) {
          await tester.tap(store(find.text(AppStrings.advanceTo(status))));
          await tester.pump();
          expect(customer(statusLabel(status)), findsOneWidget);
          expect(courierDelivery(statusLabel(status)), findsOneWidget);
        }
        expect(courierList(find.text(order.id)), findsOneWidget);

        for (final status in [OrderStatus.onTheWay, OrderStatus.completed]) {
          await tester.tap(
            courierDelivery(find.text(AppStrings.advanceTo(status))),
          );
          await tester.pump();
          expect(customer(statusLabel(status)), findsOneWidget);
        }
        expect(store(find.text(order.id)), findsNothing);
        expect(courierList(find.text(order.id)), findsNothing);
      },
    );

    testWidgets(
      'the order chips switch which order the customer and courier panels '
      'follow',
      (tester) async {
        final first = placeTestOrder(container);
        final second = placeTestOrder(container);
        await pumpApp(tester, container, AllRolesScreen.path, size: desktop);

        // Without ?order= the board follows the newest order.
        expect(
          customer(find.text(AppStrings.orderNumber(second.id))),
          findsOneWidget,
        );

        await tester.tap(chip(first.id));
        await tester.pumpAndSettle();

        expect(
          customer(find.text(AppStrings.orderNumber(first.id))),
          findsOneWidget,
        );
        expect(
          courierDelivery(find.text(AppStrings.deliveryTitle(first.id))),
          findsOneWidget,
        );
        expect(
          container
              .read(appRouterProvider)
              .routerDelegate
              .currentConfiguration
              .uri
              .toString(),
          AllRolesScreen.location(first.id),
        );
      },
    );

    testWidgets('in a narrow window the panels stack and still fit', (
      tester,
    ) async {
      final order = placeTestOrder(container);
      advanceOrderTo(container, order.id, OrderStatus.ready);
      // Tall enough to lay out all four panels without scrolling.
      await pumpApp(
        tester,
        container,
        AllRolesScreen.path,
        size: const Size(420, 3200),
      );

      expect(find.byType(OrderConfirmationScreen), findsOneWidget);
      expect(find.byType(KdsScreen), findsOneWidget);
      expect(find.byType(CourierOrdersScreen), findsOneWidget);
      expect(find.byType(CourierDeliveryScreen), findsOneWidget);
    });
  });
}
