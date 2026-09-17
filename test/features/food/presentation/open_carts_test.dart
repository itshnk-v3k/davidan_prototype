// The hub's list of every brand's cart (/client/carts) and the carts button
// on Acasă and Favorite, in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/toast/toast_notifier.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/application/favorites_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/cart/cart_screen.dart';
import 'package:davidan_prototype/features/food/presentation/cart/open_carts_screen.dart';
import 'package:davidan_prototype/features/food/presentation/favorites/favorites_screen.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/cart_button.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_card.dart';
import 'package:davidan_prototype/features/food/presentation/home/brand_feed_screen.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  Future<void> tapBack(WidgetTester tester, Type screen) async {
    await tester.tap(
      find.descendant(
        of: find.byType(screen),
        matching: find.byIcon(PhosphorIconsRegular.arrowLeft),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'the carts button on Acasă counts every brand\'s items and opens a card '
    'per cart, in the hub\'s order; a card opens that cart, and back returns '
    'to the list',
    (tester) async {
      container.read(cartProvider(Brand.bakery).notifier).add('americano');
      container
          .read(cartProvider(Brand.sushi).notifier)
          .add('alasca', quantity: 2);
      await pumpApp(tester, container, Routes.clientHome);

      final button = inScreen<BrandFeedScreen>(find.byType(OpenCartsButton));
      expect(
        find.descendant(of: button, matching: find.text('3')),
        findsOneWidget,
      );
      final semantics = tester.ensureSemantics();
      expect(find.bySemanticsLabel(ro.openCarts(3)), findsOneWidget);
      semantics.dispose();

      await tester.tap(button);
      await tester.pumpAndSettle();
      final list = find.byType(OpenCartsScreen);
      expect(list, findsOneWidget);
      expect(find.text(ro.navHome), findsNothing);

      final sushi = find.descendant(of: list, matching: find.text('Sushi'));
      final bakery = find.descendant(
        of: list,
        matching: find.text('Patiserie'),
      );
      expect(
        tester.getTopLeft(sushi).dy,
        lessThan(tester.getTopLeft(bakery).dy),
      );
      expect(
        find.descendant(
          of: list,
          matching: find.text(
            '${ro.itemsInCart(2)} · ${ro.formatLei(2 * 17000)}',
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: list,
          matching: find.text(
            '${ro.itemsInCart(1)} · '
            '${ro.formatLei(container.read(cartTotalProvider(Brand.bakery)))}',
          ),
        ),
        findsOneWidget,
      );

      await tester.tap(sushi);
      await tester.pumpAndSettle();
      expect(
        tester.widget<CartScreen>(find.byType(CartScreen)).brand,
        Brand.sushi,
      );
      expect(inScreen<CartScreen>(find.text('Alasca')), findsOneWidget);

      await tapBack(tester, CartScreen);
      expect(list, findsOneWidget);
      await tapBack(tester, OpenCartsScreen);
      expect(find.byType(BrandFeedScreen), findsOneWidget);
    },
  );

  testWidgets(
    'a cart emptied while the list is open leaves it; with no cart left the '
    'list says so and leads back to Acasă',
    (tester) async {
      container.read(cartProvider(Brand.sushi).notifier).add('motti');
      await pumpApp(tester, container, Routes.openCarts);
      expect(inScreen<OpenCartsScreen>(find.text('Sushi')), findsOneWidget);

      container.read(cartProvider(Brand.sushi).notifier).clear();
      await tester.pumpAndSettle();
      expect(inScreen<OpenCartsScreen>(find.text('Sushi')), findsNothing);
      expect(find.text(ro.openCartsEmptyTitle), findsOneWidget);

      await tester.tap(find.text(ro.backHome));
      await tester.pumpAndSettle();
      expect(find.byType(BrandFeedScreen), findsOneWidget);
    },
  );

  testWidgets(
    'on Favorite, a saved sushi product added to its cart is one tap away '
    'through the carts button',
    (tester) async {
      container.read(favoritesProvider.notifier)
        ..toggle((brand: Brand.bakery, id: 'americano'))
        ..toggle((brand: Brand.sushi, id: 'tuna-roll'));
      await pumpApp(tester, container, Routes.clientFavorites);

      await tapVisible(
        tester,
        find.descendant(
          of: find.widgetWithText(ProductCard, 'Tuna Roll'),
          matching: find.bySemanticsLabel(ro.addToCart('Tuna Roll')),
        ),
      );
      expect(container.read(cartQuantitiesProvider(Brand.sushi)), {
        'tuna-roll': 1,
      });
      // Favourites mix brands, so the card names its own and adding says
      // which cart the roll went to.
      expect(
        find.descendant(
          of: find.widgetWithText(ProductCard, 'Tuna Roll'),
          matching: find.text('Sushi'),
        ),
        findsOneWidget,
      );
      expect(find.text(ro.addedToBrandCart('Sushi')), findsOneWidget);
      await tester.pump(ToastNotifier.duration);
      await tester.pumpAndSettle();

      await tester.tap(inScreen<FavoritesScreen>(find.byType(OpenCartsButton)));
      await tester.pumpAndSettle();
      await tester.tap(inScreen<OpenCartsScreen>(find.text('Sushi')));
      await tester.pumpAndSettle();
      expect(inScreen<CartScreen>(find.text('Tuna Roll')), findsOneWidget);
    },
  );
}
