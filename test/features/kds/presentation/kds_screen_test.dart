// Store panel (/kds) in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/kds/application/kds_providers.dart';
import 'package:davidan_prototype/features/kds/presentation/kds_screen.dart';
import 'package:davidan_prototype/features/kds/presentation/widgets/kds_order_card.dart';
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

  const tablet = Size(1280, 800);

  Finder card(String orderId) => find.widgetWithText(KdsOrderCard, orderId);

  Finder inCard(String orderId, Finder finder) =>
      find.descendant(of: card(orderId), matching: finder);

  Finder inColumn(KdsColumn column, Finder finder) =>
      find.descendant(of: find.byKey(ValueKey(column)), matching: finder);

  Finder notice(String orderId) =>
      find.text(AppStrings.newOrderArrived(orderId));
  final anyNotice = find.textContaining(AppStrings.newOrderArrived(''));

  OrderStatus statusOf(String orderId) =>
      container.read(orderByIdProvider(orderId))!.status;

  Future<void> tapInCard(
    WidgetTester tester,
    String orderId,
    String label,
  ) async {
    await tester.tap(inCard(orderId, find.text(label)));
    await tester.pumpAndSettle();
  }

  Future<void> waitOutNotice(WidgetTester tester) async {
    await tester.pump(KdsScreen.noticeDuration);
    await tester.pumpAndSettle();
  }

  testWidgets('with no orders the panel says so', (tester) async {
    await pumpApp(tester, container, Routes.kds, size: tablet);
    expect(find.text(AppStrings.kdsEmptyTitle), findsOneWidget);
  });

  testWidgets('the launcher opens the store panel', (tester) async {
    await pumpApp(tester, container, Routes.launcher);
    await tapVisible(tester, find.text(AppStrings.launcherKds));
    expect(find.byType(KdsScreen), findsOneWidget);
  });

  testWidgets(
    'a new order shows its number, items, fulfilment and time since placed',
    (tester) async {
      final order = placeTestOrder(
        container,
        scheduledFor: DateTime(2026, 9, 15, 11),
      );
      now = testNow.add(const Duration(minutes: 12, seconds: 30));
      await pumpApp(tester, container, Routes.kds, size: tablet);

      expect(inColumn(KdsColumn.incoming, card(order.id)), findsOneWidget);
      expect(
        inCard(order.id, find.text(AppStrings.lineItem(2, 'Kurtos cu fistic'))),
        findsOneWidget,
      );
      expect(
        inCard(order.id, find.text(AppStrings.lineItem(1, 'Americano'))),
        findsOneWidget,
      );
      expect(
        inCard(
          order.id,
          find.text(
            '${AppStrings.delivery} · ${AppStrings.scheduledAt('11:00')}',
          ),
        ),
        findsOneWidget,
      );
      // Counted from the saved placement time: opening the panel 12½ minutes
      // later shows the whole wait, not 00:00.
      expect(inCard(order.id, find.text('12:30')), findsOneWidget);

      now = now.add(const Duration(seconds: 5));
      await tester.pump(const Duration(seconds: 1));
      expect(inCard(order.id, find.text('12:35')), findsOneWidget);
    },
  );

  testWidgets('the timer turns amber at 10 minutes and red at 15', (
    tester,
  ) async {
    final order = placeTestOrder(container);
    now = testNow.add(const Duration(minutes: 9, seconds: 59));
    await pumpApp(tester, container, Routes.kds, size: tablet);

    final colors = tester.element(card(order.id)).colors;
    Color? colorOf(String time) =>
        tester.widget<Text>(inCard(order.id, find.text(time))).style?.color;
    expect(colorOf('09:59'), colors.textSecondary);

    now = now.add(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(colorOf('10:00'), colors.warning);

    now = testNow.add(const Duration(minutes: 14, seconds: 59));
    await tester.pump(const Duration(seconds: 1));
    expect(colorOf('14:59'), colors.warning);

    now = now.add(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(colorOf('15:00'), colors.error);
  });

  testWidgets('new orders stand out until the shop accepts them', (
    tester,
  ) async {
    final order = placeTestOrder(container);
    await pumpApp(tester, container, Routes.kds, size: tablet);

    BoxBorder? borderOf(String orderId) =>
        (tester
                    .widget<DecoratedBox>(
                      find
                          .descendant(
                            of: card(orderId),
                            matching: find.byType(DecoratedBox),
                          )
                          .first,
                    )
                    .decoration
                as BoxDecoration)
            .border;

    final colors = tester.element(card(order.id)).colors;
    expect(inCard(order.id, find.text(AppStrings.kdsNewTag)), findsOneWidget);
    expect(borderOf(order.id), Border.all(color: colors.primary, width: 2));

    await tapInCard(
      tester,
      order.id,
      AppStrings.advanceTo(OrderStatus.accepted),
    );

    expect(inCard(order.id, find.text(AppStrings.kdsNewTag)), findsNothing);
    expect(borderOf(order.id), Border.all(color: colors.border));
  });

  testWidgets(
    'an order placed while the panel is open is announced; orders already '
    'there and orders moving on are not',
    (tester) async {
      final waiting = placeTestOrder(container);
      await pumpApp(tester, container, Routes.kds, size: tablet);
      expect(anyNotice, findsNothing);

      final arriving = placeTestOrder(container);
      await tester.pumpAndSettle();

      expect(notice(arriving.id), findsOneWidget);
      expect(inColumn(KdsColumn.incoming, card(arriving.id)), findsOneWidget);
      // It floats over the columns without catching taps meant for them.
      expect(
        find.ancestor(
          of: notice(arriving.id),
          matching: find.byWidgetPredicate(
            (widget) => widget is IgnorePointer && widget.ignoring,
          ),
        ),
        findsWidgets,
      );

      // Still up just before its time, gone after.
      await tester.pump(KdsScreen.noticeDuration - const Duration(seconds: 1));
      expect(notice(arriving.id), findsOneWidget);
      await waitOutNotice(tester);
      expect(anyNotice, findsNothing);

      await tapInCard(
        tester,
        waiting.id,
        AppStrings.advanceTo(OrderStatus.accepted),
      );
      expect(anyNotice, findsNothing);
    },
  );

  testWidgets('a second arrival replaces the first notice', (tester) async {
    await pumpApp(tester, container, Routes.kds, size: tablet);

    final first = placeTestOrder(container);
    await tester.pumpAndSettle();
    final second = placeTestOrder(container);
    await tester.pumpAndSettle();

    expect(notice(second.id), findsOneWidget);
    expect(notice(first.id), findsNothing);

    await waitOutNotice(tester);
    expect(anyNotice, findsNothing);
  });

  testWidgets('orders queue oldest first', (tester) async {
    final first = placeTestOrder(container);
    now = testNow.add(const Duration(minutes: 3));
    final second = placeTestOrder(container);
    await pumpApp(tester, container, Routes.kds, size: tablet);

    expect(
      tester.getTopLeft(card(first.id)).dy,
      lessThan(tester.getTopLeft(card(second.id)).dy),
    );
  });

  testWidgets(
    'the shop accepts, prepares and readies a delivery, which then waits '
    'for the courier',
    (tester) async {
      final order = placeTestOrder(container);
      await pumpApp(tester, container, Routes.kds, size: tablet);

      await tapInCard(
        tester,
        order.id,
        AppStrings.advanceTo(OrderStatus.accepted),
      );
      expect(statusOf(order.id), OrderStatus.accepted);
      expect(inColumn(KdsColumn.incoming, card(order.id)), findsNothing);
      expect(inColumn(KdsColumn.inKitchen, card(order.id)), findsOneWidget);

      await tapInCard(
        tester,
        order.id,
        AppStrings.advanceTo(OrderStatus.preparing),
      );
      expect(statusOf(order.id), OrderStatus.preparing);
      expect(
        inCard(
          order.id,
          find.text(AppStrings.orderStatus(OrderStatus.preparing)),
        ),
        findsOneWidget,
      );

      await tapInCard(
        tester,
        order.id,
        AppStrings.advanceTo(OrderStatus.ready),
      );
      expect(statusOf(order.id), OrderStatus.ready);
      expect(inColumn(KdsColumn.ready, card(order.id)), findsOneWidget);
      expect(
        inCard(order.id, find.text(AppStrings.waitingForCourier)),
        findsOneWidget,
      );
      expect(inCard(order.id, find.byType(AppButton)), findsNothing);
    },
  );

  testWidgets('the shop hands a ready pickup order over itself', (
    tester,
  ) async {
    final order = placeTestOrder(
      container,
      fulfilment: const StorePickup(locationId: 'botanica'),
    );
    advanceOrderTo(container, order.id, OrderStatus.ready);
    await pumpApp(tester, container, Routes.kds, size: tablet);

    expect(
      inCard(
        order.id,
        find.text(
          '${AppStrings.pickupAt('DaviDan Botanica')} · '
          '${AppStrings.asSoonAsPossible}',
        ),
      ),
      findsOneWidget,
    );

    await tapInCard(
      tester,
      order.id,
      AppStrings.advanceTo(OrderStatus.completed),
    );
    expect(statusOf(order.id), OrderStatus.completed);
    expect(card(order.id), findsNothing);
    expect(find.text(AppStrings.kdsEmptyTitle), findsOneWidget);
  });

  testWidgets('orders with the courier or completed are off the panel', (
    tester,
  ) async {
    final withCourier = placeTestOrder(container);
    advanceOrderTo(container, withCourier.id, OrderStatus.onTheWay);
    final pickedUp = placeTestOrder(
      container,
      fulfilment: const StorePickup(locationId: 'centru'),
    );
    advanceOrderTo(container, pickedUp.id, OrderStatus.completed);
    final waiting = placeTestOrder(container);
    await pumpApp(tester, container, Routes.kds, size: tablet);

    expect(find.byType(KdsOrderCard), findsOneWidget);
    expect(card(waiting.id), findsOneWidget);
  });

  testWidgets('on a phone the columns stack and still fit', (tester) async {
    final incoming = placeTestOrder(container);
    final inKitchen = placeTestOrder(
      container,
      fulfilment: const StorePickup(locationId: 'buiucani'),
      scheduledFor: DateTime(2026, 9, 15, 12, 30),
    );
    advanceOrderTo(container, inKitchen.id, OrderStatus.preparing);
    final ready = placeTestOrder(container);
    advanceOrderTo(container, ready.id, OrderStatus.ready);
    // Tall enough to lay out every card without scrolling.
    await pumpApp(tester, container, Routes.kds, size: const Size(360, 2400));

    expect(inColumn(KdsColumn.incoming, card(incoming.id)), findsOneWidget);
    expect(
      inCard(incoming.id, find.text(AppStrings.kdsNewTag)),
      findsOneWidget,
    );
    expect(inColumn(KdsColumn.inKitchen, card(inKitchen.id)), findsOneWidget);
    expect(inColumn(KdsColumn.ready, card(ready.id)), findsOneWidget);
    expect(
      tester.getTopLeft(card(incoming.id)).dy,
      lessThan(tester.getTopLeft(card(inKitchen.id)).dy),
    );
  });
}
