import 'package:flutter/foundation.dart';

/// How the hub presents a brand: its bubble, and the page shown for a brand
/// that has no menu of its own. Quoted from the brand's sources
/// (docs/sources/), never invented.
@immutable
class BrandIntro {
  const BrandIntro({
    required this.name,
    required this.logo,
    this.image,
    this.description,
    this.comingSoon = false,
  });

  /// The brand's name under its bubble.
  final String name;

  /// Bundled logo for the bubble, in the brand's version for a light
  /// background: bubbles are white in both themes.
  final String logo;

  /// Bundled photo for the intro page, the open carts and the active orders
  /// strip. Null when no source has one yet.
  final String? image;

  /// The brand's one-line description. Null when its page is the brand's own
  /// menu, which needs none.
  final String? description;

  /// The brand isn't open in the app yet: its bubble says so, and its page
  /// only introduces it.
  final bool comingSoon;
}
