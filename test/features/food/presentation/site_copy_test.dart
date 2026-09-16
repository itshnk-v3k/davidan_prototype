// Wording taken from davidan.md, where the customer sees it, in the real app,
// in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/data/mock/bakery/bakery_categories.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/food/presentation/checkout/checkout_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/brand_home_screen.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  testWidgets('home opens on the site\'s brand line and its section heading', (
    tester,
  ) async {
    await pumpApp(tester, container, Routes.brandHome(Brand.bakery));

    expect(
      inScreen<BrandHomeScreen>(
        find.text('DaviDan - Pasiune pentru Patiserie!'),
      ),
      findsOneWidget,
    );
    expect(
      inScreen<BrandHomeScreen>(find.text(ro.popularTitle)),
      findsOneWidget,
    );
    expect(ro.popularTitle, 'Produse DaviDan');
    expect(ro.seeAll, 'Vezi mai mult');
    expect(find.text('Populare'), findsNothing);
  });

  testWidgets(
    'a category page quotes its blurb as the site writes it, formal wording '
    'included',
    (tester) async {
      await pumpApp(
        tester,
        container,
        Routes.brandMenu(Brand.bakery, categoryId: BakeryCategoryIds.kurtos),
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
      Routes.brandMenu(Brand.bakery, categoryId: BakeryCategoryIds.bauturi),
    );

    final bauturi = bakeryCategories.firstWhere(
      (category) => category.id == BakeryCategoryIds.bauturi,
    );
    expect(bauturi.description, isNull);
    expect(inScreen<CatalogScreen>(find.text('Coca Cola')), findsOneWidget);
  });

  testWidgets('checkout names payment the way the site\'s delivery page does', (
    tester,
  ) async {
    container.read(cartProvider(Brand.bakery).notifier).add('americano');
    await pumpApp(tester, container, Routes.brandCheckout(Brand.bakery));

    expect(
      inScreen<CheckoutScreen>(find.text(ro.paymentTitle)),
      findsOneWidget,
    );
    expect(ro.paymentTitle, 'Achitare');
    expect(find.text(ro.paymentMethod(PaymentMethod.card)), findsOneWidget);
    expect(ro.paymentMethod(PaymentMethod.card), 'Card prin POS');
  });
}
