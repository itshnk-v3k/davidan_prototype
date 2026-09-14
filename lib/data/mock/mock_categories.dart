import 'package:davidan_prototype/data/models/menu_category.dart';

abstract final class CategoryIds {
  static const patiserie = 'patiserie';
  static const placinte = 'placinte-panini';
  static const bauturi = 'bauturi';
  static const sushi = 'sushi';
  static const restaurant = 'restaurant';
}

const _img = 'assets/images/products/';

/// Menu categories, in display order. Tile images reuse product photos.
const mockCategories = <MenuCategory>[
  MenuCategory(
    id: CategoryIds.patiserie,
    name: 'Patiserie',
    image: '${_img}croissant-ciocolata.webp',
  ),
  MenuCategory(
    id: CategoryIds.placinte,
    name: 'Plăcinte & Panini',
    image: '${_img}placinta-branza.webp',
  ),
  MenuCategory(
    id: CategoryIds.bauturi,
    name: 'Băuturi',
    image: '${_img}americano.webp',
  ),
  MenuCategory(
    id: CategoryIds.sushi,
    name: 'Sushi',
    image: '${_img}ebi-roll.webp',
  ),
  MenuCategory(
    id: CategoryIds.restaurant,
    name: 'Restaurant',
    image: '${_img}orez-pui.webp',
  ),
];
