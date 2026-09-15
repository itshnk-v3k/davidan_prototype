import 'package:flutter/foundation.dart';

/// Named MenuCategory because Flutter's foundation library already exports a
/// `Category` annotation.
@immutable
class MenuCategory {
  const MenuCategory({
    required this.id,
    required this.name,
    required this.image,
    this.description,
  });

  final String id;
  final String name;

  /// Bundled asset path for the category tile.
  final String image;

  /// The category's blurb from davidan.md, quoted as written. Null when the
  /// site has none.
  final String? description;
}
