// The quantity stepper on cards, cart lines and the product page: its disabled
// minus, where its plus lands on a card, and its digits, in the real app, in
// Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/product/product_detail_screen.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_card.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/quantity_stepper.dart';

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

  testWidgets('at one item the minus is disabled: it doesn\'t open the product '
      'underneath', (tester) async {
    container.read(cartProvider(Brand.bakery).notifier).add('americano');
    await pumpApp(tester, container, Routes.brandCart(Brand.bakery));
    final minus = stepperIcon(Icons.remove_rounded);

    final press = await tester.startGesture(tester.getCenter(minus));
    await tester.pump(pressed);
    await press.up();
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailScreen), findsNothing);
    expect(container.read(cartCountProvider(Brand.bakery)), 1);
  });

  testWidgets('on a card, the stepper\'s plus lands where the add button was', (
    tester,
  ) async {
    const name = 'Coca Cola';
    await pumpApp(
      tester,
      container,
      Routes.brandMenu(Brand.bakery, categoryId: 'bauturi'),
    );
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
    container
        .read(cartProvider(Brand.bakery).notifier)
        .add('americano', quantity: 9);
    await pumpApp(tester, container, Routes.brandCart(Brand.bakery));

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
