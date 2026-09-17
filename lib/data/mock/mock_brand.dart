import 'package:davidan_prototype/data/mock/rental/rental_info.dart';
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
const _logo = 'assets/images/brand/';

/// Every brand's bubble on the hub, in [Brand] order. Names, lines and photos
/// are davidan.md's homepage tiles; Rent Car's photo is the car on the first
/// slide of davidanrentcar.md's homepage. Logos are each brand's own site's
/// (tools/image_manifest.txt). The restaurant has none yet, so it shows
/// DaviDan's, as the bakery does, whose site davidan.md is.
const brandIntros = <Brand, BrandIntro>{
  Brand.restaurant: BrandIntro(
    name: 'Restaurant',
    logo: '${_logo}logo-davidan.webp',
    image: '${_img}orez-pui.webp',
    description:
        'Experiențe culinare de neuitat într-un ambient elegant și primitor.',
    comingSoon: true,
  ),
  Brand.sushi: BrandIntro(
    name: 'Sushi',
    logo: '${_logo}logo-davidan-sushi-on-light.png',
    image: '${_img}ebi-roll.webp',
  ),
  Brand.bakery: BrandIntro(
    name: 'Patiserie',
    logo: '${_logo}logo-davidan.webp',
    image: '${_img}kurtos-scortisoara.webp',
  ),
  Brand.water: BrandIntro(
    name: 'Apă naturală',
    logo: '${_logo}logo-apa-davidan.webp',
    image: '${_img}apa-davidan-plata.webp',
  ),
  Brand.carRental: BrandIntro(
    name: 'Rent Car',
    logo: '${_logo}logo-davidan-rent-car.webp',
    image: 'assets/images/cars/audi-q5-2021.webp',
  ),
};

/// The brands with an information page (contacts and legal pages). A brand
/// missing here has none: the bakery's legal pages name another shop.
const brandInfos = <Brand, BrandInfo>{
  Brand.sushi: sushiInfo,
  Brand.carRental: rentalInfo,
};
