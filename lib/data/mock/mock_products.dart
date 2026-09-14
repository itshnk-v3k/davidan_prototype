import 'package:davidan_prototype/data/mock/mock_categories.dart';
import 'package:davidan_prototype/data/models/product.dart';

const _img = 'assets/images/products/';

/// Products scraped from davidan.md (names, prices, ingredient lists), plus
/// clearly marked placeholders for the Sushi and Restaurant categories. Prices
/// are in bani. Ingredient lists are the site's text with obvious typos
/// corrected and the nutrition declaration left out.
const mockProducts = <Product>[
  // --- Kurtos ---
  // DaviDan's signature product, from davidan.md/collections/meniu-kurtos.
  Product(
    id: 'kurtos-scortisoara',
    categoryId: CategoryIds.kurtos,
    name: 'Kurtos cu zahăr și scorțișoară',
    priceBani: 3600,
    image: '${_img}kurtos-scortisoara.webp',
    description:
        'Ingrediente: făină de grâu c/s, zahăr cristal, apă potabilă, ulei '
        'de floarea-soarelui, drojdie proaspătă p/u panificație, ouă de '
        'găină, lapte pasteurizat de vacă, scorțișoară, aromă: vanilină; '
        'ameliorator p/u panificație, sare alimentară. Conține: grâu, ouă, '
        'lapte. Poate conține urme de arahide, fistic, susan.',
  ),
  Product(
    id: 'kurtos-vanilie',
    categoryId: CategoryIds.kurtos,
    name: 'Kurtos cu vanilie',
    priceBani: 3600,
    image: '${_img}kurtos-vanilie.webp',
    description:
        'Ingrediente: făină de grâu c/s, zahăr cristal, apă potabilă, ulei '
        'de floarea-soarelui, drojdie proaspătă p/u panificație, ouă de '
        'găină, lapte pasteurizat de vacă, aromă: vanilină; ameliorator p/u '
        'panificație, sare alimentară. Conține: grâu, ouă, lapte. Poate '
        'conține urme de arahide, fistic, susan.',
  ),
  Product(
    id: 'kurtos-cocos',
    categoryId: CategoryIds.kurtos,
    name: 'Kurtos cu fulgi de cocos',
    priceBani: 3600,
    image: '${_img}kurtos-cocos.webp',
    description:
        'Ingrediente: făină de grâu c/s, zahăr cristal, apă potabilă, ulei '
        'de floarea-soarelui, fulgi de cocos, drojdie proaspătă p/u '
        'panificație, ouă de găină, lapte pasteurizat de vacă cu gr. 3,5%, '
        'aromă: vanilină; ameliorator p/u panificație, sare alimentară. '
        'Conține: grâu, ouă, lapte. Poate conține urme de arahide, fistic, '
        'susan.',
  ),
  Product(
    id: 'kurtos-ciocolata',
    categoryId: CategoryIds.kurtos,
    name: 'Kurtos cu fulgi de ciocolată',
    priceBani: 3900,
    image: '${_img}kurtos-ciocolata.webp',
    description:
        'Ingrediente: făină de grâu c/s, zahăr cristal, apă potabilă, '
        'glazură de ciocolată zahăr, uleiuri și grăsimi vegetale total '
        'hidrogenate, pudră de cacao degresată, emulgatori: lecitină de '
        'soia, lecitine din floarea soarelui; sirop de glucoză, aromă: '
        'vanilină, ulei de floarea-soarelui, drojdie proaspătă p/u '
        'panificație, ouă de găină, lapte pasteurizat de vacă cu gr. 3,5%, '
        'aromă: vanilină; ameliorator p/u panificație, sare alimentară. '
        'Conține: grâu, soia, ouă, lapte. Poate conține urme de arahide, '
        'fistic, susan.',
  ),
  Product(
    id: 'kurtos-arahide',
    categoryId: CategoryIds.kurtos,
    name: 'Kurtos cu arahide',
    priceBani: 3900,
    image: '${_img}kurtos-arahide.webp',
    description:
        'Ingrediente: făină de grâu c/s, zahăr cristal, apă potabilă, '
        'arahide, ulei de floarea-soarelui, drojdie proaspătă p/u '
        'panificație, ouă de găină, lapte pasteurizat de vacă, aromă: '
        'vanilină; ameliorator p/u panificație, sare alimentară. Conține: '
        'grâu, arahide, ouă, lapte. Poate conține urme de fistic, susan.',
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
    description:
        'Ingrediente: făină de grâu c/s, zahăr cristal, grăsime cu maia din '
        'grâu, uleiuri vegetale rafinate, apă, emulsifiant, sare iodată, '
        'aromă, antioxidant, conservant, acidifiant, colorant maia de grâu, '
        'apă potabilă, drojdie proaspătă p/u panificație, unt din smântână '
        'dulce, cremă de plombir, fulgi de migdale, pudră decorativ zahăr, '
        'amidon, grăsimi vegetale, sare alimentară, ameliorator. Conține: '
        'grâu, ouă, produs derivat al laptelui. Poate conține urme de '
        'susan, ouă.',
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
    description:
        'Ingrediente: făină de grâu c/s, apă potabilă, grăsime cu maia din '
        'grâu [uleiuri vegetale rafinate (palmier, floarea soarelui), apă, '
        'emulsifiant (lecitină de floarea soarelui, mono- și digliceride '
        'ale acizilor grași), sare iodată, aromă, antioxidant (extract '
        'bogat în tocoferol, palmitat de L-ascorbil), conservant, '
        'acidifiant, colorant, maia de grâu], zahăr cristal, drojdie '
        'proaspătă p/u panificație, unt din smântână dulce, umplutură de '
        'vanilie (apă, zahăr alb cristalin, îngroșător de amidon îngroșat, '
        'zer pudrat demineralizat, grăsimi vegetale deodorizate, rafinate, '
        'sare alimentară, conservant de sorbat de potasiu, ouă de găină, '
        'sare alimentară, fructe de sezon (capșuni, mure, kiwi), mentă. '
        'Conține: grâu, produs derivat al laptelui, ouă, nuci.',
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
    description:
        'Ingrediente: făină de grâu calitate superioară, brânză de vacă, '
        'apă potabilă, ouă, ulei de floarea soarelui, sare alimentară, '
        'semințe de mac, zahăr cristal, regulator de aciditate. Conține: '
        'grâu, ouă, lapte. Poate conține urme de susan.',
  ),
  Product(
    id: 'placinta-varza',
    categoryId: CategoryIds.placinte,
    name: 'Plăcintă cu varză',
    priceBani: 1800,
    image: '${_img}placinta-varza.webp',
    description:
        'Ingrediente: varză, făină de grâu calitate superioară, apă '
        'potabilă, ceapă, ulei de floarea soarelui, sare alimentară, ouă, '
        'semințe de susan, zahăr cristal, piper negru. Conține: grâu, ouă, '
        'susan. Poate conține urme de lapte.',
  ),
  Product(
    id: 'placinta-cartof',
    categoryId: CategoryIds.placinte,
    name: 'Plăcintă cu cartof',
    priceBani: 1800,
    image: '${_img}placinta-cartof.webp',
    description:
        'Ingrediente: cartofi, făină de grâu calitate superioară, apă '
        'potabilă, ulei de floarea soarelui, ceapă, ouă, sare alimentară, '
        'miez de floarea soarelui, zahăr cristal, regulator de aciditate, '
        'piper negru. Conține: grâu, ouă. Poate conține urme de lapte, '
        'susan.',
  ),
  Product(
    id: 'placinta-branza-verdeata',
    categoryId: CategoryIds.placinte,
    name: 'Plăcintă cu brânză și verdeață',
    priceBani: 2200,
    image: '${_img}placinta-branza-verdeata.webp',
    description:
        'Ingrediente: făină de grâu calitate superioară, brânză de vacă, '
        'apă potabilă, ouă, ulei de floarea-soarelui, sare alimentară, '
        'semințe de in, semințe de susan, mărar verde, zahăr cristal, '
        'regulator de aciditate. Conține: grâu, ouă, lapte, susan. Poate '
        'conține urme de susan.',
  ),
  Product(
    id: 'placinta-pui',
    categoryId: CategoryIds.placinte,
    name: 'Plăcintă cu carne de pui',
    priceBani: 2400,
    image: '${_img}placinta-pui.webp',
    description:
        'Ingrediente: carne de pui, făină de grâu calitate superioară, '
        'ceapă, apă potabilă, ulei de floarea-soarelui, ouă, sare '
        'alimentară, semințe de in, zahăr cristal, regulator de aciditate, '
        'piper negru. Conține: grâu, ouă. Poate conține urme de lapte, '
        'susan.',
  ),
  Product(
    id: 'placinta-mere',
    categoryId: CategoryIds.placinte,
    name: 'Plăcintă cu mere',
    priceBani: 1800,
    image: '${_img}placinta-mere.webp',
    description:
        'Ingrediente: mere, făină de grâu calitate superioară, apă '
        'potabilă, ulei de floarea soarelui, zahăr cristal, ouă, zahăr '
        'pudră decorativ, nucă de cocos, sare alimentară, regulator de '
        'aciditate. Conține: grâu, ouă. Poate conține urme de susan.',
  ),
  Product(
    id: 'placinta-visina',
    categoryId: CategoryIds.placinte,
    name: 'Plăcintă cu vișină',
    priceBani: 2500,
    image: '${_img}placinta-visina.webp',
    description:
        'Ingrediente: vișine în suc propriu, făină de grâu c/s, apă '
        'potabilă, ulei de floarea soarelui, zahăr cristal, agent de '
        'îngroșare, ouă de găină, zahăr pudră decorativ, zahăr, amidon, '
        'grăsimi vegetale, sare alimentară, regulator de aciditate. '
        'Conține: grâu, ouă. Poate conține urme de susan. Produsul poate '
        'conține sâmburi de vișină.',
  ),
  Product(
    id: 'panini-muschi-porc',
    categoryId: CategoryIds.placinte,
    name: 'Panini cu mușchi de porc',
    priceBani: 3600,
    image: '${_img}panini-muschi-porc.webp',
    description:
        'Ingrediente: făină de grâu c/s, apă potabilă, maioneză, brânză cu '
        'cheag tare, mușchi de porc fiert-afumat, frunze de salată, roșii '
        'proaspete, castraveți proaspeți, ulei de floarea-soarelui, sare '
        'alimentară, zahăr cristal, maia naturală, usturoi granulat, piper '
        'negru măcinat. Conține: grâu, ouă, produs derivat al laptelui. '
        'Poate conține urme de susan.',
  ),
  Product(
    id: 'crenvursca-aluat',
    categoryId: CategoryIds.placinte,
    name: 'Crenvurșcă în aluat',
    priceBani: 2100,
    image: '${_img}crenvursca-aluat.webp',
    description:
        'Ingrediente: crenvurști, făină de grâu c/s, ouă de găină, lapte '
        'pasteurizat de vacă, ulei de floarea-soarelui, semințe de susan, '
        'zahăr cristal, grăsime cu maia din grâu uleiuri vegetale rafinate, '
        'apă, emulsifiant, sare iodată, aromă, antioxidant, conservant, '
        'acidifiant, colorant, maia de grâu, sare alimentară, drojdie '
        'proaspătă p/u panificație. Conține: grâu, ouă, lapte, susan. Poate '
        'conține urme de susan.',
  ),
  Product(
    id: 'sandwich-pui-crispy',
    categoryId: CategoryIds.placinte,
    name: 'Sandwich cu pui Crispy',
    priceBani: 4000,
    image: '${_img}sandwich-pui-crispy.webp',
    description:
        'Ingrediente: Făină de grâu c/s, apă potabilă, maioneză cu gr. 57% '
        '(ulei rafinat de floarea soarelui deodorizat, apă potabilă, '
        'gălbenuș de ou uscat, oțet de masă, sare alimentară, agenți de '
        'îngroșare: E1422, gumă xantan, gumă guar; arome, regulator de '
        'aciditate: acid lactic; conservant: acid sorbic; colorant: '
        'carotene; îndulcitor: zaharină), unt, zahăr cristal, ulei de '
        'floarea soarelui, drojdie de panificație, maia naturală (maia '
        'deshidratată din grâu dur, drojdie, antioxidant: acid ascorbic; '
        'enzime), usturoi granulat, piper negru măcinat, amestec de '
        'semințe: mac, in, in galben, susan, floarea soarelui. Conține: '
        'grâu, ouă, produs derivat al laptelui, susan. Poate conține urme '
        'de nuci. Poate conține urme de susan.',
  ),
  Product(
    id: 'pizza-piept-pui',
    categoryId: CategoryIds.placinte,
    name: 'Pizza cu piept de pui',
    priceBani: 3500,
    image: '${_img}pizza-piept-pui.webp',
    description:
        'Ingrediente: făină de grâu c/s, ulei de floarea soarelui, brânză '
        'cu cheag tare cu gr. 50%, apă potabilă, piept de pui refrigerat, '
        'sos de roșii, roșii proaspete, gogoșari proaspeți, ulei de '
        'măsline, maia naturală, sare alimentară, zahăr cristal, '
        'condimente: oregano, piper negru. Conține: grâu, produs derivat al '
        'laptelui. Poate conține urme de susan, ouă.',
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
