// The Comenzi tab (/client/orders) in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/account/presentation/sign_in/sign_in_phone_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/brand_feed_screen.dart';
import 'package:davidan_prototype/features/orders/presentation/order_confirmation_screen.dart';
import 'package:davidan_prototype/features/orders/presentation/orders_screen.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

import '../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  Finder inOrders(Finder finder) => inScreen<OrdersScreen>(finder);

  testWidgets('the Comenzi tab opens it', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);
    await tester.tap(find.text(ro.navOrders));
    await tester.pumpAndSettle();

    expect(find.byType(OrdersScreen), findsOneWidget);
    expect(inOrders(find.text(ro.navOrders)), findsOneWidget);
  });

  testWidgets(
    'signed out it is locked: no orders, and "Intră în cont" opens the '
    'sign-in',
    (tester) async {
      placeTestOrder(container);
      await pumpApp(tester, container, Routes.clientOrders);

      expect(inOrders(find.text(ro.accountLockedTitle)), findsOneWidget);
      expect(inOrders(find.text('138 lei')), findsNothing);

      await tapVisible(tester, find.text(ro.signInTitle));
      expect(find.byType(SignInPhoneScreen), findsOneWidget);
    },
  );

  testWidgets('without orders: an empty state that leads back to the hub', (
    tester,
  ) async {
    signInTestAccount(container);
    await pumpApp(tester, container, Routes.clientOrders);

    expect(inOrders(find.text(ro.ordersEmptyTitle)), findsOneWidget);

    await tapVisible(tester, inOrders(find.text(ro.backHome)));
    expect(find.byType(BrandFeedScreen), findsOneWidget);
  });

  testWidgets(
    'order history: newest first, with date, fulfilment, total and a status '
    'that follows the store',
    (tester) async {
      signInTestAccount(container);
      final delivery = placeTestOrder(container);
      final pickup = placeTestOrder(
        container,
        fulfilment: const StorePickup(locationId: 'botanica'),
      );
      await pumpApp(tester, container, Routes.clientOrders);

      expect(inOrders(find.text(ro.ordersEmptyTitle)), findsNothing);
      expect(
        tester.getTopLeft(find.text(ro.orderNumber(pickup.id))).dy,
        lessThan(tester.getTopLeft(find.text(ro.orderNumber(delivery.id))).dy),
      );
      expect(inOrders(find.text('15.09.2026, 10:07')), findsNWidgets(2));
      expect(inOrders(find.text('str. Ismail 88')), findsOneWidget);
      expect(
        inOrders(find.text('DaviDan Botanica · bd. Dacia 47, Chișinău')),
        findsOneWidget,
      );
      expect(inOrders(find.text('138 lei')), findsNWidgets(2));
      expect(
        inOrders(find.text(ro.orderStatus(OrderStatus.placed))),
        findsNWidgets(2),
      );

      advanceOrderTo(container, delivery.id, OrderStatus.onTheWay);
      await tester.pumpAndSettle();
      expect(
        inOrders(find.text(ro.orderStatus(OrderStatus.onTheWay))),
        findsOneWidget,
      );
    },
  );

  testWidgets('orders on their way are under "În curs", completed ones under '
      '"Finalizate", and an order moves down once completed', (tester) async {
    signInTestAccount(container);
    final done = placeTestOrder(container);
    advanceOrderTo(container, done.id, OrderStatus.completed);
    final onItsWay = placeTestOrder(container);
    await pumpApp(tester, container, Routes.clientOrders);

    double top(Finder finder) => tester.getTopLeft(finder).dy;
    final active = inOrders(find.text(ro.ordersActiveTitle));
    final past = inOrders(find.text(ro.ordersPastTitle));
    expect(top(active), lessThan(top(find.text(ro.orderNumber(onItsWay.id)))));
    expect(top(find.text(ro.orderNumber(onItsWay.id))), lessThan(top(past)));
    expect(top(past), lessThan(top(find.text(ro.orderNumber(done.id)))));

    advanceOrderTo(container, onItsWay.id, OrderStatus.completed);
    await tester.pumpAndSettle();
    expect(active, findsNothing);
    expect(past, findsOneWidget);
    expect(top(past), lessThan(top(find.text(ro.orderNumber(onItsWay.id)))));
  });

  testWidgets(
    'each card names its brand; chips appear once orders come from two '
    'brands, filter the list and keep the filter in the link',
    (tester) async {
      signInTestAccount(container);
      final bakery = placeTestOrder(container);
      await pumpApp(tester, container, Routes.clientOrders);
      expect(inOrders(find.text('Patiserie')), findsOneWidget);
      expect(inOrders(find.text(ro.allBrands)), findsNothing);

      final sushi = placeTestOrder(container, brand: Brand.sushi);
      await tester.pumpAndSettle();
      final chips = find.byType(AppChip);
      expect(
        [for (final chip in tester.widgetList<AppChip>(chips)) chip.label],
        [ro.allBrands, 'Sushi', 'Patiserie'],
      );

      await tester.tap(find.widgetWithText(AppChip, 'Sushi'));
      await tester.pumpAndSettle();
      expect(inOrders(find.text(ro.orderNumber(sushi.id))), findsOneWidget);
      expect(inOrders(find.text(ro.orderNumber(bakery.id))), findsNothing);
      expect(
        tester.widget<OrdersScreen>(find.byType(OrdersScreen)).brand,
        Brand.sushi,
      );

      await tester.tap(find.widgetWithText(AppChip, ro.allBrands));
      await tester.pumpAndSettle();
      expect(inOrders(find.text(ro.orderNumber(sushi.id))), findsOneWidget);
      expect(inOrders(find.text(ro.orderNumber(bakery.id))), findsOneWidget);

      // A link to a brand without orders shows them all.
      await pumpApp(tester, container, Routes.clientOrdersOf(Brand.water));
      expect(inOrders(find.text(ro.orderNumber(sushi.id))), findsOneWidget);
      expect(inOrders(find.text(ro.orderNumber(bakery.id))), findsOneWidget);
    },
  );

  testWidgets('tapping an order opens it', (tester) async {
    signInTestAccount(container);
    final order = placeTestOrder(container);
    await pumpApp(tester, container, Routes.clientOrders);

    await tapVisible(tester, find.text(ro.orderNumber(order.id)));

    expect(find.byType(OrderConfirmationScreen), findsOneWidget);
    expect(
      inScreen<OrderConfirmationScreen>(find.text(ro.orderNumber(order.id))),
      findsOneWidget,
    );
  });

  testWidgets('fits a 360 x 640 phone with long addresses', (tester) async {
    signInTestAccount(container);
    placeTestOrder(
      container,
      fulfilment: const HomeDelivery(
        address:
            'bd. Ștefan cel Mare și Sfânt 126, bloc 3, scara 2, etajul 9, '
            'apartamentul 214, interfon 214K, Chișinău',
      ),
    );
    placeTestOrder(
      container,
      fulfilment: const StorePickup(locationId: 'buiucani'),
    );
    await pumpApp(
      tester,
      container,
      Routes.clientOrders,
      size: const Size(360, 640),
    );

    expect(find.byType(OrdersScreen), findsOneWidget);
    expect(
      inOrders(find.textContaining('bd. Ștefan cel Mare')),
      findsOneWidget,
    );
  });
}
