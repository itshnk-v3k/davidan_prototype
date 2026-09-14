import 'package:davidan_prototype/data/mock/mock_categories.dart';
import 'package:davidan_prototype/data/models/promo_banner.dart';

const _img = 'assets/images/banners/';

/// Home carousel slides. Photos are from the davidan.md homepage slider; the
/// headlines are written for the demo.
const mockBanners = <PromoBanner>[
  PromoBanner(
    id: 'deserturi',
    image: '${_img}banner-deserturi.webp',
    title: 'Deserturi proaspete, în fiecare zi',
    subtitle: 'Descoperă patiseria DaviDan',
    categoryId: CategoryIds.patiserie,
  ),
  PromoBanner(
    id: 'croissante',
    image: '${_img}banner-croissante.webp',
    title: 'Croissante coapte azi',
    subtitle: 'Cu fistic, ciocolată și migdale',
    categoryId: CategoryIds.patiserie,
  ),
];
