import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/data/mock/mock_catalogs.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/brand_catalog.dart';
import 'package:davidan_prototype/data/models/menu_category.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/data/models/promo_banner.dart';
import 'package:davidan_prototype/l10n/app_language.dart';

// The only place the app reads mock menus. Each brand has its own, so every
// provider here takes the brand. Swapping in a real API later means changing
// these providers, not the screens.

/// [brand]'s menu in the app's language.
final brandCatalogProvider = Provider.family<BrandCatalog, Brand>((ref, brand) {
  final catalog = mockCatalogs[brand] ?? const BrandCatalog();
  final content = ref.watch(contentProvider);
  return BrandCatalog(
    categories: [
      for (final category in catalog.categories) content.category(category),
    ],
    products: [
      for (final product in catalog.products) content.product(product),
    ],
    banners: [for (final banner in catalog.banners) content.banner(banner)],
    popularProductIds: catalog.popularProductIds,
  );
});

final categoriesProvider = Provider.family<List<MenuCategory>, Brand>(
  (ref, brand) => ref.watch(brandCatalogProvider(brand)).categories,
);

final productsProvider = Provider.family<List<Product>, Brand>(
  (ref, brand) => ref.watch(brandCatalogProvider(brand)).products,
);

final bannersProvider = Provider.family<List<PromoBanner>, Brand>(
  (ref, brand) => ref.watch(brandCatalogProvider(brand)).banners,
);

final productsByIdProvider = Provider.family<Map<String, Product>, Brand>(
  (ref, brand) => {
    for (final product in ref.watch(productsProvider(brand)))
      product.id: product,
  },
);

/// Null when the brand has no product with this id (e.g. a hand-edited link).
final productByIdProvider = Provider.family<Product?, ProductKey>(
  (ref, key) => ref.watch(productsByIdProvider(key.brand))[key.id],
);

/// The category a catalog URL points to. A missing or unknown id falls back to
/// the brand's first category.
final catalogCategoryProvider =
    Provider.family<MenuCategory, ({Brand brand, String? categoryId})>((
      ref,
      arg,
    ) {
      final categories = ref.watch(categoriesProvider(arg.brand));
      return categories.firstWhere(
        (category) => category.id == arg.categoryId,
        orElse: () => categories.first,
      );
    });

final productsByCategoryProvider =
    Provider.family<List<Product>, ({Brand brand, String categoryId})>(
      (ref, arg) => [
        for (final product in ref.watch(productsProvider(arg.brand)))
          if (product.categoryId == arg.categoryId) product,
      ],
    );

final popularProductsProvider = Provider.family<List<Product>, Brand>((
  ref,
  brand,
) {
  final byId = ref.watch(productsByIdProvider(brand));
  return [
    for (final id in ref.watch(brandCatalogProvider(brand)).popularProductIds)
      ?byId[id],
  ];
});

/// The hub's "pentru tine" row: every brand's popular products, the brands
/// taking turns in the client's order, so each brand with a menu shows early.
final forYouProductsProvider = Provider<List<Product>>((ref) {
  final perBrand = [
    for (final brand in Brand.values) ref.watch(popularProductsProvider(brand)),
  ];
  final longest = perBrand.fold(0, (most, list) => math.max(most, list.length));
  return [
    for (var index = 0; index < longest; index++)
      for (final products in perBrand)
        if (index < products.length) products[index],
  ];
});
