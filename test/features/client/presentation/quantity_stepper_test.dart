// The quantity stepper on cards, cart lines and the product page: its press
// feedback, its disabled minus, and how it grows out of the add button, in the
// real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_motion.dart';
import 'package:davidan_prototype/features/client/application/cart_notifier.dart';
import 'package:davidan_prototype/features/client/presentation/product/product_detail_screen.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/product_card.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/quantity_stepper.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  /// Past InkWell's 100 ms press delay inside a scroll view.
  const pressed = Duration(milliseconds: 200);

  Finder stepperIcon(IconData icon) => find.descendant(
    of: find.byType(QuantityStepper),
    matching: find.byIcon(icon),
  );

  double scaleAround(WidgetTester tester, Finder finder) => tester
      .widget<AnimatedScale>(
        find.ancestor(of: finder, matching: find.byType(AnimatedScale)).first,
      )
      .scale;

  testWidgets('each stepper button shrinks while pressed, more than a card', (
    tester,
  ) async {
    container.read(cartProvider.notifier).add('americano', quantity: 2);
    await pumpApp(tester, container, Routes.clientCart);

    for (final icon in [Icons.add_rounded, Icons.remove_rounded]) {
      final button = stepperIcon(icon);
      expect(scaleAround(tester, button), 1);

      final press = await tester.startGesture(tester.getCenter(button));
      await tester.pump(pressed);
      expect(scaleAround(tester, button), AppMotion.pressedScaleButton);
      expect(AppMotion.pressedScaleButton, lessThan(AppMotion.pressedScale));

      await press.cancel();
      await tester.pumpAndSettle();
      expect(scaleAround(tester, button), 1);
    }
  });

  testWidgets(
    'at one item the minus is disabled: it neither shrinks nor opens the '
    'product underneath',
    (tester) async {
      container.read(cartProvider.notifier).add('americano');
      await pumpApp(tester, container, Routes.clientCart);
      final minus = stepperIcon(Icons.remove_rounded);

      final press = await tester.startGesture(tester.getCenter(minus));
      await tester.pump(pressed);
      expect(scaleAround(tester, minus), 1);
      await press.up();
      await tester.pumpAndSettle();

      expect(find.byType(ProductDetailScreen), findsNothing);
      expect(container.read(cartCountProvider), 1);
    },
  );

  testWidgets('on a card, the stepper\'s plus lands where the add button was', (
    tester,
  ) async {
    const name = 'Coca Cola';
    await pumpApp(tester, container, Routes.clientCategory('bauturi'));
    final card = find.widgetWithText(ProductCard, name);
    await Scrollable.ensureVisible(tester.element(card), alignment: 0.5);
    await tester.pumpAndSettle();

    final add = find.descendant(
      of: card,
      matching: find.byIcon(Icons.add_rounded),
    );
    final addCenter = tester.getCenter(add);
    await tester.tap(add);
    await tester.pumpAndSettle();

    final plus = find.descendant(
      of: find.descendant(of: card, matching: find.byType(QuantityStepper)),
      matching: find.byIcon(Icons.add_rounded),
    );
    expect(tester.getCenter(plus).dx, closeTo(addCenter.dx, 0.5));
    expect(tester.getCenter(plus).dy, closeTo(addCenter.dy, 0.5));
  });

  testWidgets('the number uses fixed-width digits, so 9 to 10 doesn\'t jump', (
    tester,
  ) async {
    container.read(cartProvider.notifier).add('americano', quantity: 9);
    await pumpApp(tester, container, Routes.clientCart);

    final number = tester.widget<Text>(
      find.descendant(
        of: find.byType(QuantityStepper),
        matching: find.text('9'),
      ),
    );
    expect(
      number.style?.fontFeatures,
      contains(const FontFeature.tabularFigures()),
    );
  });
}
