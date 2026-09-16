import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/product.dart';

/// Apa DaviDan's page, from davidan.md, the only place the water is sold
/// online (docs/sources/davidan_water.md): the heading and line of its card
/// on the "Despre Noi" page, and the photo of both bottles from its blog
/// post. The card's own photo shows croissants, so it isn't used.
abstract final class WaterPage {
  static const title = 'Apa DaviDan';
  static const line =
      'Puritate naturală, îmbuteliată pentru hidratare premium în fiecare '
      'sticlă.';

  /// Both bottles on a pure white background.
  static const photo = 'assets/images/banners/banner-apa-davidan.webp';
}

const _img = 'assets/images/products/';

/// davidan.md's "Apa DaviDan" at 15 lei, in the variants its listing names
/// ("Naturală", "Gazată"); the site has no text for them. The 0,5L is read
/// from the bottles' labels. The 19 L jug has no price in any source, so it
/// isn't offered.
const waterProducts = <Product>[
  Product(
    brand: Brand.water,
    id: 'apa-davidan-plata',
    categoryId: 'apa',
    name: 'Apa DaviDan naturală',
    priceBani: 1500,
    image: '${_img}apa-davidan-plata.webp',
    weight: '0,5L',
  ),
  Product(
    brand: Brand.water,
    id: 'apa-davidan-carbogazoasa',
    categoryId: 'apa',
    name: 'Apa DaviDan gazată',
    priceBani: 1500,
    image: '${_img}apa-davidan-carbogazoasa.webp',
    weight: '0,5L',
  ),
];

/// This brand's share of the hub's "pentru tine": both bottles.
const waterPopularProductIds = <String>[
  'apa-davidan-plata',
  'apa-davidan-carbogazoasa',
];
