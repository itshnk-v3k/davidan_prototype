// Drives the real app (router, screens, CartNotifier, localStorage) in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/app_router.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/toast/toast_notifier.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/brand_home_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/category_grid.dart';
import 'package:davidan_prototype/features/food/presentation/product/product_detail_screen.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  testWidgets('home category opens the catalog; chips switch category in '
      'place, so back still returns home', (tester) async {
    await pumpApp(tester, container, Routes.brandHome(Brand.bakery));
    await tapVisible(
      tester,
      find.descendant(
        of: find.byType(CategoryGrid),
        matching: find.text('Patiserie'),
      ),
    );

    expect(find.byType(CatalogScreen), findsOneWidget);
    expect(
      inScreen<CatalogScreen>(find.text('Croissant cu ciocolată')),
      findsOneWidget,
    );

    await tapVisible(tester, inScreen<CatalogScreen>(find.text('Băuturi')));

    expect(inScreen<CatalogScreen>(find.text('Coca Cola')), findsOneWidget);
    expect(
      inScreen<CatalogScreen>(find.text('Croissant cu ciocolată')),
      findsNothing,
    );

    await tester.tap(
      inScreen<CatalogScreen>(find.byIcon(Icons.arrow_back_rounded)),
    );
    await tester.pumpAndSettle();
    expect(find.byType(CatalogScreen), findsNothing);
    expect(find.byType(BrandHomeScreen), findsOneWidget);
  });

  testWidgets('card opens detail; add to cart adds the chosen quantity', (
    tester,
  ) async {
    await pumpApp(
      tester,
      container,
      Routes.brandMenu(Brand.bakery, categoryId: 'bauturi'),
    );
    await tapVisible(tester, inScreen<CatalogScreen>(find.text('Coca Cola')));

    expect(find.byType(ProductDetailScreen), findsOneWidget);
    await tester.tap(
      inScreen<ProductDetailScreen>(find.byIcon(Icons.add_rounded)),
    );
    await tester.pump();

    await tester.tap(
      inScreen<ProductDetailScreen>(find.text(ro.addToCartTotal('50 lei'))),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailScreen), findsNothing);
    expect(find.byType(CatalogScreen), findsOneWidget);
    expect(container.read(cartQuantitiesProvider(Brand.bakery)), {
      'coca-cola': 2,
    });
    expect(find.text(ro.addedToCart(2, 'Coca Cola')), findsOneWidget);

    // Let the snack bar time out so no timer outlives the test.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('back from product detail returns to home', (tester) async {
    await pumpApp(tester, container, Routes.brandHome(Brand.bakery));
    // In two rows (Produse DaviDan and Kurtos); either opens it.
    await tapVisible(
      tester,
      inScreen<BrandHomeScreen>(find.text('Kurtos cu zahăr și scorțișoară'))
          .first,
    );
    expect(find.byType(ProductDetailScreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailScreen), findsNothing);
    expect(find.byType(BrandHomeScreen), findsOneWidget);
  });

  testWidgets('description appears only for products that have one', (
    tester,
  ) async {
    await pumpApp(
      tester,
      container,
      Routes.brandProduct((brand: Brand.bakery, id: 'placinta-branza')),
    );
    expect(find.text(ro.descriptionTitle), findsOneWidget);

    container
        .read(appRouterProvider)
        .go(Routes.brandProduct((brand: Brand.bakery, id: 'kurtos-fistic')));
    await tester.pumpAndSettle();
    expect(find.text(ro.descriptionTitle), findsNothing);
  });

  testWidgets('unknown product id shows not found', (tester) async {
    await pumpApp(
      tester,
      container,
      Routes.brandProduct((brand: Brand.bakery, id: 'no-such-product')),
    );
    expect(find.text(ro.productNotFound), findsOneWidget);
  });

  group('a product already in the cart', () {
    const kurtos = (brand: Brand.bakery, id: 'kurtos-fistic');

    Finder inBar(Finder finder) => inScreen<ProductDetailScreen>(finder);

    testWidgets(
      'starts at the cart\'s quantity and updates it, not adds to it',
      (tester) async {
        container
            .read(cartProvider(Brand.bakery).notifier)
            .add(kurtos.id, quantity: 2);
        await pumpApp(tester, container, Routes.brandProduct(kurtos));

        expect(inBar(find.text(ro.inCart(2))), findsOneWidget);
        expect(inBar(find.text(ro.updateCartTotal('118 lei'))), findsOneWidget);
        await tester.tap(inBar(find.byIcon(Icons.add_rounded)));
        await tester.pump();
        await tester.tap(inBar(find.text(ro.updateCartTotal('177 lei'))));
        await tester.pumpAndSettle();

        expect(container.read(cartQuantitiesProvider(Brand.bakery)), {
          kurtos.id: 3,
        });
        expect(
          find.text(ro.cartUpdated(3, 'Kurtos cu fistic')),
          findsOneWidget,
        );
        await tester.pump(ToastNotifier.duration);
        await tester.pumpAndSettle();
        expect(find.byType(ProductDetailScreen), findsNothing);
      },
    );

    testWidgets('can be taken down to 0, which takes it out of the cart', (
      tester,
    ) async {
      container.read(cartProvider(Brand.bakery).notifier).add(kurtos.id);
      await pumpApp(tester, container, Routes.brandProduct(kurtos));

      await tester.tap(inBar(find.byIcon(Icons.remove_rounded)));
      await tester.pump();
      await tester.tap(inBar(find.text(ro.removeFromCartAction)));
      await tester.pumpAndSettle();

      expect(container.read(cartQuantitiesProvider(Brand.bakery)), isEmpty);
      expect(find.text(ro.removedFromCart('Kurtos cu fistic')), findsOneWidget);
      await tester.pump(ToastNotifier.duration);
      await tester.pumpAndSettle();
    });
  });
}
