import 'package:davidan_prototype/data/mock/sushi/sushi_info.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/brand_info.dart';
import 'package:davidan_prototype/data/models/brand_intro.dart';

/// Company slogan from davidan.md, for the splash screen.
abstract final class BrandFacts {
  /// Opening sentence of the site's intro text.
  static const tagline = 'Există ceva bun pentru orice moment al zilei';
}

const _img = 'assets/images/products/';

/// Every brand's bubble on the hub, in [Brand] order. Names, lines and photos
/// are davidan.md's homepage tiles; Rent Car's are its own site's (its name
/// and page title), and it has no photo in the app yet.
const brandIntros = <Brand, BrandIntro>{
  Brand.restaurant: BrandIntro(
    name: 'Restaurant',
    image: '${_img}orez-pui.webp',
    description:
        'Experiențe culinare de neuitat într-un ambient elegant și primitor.',
  ),
  Brand.sushi: BrandIntro(name: 'Sushi', image: '${_img}ebi-roll.webp'),
  Brand.bakery: BrandIntro(
    name: 'Patiserie',
    image: '${_img}kurtos-scortisoara.webp',
  ),
  Brand.water: BrandIntro(
    name: 'Apă naturală',
    image: '${_img}apa-davidan-plata.webp',
  ),
  Brand.carRental: BrandIntro(
    name: 'Rent Car',
    description: 'Mașini de Închiriat Rapid și Simplu',
  ),
};

/// The brands with an information page (contacts and legal pages). A brand
/// missing here has none: the bakery's legal pages name another shop.
const brandInfos = <Brand, BrandInfo>{Brand.sushi: sushiInfo};
