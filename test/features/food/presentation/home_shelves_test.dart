// Home's rows: Produse DaviDan and one row per category, each scrolling
// sideways with a way into the whole category, in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/data/mock/bakery/bakery_categories.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/food/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/home_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/product_shelf.dart';
import 'package:davidan_prototype/features/food/presentation/product/product_detail_screen.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_card.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_image.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/quantity_stepper.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  const croissant = 'Croissant cu ciocolată';

  Finder row(String id) => find.byWidgetPredicate(
    (widget) => widget is ProductShelf && widget.id == id,
  );
  Finder inRow(String id, Finder finder) =>
      find.descendant(of: row(id), matching: finder);
  Finder cardInRow(String id, String name) =>
      inRow(id, find.widgetWithText(ProductCard, name));
  final homeScroll = find
      .descendant(
        of: find.byType(HomeScreen),
        matching: find.byType(Scrollable),
      )
      .first;
  Finder rowScroll(String id) => inRow(id, find.byType(Scrollable)).first;

  Future<void> scrollHomeTo(WidgetTester tester, Finder finder) =>
      tester.scrollUntilVisible(finder, 300, scrollable: homeScroll);

  String heroTagOnProductPage(WidgetTester tester) =>
      tester.widget<Hero>(inScreen<ProductDetailScreen>(find.byType(Hero))).tag
          as String;

  testWidgets(
    'Produse DaviDan comes first, then every category has its own row with '
    'its products and the site\'s blurb',
    (tester) async {
      await pumpApp(tester, container, Routes.clientHome);
      expect(
        inRow('popular', find.text(AppStrings.popularTitle)),
        findsOneWidget,
      );
      expect(inRow('popular', find.byType(ProductCard)), findsWidgets);

      for (final category in bakeryCategories) {
        await scrollHomeTo(tester, row(category.id));
        expect(
          inRow(category.id, find.text(category.name)),
          findsOneWidget,
          reason: category.name,
        );
        final description = category.description;
        expect(
          inRow(category.id, find.text(description ?? '')),
          description == null ? findsNothing : findsOneWidget,
          reason: category.name,
        );
        expect(
          inRow(category.id, find.byType(ProductCard)),
          findsWidgets,
          reason: category.name,
        );
      }
    },
  );

  testWidgets('a row shows two cards and a peek of the third', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);

    final cards = inRow('popular', find.byType(ProductCard));
    expect(tester.getRect(cards.at(1)).right, lessThan(400));
    final third = tester.getRect(cards.at(2));
    expect(third.left, lessThan(400));
    expect(third.right, greaterThan(400));
  });

  testWidgets(
    '"Vezi mai mult" opens the row\'s category in the menu, and so does the '
    'tile at the end of the row',
    (tester) async {
      final kurtosCount = container
          .read(
            productsByCategoryProvider((
              brand: Brand.bakery,
              categoryId: BakeryCategoryIds.kurtos,
            )),
          )
          .length;
      await pumpApp(tester, container, Routes.clientHome);
      await scrollHomeTo(tester, row(BakeryCategoryIds.kurtos));

      await tapVisible(
        tester,
        inRow(BakeryCategoryIds.kurtos, find.text(AppStrings.seeAll)),
      );
      expect(find.byType(CatalogScreen), findsOneWidget);
      expect(
        inScreen<CatalogScreen>(
          find.textContaining('Descoperiți selecția noastră'),
        ),
        findsOneWidget,
      );

      await tester.tap(find.text(AppStrings.navHome));
      await tester.pumpAndSettle();
      final endTile = inRow(
        BakeryCategoryIds.kurtos,
        find.text(AppStrings.seeAllProducts(kurtosCount)),
      );
      await tester.scrollUntilVisible(
        endTile,
        150,
        scrollable: rowScroll(BakeryCategoryIds.kurtos),
      );
      await tapVisible(tester, endTile);
      expect(find.byType(CatalogScreen), findsOneWidget);
      expect(
        inScreen<CatalogScreen>(
          find.textContaining('Descoperiți selecția noastră'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'adding from the Produse DaviDan row shows in the product\'s category row '
    'too',
    (tester) async {
      await pumpApp(tester, container, Routes.clientHome);

      await tapVisible(
        tester,
        find.descendant(
          of: cardInRow('popular', croissant),
          matching: find.byIcon(Icons.add_rounded),
        ),
      );
      expect(container.read(cartQuantitiesProvider(Brand.bakery)), {
        'croissant-ciocolata': 1,
      });

      await scrollHomeTo(tester, row(BakeryCategoryIds.patiserie));
      final patiserieCard = cardInRow(BakeryCategoryIds.patiserie, croissant);
      await tester.scrollUntilVisible(
        patiserieCard,
        150,
        scrollable: rowScroll(BakeryCategoryIds.patiserie),
      );
      expect(
        find.descendant(
          of: patiserieCard,
          matching: find.byType(QuantityStepper),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'a product in two rows opens from the card that was tapped: its photo '
    'flies from that row',
    (tester) async {
      await pumpApp(tester, container, Routes.clientHome);

      await tapVisible(
        tester,
        find.descendant(
          of: cardInRow('popular', croissant),
          matching: find.text(croissant),
        ),
      );
      expect(find.byType(ProductDetailScreen), findsOneWidget);
      expect(
        heroTagOnProductPage(tester),
        ProductImage.heroTagFor((
          brand: Brand.bakery,
          id: 'croissant-ciocolata',
        ), scope: 'popular'),
      );

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      await scrollHomeTo(tester, row(BakeryCategoryIds.patiserie));
      final patiserieCard = cardInRow(BakeryCategoryIds.patiserie, croissant);
      await tester.scrollUntilVisible(
        patiserieCard,
        150,
        scrollable: rowScroll(BakeryCategoryIds.patiserie),
      );
      await tapVisible(
        tester,
        find.descendant(of: patiserieCard, matching: find.text(croissant)),
      );
      expect(
        heroTagOnProductPage(tester),
        ProductImage.heroTagFor((
          brand: Brand.bakery,
          id: 'croissant-ciocolata',
        ), scope: BakeryCategoryIds.patiserie),
      );
    },
  );

  testWidgets('every row fits a 360 px phone, cards with a stepper included', (
    tester,
  ) async {
    final cart = container.read(cartProvider(Brand.bakery).notifier);
    for (final product in container.read(productsProvider(Brand.bakery))) {
      cart.add(product.id, quantity: 12);
    }
    await pumpApp(
      tester,
      container,
      Routes.clientHome,
      size: const Size(360, 640),
    );

    for (final category in bakeryCategories) {
      await scrollHomeTo(tester, row(category.id));
      expect(
        inRow(category.id, find.byType(QuantityStepper)),
        findsWidgets,
        reason: category.name,
      );
    }
  });
}
