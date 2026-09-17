import 'package:davidan_prototype/data/mock/bakery/bakery_categories.dart';
import 'package:davidan_prototype/data/mock/sushi/sushi_categories.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/product.dart';

// PLACEHOLDER NUTRITION: NOT REAL DATA, approximate values for demo purposes.
//
// No DaviDan site publishes calories, and the bakery gives no weights. The
// client asked to show both on the demo's product cards and pages, so every
// number here is made up: a plausible value for the product's kind (a pastry,
// a roll, a set, a drink), picked from the product's id so it stays the same
// between launches.
//
// The sites' real weights ("Masa", Product.weight) and pieces stay as they
// are: a placeholder weight only fills in where the site gives none.
//
// TODO(nutrition): replace with real per-product calories and weights from the
// client, and delete this file.

/// How a placeholder weight is measured: grams for food, millilitres for
/// drinks.
enum PlaceholderWeightUnit { grams, millilitres }

/// Approximate calories and weight for one product. Not real data: see the
/// note at the top of this file.
class PlaceholderNutrition {
  const PlaceholderNutrition({
    required this.placeholderCalories,
    required this.placeholderWeight,
    required this.placeholderWeightUnit,
  });

  /// Approximate kcal for the whole portion.
  final int placeholderCalories;

  /// Approximate weight (or volume) of the portion. Shown only when the site
  /// gives no real weight.
  final int placeholderWeight;
  final PlaceholderWeightUnit placeholderWeightUnit;
}

/// A range of plausible values for one kind of product.
typedef _Range = ({
  int minKcal,
  int maxKcal,
  int minWeight,
  int maxWeight,
  PlaceholderWeightUnit unit,
});

_Range _food(int minKcal, int maxKcal, int minGrams, int maxGrams) => (
  minKcal: minKcal,
  maxKcal: maxKcal,
  minWeight: minGrams,
  maxWeight: maxGrams,
  unit: PlaceholderWeightUnit.grams,
);

_Range _drink(int minKcal, int maxKcal, int minMl, int maxMl) => (
  minKcal: minKcal,
  maxKcal: maxKcal,
  minWeight: minMl,
  maxWeight: maxMl,
  unit: PlaceholderWeightUnit.millilitres,
);

/// The kind of product a category holds, by brand and category.
_Range? _rangeFor(Product product) => switch (product.brand) {
  Brand.bakery => switch (product.categoryId) {
    BakeryCategoryIds.kurtos => _food(320, 480, 150, 220),
    BakeryCategoryIds.patiserie => _food(250, 450, 80, 140),
    BakeryCategoryIds.placinte => _food(300, 550, 150, 250),
    BakeryCategoryIds.bauturi => _drink(5, 220, 250, 400),
    _ => _food(250, 450, 100, 200),
  },
  Brand.sushi => switch (product.categoryId) {
    SushiCategoryIds.sushi => _food(200, 350, 180, 280),
    SushiCategoryIds.seturi => _food(900, 1600, 700, 1200),
    SushiCategoryIds.bucateThai => _food(450, 700, 300, 400),
    SushiCategoryIds.supe => _food(150, 350, 300, 400),
    SushiCategoryIds.salate => _food(180, 380, 200, 280),
    SushiCategoryIds.pokeBowl => _food(450, 650, 350, 450),
    SushiCategoryIds.gustari => _food(250, 450, 150, 250),
    SushiCategoryIds.deserturi => _food(250, 450, 100, 180),
    SushiCategoryIds.bauturi => _drink(0, 150, 330, 500),
    _ => _food(250, 450, 200, 300),
  },
  Brand.restaurant => _food(450, 700, 300, 450),
  // Water has no calories to approximate, and Rent Car sells no food.
  Brand.water || Brand.carRental => null,
};

/// Approximate calories and weight for [product], or null for a product that
/// isn't food (water). Not real data: see the note at the top of this file.
PlaceholderNutrition? placeholderNutritionFor(Product product) {
  final range = _rangeFor(product);
  if (range == null) return null;
  int pick(String salt, int min, int max, int step) {
    // A string hash that is the same on every platform and every launch
    // (String.hashCode isn't).
    var hash = 17;
    for (final unit in '${product.brand.name}/${product.id}/$salt'.codeUnits) {
      hash = (hash * 31 + unit) & 0x7fffffff;
    }
    final steps = (max - min) ~/ step;
    return min + (hash % (steps + 1)) * step;
  }

  return PlaceholderNutrition(
    placeholderCalories: pick('kcal', range.minKcal, range.maxKcal, 5),
    placeholderWeight: pick('weight', range.minWeight, range.maxWeight, 10),
    placeholderWeightUnit: range.unit,
  );
}
