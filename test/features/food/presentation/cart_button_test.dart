// The bottom tabs, and the cart buttons at the top right of Acasă's shell and
// of the other tabs, which replaced the cart tab, in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/account/presentation/profile/profile_screen.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/cart/cart_screen.dart';
import 'package:davidan_prototype/features/food/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/food/presentation/favorites/favorites_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/brand_feed_screen.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/cart_button.dart';
import 'package:davidan_prototype/features/hub/presentation/brand_shell.dart';
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
      inScreen<CartScreen>(find.byIcon(PhosphorIconsRegular.arrowLeft)),
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
    // The current tab's icon is filled, the others are outlines.
    IconData? tabIcon(String label) => tester
        .widget<Icon>(
          find.descendant(
            of: find.ancestor(
              of: find.text(label),
              matching: find.byType(InkWell),
            ),
            matching: find.byType(Icon),
          ),
        )
        .icon;
    expect(labels.map(tabIcon), [
      PhosphorIconsFill.house,
      PhosphorIconsRegular.receipt,
      PhosphorIconsRegular.heart,
      PhosphorIconsRegular.user,
    ]);
    await tester.tap(find.text(ro.navOrders));
    await tester.pumpAndSettle();
    expect(labels.map(tabIcon), [
      PhosphorIconsRegular.house,
      PhosphorIconsFill.receipt,
      PhosphorIconsRegular.heart,
      PhosphorIconsRegular.user,
    ]);
    await tester.tap(find.text(ro.navHome));
    await tester.pumpAndSettle();

    expect(find.text('Coș'), findsNothing);
    expect(find.text(ro.menuTitle), findsNothing);
    // The only shopping bag is the one in Acasă's bar: no tab. Acasă opens on
    // the patisserie, so it is that brand's own cart.
    expect(find.byIcon(PhosphorIconsRegular.handbag), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(CartButton),
        matching: find.byIcon(PhosphorIconsRegular.handbag),
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'Acasă\'s bar carries the open brand\'s cart, and every cart for a brand '
    'that sells nothing; Favorite the button for every cart; Comenzi and '
    'Profil show neither',
    (tester) async {
      for (final (route, screen, button) in [
        (Routes.brandHome(Brand.bakery), BrandShell, CartButton),
        (Routes.brandMenu(Brand.sushi), BrandShell, CartButton),
        (Routes.clientHome, BrandShell, CartButton),
        // Rent Car is a request by phone, not a cart.
        (Routes.brandHome(Brand.carRental), BrandShell, OpenCartsButton),
        (Routes.clientFavorites, FavoritesScreen, OpenCartsButton),
      ]) {
        await pumpApp(tester, container, route);

        final found = inScreenOf(screen, find.byType(button));
        expect(found, findsOneWidget, reason: route);
        // The circle is 16 px from the edge; its clear tap margin reaches
        // further.
        expect(
          tester.getTopRight(found).dx - TapTarget.iconButtonMargin,
          closeTo(400 - 16, 1),
          reason: route,
        );
        expect(tester.getTopLeft(found).dy, lessThan(80), reason: route);
        expect(
          inScreenOf(screen, find.byIcon(PhosphorIconsRegular.handbag)),
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
          inScreenOf(screen, find.byIcon(PhosphorIconsRegular.handbag)),
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
      final button = find.byType(CartButton);
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
      expect(find.byType(BrandFeedScreen), findsOneWidget);
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

    await tester.tap(find.byType(CartButton));
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
    expect(find.byType(BrandFeedScreen), findsOneWidget);
  });
}
