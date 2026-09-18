// Acasă (/client/home): the bar and the brand switcher that stay in place
// while the brand under them changes, and the brands themselves, in the real
// app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/app_router.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_assets.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/account/presentation/location/location_screen.dart';
import 'package:davidan_prototype/features/food/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/brand_feed_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/menu_feed.dart';
import 'package:davidan_prototype/features/food/presentation/home/water_feed.dart';
import 'package:davidan_prototype/features/hub/application/last_brand_notifier.dart';
import 'package:davidan_prototype/features/hub/presentation/brand_shell.dart';
import 'package:davidan_prototype/features/hub/presentation/client_shell.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/active_orders_strip.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/brand_switcher_row.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/coming_soon_feed.dart';
import 'package:davidan_prototype/features/orders/presentation/order_confirmation_screen.dart';
import 'package:davidan_prototype/features/rental/presentation/rental_feed.dart';
import 'package:davidan_prototype/features/search/presentation/search_screen.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  Finder bubble(Brand brand) => find.descendant(
    of: find.byType(BrandSwitcherRow),
    matching: find.text(brandIntros[brand]!.name),
  );

  Finder inStrip(Finder finder) =>
      find.descendant(of: find.byType(ActiveOrdersStrip), matching: finder);

  Brand openBrand(WidgetTester tester) =>
      tester.widget<BrandFeedScreen>(find.byType(BrandFeedScreen)).brand;

  Future<void> switchTo(WidgetTester tester, Brand brand) async {
    await tester.tap(bubble(brand));
    await tester.pumpAndSettle();
  }

  testWidgets('Acasă has no screen of its own: it opens on the patisserie '
      'until another brand is chosen, then on that one', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);
    expect(openBrand(tester), Brand.bakery);
    expect(
      container.read(appRouterProvider).state.uri.path,
      Routes.brandHome(Brand.bakery),
    );

    // remember() sets the brand as the switcher is tapped; only the write to
    // local storage is fire-and-forget, and nothing here reads storage back.
    // (Not flushWrites(): a widget test runs on a fake clock that a delay
    // awaited outside a pump never reaches, so it would hang the test.)
    await switchTo(tester, Brand.sushi);
    expect(container.read(lastBrandProvider), Brand.sushi);

    // As if the app were opened again.
    container.read(appRouterProvider).go(Routes.clientHome);
    await tester.pumpAndSettle();
    expect(openBrand(tester), Brand.sushi);
  });

  testWidgets(
    'the five brands in the client\'s order, each on its own colour with its '
    'own white logo; the open one is the only one marked',
    (tester) async {
      await pumpApp(tester, container, Routes.clientHome);

      expect(
        [for (final brand in Brand.values) brandIntros[brand]!.name],
        ['Restaurant', 'Sushi', 'Patiserie', 'Apă naturală', 'Rent Car'],
      );
      // One row, in order, left to right.
      final positions = [
        for (final brand in Brand.values) tester.getCenter(bubble(brand)),
      ];
      for (final (index, position) in positions.indexed) {
        if (index == 0) continue;
        expect(position.dy, closeTo(positions[index - 1].dy, 1));
        expect(position.dx, greaterThan(positions[index - 1].dx));
      }

      // A bubble shows two pictures: the brand's white logo over the brand's
      // own photo (_BubbleFace). It holds more than two Images — the logo is
      // drawn three times over, two blurred halo passes under the logo
      // proper — so this reads which assets a bubble carries rather than
      // counting them, and stays true however the halo is painted.
      Set<String> picturesOn(Brand brand) => {
        for (final image in tester.widgetList<Image>(
          find.descendant(
            of: find.ancestor(
              of: bubble(brand),
              matching: find.byType(InkResponse),
            ),
            matching: find.byType(Image),
          ),
        ))
          (image.image as AssetImage).assetName,
      };
      // The logo each brand is pinned to; the photo behind it is whichever one
      // the brand's intro carries, and nothing else is in the bubble.
      const logos = {
        Brand.restaurant: AppAssets.logoWhite,
        Brand.sushi: AppAssets.sushiLogoWhite,
        Brand.bakery: AppAssets.logoWhite,
        Brand.water: AppAssets.waterLogoWhite,
        Brand.carRental: AppAssets.rentCarLogoWhite,
      };
      for (final brand in Brand.values) {
        expect(
          picturesOn(brand),
          unorderedEquals({logos[brand]!, brandIntros[brand]!.image}),
          reason: '$brand',
        );
      }

      // A bubble's name carries no semantics of its own — the bubble around it
      // declares the button and swallows what is inside (excludeSemantics) —
      // so this asks for the node the name sits in rather than the name's.
      final semantics = tester.ensureSemantics();
      expect(
        tester.getSemantics(bubble(Brand.bakery)),
        matchesSemantics(label: 'Patiserie', isButton: true, isSelected: true),
      );
      expect(
        tester.getSemantics(bubble(Brand.sushi)),
        matchesSemantics(label: 'Sushi', isButton: true),
      );
      semantics.dispose();
    },
  );

  testWidgets('every brand opens in the same shell, keeping the bar, the '
      'switcher and the bottom bar', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);
    final shell = tester.element(find.byType(BrandShell));

    for (final brand in Brand.values) {
      await switchTo(tester, brand);
      expect(openBrand(tester), brand, reason: '$brand');
      // The very same shell: the bar and the switcher were never rebuilt.
      expect(
        tester.element(find.byType(BrandShell)),
        same(shell),
        reason: '$brand',
      );
      expect(find.byType(BrandSwitcherRow), findsOneWidget, reason: '$brand');
      expect(find.text(ro.navOrders), findsOneWidget, reason: '$brand');
      expect(find.byType(ClientShell), findsOneWidget, reason: '$brand');

      // Each brand's own content is under it.
      expect(
        switch (brand) {
          Brand.bakery || Brand.sushi => find.byType(MenuFeed),
          Brand.water => find.byType(WaterFeed),
          Brand.carRental => find.byType(RentalFeed),
          Brand.restaurant => find.byType(ComingSoonFeed),
        },
        findsOneWidget,
        reason: '$brand',
      );
    }
  });

  testWidgets(
    'the restaurant, which isn\'t open in the app yet, shows "În curând" with '
    'davidan.md\'s line and photo, and no menu, without upsetting the shell',
    (tester) async {
      await pumpApp(tester, container, Routes.brandHome(Brand.restaurant));

      expect(find.byType(BrandSwitcherRow), findsOneWidget);
      expect(
        inScreen<ComingSoonFeed>(find.text(ro.comingSoonTitle)),
        findsOneWidget,
      );
      expect(
        inScreen<ComingSoonFeed>(
          find.text(
            'Experiențe culinare de neuitat într-un ambient elegant și '
            'primitor.',
          ),
        ),
        findsOneWidget,
      );
      expect(
        (tester
                    .widget<Image>(inScreen<ComingSoonFeed>(find.byType(Image)))
                    .image
                as AssetImage)
            .assetName,
        'assets/images/products/orez-pui.webp',
      );
      expect(inScreen<ComingSoonFeed>(find.text(ro.menuTitle)), findsNothing);
    },
  );

  testWidgets('a category opens under the same bar and switcher, and back '
      'returns to the feed', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);
    final shell = tester.element(find.byType(BrandShell));

    await tapVisible(tester, find.text('Kurtos').first);
    expect(find.byType(CatalogScreen), findsOneWidget);
    expect(tester.element(find.byType(BrandShell)), same(shell));
    expect(find.byType(BrandSwitcherRow), findsOneWidget);
    expect(find.text(ro.navOrders), findsOneWidget);

    container.read(appRouterProvider).pop();
    await tester.pumpAndSettle();
    expect(find.byType(BrandFeedScreen), findsOneWidget);
    expect(find.byType(CatalogScreen), findsNothing);
  });

  testWidgets('search has a top of its own, so it covers the bar and the '
      'switcher rather than sitting under them', (tester) async {
    await pumpApp(tester, container, Routes.brandSearch(Brand.bakery));
    expect(find.byType(SearchScreen), findsOneWidget);
    expect(find.byType(BrandSwitcherRow), findsNothing);
    // Still inside Acasă, so the tabs stay.
    expect(find.text(ro.navOrders), findsOneWidget);
  });

  testWidgets('the location bar stays pinned at the top while the feed '
      'scrolls beneath it, and still opens the location screen', (
    tester,
  ) async {
    await pumpApp(
      tester,
      container,
      Routes.clientHome,
      size: const Size(360, 400),
    );
    final bar = find.text(ro.chooseAddress);
    final barTopBefore = tester.getTopLeft(bar).dy;

    await tester.drag(
      inScreen<BrandFeedScreen>(find.byType(CustomScrollView)),
      const Offset(0, -800),
    );
    await tester.pumpAndSettle();

    // The bar did not move: it is not part of what scrolls.
    expect(tester.getTopLeft(bar).dy, closeTo(barTopBefore, 0.01));
    expect(find.byType(BrandSwitcherRow), findsOneWidget);

    await tester.tap(bar);
    await tester.pumpAndSettle();
    expect(find.byType(LocationScreen), findsOneWidget);
  });

  testWidgets(
    'with no order on its way there is no strip; an order shows in it with '
    'its brand, what was ordered and its live status, opens from there, and '
    'leaves once completed',
    (tester) async {
      await pumpApp(tester, container, Routes.clientHome);
      expect(inStrip(find.byType(InkWell)), findsNothing);

      final order = placeTestOrder(container);
      await tester.pumpAndSettle();
      expect(
        inStrip(find.text(ro.activeOrderSummary(3, '138 lei'))),
        findsOneWidget,
      );
      expect(inStrip(find.text('Patiserie')), findsOneWidget);
      expect(
        inStrip(find.text(ro.orderStatus(OrderStatus.placed))),
        findsOneWidget,
      );

      advanceOrderTo(container, order.id, OrderStatus.onTheWay);
      await tester.pumpAndSettle();
      expect(
        inStrip(find.text(ro.orderStatus(OrderStatus.onTheWay))),
        findsOneWidget,
      );

      await tester.tap(inStrip(find.text(ro.activeOrderSummary(3, '138 lei'))));
      await tester.pumpAndSettle();
      expect(find.byType(OrderConfirmationScreen), findsOneWidget);

      advanceOrderTo(container, order.id, OrderStatus.completed);
      container.read(appRouterProvider).go(Routes.clientHome);
      await tester.pumpAndSettle();
      expect(
        inStrip(find.text(ro.activeOrderSummary(3, '138 lei'))),
        findsNothing,
      );
    },
  );

  testWidgets(
    'a brand opened straight from its link keeps the shell; an unknown brand, '
    'or a menu for a brand without one, lands on a brand that has one',
    (tester) async {
      await pumpApp(tester, container, Routes.brandHome(Brand.sushi));
      expect(openBrand(tester), Brand.sushi);
      expect(find.byType(BrandSwitcherRow), findsOneWidget);

      // A brand nobody has heard of goes to Acasă, which opens on the brand
      // last shopped in — sushi, remembered from the link above. The
      // patisserie is the fallback only when nothing has been remembered yet,
      // which is the first run and is what this file's first test covers.
      await pumpApp(tester, container, '${Routes.clientHome}/b/pizzeria');
      expect(openBrand(tester), Brand.sushi);

      await pumpApp(tester, container, Routes.brandMenu(Brand.restaurant));
      expect(openBrand(tester), Brand.restaurant);
      expect(find.byType(CatalogScreen), findsNothing);
    },
  );

  testWidgets('a brand that sells carries no bag at the top, since the bar at '
      'the foot is its cart; a brand that sells nothing keeps the bag for '
      'every cart', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);
    expect(
      find.byIcon(PhosphorIconsRegular.handbag),
      findsNothing,
      reason: 'the patisserie sells, so its cart is the bar at the foot',
    );

    await switchTo(tester, Brand.carRental);
    expect(find.byIcon(PhosphorIconsRegular.handbag), findsOneWidget);
  });

  testWidgets(
    'the switcher folds away as the feed is scrolled down and is back on the '
    'way up, while the bar above it never moves',
    (tester) async {
      await pumpApp(
        tester,
        container,
        Routes.clientHome,
        size: const Size(360, 640),
      );
      // The room the switcher takes: the fold is its own, so the bar and the
      // page around it are untouched.
      Finder fold() => find
          .ancestor(
            of: find.byType(BrandSwitcherRow),
            matching: find.byType(ClipRect),
          )
          .first;
      double foldHeight() => tester.getSize(fold()).height;

      final bar = find.text(ro.chooseAddress);
      final barTop = tester.getTopLeft(bar).dy;
      final open = foldHeight();
      expect(open, greaterThan(0));

      final feed = inScreen<BrandFeedScreen>(find.byType(CustomScrollView));
      await tester.drag(feed, const Offset(0, -400));
      await tester.pumpAndSettle();

      expect(foldHeight(), 0, reason: 'scrolled down, the switcher is folded');
      expect(tester.getTopLeft(bar).dy, closeTo(barTop, 0.01));
      expect(find.text(ro.chooseAddress), findsOneWidget);
      expect(
        find.byIcon(PhosphorIconsRegular.magnifyingGlass),
        findsOneWidget,
        reason: 'the bar keeps the address, search and the bell',
      );

      await tester.drag(feed, const Offset(0, 120));
      await tester.pumpAndSettle();

      expect(foldHeight(), open, reason: 'on the way up it is back');
      expect(tester.getTopLeft(bar).dy, closeTo(barTop, 0.01));
      // And it still switches brand.
      await switchTo(tester, Brand.sushi);
      expect(openBrand(tester), Brand.sushi);
    },
  );
}
