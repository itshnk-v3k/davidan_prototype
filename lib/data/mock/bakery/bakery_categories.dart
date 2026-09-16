import 'package:davidan_prototype/data/models/menu_category.dart';

abstract final class BakeryCategoryIds {
  static const kurtos = 'kurtos';
  static const patiserie = 'patiserie';
  static const placinte = 'placinte-panini';
  static const bauturi = 'bauturi';
  static const sushi = 'sushi';
  static const restaurant = 'restaurant';
}

const _img = 'assets/images/products/';

/// Menu categories, in display order. Tile images reuse product photos.
///
/// Descriptions are quoted from davidan.md as written, including the formal
/// "Descoperiți" / "Savurați" of its menu blurbs, which differs from the app's
/// informal "tu". Băuturi has no blurb on the site.
const bakeryCategories = <MenuCategory>[
  MenuCategory(
    id: BakeryCategoryIds.kurtos,
    name: 'Kurtos',
    image: '${_img}kurtos-scortisoara.webp',
    description:
        'Descoperiți selecția noastră variată de kurtosuri, coapte perfect și '
        'aromate, gata să răsfețe papilele gustative.',
  ),
  MenuCategory(
    id: BakeryCategoryIds.patiserie,
    name: 'Patiserie',
    image: '${_img}croissant-ciocolata.webp',
    description:
        'Descoperă deliciile noastre proaspete și rafinate la Patiseria '
        'noastră',
  ),
  MenuCategory(
    id: BakeryCategoryIds.placinte,
    name: 'Plăcinte & Panini',
    image: '${_img}placinta-branza.webp',
    description:
        'Savurați plăcintele noastre proaspete și panini-urile delicioase, '
        'preparate cu ingrediente de calitate și multă pasiune.',
  ),
  MenuCategory(
    id: BakeryCategoryIds.bauturi,
    name: 'Băuturi',
    image: '${_img}americano.webp',
  ),
  MenuCategory(
    id: BakeryCategoryIds.sushi,
    name: 'Sushi',
    image: '${_img}ebi-roll.webp',
    description:
        'Delicii proaspete, rafinate și autentice, direct din tradiția '
        'japoneză.',
  ),
  MenuCategory(
    id: BakeryCategoryIds.restaurant,
    name: 'Restaurant',
    image: '${_img}orez-pui.webp',
    description:
        'Experiențe culinare de neuitat într-un ambient elegant și primitor.',
  ),
];
