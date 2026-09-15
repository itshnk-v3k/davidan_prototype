import 'package:davidan_prototype/data/mock/mock_categories.dart';
import 'package:davidan_prototype/data/models/promo_banner.dart';

/// Home carousel slides. The dessert and croissant photos are from the
/// davidan.md homepage slider; the Kurtos slide reuses a product photo. The
/// headlines are quoted from davidan.md: its About page, its Kurtos section
/// and its Patiserie section (with the stray space before "!" removed).
const mockBanners = <PromoBanner>[
  PromoBanner(
    id: 'deserturi',
    image: 'assets/images/banners/banner-deserturi.webp',
    title: 'DaviDan - Pasiune pentru Patiserie!',
    subtitle:
        'Delicii proaspete, pregătite zilnic cu pasiune pentru gusturi '
        'autentice.',
    categoryId: CategoryIds.patiserie,
  ),
  PromoBanner(
    id: 'kurtos',
    image: 'assets/images/products/kurtos-scortisoara.webp',
    title: 'Specializați în Coacerea și Comercializarea Kurtosului',
    categoryId: CategoryIds.kurtos,
  ),
  PromoBanner(
    id: 'croissante',
    image: 'assets/images/banners/banner-croissante.webp',
    title: 'Patiserie',
    subtitle:
        'Descoperă deliciile noastre proaspete și rafinate la Patiseria '
        'noastră',
    categoryId: CategoryIds.patiserie,
  ),
];
