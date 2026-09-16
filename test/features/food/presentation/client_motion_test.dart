// Motion in the customer app: the product photo flying to the product page,
// presses on cards and buttons, the add button, stepper, heart and cart badge,
// the cart's empty state, one page transition on every platform, and the
// device's "remove animations" setting. Real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_motion.dart';
import 'package:davidan_prototype/core/theme/app_theme.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/scale_pop.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/cart/widgets/cart_line_tile.dart';
import 'package:davidan_prototype/features/food/presentation/home/home_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/category_strip.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/product_shelf.dart';
import 'package:davidan_prototype/features/food/presentation/product/product_detail_screen.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/favorite_toggle.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_card.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/quantity_stepper.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  /// Partway through a transition: fast ones take 150 ms, medium 250 ms,
  /// entrances and pops 400 ms, page transitions 450 ms.
  const midway = Duration(milliseconds: 100);

  /// The top of a pop: 40 % into its 400 ms.
  const popPeak = Duration(milliseconds: 160);

  /// Past InkWell's 100 ms press delay inside a scroll view.
  const pressed = Duration(milliseconds: 200);

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

  /// Current scale of a [ScalePop].
  double popScale(WidgetTester tester, Finder scalePop) => tester
      .widget<ScaleTransition>(
        find.descendant(of: scalePop, matching: find.byType(ScaleTransition)),
      )
      .scale
      .value;

  testWidgets(
    'the photo flies from a card to the product page and back, with the same '
    'product also in a hidden tab',
    (tester) async {
      const name = 'Croissant cu ciocolată';
      await pumpApp(tester, container, Routes.clientHome);
      // Open the menu on the croissant's category and come back home: both
      // tabs now hold a card with its photo, and the hidden one must stay out
      // of the flight.
      await tapVisible(
        tester,
        find.descendant(
          of: find.byType(CategoryStrip),
          matching: find.text('Patiserie'),
        ),
      );
      expect(productCard(name), findsOneWidget);
      await tester.tap(find.text(ro.navHome));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);

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

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
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

  testWidgets(
    'adding from a card grows a stepper out of the add button; its number '
    'rolls up and down',
    (tester) async {
      const name = 'Coca Cola';
      await pumpApp(tester, container, Routes.clientCategory('bauturi'));
      Finder stepperNumber(String number) => inCard(
        name,
        find.descendant(
          of: find.byType(QuantityStepper),
          matching: find.text(number),
        ),
      );

      await tapAndWait(tester, inCard(name, find.byIcon(Icons.add_rounded)));
      // The add button fades out while the stepper, with its own plus, fades
      // in.
      expect(inCard(name, find.byType(QuantityStepper)), findsOneWidget);
      expect(inCard(name, find.byIcon(Icons.add_rounded)), findsNWidgets(2));

      await tester.pumpAndSettle();
      expect(inCard(name, find.byIcon(Icons.add_rounded)), findsOneWidget);
      expect(stepperNumber('1'), findsOneWidget);

      await tapAndWait(tester, inCard(name, find.byIcon(Icons.add_rounded)));
      // Counting up: 2 comes up from below while 1 leaves upwards.
      expect(
        tester.getCenter(stepperNumber('2')).dy,
        greaterThan(tester.getCenter(stepperNumber('1')).dy),
      );
      await tester.pumpAndSettle();
      expect(stepperNumber('1'), findsNothing);
      expect(stepperNumber('2'), findsOneWidget);

      await tapAndWait(tester, inCard(name, find.byIcon(Icons.remove_rounded)));
      // Counting down: 1 comes down from above.
      expect(
        tester.getCenter(stepperNumber('1')).dy,
        lessThan(tester.getCenter(stepperNumber('2')).dy),
      );
      await tester.pumpAndSettle();
      expect(stepperNumber('2'), findsNothing);
      expect(stepperNumber('1'), findsOneWidget);
    },
  );

  testWidgets('the cart badge grows in with the first item and bumps on more', (
    tester,
  ) async {
    await pumpApp(tester, container, Routes.clientHome);
    final badge = find.byType(ScalePop<int>);
    expect(badge, findsNothing);

    container.read(cartProvider(Brand.bakery).notifier).add('americano');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 30));
    final growing = tester.widget<ScaleTransition>(
      find.ancestor(of: badge, matching: find.byType(ScaleTransition)).first,
    );
    expect(growing.scale.value, lessThan(1));

    await tester.pumpAndSettle();
    expect(popScale(tester, badge), 1);

    container.read(cartProvider(Brand.bakery).notifier).add('americano');
    await tester.pump();
    await tester.pump(popPeak);
    expect(popScale(tester, badge), greaterThan(1.2));

    await tester.pumpAndSettle();
    expect(popScale(tester, badge), 1);
  });

  testWidgets('saving a product pops its heart; unsaving it does not', (
    tester,
  ) async {
    await pumpApp(tester, container, Routes.clientCategory('bauturi'));
    final heart = inCard('Coca Cola', find.byType(FavoriteToggle));
    double heartScale() => popScale(
      tester,
      find.descendant(of: heart, matching: find.byType(ScalePop<bool>)),
    );

    await tapAndWait(tester, heart, popPeak);
    expect(heartScale(), greaterThan(1.2));
    await tester.pumpAndSettle();
    expect(heartScale(), 1);

    await tapAndWait(tester, heart, popPeak);
    expect(heartScale(), 1);
    await tester.pumpAndSettle();
  });

  testWidgets(
    'a card shrinks slightly while pressed and springs back when the press '
    'turns into a scroll; pressing its heart leaves the card alone',
    (tester) async {
      const name = 'Coca Cola';
      await pumpApp(tester, container, Routes.clientCategory('bauturi'));
      await Scrollable.ensureVisible(
        tester.element(productCard(name)),
        alignment: 0.5,
      );
      await tester.pumpAndSettle();
      double cardScale() => tester
          .widget<AnimatedScale>(inCard(name, find.byType(AnimatedScale)).first)
          .scale;

      final press = await tester.startGesture(
        tester.getCenter(inCard(name, find.text(name))),
      );
      await tester.pump(pressed);
      expect(cardScale(), AppMotion.pressedScale);

      // Past the touch slop the grid takes the gesture as a scroll.
      await press.moveBy(const Offset(0, -40));
      await tester.pump();
      expect(cardScale(), 1);
      await press.up();
      await tester.pumpAndSettle();
      expect(find.byType(ProductDetailScreen), findsNothing);

      final heartPress = await tester.startGesture(
        tester.getCenter(inCard(name, find.byType(FavoriteToggle))),
      );
      await tester.pump(pressed);
      expect(cardScale(), 1);
      await heartPress.up();
      await tester.pumpAndSettle();
    },
  );

  testWidgets('a button shrinks slightly while pressed', (tester) async {
    container.read(cartProvider(Brand.bakery).notifier).add('americano');
    await pumpApp(tester, container, Routes.brandCart(Brand.bakery));
    final button = find.widgetWithText(AppButton, ro.continueOrder);
    double buttonScale() => tester
        .widget<AnimatedScale>(
          find.descendant(of: button, matching: find.byType(AnimatedScale)),
        )
        .scale;
    expect(buttonScale(), 1);

    final press = await tester.startGesture(tester.getCenter(button));
    await tester.pump(pressed);
    expect(buttonScale(), AppMotion.pressedScale);

    await press.cancel();
    await tester.pumpAndSettle();
    expect(buttonScale(), 1);
  });

  testWidgets(
    'removing the last cart line crossfades to the empty state, which comes in',
    (tester) async {
      container.read(cartProvider(Brand.bakery).notifier).add('americano');
      await pumpApp(tester, container, Routes.brandCart(Brand.bakery));
      double titleOpacity() => tester
          .widget<Opacity>(
            find
                .ancestor(
                  of: find.text(ro.cartEmptyTitle),
                  matching: find.byType(Opacity),
                )
                .first,
          )
          .opacity;

      await tapAndWait(tester, find.byIcon(Icons.delete_outline_rounded));
      expect(find.byType(CartLineTile), findsOneWidget);
      expect(titleOpacity(), inExclusiveRange(0, 1));

      await tester.pumpAndSettle();
      expect(find.byType(CartLineTile), findsNothing);
      expect(titleOpacity(), 1);
    },
  );

  testWidgets('with animations removed on the device, changes show at once', (
    tester,
  ) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    const name = 'Coca Cola';
    await pumpApp(tester, container, Routes.clientCategory('bauturi'));

    await tapAndWait(
      tester,
      inCard(name, find.byIcon(Icons.add_rounded)),
      Duration.zero,
    );
    expect(inCard(name, find.byIcon(Icons.add_rounded)), findsOneWidget);
    expect(inCard(name, find.byType(QuantityStepper)), findsOneWidget);

    await tapAndWait(
      tester,
      inCard(name, find.byIcon(Icons.add_rounded)),
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
