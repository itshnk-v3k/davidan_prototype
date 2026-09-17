import 'package:flutter/foundation.dart';

/// A slide in the home screen banner carousel.
@immutable
class PromoBanner {
  const PromoBanner({
    required this.id,
    required this.image,
    this.title,
    this.subtitle,
    this.categoryId,
    this.focusX = 0,
  });

  final String id;

  /// Bundled asset path.
  final String image;

  /// Text drawn over the image. Null when the image already contains text.
  final String? title;
  final String? subtitle;

  /// Category opened when the banner is tapped, if any.
  final String? categoryId;

  /// Where across the photo its subject sits, from -1 (the left edge) to 1
  /// (the right), so a slide narrower than a wide photo crops around it.
  final double focusX;
}
