import 'package:davidan_prototype/data/mock/mock_categories.dart';
import 'package:davidan_prototype/data/models/product.dart';

const _img = 'assets/images/products/';

/// Products scraped from davidan.md (names and prices), plus clearly marked
/// placeholders for the Sushi and Restaurant categories. Prices are in bani.
const mockProducts = <Product>[
  // --- Kurtos ---
  // DaviDan's signature product, from davidan.md/collections/meniu-kurtos.
  Product(
    id: 'kurtos-scortisoara',
    categoryId: CategoryIds.kurtos,
    name: 'Kurtos cu zahăr și scorțișoară',
    priceBani: 3600,
    image: '${_img}kurtos-scortisoara.webp',
  ),
  Product(
    id: 'kurtos-vanilie',
    categoryId: CategoryIds.kurtos,
    name: 'Kurtos cu vanilie',
    priceBani: 3600,
    image: '${_img}kurtos-vanilie.webp',
  ),
  Product(
    id: 'kurtos-cocos',
    categoryId: CategoryIds.kurtos,
    name: 'Kurtos cu fulgi de cocos',
    priceBani: 3600,
    image: '${_img}kurtos-cocos.webp',
  ),
  Product(
    id: 'kurtos-ciocolata',
    categoryId: CategoryIds.kurtos,
    name: 'Kurtos cu fulgi de ciocolată',
    priceBani: 3900,
    image: '${_img}kurtos-ciocolata.webp',
  ),
  Product(
    id: 'kurtos-arahide',
    categoryId: CategoryIds.kurtos,
    name: 'Kurtos cu arahide',
    priceBani: 3900,
    image: '${_img}kurtos-arahide.webp',
  ),
  Product(
    id: 'kurtos-rafaello',
    categoryId: CategoryIds.kurtos,
    name: 'Kurtos Rafaello',
    priceBani: 5500,
    image: '${_img}kurtos-rafaello.webp',
  ),
  Product(
    id: 'kurtos-fistic',
    categoryId: CategoryIds.kurtos,
    name: 'Kurtos cu fistic',
    priceBani: 5900,
    image: '${_img}kurtos-fistic.webp',
  ),

  // --- Patiserie ---
  Product(
    id: 'croissant-ciocolata',
    categoryId: CategoryIds.patiserie,
    name: 'Croissant cu ciocolată',
    priceBani: 1900,
    image: '${_img}croissant-ciocolata.webp',
  ),
  Product(
    id: 'pretzel-plombir-migdale',
    categoryId: CategoryIds.patiserie,
    name: 'Pretzel cu plombir și migdale',
    priceBani: 2200,
    image: '${_img}pretzel-plombir-migdale.webp',
  ),
  Product(
    id: 'new-york-roll-mango-maracuja',
    categoryId: CategoryIds.patiserie,
    name: 'New York Rolls cu mango și maracuja',
    priceBani: 3900,
    image: '${_img}new-york-roll-mango-maracuja.webp',
  ),
  Product(
    id: 'new-york-roll-fistic',
    categoryId: CategoryIds.patiserie,
    name: 'New York Rolls cu fistic',
    priceBani: 3900,
    image: '${_img}new-york-roll-fistic.webp',
  ),
  Product(
    id: 'new-york-roll-zmeura',
    categoryId: CategoryIds.patiserie,
    name: 'New York Rolls cu zmeură',
    priceBani: 3900,
    image: '${_img}new-york-roll-zmeura.webp',
  ),
  Product(
    id: 'new-york-roll-ciocolata',
    categoryId: CategoryIds.patiserie,
    name: 'New York Rolls cu ciocolată',
    priceBani: 3900,
    image: '${_img}new-york-roll-ciocolata.webp',
  ),
  Product(
    id: 'danish-fructe-padure-vanilie',
    categoryId: CategoryIds.patiserie,
    name: 'Danish cu fructe de pădure și vanilie',
    priceBani: 2400,
    image: '${_img}danish-fructe-padure-vanilie.webp',
  ),
  Product(
    id: 'croissant-duo',
    categoryId: CategoryIds.patiserie,
    name: 'Croissant Duo',
    priceBani: 2500,
    image: '${_img}croissant-duo.webp',
  ),
  Product(
    id: 'croissant-fistic',
    categoryId: CategoryIds.patiserie,
    name: 'Croissant cu fistic',
    priceBani: 2200,
    image: '${_img}croissant-fistic.webp',
  ),
  Product(
    id: 'donuts-oreo',
    categoryId: CategoryIds.patiserie,
    name: 'Donuts Oreo',
    priceBani: 2400,
    image: '${_img}donuts-oreo.webp',
  ),
  Product(
    id: 'muffin-orange',
    categoryId: CategoryIds.patiserie,
    name: 'Muffins Orange',
    priceBani: 1800,
    image: '${_img}muffin-orange.webp',
  ),

  // --- Plăcinte & Panini ---
  Product(
    id: 'placinta-branza',
    categoryId: CategoryIds.placinte,
    name: 'Plăcintă cu brânză',
    priceBani: 2200,
    image: '${_img}placinta-branza.webp',
  ),
  Product(
    id: 'placinta-varza',
    categoryId: CategoryIds.placinte,
    name: 'Plăcintă cu varză',
    priceBani: 1800,
    image: '${_img}placinta-varza.webp',
  ),
  Product(
    id: 'placinta-cartof',
    categoryId: CategoryIds.placinte,
    name: 'Plăcintă cu cartof',
    priceBani: 1800,
    image: '${_img}placinta-cartof.webp',
  ),
  Product(
    id: 'placinta-branza-verdeata',
    categoryId: CategoryIds.placinte,
    name: 'Plăcintă cu brânză și verdeață',
    priceBani: 2200,
    image: '${_img}placinta-branza-verdeata.webp',
  ),
  Product(
    id: 'placinta-pui',
    categoryId: CategoryIds.placinte,
    name: 'Plăcintă cu carne de pui',
    priceBani: 2400,
    image: '${_img}placinta-pui.webp',
  ),
  Product(
    id: 'placinta-mere',
    categoryId: CategoryIds.placinte,
    name: 'Plăcintă cu mere',
    priceBani: 1800,
    image: '${_img}placinta-mere.webp',
  ),
  Product(
    id: 'placinta-visina',
    categoryId: CategoryIds.placinte,
    name: 'Plăcintă cu vișină',
    priceBani: 2500,
    image: '${_img}placinta-visina.webp',
  ),
  Product(
    id: 'panini-muschi-porc',
    categoryId: CategoryIds.placinte,
    name: 'Panini cu mușchi de porc',
    priceBani: 3600,
    image: '${_img}panini-muschi-porc.webp',
  ),
  Product(
    id: 'crenvursca-aluat',
    categoryId: CategoryIds.placinte,
    name: 'Crenvurșcă în aluat',
    priceBani: 2100,
    image: '${_img}crenvursca-aluat.webp',
  ),
  Product(
    id: 'sandwich-pui-crispy',
    categoryId: CategoryIds.placinte,
    name: 'Sandwich cu pui Crispy',
    priceBani: 4000,
    image: '${_img}sandwich-pui-crispy.webp',
  ),
  Product(
    id: 'pizza-piept-pui',
    categoryId: CategoryIds.placinte,
    name: 'Pizza cu piept de pui',
    priceBani: 3500,
    image: '${_img}pizza-piept-pui.webp',
  ),
  Product(
    id: 'foietaj-picnic',
    categoryId: CategoryIds.placinte,
    name: 'Foietaj Picnic',
    priceBani: 2500,
    image: '${_img}foietaj-picnic.webp',
  ),

  // --- Băuturi ---
  Product(
    id: 'coca-cola',
    categoryId: CategoryIds.bauturi,
    name: 'Coca Cola',
    priceBani: 2500,
    image: '${_img}coca-cola.webp',
  ),
  Product(
    id: 'fanta',
    categoryId: CategoryIds.bauturi,
    name: 'Fanta',
    priceBani: 2500,
    image: '${_img}fanta.webp',
  ),
  Product(
    id: 'sprite',
    categoryId: CategoryIds.bauturi,
    name: 'Sprite',
    priceBani: 2500,
    image: '${_img}sprite.webp',
  ),
  // The site lists both waters as "Apa DaviDan"; still/sparkling is inferred
  // from the bottle colour (blue / green) in the photos.
  Product(
    id: 'apa-davidan-plata',
    categoryId: CategoryIds.bauturi,
    name: 'Apa DaviDan plată',
    priceBani: 1500,
    image: '${_img}apa-davidan-plata.webp',
  ),
  Product(
    id: 'apa-davidan-carbogazoasa',
    categoryId: CategoryIds.bauturi,
    name: 'Apa DaviDan carbogazoasă',
    priceBani: 1500,
    image: '${_img}apa-davidan-carbogazoasa.webp',
  ),
  Product(
    id: 'americano',
    categoryId: CategoryIds.bauturi,
    name: 'Americano',
    priceBani: 2200,
    image: '${_img}americano.webp',
  ),
  Product(
    id: 'ciocolata-fierbinte-lapte',
    categoryId: CategoryIds.bauturi,
    name: 'Ciocolată fierbinte cu lapte',
    priceBani: 2400,
    image: '${_img}ciocolata-fierbinte-lapte.webp',
  ),
  Product(
    id: 'macchiato',
    categoryId: CategoryIds.bauturi,
    name: 'Macchiato',
    priceBani: 2500,
    image: '${_img}macchiato.webp',
  ),
  Product(
    id: 'espresso',
    categoryId: CategoryIds.bauturi,
    name: 'Espresso',
    priceBani: 2200,
    image: '${_img}espresso.webp',
  ),
  Product(
    id: 'flat-white',
    categoryId: CategoryIds.bauturi,
    name: 'Flat White',
    priceBani: 3300,
    image: '${_img}flat-white.webp',
  ),
  Product(
    id: 'ceai-natural',
    categoryId: CategoryIds.bauturi,
    name: 'Ceai natural',
    priceBani: 1500,
    image: '${_img}ceai-natural.webp',
  ),
  Product(
    id: 'ciocolata-fierbinte',
    categoryId: CategoryIds.bauturi,
    name: 'Ciocolată fierbinte',
    priceBani: 2400,
    image: '${_img}ciocolata-fierbinte.webp',
  ),

  // --- Sushi: PLACEHOLDER ---
  // davidan.md shows a Sushi category with no products. Names and prices are
  // invented for the demo. Only Ebi Roll has a photo (the homepage category
  // image); the rest render the branded placeholder tile.
  Product(
    id: 'ebi-roll',
    categoryId: CategoryIds.sushi,
    name: 'Ebi Roll',
    priceBani: 11900,
    image: '${_img}ebi-roll.webp',
  ),
  Product(
    id: 'philadelphia-roll',
    categoryId: CategoryIds.sushi,
    name: 'Philadelphia Roll',
    priceBani: 13900,
  ),
  Product(
    id: 'california-roll',
    categoryId: CategoryIds.sushi,
    name: 'California Roll',
    priceBani: 12500,
  ),
  Product(
    id: 'maki-somon',
    categoryId: CategoryIds.sushi,
    name: 'Maki cu somon',
    priceBani: 7500,
  ),

  // --- Restaurant: PLACEHOLDER ---
  // davidan.md shows a Restaurant category with no products. Names and prices
  // are invented for the demo. Only Orez cu pui has a photo (the homepage
  // category image).
  Product(
    id: 'orez-pui',
    categoryId: CategoryIds.restaurant,
    name: 'Orez cu pui',
    priceBani: 8500,
    image: '${_img}orez-pui.webp',
  ),
  Product(
    id: 'supa-crema-ciuperci',
    categoryId: CategoryIds.restaurant,
    name: 'Supă cremă de ciuperci',
    priceBani: 5500,
  ),
  Product(
    id: 'piept-pui-gratar',
    categoryId: CategoryIds.restaurant,
    name: 'Piept de pui la grătar cu legume',
    priceBani: 9500,
  ),
  Product(
    id: 'paste-carbonara',
    categoryId: CategoryIds.restaurant,
    name: 'Paste Carbonara',
    priceBani: 8900,
  ),
];

/// Products shown in the home screen's "Populare" section, in order.
const mockPopularProductIds = <String>[
  'kurtos-scortisoara',
  'new-york-roll-fistic',
  'croissant-ciocolata',
  'placinta-branza',
  'pizza-piept-pui',
  'croissant-duo',
  'americano',
];
