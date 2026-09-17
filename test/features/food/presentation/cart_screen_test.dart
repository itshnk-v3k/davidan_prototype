// Cart screen (/b/:brand/cart) in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/cart/cart_screen.dart';
import 'package:davidan_prototype/features/food/presentation/cart/widgets/cart_line_tile.dart';
import 'package:davidan_prototype/features/food/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/water_feed.dart';
import 'package:davidan_prototype/features/food/presentation/checkout/checkout_screen.dart';
import 'package:davidan_prototype/features/food/presentation/product/product_detail_screen.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/total_bar.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  Finder inLine(String productName, Finder finder) => find.descendant(
    of: find.widgetWithText(CartLineTile, productName),
    matching: finder,
  );

  Finder total(String amount) =>
      find.descendant(of: find.byType(TotalBar), matching: find.text(amount));

  testWidgets('empty cart names its brand and shows the empty state, which '
      'links to the menu', (tester) async {
    await pumpApp(tester, container, Routes.brandCart(Brand.bakery));

    expect(
      inScreen<CartScreen>(find.text(ro.brandCartTitle('Patiserie'))),
      findsOneWidget,
    );
    expect(inScreen<CartScreen>(find.text(ro.cartEmptyTitle)), findsOneWidget);
    expect(find.byType(TotalBar), findsNothing);

    await tapVisible(tester, find.text(ro.browseMenu));
    expect(find.byType(CatalogScreen), findsOneWidget);
  });

  testWidgets('lines show photo, name and price; the total follows changes', (
    tester,
  ) async {
    container.read(cartProvider(Brand.bakery).notifier)
      ..add('croissant-ciocolata') // 19 lei
      ..add('coca-cola', quantity: 2); // 2 × 25 lei
    await pumpApp(tester, container, Routes.brandCart(Brand.bakery));

    expect(find.byType(CartLineTile), findsNWidgets(2));
    expect(
      inLine('Croissant cu ciocolată', find.byType(Image)),
      findsOneWidget,
    );
    expect(inLine('Coca Cola', find.text('50 lei')), findsOneWidget);
    expect(
      inLine('Coca Cola', find.text(ro.unitPrice('25 lei'))),
      findsOneWidget,
    );
    expect(total('69 lei'), findsOneWidget);

    await tester.tap(
      inLine('Croissant cu ciocolată', find.byIcon(PhosphorIconsBold.plus)),
    );
    await tester.pump();
    expect(
      inLine('Croissant cu ciocolată', find.text('38 lei')),
      findsOneWidget,
    );
    expect(total('88 lei'), findsOneWidget);

    await tester.tap(inLine('Coca Cola', find.byIcon(PhosphorIconsBold.minus)));
    await tester.pump();
    expect(
      container.read(cartQuantitiesProvider(Brand.bakery))['coca-cola'],
      1,
    );
    expect(total('63 lei'), findsOneWidget);

    // At 1 the minus button is disabled: removing is the bin button's job.
    await tester.tap(inLine('Coca Cola', find.byIcon(PhosphorIconsBold.minus)));
    await tester.pump();
    expect(
      container.read(cartQuantitiesProvider(Brand.bakery))['coca-cola'],
      1,
    );

    await tester.tap(
      inLine('Coca Cola', find.byIcon(PhosphorIconsRegular.trash)),
    );
    await tester.pump();
    expect(find.widgetWithText(CartLineTile, 'Coca Cola'), findsNothing);
    expect(container.read(cartQuantitiesProvider(Brand.bakery)), {
      'croissant-ciocolata': 2,
    });
    expect(total('38 lei'), findsOneWidget);

    await tester.tap(
      inLine('Croissant cu ciocolată', find.byIcon(PhosphorIconsRegular.trash)),
    );
    await tester.pump();
    expect(find.text(ro.cartEmptyTitle), findsOneWidget);
    expect(find.byType(TotalBar), findsNothing);
  });

  testWidgets('continue opens checkout; back returns to the cart', (
    tester,
  ) async {
    container.read(cartProvider(Brand.bakery).notifier).add('americano');
    await pumpApp(tester, container, Routes.brandCart(Brand.bakery));

    await tapVisible(tester, find.text(ro.continueOrder));
    expect(find.byType(CheckoutScreen), findsOneWidget);

    await tester.tap(
      inScreen<CheckoutScreen>(find.byIcon(PhosphorIconsRegular.arrowLeft)),
    );
    await tester.pumpAndSettle();
    expect(find.byType(CheckoutScreen), findsNothing);
    expect(find.byType(CartScreen), findsOneWidget);
  });

  testWidgets('tapping a line opens the product', (tester) async {
    container.read(cartProvider(Brand.bakery).notifier).add('americano');
    await pumpApp(tester, container, Routes.brandCart(Brand.bakery));

    await tapVisible(tester, find.widgetWithText(CartLineTile, 'Americano'));
    expect(find.byType(ProductDetailScreen), findsOneWidget);
  });

  testWidgets('fits a 360 px wide phone with long names and big totals', (
    tester,
  ) async {
    container.read(cartProvider(Brand.bakery).notifier)
      ..add('new-york-roll-mango-maracuja', quantity: 99)
      ..add('danish-fructe-padure-vanilie', quantity: 12);
    await pumpApp(
      tester,
      container,
      Routes.brandCart(Brand.bakery),
      size: const Size(360, 640),
    );

    expect(find.byType(CartLineTile), findsNWidgets(2));
    expect(total('4149 lei'), findsOneWidget);
  });

  testWidgets('water has no menu: its empty cart leads back to its page', (
    tester,
  ) async {
    await pumpApp(tester, container, Routes.brandCart(Brand.water));

    expect(
      inScreen<CartScreen>(find.text(ro.brandCartTitle('Apă naturală'))),
      findsOneWidget,
    );
    expect(find.text(ro.cartEmptyMessageNoMenu), findsOneWidget);
    expect(find.text(ro.browseMenu), findsNothing);
    await tapVisible(tester, find.text(ro.browseProducts));
    expect(find.byType(WaterFeed), findsOneWidget);
  });
}
