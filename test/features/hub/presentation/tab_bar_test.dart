// The bottom bar inside the five brands, in the real app, in Chrome. A brand's
// browse screens (home, menu, information, legal pages) open inside Acasă and
// keep the bar; its task screens, which have their own bottom button
// (product, cart, checkout, car, request), cover it:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/account/presentation/profile/profile_screen.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/cart/cart_screen.dart';
import 'package:davidan_prototype/features/food/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/food/presentation/checkout/checkout_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/brand_home_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/water_home_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/category_strip.dart';
import 'package:davidan_prototype/features/food/presentation/product/product_detail_screen.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/cart_button.dart';
import 'package:davidan_prototype/features/hub/presentation/brand_info_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/brand_intro_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/client_shell.dart';
import 'package:davidan_prototype/features/hub/presentation/hub_home_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/legal_document_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/brand_bubbles.dart';
import 'package:davidan_prototype/features/orders/presentation/orders_screen.dart';
import 'package:davidan_prototype/features/rental/presentation/car_detail_screen.dart';
import 'package:davidan_prototype/features/rental/presentation/rental_home_screen.dart';
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
        of: find.byType(BrandBubbles),
        matching: find.text(brandIntros[brand]!.name),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> back(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
  }

  Future<void> tapInfoButton(WidgetTester tester, String brandName) async {
    final semantics = tester.ensureSemantics();
    await tester.tap(find.bySemanticsLabel(ro.openBrandInfo(brandName)));
    await tester.pumpAndSettle();
    semantics.dispose();
  }

  testWidgets('Patiserie: home and menu keep the bar; a product and the cart '
      'cover it; the empty cart\'s "browse the menu" opens the menu under the '
      'bar, and back steps through the brand to the hub', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);

    await openBrand(tester, Brand.bakery);
    expectBar(tester, BrandHomeScreen);

    await tapVisible(
      tester,
      find.descendant(
        of: find.byType(CategoryStrip),
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
    await back(tester);
    expectBar(tester, BrandHomeScreen);
    await back(tester);
    expectBar(tester, HubHomeScreen);
  });

  testWidgets('Sushi: home, information and a legal page keep the bar; the '
      'cart and checkout cover it; an emptied checkout\'s "browse the menu" '
      'opens the menu under the bar', (tester) async {
    container.read(cartProvider(Brand.sushi).notifier).add('alasca');
    await pumpApp(tester, container, Routes.clientHome);

    await openBrand(tester, Brand.sushi);
    expectBar(tester, BrandHomeScreen);

    await tapInfoButton(tester, 'DaviDan Sushi');
    expectBar(tester, BrandInfoScreen);
    await tapVisible(tester, find.text('Termeni și Condiții'));
    expectBar(tester, LegalDocumentScreen);
    await back(tester);
    await back(tester);
    expectBar(tester, BrandHomeScreen);

    await tester.tap(inScreen<BrandHomeScreen>(find.byType(CartButton)));
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
    expectBar(tester, BrandHomeScreen);
    await back(tester);
    expectBar(tester, HubHomeScreen);
  });

  testWidgets('Apă: its home keeps the bar; a product and the cart cover it; '
      'the empty cart\'s "browse the products" returns to the home under the '
      'bar', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);

    await openBrand(tester, Brand.water);
    expectBar(tester, WaterHomeScreen);

    await tapVisible(
      tester,
      inScreen<WaterHomeScreen>(find.text('Apa DaviDan naturală')),
    );
    expectNoBar(ProductDetailScreen);
    await back(tester);
    expectBar(tester, WaterHomeScreen);

    await tester.tap(inScreen<WaterHomeScreen>(find.byType(CartButton)));
    await tester.pumpAndSettle();
    expectNoBar(CartScreen);
    await tapVisible(tester, find.text(ro.browseProducts));
    expectBar(tester, WaterHomeScreen);
    await back(tester);
    expectBar(tester, HubHomeScreen);
  });

  testWidgets('Restaurant: "În curând" keeps the bar, and back returns to the '
      'hub', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);

    await openBrand(tester, Brand.restaurant);
    expectBar(tester, BrandIntroScreen);
    await back(tester);
    expectBar(tester, HubHomeScreen);
  });

  testWidgets('Rent Car: the fleet, information and a legal page keep the bar; '
      'a car and its request cover it', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);

    await openBrand(tester, Brand.carRental);
    expectBar(tester, RentalHomeScreen);

    await tapInfoButton(tester, 'DaviDan Rent Car');
    expectBar(tester, BrandInfoScreen);
    await tapVisible(tester, find.text('Termeni și Condiții'));
    expectBar(tester, LegalDocumentScreen);
    await back(tester);
    await back(tester);
    expectBar(tester, RentalHomeScreen);

    await tapVisible(
      tester,
      inScreen<RentalHomeScreen>(find.text('Audi Q5 2012')),
    );
    expectNoBar(CarDetailScreen);
    await tapVisible(tester, find.text(ro.rentalRequestAction));
    expectNoBar(RentalRequestScreen);
    await back(tester);
    expectNoBar(CarDetailScreen);
    await back(tester);
    expectBar(tester, RentalHomeScreen);
    await back(tester);
    expectBar(tester, HubHomeScreen);
  });

  testWidgets('inside a brand, another tab and back keeps the brand\'s screen; '
      'the phone\'s back steps back inside Acasă; tapping Acasă again returns '
      'to the hub', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);
    await openBrand(tester, Brand.bakery);
    await tapVisible(
      tester,
      find.descendant(
        of: find.byType(CategoryStrip),
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
    expectBar(tester, BrandHomeScreen);

    await tester.tap(find.text(ro.navHome));
    await tester.pumpAndSettle();
    expectBar(tester, HubHomeScreen);
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
    expectBar(tester, HubHomeScreen);
  });
}
