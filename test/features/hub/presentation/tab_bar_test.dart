// The bottom bar inside the five brands, in the real app, in Chrome. A brand's
// browse screens (its feed, a category, its information and legal pages) open
// inside Acasă and keep the bar; its task screens, which have their own bottom
// button (product, cart, checkout, car, request), cover it:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/account/presentation/profile/profile_screen.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/cart/cart_screen.dart';
import 'package:davidan_prototype/features/food/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/food/presentation/checkout/checkout_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/brand_feed_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/water_feed.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/category_grid.dart';
import 'package:davidan_prototype/features/food/presentation/product/product_detail_screen.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/cart_button.dart';
import 'package:davidan_prototype/features/hub/presentation/brand_info_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/coming_soon_feed.dart';
import 'package:davidan_prototype/features/hub/presentation/client_shell.dart';
import 'package:davidan_prototype/features/hub/presentation/legal_document_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/brand_switcher_row.dart';
import 'package:davidan_prototype/features/orders/presentation/orders_screen.dart';
import 'package:davidan_prototype/features/rental/presentation/car_detail_screen.dart';
import 'package:davidan_prototype/features/rental/presentation/rental_feed.dart';
import 'package:davidan_prototype/features/rental/presentation/rental_request_screen.dart';

import '../../../helpers/test_app.dart';

const _home = 0;
const _orders = 1;
const _profile = 3;

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  /// [screen] is showing, under the bar, once, with [tab] selected. "Acasă"
  /// is only ever the bar's label; "Comenzi" is also Comenzi's title.
  void expectBar(WidgetTester tester, Type screen, {int tab = _home}) {
    expect(find.byType(screen), findsOneWidget, reason: '$screen');
    final shell = find.byType(ClientShell);
    expect(shell, findsOneWidget, reason: '$screen');
    expect(
      tester.widget<ClientShell>(shell).navigationShell.currentIndex,
      tab,
      reason: '$screen',
    );
    expect(find.text(ro.navHome), findsOneWidget, reason: '$screen');
  }

  /// [screen] is showing full screen, over the bar.
  void expectNoBar(Type screen) {
    expect(find.byType(screen), findsOneWidget, reason: '$screen');
    expect(find.byType(ClientShell), findsNothing, reason: '$screen');
    expect(find.text(ro.navOrders), findsNothing, reason: '$screen');
  }

  Future<void> openBrand(WidgetTester tester, Brand brand) async {
    await tester.tap(
      find.descendant(
        of: find.byType(BrandSwitcherRow),
        matching: find.text(brandIntros[brand]!.name),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> back(WidgetTester tester) async {
    await tester.tap(find.byIcon(PhosphorIconsRegular.arrowLeft));
    await tester.pumpAndSettle();
  }

  /// The link to the brand's information, at the end of its feed.
  Future<void> tapInfoLink(WidgetTester tester, String brandName) =>
      tapVisible(tester, find.text(ro.openBrandInfo(brandName)));

  testWidgets('Patiserie: home and menu keep the bar; a product and the cart '
      'cover it; the empty cart\'s "browse the menu" opens the menu under the '
      'bar, and back steps through the brand to the hub', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);

    await openBrand(tester, Brand.bakery);
    expectBar(tester, BrandFeedScreen);

    await tapVisible(
      tester,
      find.descendant(
        of: find.byType(CategoryGrid),
        matching: find.text('Patiserie'),
      ),
    );
    expectBar(tester, CatalogScreen);

    await tapVisible(
      tester,
      inScreen<CatalogScreen>(find.text('Croissant cu ciocolată')),
    );
    expectNoBar(ProductDetailScreen);
    await back(tester);
    expectBar(tester, CatalogScreen);

    await tester.tap(inScreen<CatalogScreen>(find.byType(CartButton)));
    await tester.pumpAndSettle();
    expectNoBar(CartScreen);

    await tapVisible(tester, find.text(ro.browseMenu));
    expectBar(tester, CatalogScreen);
    // The feed is Acasă's first screen, so back from a category returns to it
    // and stops there.
    await back(tester);
    expectBar(tester, BrandFeedScreen);
    expect(find.byIcon(PhosphorIconsRegular.arrowLeft), findsNothing);
  });

  testWidgets('Sushi: home, information and a legal page keep the bar; the '
      'cart and checkout cover it; an emptied checkout\'s "browse the menu" '
      'opens the menu under the bar', (tester) async {
    container.read(cartProvider(Brand.sushi).notifier).add('alasca');
    await pumpApp(tester, container, Routes.clientHome);

    await openBrand(tester, Brand.sushi);
    expectBar(tester, BrandFeedScreen);

    await tapInfoLink(tester, 'DaviDan Sushi');
    expectBar(tester, BrandInfoScreen);
    await tapVisible(tester, find.text('Termeni și Condiții'));
    expectBar(tester, LegalDocumentScreen);
    await back(tester);
    await back(tester);
    expectBar(tester, BrandFeedScreen);

    await tester.tap(find.byType(CartButton));
    await tester.pumpAndSettle();
    expectNoBar(CartScreen);
    await tapVisible(tester, find.text(ro.continueOrder));
    expectNoBar(CheckoutScreen);

    container.read(cartProvider(Brand.sushi).notifier).clear();
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text(ro.browseMenu));
    expectBar(tester, CatalogScreen);
    expect(
      tester.widget<CatalogScreen>(find.byType(CatalogScreen)).brand,
      Brand.sushi,
    );
    await back(tester);
    expectBar(tester, BrandFeedScreen);
  });

  testWidgets('Apă: its home keeps the bar; a product and the cart cover it; '
      'the empty cart\'s "browse the products" returns to the home under the '
      'bar', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);

    await openBrand(tester, Brand.water);
    expectBar(tester, WaterFeed);

    await tapVisible(
      tester,
      inScreen<WaterFeed>(find.text('Apa DaviDan naturală')),
    );
    expectNoBar(ProductDetailScreen);
    await back(tester);
    expectBar(tester, WaterFeed);

    await tester.tap(find.byType(CartButton));
    await tester.pumpAndSettle();
    expectNoBar(CartScreen);
    await tapVisible(tester, find.text(ro.browseProducts));
    expectBar(tester, WaterFeed);
  });

  testWidgets('Restaurant: "În curând" keeps the bar and the switcher, which '
      'leads on to a brand that is open', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);

    await openBrand(tester, Brand.restaurant);
    expectBar(tester, ComingSoonFeed);
    expect(find.byType(BrandSwitcherRow), findsOneWidget);

    await openBrand(tester, Brand.bakery);
    expectBar(tester, BrandFeedScreen);
    expect(find.byType(ComingSoonFeed), findsNothing);
  });

  testWidgets('Rent Car: the fleet, information and a legal page keep the bar; '
      'a car and its request cover it', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);

    await openBrand(tester, Brand.carRental);
    expectBar(tester, RentalFeed);

    await tapInfoLink(tester, 'DaviDan Rent Car');
    expectBar(tester, BrandInfoScreen);
    await tapVisible(tester, find.text('Termeni și Condiții'));
    expectBar(tester, LegalDocumentScreen);
    await back(tester);
    await back(tester);
    expectBar(tester, RentalFeed);

    await tapVisible(tester, inScreen<RentalFeed>(find.text('Audi Q5 2012')));
    expectNoBar(CarDetailScreen);
    await tapVisible(tester, find.text(ro.rentalRequestAction));
    expectNoBar(RentalRequestScreen);
    await back(tester);
    expectNoBar(CarDetailScreen);
    await back(tester);
    expectBar(tester, RentalFeed);
  });

  testWidgets('inside a brand, another tab and back keeps the brand\'s screen; '
      'the phone\'s back steps back inside Acasă; tapping Acasă again returns '
      'to the brand\'s feed', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);
    await openBrand(tester, Brand.bakery);
    await tapVisible(
      tester,
      find.descendant(
        of: find.byType(CategoryGrid),
        matching: find.text('Patiserie'),
      ),
    );

    await tester.tap(find.text(ro.navOrders));
    await tester.pumpAndSettle();
    expectBar(tester, OrdersScreen, tab: _orders);
    await tester.tap(find.text(ro.navHome));
    await tester.pumpAndSettle();
    expectBar(tester, CatalogScreen);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expectBar(tester, BrandFeedScreen);

    await tester.tap(find.text(ro.navHome));
    await tester.pumpAndSettle();
    expectBar(tester, BrandFeedScreen);
    expect(
      tester.widget<BrandFeedScreen>(find.byType(BrandFeedScreen)).brand,
      Brand.bakery,
    );
  });

  testWidgets('Profil opens a brand\'s information and legal pages inside '
      'Profil, and back returns to Profil; Acasă is left as it was', (
    tester,
  ) async {
    await pumpApp(tester, container, Routes.clientProfile);

    await tapVisible(
      tester,
      inScreen<ProfileScreen>(find.text(brandIntros[Brand.sushi]!.name)),
    );
    expectBar(tester, BrandInfoScreen, tab: _profile);
    await tapVisible(tester, find.text('Politica de Confidențialitate'));
    expectBar(tester, LegalDocumentScreen, tab: _profile);
    await back(tester);
    await back(tester);
    expectBar(tester, ProfileScreen, tab: _profile);

    await tester.tap(find.text(ro.navHome));
    await tester.pumpAndSettle();
    expectBar(tester, BrandFeedScreen);
  });
}
