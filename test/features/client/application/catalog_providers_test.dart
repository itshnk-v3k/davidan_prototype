import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:davidan_prototype/data/mock/mock_categories.dart';
import 'package:davidan_prototype/data/mock/mock_products.dart';
import 'package:davidan_prototype/features/client/application/catalog_providers.dart';

void main() {
  test('products are filtered by category', () {
    final container = ProviderContainer.test();
    final kurtos = container.read(
      productsByCategoryProvider(CategoryIds.kurtos),
    );
    expect(kurtos, hasLength(7));
    expect(kurtos.map((p) => p.categoryId).toSet(), {CategoryIds.kurtos});
  });

  test('every category has products', () {
    final container = ProviderContainer.test();
    for (final category in container.read(categoriesProvider)) {
      expect(
        container.read(productsByCategoryProvider(category.id)),
        isNotEmpty,
        reason: category.id,
      );
    }
  });

  test('a missing or unknown category falls back to the first one', () {
    final container = ProviderContainer.test();
    final first = container.read(categoriesProvider).first;
    expect(container.read(catalogCategoryProvider(null)), first);
    expect(container.read(catalogCategoryProvider('no-such-category')), first);
    expect(
      container.read(catalogCategoryProvider(CategoryIds.sushi)).id,
      CategoryIds.sushi,
    );
  });

  test('product lookup by id', () {
    final container = ProviderContainer.test();
    expect(
      container.read(productByIdProvider('kurtos-fistic'))?.name,
      'Kurtos cu fistic',
    );
    expect(container.read(productByIdProvider('no-such-product')), isNull);
  });

  test('every popular product id exists', () {
    final container = ProviderContainer.test();
    expect(
      container.read(popularProductsProvider),
      hasLength(mockPopularProductIds.length),
    );
  });
}
