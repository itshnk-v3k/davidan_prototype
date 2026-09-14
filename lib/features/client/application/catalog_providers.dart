import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/data/mock/mock_banners.dart';
import 'package:davidan_prototype/data/mock/mock_categories.dart';
import 'package:davidan_prototype/data/mock/mock_products.dart';
import 'package:davidan_prototype/data/models/menu_category.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/data/models/promo_banner.dart';

// The only place the customer app reads mock catalog data. Swapping in a real
// API later means changing these providers, not the screens.

final categoriesProvider = Provider<List<MenuCategory>>(
  (ref) => mockCategories,
);

final productsProvider = Provider<List<Product>>((ref) => mockProducts);

final bannersProvider = Provider<List<PromoBanner>>((ref) => mockBanners);

final productsByIdProvider = Provider<Map<String, Product>>(
  (ref) => {
    for (final product in ref.watch(productsProvider)) product.id: product,
  },
);

/// Null when no product has this id (e.g. a hand-edited link).
final productByIdProvider = Provider.family<Product?, String>(
  (ref, productId) => ref.watch(productsByIdProvider)[productId],
);

/// The category a catalog URL points to. A missing or unknown id falls back to
/// the first category.
final catalogCategoryProvider = Provider.family<MenuCategory, String?>((
  ref,
  categoryId,
) {
  final categories = ref.watch(categoriesProvider);
  return categories.firstWhere(
    (category) => category.id == categoryId,
    orElse: () => categories.first,
  );
});

final productsByCategoryProvider = Provider.family<List<Product>, String>(
  (ref, categoryId) => [
    for (final product in ref.watch(productsProvider))
      if (product.categoryId == categoryId) product,
  ],
);

final popularProductsProvider = Provider<List<Product>>((ref) {
  final byId = ref.watch(productsByIdProvider);
  return [for (final id in mockPopularProductIds) ?byId[id]];
});
