import 'package:flutter/foundation.dart';

/// A menu item. Prices are stored in bani (1/100 MDL) so cart totals never
/// pick up floating-point rounding errors.
@immutable
class Product {
  const Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.priceBani,
    this.image,
    this.description,
  });

  /// Stable slug, also used in routes and saved cart data.
  final String id;
  final String categoryId;
  final String name;
  final int priceBani;

  /// Bundled asset path, or null to show a branded placeholder tile.
  final String? image;

  /// Ingredient list from davidan.md. Null when the site has none; never
  /// invented.
  final String? description;
}
