// The hub (/client/home): the pinned location bar, the brand bubbles, and the
// brands they open full screen, in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/widgets/brand_logo.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/account/presentation/location/location_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/brand_home_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/brand_intro_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/client_shell.dart';
import 'package:davidan_prototype/features/hub/presentation/hub_home_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/brand_bubbles.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  Finder bubble(Brand brand) => find.descendant(
    of: find.byType(BrandBubbles),
    matching: find.text(brandIntros[brand]!.name),
  );

  Future<void> open(WidgetTester tester, Brand brand) async {
    await tester.tap(bubble(brand));
    await tester.pumpAndSettle();
  }

  testWidgets('the location bar stays pinned at the top while the page scrolls '
      'beneath it, and still opens the location screen', (tester) async {
    // Short enough for the hub to scroll.
    await pumpApp(
      tester,
      container,
      Routes.clientHome,
      size: const Size(360, 400),
    );
    final bar = inScreen<HubHomeScreen>(find.text(ro.chooseAddress));
    final logo = inScreen<HubHomeScreen>(find.byType(BrandLogo));
    final barTopBefore = tester.getTopLeft(bar).dy;
    expect(tester.getTopLeft(logo).dy, lessThan(barTopBefore));

    await tester.drag(
      inScreen<HubHomeScreen>(find.byType(CustomScrollView)),
      const Offset(0, -800),
    );
    await tester.pumpAndSettle();

    // The logo row scrolled out of view (finders skip what's off screen);
    // the bar moved up by that row only and stays on screen.
    expect(logo, findsNothing);
    final barTopAfter = tester.getTopLeft(bar).dy;
    expect(barTopAfter, lessThan(barTopBefore));
    expect(barTopAfter, greaterThanOrEqualTo(0));

    await tester.tap(bar);
    await tester.pumpAndSettle();
    expect(find.byType(LocationScreen), findsOneWidget);
  });

  testWidgets(
    'the five brands in the client\'s order, three on a 360 px phone\'s first '
    'row and two centred below, on DaviDan\'s caramel',
    (tester) async {
      await pumpApp(
        tester,
        container,
        Routes.clientHome,
        size: const Size(360, 640),
      );

      expect(
        [for (final brand in Brand.values) brandIntros[brand]!.name],
        ['Restaurant', 'Sushi', 'Patiserie', 'Apă naturală', 'Rent Car'],
      );
      // Each name is centred under its bubble: its top gives the row, its
      // centre the position in the row.
      final names = [
        for (final brand in Brand.values)
          (
            top: tester.getTopLeft(bubble(brand)).dy,
            x: tester.getCenter(bubble(brand)).dx,
          ),
      ];
      final [restaurant, sushi, bakery, water, carRental] = names;
      for (final (left, right) in [
        (restaurant, sushi),
        (sushi, bakery),
        (water, carRental),
      ]) {
        expect(left.top, closeTo(right.top, 1));
        expect(left.x, lessThan(right.x));
      }
      expect(water.top, greaterThan(bakery.top));
      expect(sushi.x, closeTo(180, 1));
      expect((water.x + carRental.x) / 2, closeTo(180, 1));

      final band = tester.widget<ColoredBox>(
        find
            .descendant(
              of: find.byType(BrandBubbles),
              matching: find.byType(ColoredBox),
            )
            .first,
      );
      expect(band.color, AppColors.dark.hubBand);
    },
  );

  testWidgets(
    'Patiserie opens the bakery full screen, without the bottom bar, and back '
    'returns to the hub',
    (tester) async {
      await pumpApp(tester, container, Routes.clientHome);

      await open(tester, Brand.bakery);

      expect(find.byType(BrandHomeScreen), findsOneWidget);
      expect(find.text(ro.navOrders), findsNothing);
      await tester.tap(
        inScreen<BrandHomeScreen>(find.byIcon(Icons.arrow_back_rounded)),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HubHomeScreen), findsOneWidget);
      expect(find.byType(ClientShell), findsOneWidget);
    },
  );

  testWidgets(
    'Restaurant opens "În curând" with davidan.md\'s line and photo, and no '
    'menu',
    (tester) async {
      await pumpApp(tester, container, Routes.clientHome);

      await open(tester, Brand.restaurant);

      final page = find.byType(BrandIntroScreen);
      expect(page, findsOneWidget);
      expect(find.text(ro.navOrders), findsNothing);
      expect(
        inScreen<BrandIntroScreen>(find.text(ro.comingSoonTitle)),
        findsOneWidget,
      );
      expect(
        inScreen<BrandIntroScreen>(
          find.text(
            'Experiențe culinare de neuitat într-un ambient elegant și '
            'primitor.',
          ),
        ),
        findsOneWidget,
      );
      expect(
        (tester
                    .widget<Image>(
                      inScreen<BrandIntroScreen>(find.byType(Image)),
                    )
                    .image
                as AssetImage)
            .assetName,
        'assets/images/products/orez-pui.webp',
      );
      expect(
        inScreen<BrandIntroScreen>(find.text(ro.inProgressTitle)),
        findsNothing,
      );
      expect(inScreen<BrandIntroScreen>(find.text(ro.menuTitle)), findsNothing);

      await tester.tap(
        inScreen<BrandIntroScreen>(find.byIcon(Icons.arrow_back_rounded)),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HubHomeScreen), findsOneWidget);
    },
  );

  testWidgets(
    'Sushi, Apă naturală and Rent Car open a temporary page that says it is '
    'still being built, with their source\'s one line',
    (tester) async {
      await pumpApp(tester, container, Routes.clientHome);

      for (final brand in [Brand.sushi, Brand.water, Brand.carRental]) {
        await open(tester, brand);

        expect(find.byType(BrandIntroScreen), findsOneWidget, reason: '$brand');
        expect(find.text(ro.navOrders), findsNothing, reason: '$brand');
        expect(find.text(ro.inProgressTitle), findsOneWidget, reason: '$brand');
        expect(
          find.text(ro.inProgressMessage),
          findsOneWidget,
          reason: '$brand',
        );
        expect(find.text(ro.comingSoonTitle), findsNothing, reason: '$brand');
        expect(
          find.text(brandIntros[brand]!.description!),
          findsOneWidget,
          reason: '$brand',
        );

        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
        await tester.pumpAndSettle();
        expect(find.byType(HubHomeScreen), findsOneWidget, reason: '$brand');
      }
    },
  );

  testWidgets(
    'a brand opened straight from its link goes back to the hub; an unknown '
    'brand, or a menu for a brand without one, lands elsewhere',
    (tester) async {
      await pumpApp(tester, container, Routes.brandHome(Brand.bakery));
      expect(find.byType(BrandHomeScreen), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
      await tester.pumpAndSettle();
      expect(find.byType(HubHomeScreen), findsOneWidget);

      await pumpApp(tester, container, '/b/pizzeria');
      expect(find.byType(HubHomeScreen), findsOneWidget);

      await pumpApp(tester, container, Routes.brandMenu(Brand.restaurant));
      expect(find.byType(BrandIntroScreen), findsOneWidget);
    },
  );
}
