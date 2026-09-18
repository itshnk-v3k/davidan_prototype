import 'package:davidan_prototype/data/mock/bakery/bakery_categories.dart';
import 'package:davidan_prototype/data/mock/sushi/sushi_categories.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/product.dart';

// DEMO CONTENT: made-up promotions to show the client what promo cards could
// look like. Not real offers: the prices and the cart don't change.

/// A promo card: a discount on one of a brand's categories, shown on the
/// [productId] of that category it puts forward. The card carries that
/// product's photo and name, and opens its page, so a tap on an offer lands on
/// something that can be ordered rather than back on the offer.
class DemoPromo {
  const DemoPromo({
    required this.categoryId,
    required this.productId,
    required this.percent,
  });

  final String categoryId;

  /// The product the card shows and opens: one of [categoryId]'s.
  final String productId;
  final int percent;
}

const demoPromos = <Brand, List<DemoPromo>>{
  Brand.bakery: [
    DemoPromo(
      categoryId: BakeryCategoryIds.kurtos,
      productId: 'kurtos-scortisoara',
      percent: 20,
    ),
    DemoPromo(
      categoryId: BakeryCategoryIds.patiserie,
      productId: 'croissant-ciocolata',
      percent: 15,
    ),
  ],
  Brand.sushi: [
    DemoPromo(
      categoryId: SushiCategoryIds.seturi,
      productId: 'davidan-set',
      percent: 20,
    ),
    DemoPromo(
      categoryId: SushiCategoryIds.pokeBowl,
      productId: 'poke-bowl-creveti',
      percent: 10,
    ),
  ],
};

/// The offer running on [product]'s category, for the "-20%" on its card and
/// on its page, or null when its category has none. Every product of a
/// category on offer carries the same badge: the offer is on the category, not
/// on the product, and no discount is invented for one.
int? demoDiscountFor(Product product) {
  for (final promo in demoPromos[product.brand] ?? const <DemoPromo>[]) {
    if (promo.categoryId == product.categoryId) return promo.percent;
  }
  return null;
}
