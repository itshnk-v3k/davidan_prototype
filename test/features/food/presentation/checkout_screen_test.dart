// Checkout screen (/b/:brand/checkout) in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/widgets/option_tile.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/account/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/food/presentation/checkout/checkout_screen.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/total_bar.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/features/orders/presentation/order_confirmation_screen.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async {
    container = await createTestContainer();
    container.read(cartProvider(Brand.bakery).notifier)
      ..add('croissant-ciocolata') // 19 lei
      ..add('coca-cola', quantity: 2); // 2 × 25 lei
  });

  final placeOrderButton = find.descendant(
    of: find.byType(TotalBar),
    matching: find.text(ro.placeOrder),
  );

  testWidgets('delivery needs an address before the order is placed', (
    tester,
  ) async {
    await pumpApp(tester, container, Routes.brandCheckout(Brand.bakery));
    expect(find.text(ro.deliveryAddressMissing), findsNothing);
    // The total is in the bottom bar only, not repeated in the summary.
    expect(find.text('69 lei'), findsOneWidget);
    expect(
      find.descendant(of: find.byType(TotalBar), matching: find.text('69 lei')),
      findsOneWidget,
    );

    await tester.tap(placeOrderButton);
    await tester.pumpAndSettle();

    expect(find.byType(CheckoutScreen), findsOneWidget);
    expect(find.text(ro.deliveryAddressMissing), findsOneWidget);
    expect(container.read(ordersProvider), isEmpty);
    expect(container.read(cartCountProvider(Brand.bakery)), 3);

    await tester.enterText(find.byType(TextFormField), 'str. Ismail 88');
    await tester.pump();
    expect(find.text(ro.deliveryAddressMissing), findsNothing);
  });

  testWidgets(
    'delivery at a set time, paid by card: places the order, empties the '
    'cart and opens the confirmation',
    (tester) async {
      await pumpApp(tester, container, Routes.brandCheckout(Brand.bakery));

      expect(
        inScreen<CheckoutScreen>(find.text(ro.lineItem(2, 'Coca Cola'))),
        findsOneWidget,
      );
      await tester.enterText(
        find.byType(TextFormField),
        ' str. Ismail 88, ap. 12 ',
      );
      // testNow is 10:07, so the first slot is 11:00.
      await tapVisible(tester, find.text('11:00'));
      await tapVisible(tester, find.text(ro.paymentMethod(PaymentMethod.card)));

      await tester.tap(placeOrderButton);
      // The checkout must not flash its empty-cart state while the
      // confirmation slides in.
      for (var frame = 0; frame < 40; frame++) {
        await tester.pump(const Duration(milliseconds: 16));
        expect(find.text(ro.cartEmptyTitle), findsNothing);
      }
      await tester.pumpAndSettle();

      final [order] = container.read(ordersProvider);
      expect(order.id, 'DD-1001');
      expect(order.status, OrderStatus.placed);
      expect(
        (order.fulfilment as HomeDelivery).address,
        'str. Ismail 88, ap. 12',
      );
      expect(order.scheduledFor, DateTime(2026, 9, 15, 11));
      expect(order.payment, PaymentMethod.card);
      expect(order.totalBani, 6900);
      expect(order.createdAt, testNow);
      expect(
        [for (final item in order.items) item.toJson()],
        [
          {
            'productId': 'croissant-ciocolata',
            'quantity': 1,
            'priceBani': 1900,
          },
          {'productId': 'coca-cola', 'quantity': 2, 'priceBani': 2500},
        ],
      );
      expect(container.read(cartProvider(Brand.bakery)), isEmpty);

      expect(find.byType(CheckoutScreen), findsNothing);
      expect(find.byType(OrderConfirmationScreen), findsOneWidget);
      expect(find.text(ro.orderNumber('DD-1001')), findsOneWidget);
      expect(find.text('str. Ismail 88, ap. 12'), findsOneWidget);
      expect(find.text('11:00'), findsOneWidget);
    },
  );

  testWidgets('pickup from a chosen shop, as soon as possible, in cash', (
    tester,
  ) async {
    await pumpApp(tester, container, Routes.brandCheckout(Brand.bakery));

    await tapVisible(tester, find.text(ro.pickup));
    expect(find.byType(TextFormField), findsNothing);
    expect(find.text('DaviDan Centru'), findsOneWidget);

    await tapVisible(tester, find.text('DaviDan Botanica'));
    await tester.tap(placeOrderButton);
    await tester.pumpAndSettle();

    final [order] = container.read(ordersProvider);
    expect((order.fulfilment as StorePickup).locationId, 'botanica');
    expect(order.scheduledFor, isNull);
    expect(order.payment, PaymentMethod.cash);

    expect(find.byType(OrderConfirmationScreen), findsOneWidget);
    expect(
      find.text('DaviDan Botanica · bd. Dacia 47, Chișinău'),
      findsOneWidget,
    );
    expect(find.text(ro.asSoonAsPossible), findsOneWidget);
  });

  testWidgets('the typed address survives switching to pickup and back', (
    tester,
  ) async {
    await pumpApp(tester, container, Routes.brandCheckout(Brand.bakery));
    await tester.enterText(find.byType(TextFormField), 'str. Ismail 88');

    await tapVisible(tester, find.text(ro.pickup));
    await tapVisible(tester, find.text(ro.delivery));

    expect(find.text('str. Ismail 88'), findsOneWidget);
  });

  testWidgets('with an empty cart, checkout shows the empty state', (
    tester,
  ) async {
    container.read(cartProvider(Brand.bakery).notifier).clear();
    await pumpApp(tester, container, Routes.brandCheckout(Brand.bakery));

    expect(find.text(ro.cartEmptyTitle), findsOneWidget);
    expect(find.byType(TotalBar), findsNothing);

    await tapVisible(tester, find.text(ro.browseMenu));
    expect(find.byType(CatalogScreen), findsOneWidget);
  });

  testWidgets('fits a 360 px wide phone, for delivery and for pickup', (
    tester,
  ) async {
    container
        .read(cartProvider(Brand.bakery).notifier)
        .add('new-york-roll-mango-maracuja');
    // Tall enough that every section is laid out without scrolling.
    await pumpApp(
      tester,
      container,
      Routes.brandCheckout(Brand.bakery),
      size: const Size(360, 2000),
    );
    await tester.tap(placeOrderButton);
    await tester.pumpAndSettle();
    expect(find.text(ro.deliveryAddressMissing), findsOneWidget);

    await tester.tap(find.text(ro.pickup));
    await tester.pumpAndSettle();
    expect(find.text('DaviDan Buiucani'), findsOneWidget);
  });

  testWidgets('starts from the delivery address saved on the location screen', (
    tester,
  ) async {
    container
        .read(fulfilmentChoiceProvider.notifier)
        .chooseDelivery('str. Ismail 88');
    await pumpApp(tester, container, Routes.brandCheckout(Brand.bakery));

    expect(
      inScreen<CheckoutScreen>(find.text('str. Ismail 88')),
      findsOneWidget,
    );
    await tester.tap(placeOrderButton);
    await tester.pumpAndSettle();

    final [order] = container.read(ordersProvider);
    expect((order.fulfilment as HomeDelivery).address, 'str. Ismail 88');
  });

  testWidgets('starts from the pickup shop saved on the location screen', (
    tester,
  ) async {
    container.read(fulfilmentChoiceProvider.notifier).choosePickup('buiucani');
    await pumpApp(tester, container, Routes.brandCheckout(Brand.bakery));

    expect(find.byType(TextFormField), findsNothing);
    expect(
      tester
          .widget<OptionTile>(
            find.widgetWithText(OptionTile, 'DaviDan Buiucani'),
          )
          .selected,
      isTrue,
    );
    await tester.tap(placeOrderButton);
    await tester.pumpAndSettle();

    final [order] = container.read(ordersProvider);
    expect((order.fulfilment as StorePickup).locationId, 'buiucani');
  });

  group('at 19:45', () {
    setUp(() async {
      container = await createTestContainer(
        clock: () => DateTime(2026, 9, 15, 19, 45),
      );
      container.read(cartProvider(Brand.bakery).notifier).add('americano');
    });

    testWidgets('only "as soon as possible" is offered, no slot past 20:00', (
      tester,
    ) async {
      await pumpApp(tester, container, Routes.brandCheckout(Brand.bakery));

      expect(find.text(ro.asSoonAsPossible), findsOneWidget);
      expect(find.textContaining(RegExp(r'^\d\d:\d\d$')), findsNothing);
    });
  });
}
