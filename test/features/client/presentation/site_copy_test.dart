// Wording taken from davidan.md, where the customer sees it, in the real app,
// in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/data/mock/mock_categories.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/client/application/cart_notifier.dart';
import 'package:davidan_prototype/features/client/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/client/presentation/checkout/checkout_screen.dart';
import 'package:davidan_prototype/features/client/presentation/home/home_screen.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  testWidgets('home opens on the site\'s brand line and its section heading', (
    tester,
  ) async {
    await pumpApp(tester, container, Routes.clientHome);

    expect(
      inScreen<HomeScreen>(find.text('DaviDan - Pasiune pentru Patiserie!')),
      findsOneWidget,
    );
    expect(
      inScreen<HomeScreen>(find.text(AppStrings.popularTitle)),
      findsOneWidget,
    );
    expect(AppStrings.popularTitle, 'Produse DaviDan');
    expect(AppStrings.seeAll, 'Vezi mai mult');
    expect(find.text('Populare'), findsNothing);
  });

  testWidgets(
    'a category page quotes its blurb as the site writes it, formal wording '
    'included',
    (tester) async {
      await pumpApp(
        tester,
        container,
        Routes.clientCategory(CategoryIds.kurtos),
      );
      expect(
        inScreen<CatalogScreen>(
          find.text(
            'Descoperiți selecția noastră variată de kurtosuri, coapte perfect '
            'și aromate, gata să răsfețe papilele gustative.',
          ),
        ),
        findsOneWidget,
      );

      await tapVisible(
        tester,
        inScreen<CatalogScreen>(find.text('Plăcinte & Panini')),
      );
      expect(
        inScreen<CatalogScreen>(
          find.textContaining('Savurați plăcintele noastre proaspete'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('Băuturi has no blurb on the site, so none is shown', (
    tester,
  ) async {
    await pumpApp(
      tester,
      container,
      Routes.clientCategory(CategoryIds.bauturi),
    );

    final bauturi = mockCategories.firstWhere(
      (category) => category.id == CategoryIds.bauturi,
    );
    expect(bauturi.description, isNull);
    expect(inScreen<CatalogScreen>(find.text('Coca Cola')), findsOneWidget);
  });

  testWidgets('checkout names payment the way the site\'s delivery page does', (
    tester,
  ) async {
    container.read(cartProvider.notifier).add('americano');
    await pumpApp(tester, container, Routes.clientCheckout);

    expect(
      inScreen<CheckoutScreen>(find.text(AppStrings.paymentTitle)),
      findsOneWidget,
    );
    expect(AppStrings.paymentTitle, 'Achitare');
    expect(
      find.text(AppStrings.paymentMethod(PaymentMethod.card)),
      findsOneWidget,
    );
    expect(AppStrings.paymentMethod(PaymentMethod.card), 'Card prin POS');
  });
}
