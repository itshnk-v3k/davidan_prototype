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
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/features/client/application/favorites_notifier.dart';
import 'package:davidan_prototype/features/client/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/client/presentation/favorites/favorites_screen.dart';
import 'package:davidan_prototype/features/client/presentation/home/home_screen.dart';
import 'package:davidan_prototype/features/client/presentation/product/product_detail_screen.dart';
import 'package:davidan_prototype/features/client/presentation/profile/profile_screen.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/favorite_toggle.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/product_card.dart';

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
    await pumpApp(tester, container, Routes.clientCategory('bauturi'));
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
    await pumpApp(tester, container, Routes.clientProduct('coca-cola'));
    final heart = inScreen<ProductDetailScreen>(find.byType(FavoriteToggle));
    expect(isSaved(tester, heart), isFalse);

    await tester.tap(heart);
    await tester.pumpAndSettle();

    expect(isSaved(tester, heart), isTrue);
    expect(savedNames(), ['Coca Cola']);

    container.read(appRouterProvider).go(Routes.clientCategory('bauturi'));
    await tester.pumpAndSettle();
    expect(find.byType(CatalogScreen), findsOneWidget);
    expect(isSaved(tester, heartOn('Coca Cola')), isTrue);
  });

  testWidgets('the bottom bar has five tabs on a 360 px phone, in the order '
      'Acasă, Meniu, Coș, Favorite, Profil, each in its own fifth', (
    tester,
  ) async {
    await pumpApp(
      tester,
      container,
      Routes.clientHome,
      size: const Size(360, 640),
    );

    const labels = [
      AppStrings.navHome,
      AppStrings.navMenu,
      AppStrings.navCart,
      AppStrings.navFavorites,
      AppStrings.navProfile,
    ];
    // Only positions: flutter_test draws text in a test font where most glyphs
    // are a full em wide, so label widths here say nothing about Roboto.
    const tabWidth = 360 / 5;
    for (final (index, label) in labels.indexed) {
      expect(
        tester.getCenter(find.text(label)).dx,
        closeTo(tabWidth * index + tabWidth / 2, 1),
        reason: label,
      );
    }
  });

  testWidgets(
    'the Favorite tab lists saved products, newest first, with the bottom bar '
    'and no back button; unsaving one removes it',
    (tester) async {
      container.read(favoritesProvider.notifier)
        ..toggle('coca-cola')
        ..toggle('americano');
      await pumpApp(tester, container, Routes.clientHome);
      expect(find.byType(HomeScreen), findsOneWidget);

      await tester.tap(find.text(AppStrings.navFavorites));
      await tester.pumpAndSettle();

      expect(find.byType(FavoritesScreen), findsOneWidget);
      expect(find.text(AppStrings.navCart), findsOneWidget);
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
      expect(find.text(AppStrings.favoritesEmptyTitle), findsOneWidget);
    },
  );

  testWidgets('the profile no longer links to favourites', (tester) async {
    container.read(favoritesProvider.notifier).toggle('coca-cola');
    await pumpApp(tester, container, Routes.clientProfile);

    expect(
      inScreen<ProfileScreen>(find.text(AppStrings.favoritesTitle)),
      findsNothing,
    );
  });

  testWidgets('with nothing saved, the tab points to the menu', (tester) async {
    await pumpApp(tester, container, Routes.clientFavorites);
    expect(find.text(AppStrings.favoritesEmptyTitle), findsOneWidget);

    await tapVisible(tester, find.text(AppStrings.browseMenu));
    expect(find.byType(CatalogScreen), findsOneWidget);
  });

  testWidgets('the saved list fits a 360 x 640 phone', (tester) async {
    container.read(favoritesProvider.notifier)
      ..toggle('new-york-roll-mango-maracuja')
      ..toggle('danish-fructe-padure-vanilie')
      ..toggle('coca-cola');
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
