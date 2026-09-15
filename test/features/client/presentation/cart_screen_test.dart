// Cart screen (/client/cart) in the real app, in Chrome:
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
import 'package:davidan_prototype/features/client/presentation/cart/widgets/cart_line_tile.dart';
import 'package:davidan_prototype/features/client/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/client/presentation/checkout/checkout_screen.dart';
import 'package:davidan_prototype/features/client/presentation/product/product_detail_screen.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/total_bar.dart';

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

  testWidgets('empty cart shows the empty state, which links to the menu', (
    tester,
  ) async {
    await pumpApp(tester, container, Routes.clientCart);

    expect(
      inScreen<CartScreen>(find.text(AppStrings.cartEmptyTitle)),
      findsOneWidget,
    );
    expect(find.byType(TotalBar), findsNothing);

    await tapVisible(tester, find.text(AppStrings.browseMenu));
    expect(find.byType(CatalogScreen), findsOneWidget);
  });

  testWidgets('lines show photo, name and price; the total follows changes', (
    tester,
  ) async {
    container.read(cartProvider.notifier)
      ..add('croissant-ciocolata') // 19 lei
      ..add('coca-cola', quantity: 2); // 2 × 25 lei
    await pumpApp(tester, container, Routes.clientCart);

    expect(find.byType(CartLineTile), findsNWidgets(2));
    expect(
      inLine('Croissant cu ciocolată', find.byType(Image)),
      findsOneWidget,
    );
    expect(inLine('Coca Cola', find.text('50 lei')), findsOneWidget);
    expect(
      inLine('Coca Cola', find.text(AppStrings.unitPrice('25 lei'))),
      findsOneWidget,
    );
    expect(total('69 lei'), findsOneWidget);

    await tester.tap(
      inLine('Croissant cu ciocolată', find.byIcon(Icons.add_rounded)),
    );
    await tester.pump();
    expect(
      inLine('Croissant cu ciocolată', find.text('38 lei')),
      findsOneWidget,
    );
    expect(total('88 lei'), findsOneWidget);

    await tester.tap(inLine('Coca Cola', find.byIcon(Icons.remove_rounded)));
    await tester.pump();
    expect(container.read(cartQuantitiesProvider)['coca-cola'], 1);
    expect(total('63 lei'), findsOneWidget);

    // At 1 the minus button is disabled: removing is the bin button's job.
    await tester.tap(inLine('Coca Cola', find.byIcon(Icons.remove_rounded)));
    await tester.pump();
    expect(container.read(cartQuantitiesProvider)['coca-cola'], 1);

    await tester.tap(
      inLine('Coca Cola', find.byIcon(Icons.delete_outline_rounded)),
    );
    await tester.pump();
    expect(find.widgetWithText(CartLineTile, 'Coca Cola'), findsNothing);
    expect(container.read(cartQuantitiesProvider), {'croissant-ciocolata': 2});
    expect(total('38 lei'), findsOneWidget);

    await tester.tap(
      inLine(
        'Croissant cu ciocolată',
        find.byIcon(Icons.delete_outline_rounded),
      ),
    );
    await tester.pump();
    expect(find.text(AppStrings.cartEmptyTitle), findsOneWidget);
    expect(find.byType(TotalBar), findsNothing);
  });

  testWidgets('continue opens checkout; back returns to the cart', (
    tester,
  ) async {
    container.read(cartProvider.notifier).add('americano');
    await pumpApp(tester, container, Routes.clientCart);

    await tapVisible(tester, find.text(AppStrings.continueOrder));
    expect(find.byType(CheckoutScreen), findsOneWidget);

    await tester.tap(
      inScreen<CheckoutScreen>(find.byIcon(Icons.arrow_back_rounded)),
    );
    await tester.pumpAndSettle();
    expect(find.byType(CheckoutScreen), findsNothing);
    expect(find.byType(CartScreen), findsOneWidget);
  });

  testWidgets('tapping a line opens the product', (tester) async {
    container.read(cartProvider.notifier).add('americano');
    await pumpApp(tester, container, Routes.clientCart);

    await tapVisible(tester, find.widgetWithText(CartLineTile, 'Americano'));
    expect(find.byType(ProductDetailScreen), findsOneWidget);
  });

  testWidgets('fits a 360 px wide phone with long names and big totals', (
    tester,
  ) async {
    container.read(cartProvider.notifier)
      ..add('new-york-roll-mango-maracuja', quantity: 99)
      ..add('danish-fructe-padure-vanilie', quantity: 12);
    await pumpApp(
      tester,
      container,
      Routes.clientCart,
      size: const Size(360, 640),
    );

    expect(find.byType(CartLineTile), findsNWidgets(2));
    expect(total('4149 lei'), findsOneWidget);
  });
}
