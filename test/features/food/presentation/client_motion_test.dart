// Motion in the customer app: the product photo flying to the product page,
// one page transition on every platform, and the device's "remove animations"
// setting. Real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_theme.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/cart/widgets/cart_line_tile.dart';
import 'package:davidan_prototype/features/food/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/brand_home_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/category_grid.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/product_shelf.dart';
import 'package:davidan_prototype/features/food/presentation/product/product_detail_screen.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_card.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/quantity_stepper.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  /// Partway through a page transition.
  const midway = Duration(milliseconds: 100);

  Finder productCard(String name) => find.widgetWithText(ProductCard, name);
  Finder inCard(String name, Finder finder) =>
      find.descendant(of: productCard(name), matching: finder);

  /// Scrolls [finder] into view, taps it, and stops [wait] into what follows.
  Future<void> tapAndWait(
    WidgetTester tester,
    Finder finder, [
    Duration wait = midway,
  ]) async {
    await Scrollable.ensureVisible(tester.element(finder), alignment: 0.5);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pump();
    await tester.pump(wait);
  }

  testWidgets(
    'the photo flies from a card to the product page and back, after the '
    'menu showed the same product',
    (tester) async {
      const name = 'Croissant cu ciocolată';
      await pumpApp(tester, container, Routes.brandHome(Brand.bakery));
      // Open the menu on the croissant's category and come back home: the
      // flight must start from home's card, not the menu's.
      await tapVisible(
        tester,
        find.descendant(
          of: find.byType(CategoryGrid),
          matching: find.text('Patiserie'),
        ),
      );
      expect(productCard(name), findsOneWidget);
      await tester.tap(
        inScreen<CatalogScreen>(find.byIcon(PhosphorIconsRegular.arrowLeft)),
      );
      await tester.pumpAndSettle();
      expect(find.byType(BrandHomeScreen), findsOneWidget);

      // Home shows the croissant in two rows; this is its Produse DaviDan
      // card.
      final homeCard = find.descendant(
        of: find.byWidgetPredicate(
          (widget) => widget is ProductShelf && widget.title == ro.popularTitle,
        ),
        matching: productCard(name),
      );
      Finder inHomeCard(Finder finder) =>
          find.descendant(of: homeCard, matching: finder);

      await tapAndWait(tester, inHomeCard(find.text(name)));

      // In flight, the photo leaves the card and hasn't landed on the page.
      expect(find.byType(ProductDetailScreen), findsOneWidget);
      expect(inHomeCard(find.byType(Image)), findsNothing);
      expect(inScreen<ProductDetailScreen>(find.byType(Image)), findsNothing);

      await tester.pumpAndSettle();
      expect(inScreen<ProductDetailScreen>(find.byType(Image)), findsOneWidget);

      await tester.tap(find.byIcon(PhosphorIconsRegular.arrowLeft));
      await tester.pump();
      await tester.pump(midway);
      expect(inScreen<ProductDetailScreen>(find.byType(Image)), findsNothing);

      await tester.pumpAndSettle();
      expect(find.byType(ProductDetailScreen), findsNothing);
      expect(inHomeCard(find.byType(Image)), findsOneWidget);
    },
  );

  testWidgets('the photo also flies from a cart line to the product page', (
    tester,
  ) async {
    container.read(cartProvider(Brand.bakery).notifier).add('americano');
    await pumpApp(tester, container, Routes.brandCart(Brand.bakery));
    final line = find.widgetWithText(CartLineTile, 'Americano');

    await tapAndWait(
      tester,
      find.descendant(of: line, matching: find.text('Americano')),
    );
    expect(
      find.descendant(of: line, matching: find.byType(Image)),
      findsNothing,
    );

    await tester.pumpAndSettle();
    expect(inScreen<ProductDetailScreen>(find.byType(Image)), findsOneWidget);
  });

  testWidgets('with animations removed on the device, changes show at once', (
    tester,
  ) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    const name = 'Coca Cola';
    await pumpApp(
      tester,
      container,
      Routes.brandMenu(Brand.bakery, categoryId: 'bauturi'),
    );

    await tapAndWait(
      tester,
      inCard(name, find.byIcon(PhosphorIconsBold.plus)),
      Duration.zero,
    );
    expect(inCard(name, find.byIcon(PhosphorIconsBold.plus)), findsOneWidget);
    expect(inCard(name, find.byType(QuantityStepper)), findsOneWidget);

    await tapAndWait(
      tester,
      inCard(name, find.byIcon(PhosphorIconsBold.plus)),
      Duration.zero,
    );
    expect(inCard(name, find.text('1')), findsNothing);
    expect(inCard(name, find.text('2')), findsOneWidget);
  });

  test('every platform gets the same page transition', () {
    final builders = AppTheme.light().pageTransitionsTheme.builders;
    for (final platform in TargetPlatform.values) {
      expect(
        builders[platform],
        platform == TargetPlatform.android
            // Fades forwards too, and follows Android's back gesture.
            ? isA<PredictiveBackPageTransitionsBuilder>()
            : isA<FadeForwardsPageTransitionsBuilder>(),
        reason: '$platform',
      );
    }
  });
}
