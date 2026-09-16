import 'package:davidan_prototype/data/models/menu_category.dart';

/// The site's category slugs.
abstract final class SushiCategoryIds {
  static const sushi = 'sushi';
  static const seturi = 'seturi';
  static const bucateThai = 'bucate-thai';
  static const supe = 'supe';
  static const salate = 'salate';
  static const pokeBowl = 'poke-bowl';
  static const gustari = 'gustari';
  static const deserturi = 'deserturi';
  static const bauturi = 'bauturi';
}

const _img = 'assets/images/sushi/';

/// davidansushi.md's nine top categories, named as its category list names
/// them, in its menu's order (Băuturi, which the menu bar leaves out, last).
/// Its subcategories (Roluri, Tempura, Maki under Sushi; Orez, Soba, Udon,
/// Funcioza under Bucate Thai; soft drinks and wine under Băuturi) only set
/// the order of the products. The site has no category blurbs. Tile images
/// are each category's first product photo.
const sushiCategories = <MenuCategory>[
  MenuCategory(
    id: SushiCategoryIds.sushi,
    name: 'Sushi',
    image: '${_img}alasca.webp',
  ),
  MenuCategory(
    id: SushiCategoryIds.seturi,
    name: 'Seturi',
    image: '${_img}davidan-set.webp',
  ),
  MenuCategory(
    id: SushiCategoryIds.bucateThai,
    name: 'Bucate Thai',
    image: '${_img}orez-cu-fructe-de-mare.webp',
  ),
  MenuCategory(
    id: SushiCategoryIds.supe,
    name: 'Supe',
    image: '${_img}ramen-cu-pui.webp',
  ),
  MenuCategory(
    id: SushiCategoryIds.salate,
    name: 'Salate',
    image: '${_img}chuka.webp',
  ),
  MenuCategory(
    id: SushiCategoryIds.pokeBowl,
    name: 'Poke bowl',
    image: '${_img}poke-bowl-creveti.webp',
  ),
  MenuCategory(
    id: SushiCategoryIds.gustari,
    name: 'Gustări',
    image: '${_img}aripioare-crocante.webp',
  ),
  MenuCategory(
    id: SushiCategoryIds.deserturi,
    name: 'Deserturi',
    image: '${_img}cheescake.webp',
  ),
  MenuCategory(
    id: SushiCategoryIds.bauturi,
    name: 'Băuturi',
    image: '${_img}coca-cola-250ml.webp',
  ),
];
