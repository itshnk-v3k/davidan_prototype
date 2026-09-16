import 'package:flutter/foundation.dart';

import 'package:davidan_prototype/data/models/menu_category.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/data/models/promo_banner.dart';

/// One brand's menu: its categories in display order, its products, the
/// banners on its home and the products its home shows first. Empty for a
/// brand that sells nothing from a menu.
@immutable
class BrandCatalog {
  const BrandCatalog({
    this.categories = const [],
    this.products = const [],
    this.banners = const [],
    this.popularProductIds = const [],
  });

  final List<MenuCategory> categories;
  final List<Product> products;
  final List<PromoBanner> banners;

  /// Ids of the products in home's first row, in order.
  final List<String> popularProductIds;
}
