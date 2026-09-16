import 'package:davidan_prototype/data/mock/sushi/sushi_categories.dart';
import 'package:davidan_prototype/data/models/promo_banner.dart';

/// davidansushi.md's homepage slider, which has one slide: its dessert photo
/// and title. The slide's two-sentence text doesn't fit a phone banner, so
/// only the title is quoted.
const sushiBanners = <PromoBanner>[
  PromoBanner(
    id: 'dulciuri-nipone',
    image: 'assets/images/banners/banner-sushi-dulciuri-nipone.webp',
    title: 'Dulciuri Nipone',
    categoryId: SushiCategoryIds.deserturi,
  ),
];
