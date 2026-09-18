// The bottom tabs, and the ways into a cart that replaced the cart tab: the
// bar at the foot of a brand's pages (CartBar) and the bag for every cart in
// the header of the screens that have no bar of their own. In the real app, in
// Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/glass_surface.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/account/presentation/profile/profile_screen.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/cart/cart_screen.dart';
import 'package:davidan_prototype/features/food/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/food/presentation/favorites/favorites_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/brand_feed_screen.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/cart_bar.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/cart_button.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_card.dart';
import 'package:davidan_prototype/features/hub/presentation/brand_shell.dart';
import 'package:davidan_prototype/features/orders/presentation/orders_screen.dart';
import 'package:davidan_prototype/features/search/presentation/search_screen.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  Finder inScreenOf(Type screen, Finder finder) =>
      find.descendant(of: find.byType(screen), matching: finder);

  Finder inBar(Finder finder) =>
      find.descendant(of: find.byType(CartBar), matching: finder);

  /// What the brand's cart really holds, worked out from its lines rather than
  /// from the totals the bar itself reads, so a bar showing anything else is
  /// caught.
  ({int count, int totalBani}) cartOf(Brand brand) {
    final lines = container.read(cartLinesProvider(brand));
    return (
      count: lines.fold(0, (sum, line) => sum + line.quantity),
      totalBani: lines.fold(
        0,
        (sum, line) => sum + line.priceBani * line.quantity,
      ),
    );
  }

  /// The bar is showing [brand]'s cart, down to the last leu.
  void expectBarShows(Brand brand) {
    final (:count, :totalBani) = cartOf(brand);
    expect(find.byType(CartBar), findsOneWidget);
    expect(
      inBar(find.text(ro.cartBarTotal(ro.formatLei(totalBani)))),
      findsOneWidget,
    );
    expect(inBar(find.text('$count')), findsOneWidget);
  }

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
    // No cart tab, and no bag in the bar above it either: Acasă opens on the
    // patisserie, whose cart is empty, and once it holds something the bar at
    // the foot carries it.
    expect(find.byIcon(PhosphorIconsRegular.handbag), findsNothing);
    expect(find.byType(CartBar), findsNothing);
  });

  testWidgets(
    'inside a brand that sells, the bar at the top carries search and the '
    'bell and no bag; a brand that sells nothing keeps the bag for every '
    'cart, and so does Favorite; Comenzi and Profil show neither',
    (tester) async {
      // The header's own magnifier, not the search field under the banners.
      final headerSearch = find.widgetWithIcon(
        AppIconButton,
        PhosphorIconsRegular.magnifyingGlass,
      );

      for (final route in [
        Routes.brandHome(Brand.bakery),
        Routes.brandMenu(Brand.sushi),
        Routes.clientHome,
      ]) {
        await pumpApp(tester, container, route);
        expect(
          inScreenOf(BrandShell, find.byIcon(PhosphorIconsRegular.handbag)),
          findsNothing,
          reason: route,
        );
        expect(headerSearch, findsOneWidget, reason: route);
        expect(tester.getTopLeft(headerSearch).dy, lessThan(80), reason: route);
      }

      // Search is reachable from a category too, where there is no field.
      await pumpApp(
        tester,
        container,
        Routes.brandMenu(Brand.bakery, categoryId: 'bauturi'),
      );
      expect(headerSearch, findsOneWidget);
      await tester.tap(headerSearch);
      await tester.pumpAndSettle();
      expect(find.byType(SearchScreen), findsOneWidget);

      for (final (route, screen) in [
        // Rent Car is a request by phone, not a cart, so it never has a bar.
        (Routes.brandHome(Brand.carRental), BrandShell),
        (Routes.clientFavorites, FavoritesScreen),
      ]) {
        await pumpApp(tester, container, route);

        final found = inScreenOf(screen, find.byType(OpenCartsButton));
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
    'the bar counts the items and totals them; the cart opens over the '
    'brand\'s home, and back returns there',
    (tester) async {
      container.read(cartProvider(Brand.bakery).notifier)
        ..add('americano')
        ..add('coca-cola', quantity: 2);
      await pumpApp(tester, container, Routes.brandHome(Brand.bakery));
      expect(cartOf(Brand.bakery).count, 3);
      expectBarShows(Brand.bakery);

      final semantics = tester.ensureSemantics();
      expect(find.bySemanticsLabel(ro.openCart(3)), findsOneWidget);
      semantics.dispose();

      await tester.tap(find.byType(CartBar));
      await tester.pumpAndSettle();
      expect(find.byType(CartScreen), findsOneWidget);
      expect(find.text(ro.navHome), findsNothing);

      await goBack(tester);
      expect(find.byType(CartScreen), findsNothing);
      expect(find.byType(BrandFeedScreen), findsOneWidget);
      expectBarShows(Brand.bakery);
    },
  );

  testWidgets(
    'the bar comes up with the first item and goes away with the last, and '
    'its count and total never drift from the cart',
    (tester) async {
      await pumpApp(
        tester,
        container,
        Routes.brandMenu(Brand.bakery, categoryId: 'bauturi'),
      );
      expect(find.byType(CartBar), findsNothing);

      // Added from a card, as a customer would.
      await tapVisible(
        tester,
        find.descendant(
          of: find.widgetWithText(ProductCard, 'Americano'),
          matching: find.bySemanticsLabel(ro.addToCart('Americano')),
        ),
      );
      expectBarShows(Brand.bakery);

      for (final change in [
        () => container
            .read(cartProvider(Brand.bakery).notifier)
            .add('americano'),
        () => container
            .read(cartProvider(Brand.bakery).notifier)
            .add('coca-cola', quantity: 4),
        () => container
            .read(cartProvider(Brand.bakery).notifier)
            .removeOne('coca-cola'),
        () => container
            .read(cartProvider(Brand.bakery).notifier)
            .setQuantity('americano', 3),
        () => container
            .read(cartProvider(Brand.bakery).notifier)
            .remove('coca-cola'),
      ]) {
        change();
        await tester.pumpAndSettle();
        expectBarShows(Brand.bakery);
      }

      container.read(cartProvider(Brand.bakery).notifier).clear();
      await tester.pumpAndSettle();
      expect(find.byType(CartBar), findsNothing);
    },
  );

  testWidgets(
    'the bar is the open brand\'s cart: another brand\'s items are not in it, '
    'and a brand that sells nothing never shows one',
    (tester) async {
      container.read(cartProvider(Brand.bakery).notifier).add('americano');
      container.read(cartProvider(Brand.sushi).notifier)
        ..add('alasca')
        ..add('california-creveti', quantity: 2);

      await pumpApp(tester, container, Routes.brandHome(Brand.bakery));
      expectBarShows(Brand.bakery);

      await pumpApp(tester, container, Routes.brandHome(Brand.sushi));
      expectBarShows(Brand.sushi);
      expect(cartOf(Brand.sushi).count, 3);

      await pumpApp(tester, container, Routes.brandHome(Brand.carRental));
      expect(find.byType(CartBar), findsNothing);
      expect(find.byType(OpenCartsButton), findsOneWidget);
    },
  );

  testWidgets('the pages leave room for the bar: what they keep clear at the '
      'foot grows by its height while it is there, and the bar itself sits '
      'above the tab bar', (tester) async {
    await pumpApp(tester, container, Routes.brandHome(Brand.bakery));
    // What a page's last sliver leaves clear (BottomBarSpace).
    double roomUnderTheFeed() =>
        MediaQuery.paddingOf(tester.element(find.byType(BrandFeedScreen)))
            .bottom;
    final withoutBar = roomUnderTheFeed();
    expect(withoutBar, greaterThan(0), reason: 'the tab bar\'s own room');

    // Part way down the feed, where the bar coming up must leave the reader.
    final scroll = inScreen<BrandFeedScreen>(find.byType(Scrollable)).first;
    await tester.drag(scroll, const Offset(0, -400));
    await tester.pumpAndSettle();
    final scrolled = tester.state<ScrollableState>(scroll).position.pixels;
    expect(scrolled, greaterThan(0));

    container.read(cartProvider(Brand.bakery).notifier).add('americano');
    await tester.pumpAndSettle();
    expect(roomUnderTheFeed() - withoutBar, CartBar.space);
    expect(
      tester.state<ScrollableState>(scroll).position.pixels,
      scrolled,
      reason: 'the first thing added must not send the feed back to the top',
    );

    final bar = tester.getRect(find.byType(CartBar));
    expect(bar.height, CartBar.height);
    // Clear of the tab bar under it, and well below the chrome above.
    expect(bar.bottom, lessThanOrEqualTo(900 - GlassSurface.barHeight));
    expect(
      bar.top,
      greaterThan(
        BrandShell.chromeHeight(
          tester.element(find.byType(BrandFeedScreen)),
          // The switcher starts folded out, as this feed has just opened.
          switcherOpen: true,
        ),
      ),
    );

    container.read(cartProvider(Brand.bakery).notifier).clear();
    await tester.pumpAndSettle();
    expect(roomUnderTheFeed(), withoutBar);
  });

  testWidgets('opened from a menu category, back returns to that category', (
    tester,
  ) async {
    container.read(cartProvider(Brand.bakery).notifier).add('americano');
    await pumpApp(
      tester,
      container,
      Routes.brandMenu(Brand.bakery, categoryId: 'bauturi'),
    );

    await tester.tap(find.byType(CartBar));
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
