import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:davidan_prototype/data/mock/bakery/bakery_categories.dart';
import 'package:davidan_prototype/data/mock/bakery/bakery_products.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';

void main() {
  test('products are filtered by category', () {
    final container = ProviderContainer.test();
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
    final container = ProviderContainer.test();
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
    final container = ProviderContainer.test();
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
    final container = ProviderContainer.test();
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
    final container = ProviderContainer.test();
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
    final container = ProviderContainer.test();
    expect(
      container.read(popularProductsProvider(Brand.bakery)),
      hasLength(bakeryPopularProductIds.length),
    );
  });
}
