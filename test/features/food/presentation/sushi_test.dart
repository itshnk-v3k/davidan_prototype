// DaviDan Sushi's pages with davidansushi.md's menu: home, menu, product,
// cart and checkout (/b/sushi/...), in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_assets.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/core/widgets/brand_logo.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/data/mock/sushi/sushi_categories.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/account/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/application/shop_providers.dart';
import 'package:davidan_prototype/features/food/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/food/presentation/checkout/checkout_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/brand_feed_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/category_grid.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/product_shelf.dart';
import 'package:davidan_prototype/features/food/presentation/product/product_detail_screen.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_card.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/total_bar.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/brand_switcher_row.dart';
import 'package:davidan_prototype/features/orders/application/order_lines_provider.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/features/orders/presentation/order_confirmation_screen.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  const siteCategories = [
    'Sushi',
    'Seturi',
    'Bucate Thai',
    'Supe',
    'Salate',
    'Poke bowl',
    'Gustări',
    'Deserturi',
    'Băuturi',
  ];

  Finder row(String id) => find.byWidgetPredicate(
    (widget) => widget is ProductShelf && widget.id == id,
  );

  testWidgets(
    'the Sushi bubble opens the sushi home: its own logo, the site\'s '
    '"Dulciuri Nipone" slide, its nine categories, and a row for each',
    (tester) async {
      await pumpApp(tester, container, Routes.clientHome);
      await tester.tap(
        find.descendant(
          of: find.byType(BrandSwitcherRow),
          matching: find.text(brandIntros[Brand.sushi]!.name),
        ),
      );
      await tester.pumpAndSettle();

      final home = tester.widget<BrandFeedScreen>(find.byType(BrandFeedScreen));
      expect(home.brand, Brand.sushi);
      // The app starts in the dark theme.
      final logo = tester.widget<Image>(
        inScreen<BrandFeedScreen>(
          find.descendant(
            of: find.byType(BrandLogo),
            matching: find.byType(Image),
          ),
        ),
      );
      expect((logo.image as AssetImage).assetName, AppAssets.sushiLogoOnDark);
      expect(
        inScreen<BrandFeedScreen>(find.text('Dulciuri Nipone')),
        findsOneWidget,
      );
      expect([
        for (final category
            in tester
                .widget<CategoryGrid>(find.byType(CategoryGrid))
                .categories)
          category.name,
      ], siteCategories);
      expect(
        find.descendant(
          of: row('popular'),
          matching: find.widgetWithText(ProductCard, 'Alasca'),
        ),
        findsOneWidget,
      );
      // "Produse DaviDan" is davidan.md's heading; the sushi site has none.
      expect(
        find.descendant(of: row('popular'), matching: find.text('Populare')),
        findsOneWidget,
      );
      expect(
        inScreen<BrandFeedScreen>(find.text(ro.popularTitle)),
        findsNothing,
      );

      final homeScroll = find
          .descendant(
            of: find.byType(BrandFeedScreen),
            matching: find.byType(Scrollable),
          )
          .first;
      for (final category in sushiCategories) {
        await tester.scrollUntilVisible(
          row(category.id),
          300,
          scrollable: homeScroll,
        );
        expect(
          find.descendant(
            of: row(category.id),
            matching: find.text(category.name),
          ),
          findsOneWidget,
          reason: category.name,
        );
      }
      // The last row ends in a tile opening all 11 drinks.
      await tester.scrollUntilVisible(
        find.descendant(
          of: row(SushiCategoryIds.bauturi),
          matching: find.text(ro.seeAllProducts(11)),
        ),
        300,
        scrollable: find
            .descendant(
              of: row(SushiCategoryIds.bauturi),
              matching: find.byType(Scrollable),
            )
            .first,
      );
    },
  );

  testWidgets(
    'the menu opens on the slide\'s category, and its chips switch between '
    'the nine in place',
    (tester) async {
      await pumpApp(tester, container, Routes.brandHome(Brand.sushi));
      await tester.tap(find.text('Dulciuri Nipone'));
      await tester.pumpAndSettle();

      expect(find.byType(CatalogScreen), findsOneWidget);
      expect([
        for (final chip in tester.widgetList<AppChip>(
          inScreen<CatalogScreen>(find.byType(AppChip)),
        ))
          chip.label,
      ], siteCategories);
      expect(inScreen<CatalogScreen>(find.text('Cheesecake')), findsOneWidget);
      expect(inScreen<CatalogScreen>(find.text('Motti')), findsOneWidget);

      await tapVisible(tester, find.widgetWithText(AppChip, 'Seturi'));
      expect(inScreen<CatalogScreen>(find.text('Davidan Set')), findsOneWidget);
      expect(inScreen<CatalogScreen>(find.text('Cheesecake')), findsNothing);
    },
  );

  testWidgets(
    'a product page shows the site\'s pieces and weight with the set\'s '
    'contents; a product the site gives no weight or text for shows none',
    (tester) async {
      await pumpApp(
        tester,
        container,
        Routes.brandProduct((brand: Brand.sushi, id: 'davidan-set')),
      );
      final page = find.byType(ProductDetailScreen);
      expect(
        find.descendant(of: page, matching: find.text('Davidan Set')),
        findsOneWidget,
      );
      for (final size in [
        ro.productPieces('48 buc'),
        ro.productWeight('1900g'),
      ]) {
        expect(
          find.descendant(of: page, matching: find.text(size)),
          findsOneWidget,
          reason: size,
        );
      }
      expect(ro.productWeight('1900g'), 'Masa: 1900g');
      expect(
        find.descendant(
          of: page,
          matching: find.textContaining(
            'Componența setului: Haruto – 8 bucăți, Philadelphia Classic',
          ),
        ),
        findsOneWidget,
      );

      await pumpApp(
        tester,
        container,
        Routes.brandProduct((brand: Brand.sushi, id: 'poke-bowl-ton')),
      );
      // "cremă de brnânză" and "castrevete" on the site.
      expect(
        find.descendant(
          of: page,
          matching: find.textContaining(
            'castravete, cremă de brânză, sos poke',
          ),
        ),
        findsOneWidget,
      );

      await pumpApp(
        tester,
        container,
        Routes.brandProduct((brand: Brand.sushi, id: 'coca-cola-250ml')),
      );
      expect(
        find.descendant(of: page, matching: find.text('Coca Cola 250ml')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: page, matching: find.textContaining('Masa')),
        findsNothing,
      );
      expect(
        find.descendant(of: page, matching: find.text(ro.descriptionTitle)),
        findsNothing,
      );

      // The bakery's site gives no weights either.
      await pumpApp(
        tester,
        container,
        Routes.brandProduct((brand: Brand.bakery, id: 'kurtos-fistic')),
      );
      expect(
        find.descendant(of: page, matching: find.textContaining('Masa')),
        findsNothing,
      );
    },
  );

  testWidgets(
    'sushi checkout only delivers, even with a bakery shop chosen for pickup, '
    'and places the sushi cart alone',
    (tester) async {
      final shop = container.read(locationsProvider).first;
      container.read(fulfilmentChoiceProvider.notifier).choosePickup(shop.id);
      container.read(cartProvider(Brand.bakery).notifier).add('americano');
      container.read(cartProvider(Brand.sushi).notifier)
        ..add('alasca')
        ..add('motti', quantity: 2);
      expect(container.read(cartTotalProvider(Brand.sushi)), 17000 + 2 * 3000);

      await pumpApp(tester, container, Routes.brandCheckout(Brand.sushi));
      final checkout = find.byType(CheckoutScreen);
      expect(
        find.descendant(of: checkout, matching: find.text(ro.pickup)),
        findsNothing,
      );
      expect(
        find.descendant(of: checkout, matching: find.text(shop.name)),
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
      final order = container.read(ordersProvider).single;
      expect(order.brand, Brand.sushi);
      expect(order.fulfilment, isA<HomeDelivery>());
      expect(order.totalBani, 23000);
      expect(
        inScreen<OrderConfirmationScreen>(find.text(ro.formatLei(23000))),
        findsOneWidget,
      );
      expect(
        [
          for (final line in container.read(orderLinesProvider(order.id)))
            ro.lineItem(line.quantity, line.product.name),
        ],
        [ro.lineItem(1, 'Alasca'), ro.lineItem(2, 'Motti')],
      );
      expect(container.read(cartCountProvider(Brand.sushi)), 0);
      expect(container.read(cartCountProvider(Brand.bakery)), 1);
    },
  );
}
