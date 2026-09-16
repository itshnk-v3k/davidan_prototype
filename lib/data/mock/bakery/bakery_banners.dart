import 'package:davidan_prototype/data/mock/bakery/bakery_categories.dart';
import 'package:davidan_prototype/data/models/promo_banner.dart';

/// Home carousel slides. The dessert and croissant photos are from the
/// davidan.md homepage slider; the Kurtos slide reuses a product photo. The
/// headlines are quoted from davidan.md: its About page, its Kurtos section
/// and its Patiserie section (with the stray space before "!" removed).
const bakeryBanners = <PromoBanner>[
  PromoBanner(
    id: 'deserturi',
    image: 'assets/images/banners/banner-deserturi.webp',
    title: 'DaviDan - Pasiune pentru Patiserie!',
    subtitle:
        'Delicii proaspete, pregătite zilnic cu pasiune pentru gusturi '
        'autentice.',
    categoryId: BakeryCategoryIds.patiserie,
  ),
  PromoBanner(
    id: 'kurtos',
    image: 'assets/images/products/kurtos-scortisoara.webp',
    title: 'Specializați în Coacerea și Comercializarea Kurtosului',
    categoryId: BakeryCategoryIds.kurtos,
  ),
  PromoBanner(
    id: 'croissante',
    image: 'assets/images/banners/banner-croissante.webp',
    title: 'Patiserie',
    subtitle:
        'Descoperă deliciile noastre proaspete și rafinate la Patiseria '
        'noastră',
    categoryId: BakeryCategoryIds.patiserie,
  ),
];
