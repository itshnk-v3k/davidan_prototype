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

final popularProductsProvider = Provider<List<Product>>((ref) {
  final byId = ref.watch(productsByIdProvider);
  return [for (final id in mockPopularProductIds) ?byId[id]];
});
