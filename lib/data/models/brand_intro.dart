import 'package:flutter/foundation.dart';

/// How the hub presents a brand: its bubble, and the page shown for a brand
/// that has no menu of its own. Quoted from the brand's sources
/// (docs/sources/), never invented.
@immutable
class BrandIntro {
  const BrandIntro({required this.name, this.image, this.description});

  /// The brand's name under its bubble.
  final String name;

  /// Bundled photo for the bubble and the intro page. Null when no source has
  /// one yet; the bubble shows an icon instead.
  final String? image;

  /// The brand's one-line description. Null when its page is the brand's own
  /// menu, which needs none.
  final String? description;
}
