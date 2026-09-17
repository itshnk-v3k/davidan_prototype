// The hub's bottom tabs, and the cart buttons at the top right of a brand's
// pages and of the hub's tabs, which replaced the cart tab, in the real app,
// in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/account/presentation/profile/profile_screen.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/cart/cart_screen.dart';
import 'package:davidan_prototype/features/food/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/food/presentation/favorites/favorites_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/brand_home_screen.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/cart_button.dart';
import 'package:davidan_prototype/features/hub/presentation/hub_home_screen.dart';
import 'package:davidan_prototype/features/orders/presentation/orders_screen.dart';

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
      'Acasă, Comenzi, Favorite, Profil, each in its own quarter; no Coș and '
      'no Meniu', (tester) async {
    await pumpApp(
      tester,
      container,
      Routes.clientHome,
      size: const Size(360, 640),
    );

    final labels = [ro.navHome, ro.navOrders, ro.navFavorites, ro.navProfile];
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
    expect(find.text(ro.menuTitle), findsNothing);
    // The only shopping bag is the carts button in Acasă's header: no tab.
    expect(find.byIcon(Icons.shopping_bag_rounded), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(OpenCartsButton),
        matching: find.byIcon(Icons.shopping_bag_rounded),
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'a brand\'s home and menu show its cart button at the top right, and '
    'Acasă and Favorite the button for every cart; Comenzi and Profil show '
    'neither',
    (tester) async {
      for (final (route, screen, button) in [
        (Routes.brandHome(Brand.bakery), BrandHomeScreen, CartButton),
        (Routes.brandMenu(Brand.sushi), CatalogScreen, CartButton),
        (Routes.clientHome, HubHomeScreen, OpenCartsButton),
        (Routes.clientFavorites, FavoritesScreen, OpenCartsButton),
      ]) {
        await pumpApp(tester, container, route);

        final found = inScreenOf(screen, find.byType(button));
        expect(found, findsOneWidget, reason: route);
        expect(
          tester.getTopRight(found).dx,
          closeTo(400 - 16, 1),
          reason: route,
        );
        expect(tester.getTopLeft(found).dy, lessThan(80), reason: route);
        expect(
          inScreenOf(screen, find.byIcon(Icons.shopping_bag_rounded)),
          findsOneWidget,
          reason: route,
        );
      }

      for (final (route, screen) in [
        (Routes.clientOrders, OrdersScreen),
        (Routes.clientProfile, ProfileScreen),
      ]) {
        await pumpApp(tester, container, route);
        expect(
          inScreenOf(screen, find.byIcon(Icons.shopping_bag_rounded)),
          findsNothing,
          reason: route,
        );
      }
    },
  );

  testWidgets(
    'the badge counts the items; the cart opens over the brand\'s home, and '
    'back returns there',
    (tester) async {
      container.read(cartProvider(Brand.bakery).notifier)
        ..add('americano')
        ..add('coca-cola', quantity: 2);
      await pumpApp(tester, container, Routes.brandHome(Brand.bakery));
      final button = inScreen<BrandHomeScreen>(find.byType(CartButton));
      expect(
        find.descendant(of: button, matching: find.text('3')),
        findsOneWidget,
      );

      final semantics = tester.ensureSemantics();
      expect(find.bySemanticsLabel(ro.openCart(3)), findsOneWidget);
      semantics.dispose();

      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.byType(CartScreen), findsOneWidget);
      expect(find.text(ro.navHome), findsNothing);

      await goBack(tester);
      expect(find.byType(CartScreen), findsNothing);
      expect(find.byType(BrandHomeScreen), findsOneWidget);
    },
  );

  testWidgets('opened from a menu category, back returns to that category', (
    tester,
  ) async {
    container.read(cartProvider(Brand.bakery).notifier).add('americano');
    await pumpApp(
      tester,
      container,
      Routes.brandMenu(Brand.bakery, categoryId: 'bauturi'),
    );

    await tester.tap(inScreen<CatalogScreen>(find.byType(CartButton)));
    await tester.pumpAndSettle();
    expect(find.byType(CartScreen), findsOneWidget);

    await goBack(tester);
    expect(inScreen<CatalogScreen>(find.text('Coca Cola')), findsOneWidget);
  });

  testWidgets('opened straight from its link, back goes to the brand\'s home', (
    tester,
  ) async {
    await pumpApp(tester, container, Routes.brandCart(Brand.bakery));
    expect(find.byType(CartScreen), findsOneWidget);

    await goBack(tester);
    expect(find.byType(BrandHomeScreen), findsOneWidget);
  });
}
