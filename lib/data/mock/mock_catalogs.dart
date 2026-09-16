import 'package:davidan_prototype/data/mock/bakery/bakery_banners.dart';
import 'package:davidan_prototype/data/mock/bakery/bakery_categories.dart';
import 'package:davidan_prototype/data/mock/bakery/bakery_products.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/brand_catalog.dart';

/// Every brand's menu. A brand missing here has none (yet).
const mockCatalogs = <Brand, BrandCatalog>{
  Brand.bakery: BrandCatalog(
    categories: bakeryCategories,
    products: bakeryProducts,
    banners: bakeryBanners,
    popularProductIds: bakeryPopularProductIds,
  ),
};
