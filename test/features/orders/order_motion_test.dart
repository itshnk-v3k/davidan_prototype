// Motion on the order screens: the status pill and action bar crossfading on
// the courier's delivery screen, and store panel cards and notices coming in.
// Real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/widgets/entrance.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/kds/presentation/kds_screen.dart';
import 'package:davidan_prototype/features/kds/presentation/widgets/kds_order_card.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/order_status_pill.dart';

import '../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  const tablet = Size(1280, 800);

  /// Partway through a transition: medium ones take 250 ms, entrances 400 ms.
  const midway = Duration(milliseconds: 100);

  Finder statusInPill(OrderStatus status) => find.descendant(
    of: find.byType(OrderStatusPill),
    matching: find.text(AppStrings.orderStatus(status)),
  );

  testWidgets(
    'on the delivery screen the next status crossfades into the pill and the '
    'action bar',
    (tester) async {
      final order = placeTestOrder(container);
      advanceOrderTo(container, order.id, OrderStatus.ready);
      await pumpApp(tester, container, Routes.courierDelivery(order.id));

      await tester.tap(find.text(AppStrings.advanceTo(OrderStatus.onTheWay)));
      await tester.pump();
      await tester.pump(midway);
      final next = container.read(orderByIdProvider(order.id))!.nextStatus!;

      // Old and new are both on screen while they crossfade.
      expect(statusInPill(OrderStatus.ready), findsOneWidget);
      expect(statusInPill(OrderStatus.onTheWay), findsOneWidget);
      expect(
        find.text(AppStrings.advanceTo(OrderStatus.onTheWay)),
        findsOneWidget,
      );
      expect(find.text(AppStrings.advanceTo(next)), findsOneWidget);

      await tester.pumpAndSettle();

      expect(statusInPill(OrderStatus.ready), findsNothing);
      expect(statusInPill(OrderStatus.onTheWay), findsOneWidget);
      expect(
        find.text(AppStrings.advanceTo(OrderStatus.onTheWay)),
        findsNothing,
      );
      expect(find.text(AppStrings.advanceTo(next)), findsOneWidget);
    },
  );

  testWidgets('an accepted order fades into the kitchen column', (
    tester,
  ) async {
    final order = placeTestOrder(container);
    await pumpApp(tester, container, Routes.kds, size: tablet);

    double cardOpacity() => tester
        .widget<Opacity>(
          find
              .descendant(
                of: find
                    .ancestor(
                      of: find.widgetWithText(KdsOrderCard, order.id),
                      matching: find.byType(Entrance),
                    )
                    .first,
                matching: find.byType(Opacity),
              )
              .first,
        )
        .opacity;
    expect(cardOpacity(), 1);

    await tester.tap(find.text(AppStrings.advanceTo(OrderStatus.accepted)));
    await tester.pump();
    await tester.pump(midway);
    expect(cardOpacity(), inExclusiveRange(0, 1));

    await tester.pumpAndSettle();
    expect(cardOpacity(), 1);
  });

  testWidgets('a new-order notice drops in from the top', (tester) async {
    await pumpApp(tester, container, Routes.kds, size: tablet);

    final arriving = placeTestOrder(container);
    await tester.pump();
    await tester.pump(midway);

    Offset noticeOffset() => tester
        .widget<SlideTransition>(
          find
              .ancestor(
                of: find.text(AppStrings.newOrderArrived(arriving.id)),
                matching: find.byType(SlideTransition),
              )
              .first,
        )
        .position
        .value;
    expect(noticeOffset().dy, lessThan(0));

    await tester.pumpAndSettle();
    expect(noticeOffset(), Offset.zero);

    // Let the notice time out so no timer outlives the test.
    await tester.pump(KdsScreen.noticeDuration);
    await tester.pumpAndSettle();
  });
}
