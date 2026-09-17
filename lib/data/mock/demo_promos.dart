import 'package:davidan_prototype/data/mock/bakery/bakery_categories.dart';
import 'package:davidan_prototype/data/mock/sushi/sushi_categories.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/product.dart';

// DEMO CONTENT: made-up promotions to show the client what promo cards could
// look like. Not real offers: the prices and the cart don't change.

/// A promo card: a discount on one of a brand's categories.
class DemoPromo {
  const DemoPromo({required this.categoryId, required this.percent});

  final String categoryId;
  final int percent;
}

const demoPromos = <Brand, List<DemoPromo>>{
  Brand.bakery: [
    DemoPromo(categoryId: BakeryCategoryIds.kurtos, percent: 20),
    DemoPromo(categoryId: BakeryCategoryIds.patiserie, percent: 15),
  ],
  Brand.sushi: [
    DemoPromo(categoryId: SushiCategoryIds.seturi, percent: 20),
    DemoPromo(categoryId: SushiCategoryIds.pokeBowl, percent: 10),
  ],
};

/// The offer running on [product]'s category, for the "-20%" on its card, or
/// null when its category has none. Every product of a category on offer
/// carries the same badge: the offer is on the category, not on the product,
/// and no discount is invented for one.
int? demoDiscountFor(Product product) {
  for (final promo in demoPromos[product.brand] ?? const <DemoPromo>[]) {
    if (promo.categoryId == product.categoryId) return promo.percent;
  }
  return null;
}
