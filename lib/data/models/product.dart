import 'package:flutter/foundation.dart';

import 'package:davidan_prototype/data/models/brand.dart';

/// A product's identity across brands. Ids are unique within a brand only:
/// the bakery and the sushi menu both sell a Coca Cola.
typedef ProductKey = ({Brand brand, String id});

/// A menu item. Prices are stored in bani (1/100 MDL) so cart totals never
/// pick up floating-point rounding errors.
@immutable
class Product {
  const Product({
    required this.brand,
    required this.id,
    required this.categoryId,
    required this.name,
    required this.priceBani,
    this.image,
    this.description,
  });

  /// The brand that sells it.
  final Brand brand;

  /// Stable slug within [brand], also used in routes and saved cart data.
  final String id;
  final String categoryId;
  final String name;
  final int priceBani;

  /// Bundled asset path, or null to show a branded placeholder tile.
  final String? image;

  /// Ingredient list from davidan.md. Null when the site has none; never
  /// invented.
  final String? description;

  ProductKey get key => (brand: brand, id: id);
}
