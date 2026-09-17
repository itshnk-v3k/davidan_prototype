import 'package:davidan_prototype/data/models/product.dart';

// PLACEHOLDER RATINGS: NOT REAL DATA.
//
// No DaviDan site collects reviews, so no product has a real rating. The
// client asked to show one on product cards anyway, as a placeholder for the
// demo. Every number here is made up from the product's id, so it stays the
// same between launches and differs between products.
//
// TODO(reviews): replace with real review data (average and count) once the
// platform collects reviews, and delete this file.

/// The lowest and highest placeholder rating.
const placeholderRatingMin = 4.3;
const placeholderRatingMax = 4.9;

/// A made-up rating for [product], from [placeholderRatingMin] to
/// [placeholderRatingMax] in steps of 0.1. Not a real rating: see the note at
/// the top of this file.
double placeholderRatingFor(ProductKey product) {
  // A string hash that is the same on every platform and every launch
  // (String.hashCode isn't).
  var hash = 17;
  for (final unit in '${product.brand.name}/${product.id}'.codeUnits) {
    hash = (hash * 31 + unit) & 0x7fffffff;
  }
  final steps = ((placeholderRatingMax - placeholderRatingMin) * 10).round();
  return placeholderRatingMin + (hash % (steps + 1)) / 10;
}
