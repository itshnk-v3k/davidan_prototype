// Apa DaviDan's page (/b/water) with its two bottles and "Comandă din nou",
// then its cart and checkout, in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/app_router.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/brand_colors.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/data/mock/water/water_catalog.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/cart/cart_screen.dart';
import 'package:davidan_prototype/features/food/presentation/checkout/checkout_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/water_home_screen.dart';
import 'package:davidan_prototype/features/food/presentation/product/product_detail_screen.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_card.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/total_bar.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/brand_bubbles.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/features/orders/presentation/order_confirmation_screen.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  const still = (brand: Brand.water, id: 'apa-davidan-plata');
  const sparkling = (brand: Brand.water, id: 'apa-davidan-carbogazoasa');

  Finder inPage(Finder finder) =>
      find.descendant(of: find.byType(WaterHomeScreen), matching: finder);

  Order placeWaterOrder({
    List<OrderItem> items = const [
      OrderItem(productId: 'apa-davidan-plata', quantity: 6, priceBani: 1500),
      OrderItem(
        productId: 'apa-davidan-carbogazoasa',
        quantity: 2,
        priceBani: 1500,
      ),
    ],
  }) => container
      .read(ordersProvider.notifier)
      .place(
        brand: Brand.water,
        items: items,
        fulfilment: const HomeDelivery(address: 'str. Ismail 88'),
        payment: PaymentMethod.cash,
      );

  testWidgets(
    'the Apă naturală bubble opens the water page: davidan.md\'s heading, '
    'line and photo of both bottles, the two 0,5L bottles at 15 lei, and the '
    'water blue; before a first order, a hint instead of "Comandă din nou"',
    (tester) async {
      await pumpApp(tester, container, Routes.clientHome);
      await tester.tap(
        find.descendant(
          of: find.byType(BrandBubbles),
          matching: find.text(brandIntros[Brand.water]!.name),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WaterHomeScreen), findsOneWidget);
      expect(find.text(ro.navOrders), findsNothing);
      expect(inPage(find.text('Apa DaviDan')), findsOneWidget);
      expect(
        inPage(
          find.text(
            'Puritate naturală, îmbuteliată pentru hidratare premium în '
            'fiecare sticlă.',
          ),
        ),
        findsOneWidget,
      );
      expect(
        tester
            .widgetList<Image>(inPage(find.byType(Image)))
            .map((image) => (image.image as AssetImage).assetName),
        contains(WaterPage.photo),
      );
      expect(
        [
          for (final card in tester.widgetList<ProductCard>(
            inPage(find.byType(ProductCard)),
          ))
            (card.product.name, card.product.priceBani),
        ],
        [('Apa DaviDan naturală', 1500), ('Apa DaviDan gazată', 1500)],
      );
      expect(inPage(find.text(ro.formatLei(1500))), findsNWidgets(2));
      expect(
        Theme.of(tester.element(find.byType(WaterHomeScreen)))
            .extension<AppColors>()!
            .primary,
        BrandColors.of(Brand.water, Brightness.dark).primary,
      );

      expect(inPage(find.text(ro.orderAgainHint)), findsOneWidget);
      expect(inPage(find.text(ro.orderAgain)), findsNothing);
    },
  );

  testWidgets(
    'a bottle\'s page shows its 0,5L; the water menu link shows the water '
    'page, since there is no menu',
    (tester) async {
      await pumpApp(tester, container, Routes.brandProduct(sparkling));
      expect(
        find.descendant(
          of: find.byType(ProductDetailScreen),
          matching: find.text(ro.productWeight('0,5L')),
        ),
        findsOneWidget,
      );

      await pumpApp(tester, container, Routes.brandMenu(Brand.water));
      expect(find.byType(WaterHomeScreen), findsOneWidget);
    },
  );

  testWidgets(
    'a first water order goes through the water cart and a delivery-only '
    'checkout; back on the page, "Comandă din nou" shows that order and puts '
    'it back in the cart',
    (tester) async {
      await pumpApp(tester, container, Routes.brandHome(Brand.water));
      for (final name in ['Apa DaviDan naturală', 'Apa DaviDan gazată']) {
        await tapVisible(
          tester,
          inPage(find.bySemanticsLabel(ro.addToCart(name))),
        );
      }
      await tapVisible(
        tester,
        inPage(find.bySemanticsLabel(ro.addToCart('Apa DaviDan naturală'))),
      );
      expect(container.read(cartQuantitiesProvider(Brand.water)), {
        still.id: 2,
        sparkling.id: 1,
      });

      await tester.tap(inPage(find.byIcon(Icons.receipt_long_rounded)));
      await tester.pumpAndSettle();
      await tester.tap(find.text(ro.continueOrder));
      await tester.pumpAndSettle();
      expect(find.byType(CheckoutScreen), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(CheckoutScreen),
          matching: find.text(ro.pickup),
        ),
        findsNothing,
      );
      await tester.enterText(find.byType(TextFormField), 'str. Ismail 88');
      await tester.tap(
        find.descendant(
          of: find.byType(TotalBar),
          matching: find.text(ro.placeOrder),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(OrderConfirmationScreen), findsOneWidget);
      final order = container.read(lastOrderOfProvider(Brand.water))!;
      expect(order.totalBani, 4500);
      expect(container.read(cartCountProvider(Brand.water)), 0);

      container.read(appRouterProvider).go(Routes.brandHome(Brand.water));
      await tester.pumpAndSettle();
      expect(inPage(find.text(ro.orderAgainHint)), findsNothing);
      expect(inPage(find.text(ro.lastOrderTitle)), findsOneWidget);
      expect(
        inPage(
          find.text(
            '${ro.orderNumber(order.id)} · ${formatDateTime(order.createdAt)}',
          ),
        ),
        findsOneWidget,
      );
      expect(
        inPage(find.text(ro.lineItem(2, 'Apa DaviDan naturală'))),
        findsOneWidget,
      );
      expect(
        inPage(find.text(ro.lineItem(1, 'Apa DaviDan gazată'))),
        findsOneWidget,
      );

      await tapVisible(tester, inPage(find.text(ro.orderAgain)));
      expect(
        tester.widget<CartScreen>(find.byType(CartScreen)).brand,
        Brand.water,
      );
      expect(container.read(cartQuantitiesProvider(Brand.water)), {
        still.id: 2,
        sparkling.id: 1,
      });
    },
  );

  test(
    '"Comandă din nou" follows the newest water order only, adds to what the '
    'cart holds, and skips products no longer sold',
    () {
      placeWaterOrder();
      final newest = placeWaterOrder(
        items: const [
          OrderItem(
            productId: 'apa-davidan-plata',
            quantity: 3,
            priceBani: 1500,
          ),
          OrderItem(productId: 'apa-19l', quantity: 1, priceBani: 9000),
        ],
      );
      placeTestOrder(container);
      expect(container.read(lastOrderOfProvider(Brand.water)), newest);
      expect(container.read(lastOrderOfProvider(Brand.sushi)), isNull);

      container.read(cartProvider(Brand.water).notifier)
        ..add(still.id)
        ..repeat(newest);
      expect(container.read(cartQuantitiesProvider(Brand.water)), {
        still.id: 4,
      });
    },
  );
}
