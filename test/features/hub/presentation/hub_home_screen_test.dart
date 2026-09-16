// The hub (/client/home): the pinned location bar, the brand bubbles, and the
// brands they open full screen, in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/app_router.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/widgets/brand_logo.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/account/presentation/location/location_screen.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/food/presentation/home/brand_home_screen.dart';
import 'package:davidan_prototype/features/food/presentation/product/product_detail_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/brand_intro_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/client_shell.dart';
import 'package:davidan_prototype/features/hub/presentation/hub_home_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/active_orders_strip.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/brand_bubbles.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/for_you_sheet.dart';
import 'package:davidan_prototype/features/orders/presentation/order_confirmation_screen.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  Finder bubble(Brand brand) => find.descendant(
    of: find.byType(BrandBubbles),
    matching: find.text(brandIntros[brand]!.name),
  );

  Finder inStrip(Finder finder) =>
      find.descendant(of: find.byType(ActiveOrdersStrip), matching: finder);

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
    'with no order on its way there is no strip; an order shows in it with '
    'its brand and live status, opens from there, and leaves once completed',
    (tester) async {
      await pumpApp(tester, container, Routes.clientHome);
      expect(inStrip(find.byType(InkWell)), findsNothing);

      final order = placeTestOrder(container);
      await tester.pumpAndSettle();
      expect(inStrip(find.text(ro.orderNumber(order.id))), findsOneWidget);
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

      await tester.tap(inStrip(find.text(ro.orderNumber(order.id))));
      await tester.pumpAndSettle();
      expect(find.byType(OrderConfirmationScreen), findsOneWidget);

      advanceOrderTo(container, order.id, OrderStatus.completed);
      container.read(appRouterProvider).go(Routes.clientHome);
      await tester.pumpAndSettle();
      expect(inStrip(find.text(ro.orderNumber(order.id))), findsNothing);
    },
  );

  testWidgets(
    'orders from two brands both show, the newest first, the next one '
    'peeking in at the edge',
    (tester) async {
      final bakery = placeTestOrder(container);
      final sushi = placeTestOrder(container, brand: Brand.sushi);
      await pumpApp(tester, container, Routes.clientHome);

      Rect cardOf(Order order) => tester.getRect(
        find
            .ancestor(
              of: inStrip(find.text(ro.orderNumber(order.id))),
              matching: find.byType(InkWell),
            )
            .first,
      );
      final newest = cardOf(sushi);
      final older = cardOf(bakery);
      expect(newest.left, closeTo(16, 1));
      expect(older.left, greaterThan(newest.right));
      expect(older.left, lessThan(400));
      expect(inStrip(find.text('Sushi')), findsOneWidget);
    },
  );

  testWidgets(
    '"Pentru tine" signed out, "{first name}, pentru tine" signed in, with the '
    'bakery\'s popular products; adding from it fills the bakery\'s cart',
    (tester) async {
      await pumpApp(tester, container, Routes.clientHome);
      final sheet = find.byType(ForYouSheet);
      await tester.scrollUntilVisible(
        sheet,
        200,
        scrollable: inScreen<HubHomeScreen>(find.byType(Scrollable)).first,
      );
      expect(
        find.descendant(
          of: sheet,
          matching: find.text(ro.forYouTitleSignedOut),
        ),
        findsOneWidget,
      );

      signInTestAccount(container, name: 'Ana Popescu');
      await tester.pumpAndSettle();
      expect(
        find.descendant(of: sheet, matching: find.text(ro.forYouTitle('Ana'))),
        findsOneWidget,
      );

      final products = container.read(popularProductsProvider(Brand.bakery));
      expect(container.read(forYouProductsProvider), products);
      final first = products.first;
      await tapVisible(
        tester,
        find.descendant(
          of: sheet,
          matching: find.bySemanticsLabel(ro.addToCart(first.name)),
        ),
      );
      expect(container.read(cartQuantitiesProvider(Brand.bakery)), {
        first.id: 1,
      });

      await tapVisible(
        tester,
        find.descendant(of: sheet, matching: find.text(first.name)),
      );
      expect(find.byType(ProductDetailScreen), findsOneWidget);
      expect(
        tester
            .widget<ProductDetailScreen>(find.byType(ProductDetailScreen))
            .productKey,
        first.key,
      );
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
