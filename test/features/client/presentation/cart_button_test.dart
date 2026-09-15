// The cart button at the top right of the customer tabs, which replaced the
// cart tab, in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/features/client/application/cart_notifier.dart';
import 'package:davidan_prototype/features/client/presentation/cart/cart_screen.dart';
import 'package:davidan_prototype/features/client/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/client/presentation/favorites/favorites_screen.dart';
import 'package:davidan_prototype/features/client/presentation/home/home_screen.dart';
import 'package:davidan_prototype/features/client/presentation/profile/profile_screen.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/cart_button.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  Finder inScreenOf(Type screen, Finder finder) =>
      find.descendant(of: find.byType(screen), matching: finder);

  Future<void> goBack(WidgetTester tester) async {
    await tester.tap(
      inScreen<CartScreen>(find.byIcon(Icons.arrow_back_rounded)),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('the bottom bar has four tabs on a 360 px phone, in the order '
      'Acasă, Meniu, Favorite, Profil, each in its own quarter; no Coș', (
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
      AppStrings.navFavorites,
      AppStrings.navProfile,
    ];
    // Only positions: flutter_test draws text in a test font where most glyphs
    // are a full em wide, so label widths here say nothing about Roboto.
    const tabWidth = 360 / 4;
    for (final (index, label) in labels.indexed) {
      expect(
        tester.getCenter(find.text(label)).dx,
        closeTo(tabWidth * index + tabWidth / 2, 1),
        reason: label,
      );
    }
    expect(find.text('Coș'), findsNothing);
    expect(find.byIcon(Icons.shopping_bag_rounded), findsNothing);
  });

  testWidgets(
    'Acasă, Meniu and Favorite show the cart button at the top right, right '
    'of the launcher button; Profil does not',
    (tester) async {
      await pumpApp(tester, container, Routes.clientHome);

      for (final (tab, screen) in [
        (AppStrings.navHome, HomeScreen),
        (AppStrings.navMenu, CatalogScreen),
        (AppStrings.navFavorites, FavoritesScreen),
      ]) {
        await tester.tap(find.text(tab));
        await tester.pumpAndSettle();

        final button = inScreenOf(screen, find.byType(CartButton));
        expect(button, findsOneWidget, reason: tab);
        final launcher = inScreenOf(screen, find.byIcon(Icons.apps_rounded));
        expect(
          tester.getCenter(button).dx,
          greaterThan(tester.getCenter(launcher).dx),
          reason: tab,
        );
        expect(
          tester.getTopRight(button).dx,
          closeTo(400 - 16, 1),
          reason: tab,
        );
        expect(tester.getTopLeft(button).dy, lessThan(80), reason: tab);
        expect(
          inScreenOf(screen, find.byIcon(Icons.receipt_long_rounded)),
          findsOneWidget,
          reason: tab,
        );
      }

      await tester.tap(find.text(AppStrings.navProfile));
      await tester.pumpAndSettle();
      expect(inScreen<ProfileScreen>(find.byType(CartButton)), findsNothing);
    },
  );

  testWidgets(
    'the badge counts the items; the cart opens over the tabs, without the '
    'bottom bar, and back returns home',
    (tester) async {
      container.read(cartProvider.notifier)
        ..add('americano')
        ..add('coca-cola', quantity: 2);
      await pumpApp(tester, container, Routes.clientHome);
      final button = inScreen<HomeScreen>(find.byType(CartButton));
      expect(
        find.descendant(of: button, matching: find.text('3')),
        findsOneWidget,
      );

      final semantics = tester.ensureSemantics();
      expect(find.bySemanticsLabel(AppStrings.openCart(3)), findsOneWidget);
      semantics.dispose();

      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.byType(CartScreen), findsOneWidget);
      expect(find.text(AppStrings.navHome), findsNothing);

      await goBack(tester);
      expect(find.byType(CartScreen), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);
    },
  );

  testWidgets('opened from a menu category, back returns to that category', (
    tester,
  ) async {
    container.read(cartProvider.notifier).add('americano');
    await pumpApp(tester, container, Routes.clientCategory('bauturi'));

    await tester.tap(inScreen<CatalogScreen>(find.byType(CartButton)));
    await tester.pumpAndSettle();
    expect(find.byType(CartScreen), findsOneWidget);

    await goBack(tester);
    expect(inScreen<CatalogScreen>(find.text('Coca Cola')), findsOneWidget);
  });

  testWidgets('opened straight from its link, back goes home', (tester) async {
    await pumpApp(tester, container, Routes.clientCart);
    expect(find.byType(CartScreen), findsOneWidget);

    await goBack(tester);
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
