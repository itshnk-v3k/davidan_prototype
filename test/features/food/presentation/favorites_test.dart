// Favourites: the hearts on product cards and the product page, and the
// Favorite tab, in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/app_router.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/account/presentation/profile/profile_screen.dart';
import 'package:davidan_prototype/features/food/application/favorites_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/food/presentation/favorites/favorites_screen.dart';
import 'package:davidan_prototype/features/food/presentation/product/product_detail_screen.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/favorite_toggle.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_card.dart';
import 'package:davidan_prototype/features/hub/presentation/hub_home_screen.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  Finder productCard(String productName) =>
      find.widgetWithText(ProductCard, productName);
  Finder heartOn(String productName) => find.descendant(
    of: productCard(productName),
    matching: find.byType(FavoriteToggle),
  );
  bool isSaved(WidgetTester tester, Finder heart) =>
      tester.widget<FavoriteToggle>(heart).favorite;
  List<String> savedNames() => [
    for (final product in container.read(favoriteProductsProvider))
      product.name,
  ];

  testWidgets('the heart on a card saves the product without opening it', (
    tester,
  ) async {
    await pumpApp(
      tester,
      container,
      Routes.brandMenu(Brand.bakery, categoryId: 'bauturi'),
    );
    expect(isSaved(tester, heartOn('Coca Cola')), isFalse);

    await tapVisible(tester, heartOn('Coca Cola'));

    expect(find.byType(ProductDetailScreen), findsNothing);
    expect(isSaved(tester, heartOn('Coca Cola')), isTrue);
    expect(savedNames(), ['Coca Cola']);

    await tapVisible(tester, heartOn('Coca Cola'));

    expect(isSaved(tester, heartOn('Coca Cola')), isFalse);
    expect(savedNames(), isEmpty);
  });

  testWidgets('the product page heart and the card heart are the same', (
    tester,
  ) async {
    await pumpApp(
      tester,
      container,
      Routes.brandProduct((brand: Brand.bakery, id: 'coca-cola')),
    );
    final heart = inScreen<ProductDetailScreen>(find.byType(FavoriteToggle));
    expect(isSaved(tester, heart), isFalse);

    await tester.tap(heart);
    await tester.pumpAndSettle();

    expect(isSaved(tester, heart), isTrue);
    expect(savedNames(), ['Coca Cola']);

    container
        .read(appRouterProvider)
        .go(Routes.brandMenu(Brand.bakery, categoryId: 'bauturi'));
    await tester.pumpAndSettle();
    expect(find.byType(CatalogScreen), findsOneWidget);
    expect(isSaved(tester, heartOn('Coca Cola')), isTrue);
  });

  testWidgets(
    'the Favorite tab lists saved products, newest first, with the bottom bar '
    'and no back button; unsaving one removes it',
    (tester) async {
      container.read(favoritesProvider.notifier)
        ..toggle((brand: Brand.bakery, id: 'coca-cola'))
        ..toggle((brand: Brand.bakery, id: 'americano'));
      await pumpApp(tester, container, Routes.clientHome);
      expect(find.byType(HubHomeScreen), findsOneWidget);

      await tester.tap(find.text(ro.navFavorites));
      await tester.pumpAndSettle();

      expect(find.byType(FavoritesScreen), findsOneWidget);
      expect(find.text(ro.navProfile), findsOneWidget);
      expect(
        inScreen<FavoritesScreen>(find.byIcon(Icons.arrow_back_rounded)),
        findsNothing,
      );
      expect(
        tester.getTopLeft(productCard('Americano')).dx,
        lessThan(tester.getTopLeft(productCard('Coca Cola')).dx),
      );

      await tester.tap(heartOn('Americano'));
      await tester.pumpAndSettle();
      expect(productCard('Americano'), findsNothing);

      await tester.tap(heartOn('Coca Cola'));
      await tester.pumpAndSettle();
      expect(find.text(ro.favoritesEmptyTitle), findsOneWidget);
    },
  );

  testWidgets('the profile no longer links to favourites', (tester) async {
    container.read(favoritesProvider.notifier).toggle((
      brand: Brand.bakery,
      id: 'coca-cola',
    ));
    await pumpApp(tester, container, Routes.clientProfile);

    expect(inScreen<ProfileScreen>(find.text(ro.favoritesTitle)), findsNothing);
  });

  testWidgets('with nothing saved, the tab points back to the hub', (
    tester,
  ) async {
    await pumpApp(tester, container, Routes.clientFavorites);
    expect(find.text(ro.favoritesEmptyTitle), findsOneWidget);

    await tapVisible(tester, find.text(ro.backHome));
    expect(find.byType(HubHomeScreen), findsOneWidget);
  });

  testWidgets('the saved list fits a 360 x 640 phone', (tester) async {
    container.read(favoritesProvider.notifier)
      ..toggle((brand: Brand.bakery, id: 'new-york-roll-mango-maracuja'))
      ..toggle((brand: Brand.bakery, id: 'danish-fructe-padure-vanilie'))
      ..toggle((brand: Brand.bakery, id: 'coca-cola'));
    await pumpApp(
      tester,
      container,
      Routes.clientFavorites,
      size: const Size(360, 640),
    );

    expect(find.byType(FavoritesScreen), findsOneWidget);
    expect(find.byType(ProductCard), findsWidgets);
  });
}
