import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:davidan_prototype/data/mock/bakery/bakery_categories.dart';
import 'package:davidan_prototype/data/mock/bakery/bakery_products.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/l10n/app_language.dart';
import 'package:davidan_prototype/l10n/content.dart';

void main() {
  // The menus follow the app's language, which is a saved setting; these
  // tests have no storage, so they set the language themselves.
  final inRomanian = [
    contentProvider.overrideWithValue(ContentTranslator.romanian),
  ];

  test(
    'the menus are in the app\'s language, keeping their ids and prices',
    () {
      final romanian = ProviderContainer.test(overrides: inRomanian);
      final russian = ProviderContainer.test(
        overrides: [
          contentProvider.overrideWithValue(ContentTranslator.russian),
        ],
      );
      expect(
        russian.read(categoriesProvider(Brand.bakery)).map((c) => c.name),
        ['Куртош', 'Выпечка', 'Плацинды и панини', 'Напитки'],
      );
      const key = (brand: Brand.sushi, id: 'alasca');
      final alasca = russian.read(productByIdProvider(key))!;
      expect(alasca.name, 'Аляска');
      expect(alasca.weight, '250г');
      expect(
        alasca.priceBani,
        romanian.read(productByIdProvider(key))!.priceBani,
      );
      expect(
        russian.read(popularProductsProvider(Brand.sushi)).map((p) => p.id),
        romanian.read(popularProductsProvider(Brand.sushi)).map((p) => p.id),
      );
    },
  );

  test('products are filtered by category', () {
    final container = ProviderContainer.test(overrides: inRomanian);
    final kurtos = container.read(
      productsByCategoryProvider((
        brand: Brand.bakery,
        categoryId: BakeryCategoryIds.kurtos,
      )),
    );
    expect(kurtos, hasLength(7));
    expect(kurtos.map((p) => p.categoryId).toSet(), {BakeryCategoryIds.kurtos});
  });

  test('the bakery sells only what davidan.md does: the invented Sushi and '
      'Restaurant categories are gone, now that those are brands of their '
      'own', () {
    final container = ProviderContainer.test(overrides: inRomanian);
    expect(
      container.read(categoriesProvider(Brand.bakery)).map((c) => c.name),
      ['Kurtos', 'Patiserie', 'Plăcinte & Panini', 'Băuturi'],
    );
    final ids = container.read(productsByIdProvider(Brand.bakery)).keys;
    for (final invented in [
      'ebi-roll',
      'philadelphia-roll',
      'california-roll',
      'maki-somon',
      'orez-pui',
      'supa-crema-ciuperci',
      'piept-pui-gratar',
      'paste-carbonara',
    ]) {
      expect(ids, isNot(contains(invented)));
    }
  });

  test('every category has products', () {
    final container = ProviderContainer.test(overrides: inRomanian);
    for (final category in container.read(categoriesProvider(Brand.bakery))) {
      expect(
        container.read(
          productsByCategoryProvider((
            brand: Brand.bakery,
            categoryId: category.id,
          )),
        ),
        isNotEmpty,
        reason: category.id,
      );
    }
  });

  test('a missing or unknown category falls back to the first one', () {
    final container = ProviderContainer.test(overrides: inRomanian);
    final first = container.read(categoriesProvider(Brand.bakery)).first;
    expect(
      container.read(
        catalogCategoryProvider((brand: Brand.bakery, categoryId: null)),
      ),
      first,
    );
    expect(
      container.read(
        catalogCategoryProvider((
          brand: Brand.bakery,
          categoryId: 'no-such-category',
        )),
      ),
      first,
    );
    expect(
      container
          .read(
            catalogCategoryProvider((
              brand: Brand.bakery,
              categoryId: BakeryCategoryIds.bauturi,
            )),
          )
          .id,
      BakeryCategoryIds.bauturi,
    );
  });

  test('product lookup by id', () {
    final container = ProviderContainer.test(overrides: inRomanian);
    expect(
      container
          .read(productByIdProvider((brand: Brand.bakery, id: 'kurtos-fistic')))
          ?.name,
      'Kurtos cu fistic',
    );
    expect(
      container.read(
        productByIdProvider((brand: Brand.bakery, id: 'no-such-product')),
      ),
      isNull,
    );
  });

  test('every popular product id exists', () {
    final container = ProviderContainer.test(overrides: inRomanian);
    expect(
      container.read(popularProductsProvider(Brand.bakery)),
      hasLength(bakeryPopularProductIds.length),
    );
  });
}
