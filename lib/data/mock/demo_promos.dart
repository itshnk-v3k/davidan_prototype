import 'package:davidan_prototype/data/mock/bakery/bakery_categories.dart';
import 'package:davidan_prototype/data/mock/sushi/sushi_categories.dart';
import 'package:davidan_prototype/data/models/brand.dart';

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
