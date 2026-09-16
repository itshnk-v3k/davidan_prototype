import 'package:davidan_prototype/data/mock/bakery/bakery_banners.dart';
import 'package:davidan_prototype/data/mock/bakery/bakery_categories.dart';
import 'package:davidan_prototype/data/mock/bakery/bakery_products.dart';
import 'package:davidan_prototype/data/mock/sushi/sushi_banners.dart';
import 'package:davidan_prototype/data/mock/sushi/sushi_categories.dart';
import 'package:davidan_prototype/data/mock/sushi/sushi_products.dart';
import 'package:davidan_prototype/data/mock/water/water_catalog.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/brand_catalog.dart';

/// Every brand's menu. A brand missing here has none (yet).
const mockCatalogs = <Brand, BrandCatalog>{
  Brand.sushi: BrandCatalog(
    categories: sushiCategories,
    products: sushiProducts,
    banners: sushiBanners,
    popularProductIds: sushiPopularProductIds,
  ),
  Brand.bakery: BrandCatalog(
    categories: bakeryCategories,
    products: bakeryProducts,
    banners: bakeryBanners,
    popularProductIds: bakeryPopularProductIds,
  ),
  // One page with both bottles: no categories, so no menu page.
  Brand.water: BrandCatalog(
    products: waterProducts,
    popularProductIds: waterPopularProductIds,
  ),
};
