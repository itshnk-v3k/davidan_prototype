import 'package:davidan_prototype/data/mock/sushi/sushi_categories.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/product.dart';

const _img = 'assets/images/sushi/';

/// The 102 products of davidansushi.md (docs/sources/davidansushi_md.md, and
/// davidansushi_md_menu.json for the same data as JSON), in the site's order:
/// by subcategory, then alphabetically, as its category pages list them.
/// Prices are in bani; weights and pieces are the site's "Masa" and "Bucăți".
///
/// Descriptions join the site's ingredient list into one line under its own
/// label ("Ingrediente" or "Componența setului"). Tempura Ton and Sushi burger
/// Țipar share another product's photo, as they do on the site. Obvious typos
/// are corrected: "cream de brânză", "cremă de brnânză" and "crema de brinza"
/// → "cremă de brânză"; "castrevete" → "castravete"; "castraveti" →
/// "castraveți"; "creveti" → "creveți"; "sos spisy" → "sos spicy"; "parmenzan"
/// → "parmezan"; "sus de soia" → "sos de soia"; "rosii" → "roșii"; "pesmeti"
/// → "pesmeți"; "pirjoală" → "pârjoală"; "champinion" → "champignon";
/// "Avokado Maki" → "Avocado Maki"; "bucăţi" (with a cedilla) → "bucăți"; and
/// the name "Cheescake" → "Cheesecake" (its id keeps the site's slug).
const sushiProducts = <Product>[
  // --- Sushi ---
  Product(
    brand: Brand.sushi,
    id: 'alasca',
    categoryId: SushiCategoryIds.sushi,
    name: 'Alasca',
    priceBani: 17000,
    image: '${_img}alasca.webp',
    weight: '250g',
    description:
        'Ingrediente: nori, orez, cremă de brânză, castravete, somon, tobico',
  ),
  Product(
    brand: Brand.sushi,
    id: 'california-creveti',
    categoryId: SushiCategoryIds.sushi,
    name: 'California Creveți',
    priceBani: 16500,
    image: '${_img}california-creveti.webp',
    weight: '270g',
    description:
        'Ingrediente: nori, orez, cremă de brânză, castraveți, maioneză '
        'japoneză, creveți, tobico',
  ),
  Product(
    brand: Brand.sushi,
    id: 'canada',
    categoryId: SushiCategoryIds.sushi,
    name: 'Canada',
    priceBani: 20000,
    image: '${_img}canada.webp',
    weight: '270g',
    description:
        'Ingrediente: nori, orez, cremă de brânză, castravete, somon, țipar, '
        'sos unaghi, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'canada-creveti',
    categoryId: SushiCategoryIds.sushi,
    name: 'Canada Creveți',
    priceBani: 20000,
    image: '${_img}canada-creveti.webp',
    weight: '270g',
    description:
        'Ingrediente: nori, orez, cremă de brânză, creveți, țipar, tobico, '
        'sos unaghi, castravete, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'chyka-roll',
    categoryId: SushiCategoryIds.sushi,
    name: 'Chyka Roll',
    priceBani: 12000,
    image: '${_img}chyka-roll.webp',
    weight: '300g',
    description:
        'Ingrediente: orez, nori, cremă de brânză, avocado, somon grill, '
        'chyka, susan, sos de nuci',
  ),
  Product(
    brand: Brand.sushi,
    id: 'crunchy-tony',
    categoryId: SushiCategoryIds.sushi,
    name: 'Crunchy Tony',
    priceBani: 14900,
    image: '${_img}crunchy-tony.webp',
    weight: '260g',
    description:
        'Ingrediente: nori, orez, ton, daicon murat, sos Sriracha, Masago '
        'Arare, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'dragon-verde',
    categoryId: SushiCategoryIds.sushi,
    name: 'Dragon Verde',
    priceBani: 14500,
    image: '${_img}dragon-verde.webp',
    weight: '280g',
    description:
        'Ingrediente: nori, orez, cremă de brânză, avocado, castravete, '
        'somon, sos unaghi, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'ebi-roll',
    categoryId: SushiCategoryIds.sushi,
    name: 'Ebi Roll',
    priceBani: 16000,
    image: '${_img}ebi-roll.webp',
    weight: '280g',
    description:
        'Ingrediente: nori, orez, cremă de brânză, castraveți, somon, creveți',
  ),
  Product(
    brand: Brand.sushi,
    id: 'haruto',
    categoryId: SushiCategoryIds.sushi,
    name: 'Haruto',
    priceBani: 20000,
    image: '${_img}haruto.webp',
    weight: '320g',
    description:
        'Ingrediente: nori, orez, cremă de brânză, castraveți, avocado, ton, '
        'somon, țipar, tobico, mango gem',
  ),
  Product(
    brand: Brand.sushi,
    id: 'kyoto',
    categoryId: SushiCategoryIds.sushi,
    name: 'Kyoto',
    priceBani: 18000,
    image: '${_img}kyoto.webp',
    weight: '270g',
    description:
        'Ingrediente: nori, orez, cremă de brânză, castraveți, somon grill, '
        'somon, țipar, sos unaghi, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'oh-my-cheeseus',
    categoryId: SushiCategoryIds.sushi,
    name: 'Oh my cheeseus',
    priceBani: 16900,
    image: '${_img}oh-my-cheeseus.webp',
    weight: '355g',
    description:
        'Ingrediente: nori, orez, cheddar, creveți pane, cremă de brânză, '
        'castraveți, fidea de boabe, sos unaghi, sos Kimchi Maio',
  ),
  Product(
    brand: Brand.sushi,
    id: 'philadelphia-classic',
    categoryId: SushiCategoryIds.sushi,
    name: 'Philadelphia Classic',
    priceBani: 14500,
    image: '${_img}philadelphia-classic.webp',
    weight: '280g',
    description:
        'Ingrediente: nori, orez, cremă de brânză, castravete, avocado, somon',
  ),
  Product(
    brand: Brand.sushi,
    id: 'philadelphia-cu-creveti',
    categoryId: SushiCategoryIds.sushi,
    name: 'Philadelphia cu Creveți',
    priceBani: 17000,
    image: '${_img}philadelphia-cu-creveti.webp',
    weight: '320g',
    description:
        'Ingrediente: orez, nori, cremă de brânză, castraveți, avocado, '
        'somon, creveți, sos unaghi, sos spicy',
  ),
  Product(
    brand: Brand.sushi,
    id: 'philadelphia-ebi',
    categoryId: SushiCategoryIds.sushi,
    name: 'Philadelphia Ebi',
    priceBani: 16000,
    image: '${_img}philadelphia-ebi.webp',
    weight: '280g',
    description:
        'Ingrediente: nori, orez, cremă de brânză, castraveți, creveți pane, '
        'somon',
  ),
  Product(
    brand: Brand.sushi,
    id: 'philadelphia-flambe',
    categoryId: SushiCategoryIds.sushi,
    name: 'Philadelphia Flambe',
    priceBani: 15000,
    image: '${_img}philadelphia-flambe.webp',
    weight: '280g',
    description:
        'Ingrediente: nori, orez, cremă de brânză, avocado, somon, sos spicy',
  ),
  Product(
    brand: Brand.sushi,
    id: 'salmon-bliss',
    categoryId: SushiCategoryIds.sushi,
    name: 'Salmon Bliss',
    priceBani: 16900,
    image: '${_img}salmon-bliss.webp',
    weight: '350g',
    description:
        'Ingrediente: nori, orez, somon copt, ardei california, cremă de '
        'brânză, sos Maio Dulce, sos Sriracha, sos Unaghi, Masago Arare',
  ),
  Product(
    brand: Brand.sushi,
    id: 'salmon-explosion',
    categoryId: SushiCategoryIds.sushi,
    name: 'Salmon Explosion',
    priceBani: 17900,
    image: '${_img}salmon-explosion.webp',
    weight: '285g',
    description:
        'Ingrediente: nori, orez, somon, chuka, sos Kimchi Maio, sos unaghi, '
        'togarashi, tobico',
  ),
  Product(
    brand: Brand.sushi,
    id: 'shrimps-explosion',
    categoryId: SushiCategoryIds.sushi,
    name: 'Shrimps Explosion',
    priceBani: 17900,
    image: '${_img}shrimps-explosion.webp',
    weight: '270g',
    description:
        'Ingrediente: nori, orez, creveți, sos Kimchi Maio, maioneză '
        'japoneză, sos unaghi, togarashi',
  ),
  Product(
    brand: Brand.sushi,
    id: 'spicy-tuna',
    categoryId: SushiCategoryIds.sushi,
    name: 'Spicy Tuna',
    priceBani: 14900,
    image: '${_img}spicy-tuna.webp',
    weight: '320g',
    description:
        'Ingrediente: nori, orez, ton, creveți pane, chuka, maioneză '
        'japoneză, sos Sriracha, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'tuna-roll',
    categoryId: SushiCategoryIds.sushi,
    name: 'Tuna Roll',
    priceBani: 14000,
    image: '${_img}tuna-roll.webp',
    weight: '270g',
    description:
        'Ingrediente: nori, orez, cremă de brânză, castravete, ton, somon, '
        'mango gem',
  ),
  Product(
    brand: Brand.sushi,
    id: 'sushidog',
    categoryId: SushiCategoryIds.sushi,
    name: 'SushiDog',
    priceBani: 14500,
    image: '${_img}sushidog.webp',
    weight: '300g',
    description:
        'Ingrediente: nori, orez, cremă de brânză, castraveți, maioneză '
        'japoneză, tobico, creveți, somon, sos sriracha, sos spicy, sos '
        'unaghi, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'tempura-creveti',
    categoryId: SushiCategoryIds.sushi,
    name: 'Tempura Creveți',
    priceBani: 14000,
    image: '${_img}tempura-creveti.webp',
    weight: '300g',
    description:
        'Ingrediente: nori, orez, cremă de brânză, tobico, castraveți, '
        'creveți, sos unaghi, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'tempura-somon',
    categoryId: SushiCategoryIds.sushi,
    name: 'Tempura Somon',
    priceBani: 14500,
    image: '${_img}tempura-somon.webp',
    weight: '300g',
    description:
        'Ingrediente: nori, orez, cremă de brânză, tobico, castraveți, somon, '
        'sos unaghi, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'tempura-somon-grill',
    categoryId: SushiCategoryIds.sushi,
    name: 'Tempura Somon Grill',
    priceBani: 12000,
    image: '${_img}tempura-somon-grill.webp',
    weight: '300g',
    description:
        'Ingrediente: nori, orez, cremă de brânză, tobico, castraveți, somon '
        'grill, sos unaghi, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'tempura-ton',
    categoryId: SushiCategoryIds.sushi,
    name: 'Tempura Ton',
    priceBani: 14000,
    image: '${_img}tempura-creveti.webp',
    weight: '300g',
    description:
        'Ingrediente: nori, orez, cremă de brânză, tobico, castraveți, ton, '
        'sos unaghi, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'tempura-tipar',
    categoryId: SushiCategoryIds.sushi,
    name: 'Tempura Țipar',
    priceBani: 15500,
    image: '${_img}tempura-tipar.webp',
    weight: '300g',
    description:
        'Ingrediente: nori, orez, cremă de brânză, tobico, castraveți, țipar, '
        'sos unaghi, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'avocado-maki',
    categoryId: SushiCategoryIds.sushi,
    name: 'Avocado Maki',
    priceBani: 5500,
    image: '${_img}avocado-maki.webp',
    weight: '130g',
    description: 'Ingrediente: nori, orez, avocado',
  ),
  Product(
    brand: Brand.sushi,
    id: 'ebi-maki',
    categoryId: SushiCategoryIds.sushi,
    name: 'Ebi Maki',
    priceBani: 7500,
    image: '${_img}ebi-maki.webp',
    weight: '130g',
    description: 'Ingrediente: nori, orez, creveți',
  ),
  Product(
    brand: Brand.sushi,
    id: 'kappa-maki',
    categoryId: SushiCategoryIds.sushi,
    name: 'Kappa Maki',
    priceBani: 5000,
    image: '${_img}kappa-maki.webp',
    weight: '130g',
    description: 'Ingrediente: nori, orez, castravete',
  ),
  Product(
    brand: Brand.sushi,
    id: 'somon-maki',
    categoryId: SushiCategoryIds.sushi,
    name: 'Somon Maki',
    priceBani: 7500,
    image: '${_img}somon-maki.webp',
    weight: '130g',
    description: 'Ingrediente: nori, orez, somon',
  ),
  Product(
    brand: Brand.sushi,
    id: 'ton-maki',
    categoryId: SushiCategoryIds.sushi,
    name: 'Ton Maki',
    priceBani: 7000,
    image: '${_img}ton-maki.webp',
    weight: '130g',
    description: 'Ingrediente: nori, orez, ton',
  ),
  Product(
    brand: Brand.sushi,
    id: 'unaghi-maki',
    categoryId: SushiCategoryIds.sushi,
    name: 'Unaghi Maki',
    priceBani: 9000,
    image: '${_img}unaghi-maki.webp',
    weight: '130g',
    description: 'Ingrediente: nori, orez, țipar, sos unaghi, susan',
  ),
  // --- Seturi ---
  Product(
    brand: Brand.sushi,
    id: 'davidan-set',
    categoryId: SushiCategoryIds.seturi,
    name: 'Davidan Set',
    priceBani: 90000,
    image: '${_img}davidan-set.webp',
    pieces: '48 buc',
    weight: '1900g',
    description:
        'Componența setului: Haruto – 8 bucăți, Philadelphia Classic – 8 '
        'bucăți, California Creveți – 8 bucăți, Chyka Roll – 8 bucăți, Salmon '
        'Bliss – 8 bucăți, Oh my cheeseus – 8 bucăți',
  ),
  Product(
    brand: Brand.sushi,
    id: 'gunkan-set',
    categoryId: SushiCategoryIds.seturi,
    name: 'Gunkan Set',
    priceBani: 23500,
    image: '${_img}gunkan-set.webp',
    pieces: '4 buc',
    weight: '280g',
    description:
        'Componența setului: orez, nori, tobico, maioneză japoneză, creveți, '
        'ton, somon, țipar, sos unaghi, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'love-story-set',
    categoryId: SushiCategoryIds.seturi,
    name: 'Love Story Set',
    priceBani: 46000,
    image: '${_img}love-story-set.webp',
    pieces: '32 buc',
    weight: '950g',
    description:
        'Componența setului: Dragon Verde 8 bucăți, Philadelphia Flambe 8 '
        'bucăți, California Creveți – 8 bucăți, Kappa Maki 4 bucăți, Avocado '
        'Maki 4 bucăți',
  ),
  Product(
    brand: Brand.sushi,
    id: 'maki-set',
    categoryId: SushiCategoryIds.seturi,
    name: 'Maki Set',
    priceBani: 18500,
    image: '${_img}maki-set.webp',
    pieces: '24 buc',
    weight: '390g',
    description:
        'Componența setului: Somon Maki 4 bucăți, Ton Maki 4 bucăți, Ebi Maki '
        '4 bucăți, Unaghi Maki 4 bucăți, Kappa Maki 4 bucăți, Avocado Maki 4 '
        'bucăți',
  ),
  Product(
    brand: Brand.sushi,
    id: 'nigiri-set',
    categoryId: SushiCategoryIds.seturi,
    name: 'Nigiri Set',
    priceBani: 12500,
    image: '${_img}nigiri-set.webp',
    pieces: '4 buc',
    weight: '230g',
    description:
        'Componența setului: Nigiri somon, Nigiri ton, Nigiri creveți, Nigiri '
        'țipar',
  ),
  Product(
    brand: Brand.sushi,
    id: 'phila-ebi-set',
    categoryId: SushiCategoryIds.seturi,
    name: 'Phila-Ebi Set',
    priceBani: 40000,
    image: '${_img}phila-ebi-set.webp',
    pieces: '24 buc',
    weight: '850g',
    description:
        'Componența setului: Philadelphia Classic 8 bucăți, Ebi Roll 8 '
        'bucăți, Tempura cu somon grill 8 bucăți',
  ),
  Product(
    brand: Brand.sushi,
    id: 'philadelphia-set',
    categoryId: SushiCategoryIds.seturi,
    name: 'Philadelphia Set',
    priceBani: 52500,
    image: '${_img}philadelphia-set.webp',
    pieces: '32 buc',
    weight: '1200g',
    description:
        'Componența setului: Tempura Somon Grill – 8 bucăți, Tempura Somon – '
        '8 bucăți, Philadelphia cu Creveți – 8 bucăți, Philadelphia Classic – '
        '8 bucăți',
  ),
  Product(
    brand: Brand.sushi,
    id: 'sacura-set',
    categoryId: SushiCategoryIds.seturi,
    name: 'Sacura Set',
    priceBani: 44000,
    image: '${_img}sacura-set.webp',
    pieces: '24 buc',
    weight: '850g',
    description:
        'Componența setului: Dragon Verde 8 bucăți, Tuna Roll 8 bucăți, '
        'Canada 8 bucăți',
  ),
  Product(
    brand: Brand.sushi,
    id: 'tempura-set',
    categoryId: SushiCategoryIds.seturi,
    name: 'Tempura Set',
    priceBani: 36000,
    image: '${_img}tempura-set.webp',
    pieces: '24 buc',
    weight: '900g',
    description:
        'Componența setului: Tempura Somon 8 bucăți, Tempura Ton 8 bucăți, '
        'Tempura Creveți 8 bucăți',
  ),
  // --- Bucate Thai ---
  Product(
    brand: Brand.sushi,
    id: 'orez-cu-fructe-de-mare',
    categoryId: SushiCategoryIds.bucateThai,
    name: 'Orez cu fructe de mare',
    priceBani: 11500,
    image: '${_img}orez-cu-fructe-de-mare.webp',
    weight: '350g',
    description:
        'Ingrediente: orez, midii, calmari, creveți, somon, morcov, păstăi, '
        'ardei, sos sriracha, sos de soia, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'orez-cu-pui',
    categoryId: SushiCategoryIds.bucateThai,
    name: 'Orez cu pui',
    priceBani: 8500,
    image: '${_img}orez-cu-pui.webp',
    weight: '350g',
    description:
        'Ingrediente: orez, carne de pui, morcov, păstăi, ardei, sos '
        'sriracha, sos de soia, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'orez-cu-vita',
    categoryId: SushiCategoryIds.bucateThai,
    name: 'Orez cu vită',
    priceBani: 11000,
    image: '${_img}orez-cu-vita.webp',
    weight: '350g',
    description:
        'Ingrediente: orez, carne de vită, morcov, păstăi, ardei, sos '
        'sriracha, sos de soia, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'soba-cu-fructe-de-mare',
    categoryId: SushiCategoryIds.bucateThai,
    name: 'Soba cu fructe de mare',
    priceBani: 13000,
    image: '${_img}soba-cu-fructe-de-mare.webp',
    weight: '320g',
    description:
        'Ingrediente: fidea de hrișcă, creveți, somon, midii, calmari, '
        'ciuperci shitake, morcov, ardei, tulpină de țelină, susan, sos '
        'lunch-king, sos sriracha',
  ),
  Product(
    brand: Brand.sushi,
    id: 'soba-cu-pui',
    categoryId: SushiCategoryIds.bucateThai,
    name: 'Soba cu pui',
    priceBani: 10000,
    image: '${_img}soba-cu-pui.webp',
    weight: '350g',
    description:
        'Ingrediente: fidea de hrișcă, carne de pui, ciuperci shitake, '
        'morcov, ardei, tulpină de țelină, susan, sos lunch-king, sos sriracha',
  ),
  Product(
    brand: Brand.sushi,
    id: 'soba-cu-vita',
    categoryId: SushiCategoryIds.bucateThai,
    name: 'Soba cu vită',
    priceBani: 11000,
    image: '${_img}soba-cu-vita.webp',
    weight: '350g',
    description:
        'Ingrediente: fidea de hrișcă, carne de vită, ciuperci shitake, '
        'morcov, ardei, tulpină de țelină, susan, sos lunch-king, sos sriracha',
  ),
  Product(
    brand: Brand.sushi,
    id: 'udon-cu-carne-de-vita',
    categoryId: SushiCategoryIds.bucateThai,
    name: 'Udon cu carne de vită',
    priceBani: 11000,
    image: '${_img}udon-cu-carne-de-vita.webp',
    weight: '350g',
    description:
        'Ingrediente: fidea de grâu, carne de vită, ciuperci, morcov, ardei, '
        'păstăi, susan, sos sriracha, sos lunch-king',
  ),
  Product(
    brand: Brand.sushi,
    id: 'udon-cu-fructe-de-mare',
    categoryId: SushiCategoryIds.bucateThai,
    name: 'Udon cu fructe de mare',
    priceBani: 13000,
    image: '${_img}udon-cu-fructe-de-mare.webp',
    weight: '350g',
    description:
        'Ingrediente: fidea de grâu, creveți, somon, midii, calmari, '
        'ciuperci, morcov, ardei, păstăi, susan, sos sriracha, sos lunch-king',
  ),
  Product(
    brand: Brand.sushi,
    id: 'udon-cu-pui',
    categoryId: SushiCategoryIds.bucateThai,
    name: 'Udon cu pui',
    priceBani: 10000,
    image: '${_img}udon-cu-pui.webp',
    weight: '350g',
    description:
        'Ingrediente: fidea de grâu, carne de pui, ciuperci, morcov, ardei, '
        'păstăi, susan, sos sriracha, sos lunch-king',
  ),
  Product(
    brand: Brand.sushi,
    id: 'udon-cu-spanac-si-creveti',
    categoryId: SushiCategoryIds.bucateThai,
    name: 'Udon cu spanac și creveți',
    priceBani: 12000,
    image: '${_img}udon-cu-spanac-si-creveti.webp',
    weight: '350g',
    description:
        'Ingrediente: fidea de grâu, spanac, creveți, parmezan, frișcă, '
        'ceapă, usturoi, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'funcioza-cu-fructe-de-mare',
    categoryId: SushiCategoryIds.bucateThai,
    name: 'Funcioza cu fructe de mare',
    priceBani: 13500,
    image: '${_img}funcioza-cu-fructe-de-mare.webp',
    weight: '300g',
    description:
        'Ingrediente: fidea de boabe, fructe de mare, morcov, tulpină de '
        'țelină, sos sriracha, sos lunch-king, ardei, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'funcioza-cu-pui',
    categoryId: SushiCategoryIds.bucateThai,
    name: 'Funcioza cu pui',
    priceBani: 10000,
    image: '${_img}funcioza-cu-pui.webp',
    weight: '320g',
    description:
        'Ingrediente: fidea de boabe, carne de pui, morcov, tulpină de '
        'țelină, sos sriracha, sos lunch-king, ardei, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'funcioza-cu-vita',
    categoryId: SushiCategoryIds.bucateThai,
    name: 'Funcioza cu vită',
    priceBani: 11500,
    image: '${_img}funcioza-cu-vita.webp',
    weight: '300g',
    description:
        'Ingrediente: fidea de boabe, carne de vită, morcov, tulpină de '
        'țelină, sos sriracha, sos lunch-king, ardei, susan',
  ),
  // --- Supe ---
  Product(
    brand: Brand.sushi,
    id: 'ramen-cu-pui',
    categoryId: SushiCategoryIds.supe,
    name: 'Ramen cu pui',
    priceBani: 7500,
    image: '${_img}ramen-cu-pui.webp',
    weight: '400ml',
    description:
        'Ingrediente: bulion de găină, ouă, fidea de grâu, fileu de pui pane, '
        'ceapă verde, ardei iute, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'supa-crema-cu-spanac',
    categoryId: SushiCategoryIds.supe,
    name: 'Supă cremă cu spanac',
    priceBani: 7000,
    image: '${_img}supa-crema-cu-spanac.webp',
    weight: '300ml',
    description:
        'Ingrediente: frișcă, spanac, parmezan, ceapă, usturoi, susan, pesmeți',
  ),
  Product(
    brand: Brand.sushi,
    id: 'supa-crema-cu-spanac-si-creveti',
    categoryId: SushiCategoryIds.supe,
    name: 'Supă cremă cu spanac și creveți',
    priceBani: 10000,
    image: '${_img}supa-crema-cu-spanac-si-creveti.webp',
    weight: '350ml, 50g',
    description:
        'Ingrediente: frișcă, spanac, creveți, parmezan, ceapă, usturoi, '
        'susan, pesmeți',
  ),
  Product(
    brand: Brand.sushi,
    id: 'tom-yam-cu-fructe-de-mare',
    categoryId: SushiCategoryIds.supe,
    name: 'Tom Yam cu fructe de mare',
    priceBani: 13000,
    image: '${_img}tom-yam-cu-fructe-de-mare.webp',
    weight: '400ml',
    description:
        'Ingrediente: lapte de cocos, sos Tom Yam, bulion din creveți, '
        'creveți, calmari, somon, midii, ciuperci champignon, orez',
  ),
  Product(
    brand: Brand.sushi,
    id: 'tom-yam-cu-pui',
    categoryId: SushiCategoryIds.supe,
    name: 'Tom Yam cu pui',
    priceBani: 9000,
    image: '${_img}tom-yam-cu-pui.webp',
    weight: '400ml',
    description:
        'Ingrediente: lapte de cocos, sos Tom Yam, bulion din creveți, carne '
        'de pui, ciuperci champignon, orez',
  ),
  // --- Salate ---
  Product(
    brand: Brand.sushi,
    id: 'chuka',
    categoryId: SushiCategoryIds.salate,
    name: 'Chuka',
    priceBani: 7500,
    image: '${_img}chuka.webp',
    weight: '200g, 30g',
    description:
        'Ingrediente: frunză de salată, alge chuka, susan, lămâie, sos de nuci',
  ),
  Product(
    brand: Brand.sushi,
    id: 'mixt-salata-cu-pui',
    categoryId: SushiCategoryIds.salate,
    name: 'Mix salată cu pui',
    priceBani: 8500,
    image: '${_img}mixt-salata-cu-pui.webp',
    weight: '250g',
    description:
        'Ingrediente: mix salată, carne de pui panată, avocado, ciuperci '
        'champignon, roșii cherry, ulei de măsline, nuci caju, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'salata-caesar-cu-creveti',
    categoryId: SushiCategoryIds.salate,
    name: 'Salată Caesar cu Creveți',
    priceBani: 12000,
    image: '${_img}salata-caesar-cu-creveti.webp',
    weight: '320g',
    description:
        'Ingrediente: Mix salată, roșii cherry, pesmeți, creveți, sos caesar, '
        'parmesan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'salata-caesar-cu-pui',
    categoryId: SushiCategoryIds.salate,
    name: 'Salată Caesar cu Pui',
    priceBani: 10000,
    image: '${_img}salata-caesar-cu-pui.webp',
    weight: '320g',
    description:
        'Ingrediente: Mix salată, roșii cherry, pesmeți, carne de pui grill, '
        'sos caesar, parmesan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'salata-cu-creveti',
    categoryId: SushiCategoryIds.salate,
    name: 'Salată cu creveți',
    priceBani: 12900,
    image: '${_img}salata-cu-creveti.webp',
    weight: '280g',
    description:
        'Ingrediente: mix de salată, quinoa, creveți, avocado, roșii cherry, '
        'mango, dressing pentru salată, sos Unaghi',
  ),
  Product(
    brand: Brand.sushi,
    id: 'salata-cu-somon',
    categoryId: SushiCategoryIds.salate,
    name: 'Salată cu somon',
    priceBani: 12900,
    image: '${_img}salata-cu-somon.webp',
    weight: '225g',
    description:
        'Ingrediente: mix de salată, somon slab sărat, mozzarella, roșii '
        'cherry, castraveți, nuci caju, dressing pentru salată',
  ),
  // --- Poke bowl ---
  Product(
    brand: Brand.sushi,
    id: 'poke-bowl-creveti',
    categoryId: SushiCategoryIds.pokeBowl,
    name: 'Poke bowl creveți',
    priceBani: 15500,
    image: '${_img}poke-bowl-creveti.webp',
    weight: '450g',
    description:
        'Ingrediente: orez, creveți, mango, boabe edamame, avocado, nori, '
        'ghimbir marinat, alge wakame, castravete, cremă de brânză, sos poke, '
        'sos soia, nuci caju, sos unaghi, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'poke-bowl-somon',
    categoryId: SushiCategoryIds.pokeBowl,
    name: 'Poke bowl somon',
    priceBani: 16500,
    image: '${_img}poke-bowl-somon.webp',
    weight: '450g',
    description:
        'Ingrediente: orez, somon, mango, boabe edamame, avocado, nori, '
        'ghimbir marinat, alge wakame, castravete, cremă de brânză, sos poke, '
        'sos soia, nuci caju, sos unaghi, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'poke-bowl-ton',
    categoryId: SushiCategoryIds.pokeBowl,
    name: 'Poke bowl ton',
    priceBani: 15500,
    image: '${_img}poke-bowl-ton.webp',
    weight: '450g',
    description:
        'Ingrediente: orez, ton, mango, boabe edamame, avocado, nori, ghimbir '
        'marinat, alge wakame, castravete, cremă de brânză, sos poke, sos '
        'soia, nuci caju, sos unaghi, susan',
  ),
  // --- Gustări ---
  Product(
    brand: Brand.sushi,
    id: 'aripioare-crocante',
    categoryId: SushiCategoryIds.gustari,
    name: 'Aripioare Crocante',
    priceBani: 7500,
    image: '${_img}aripioare-crocante.webp',
    weight: '250g, 50g',
    description:
        'Ingrediente: aripioare de pui, pesmeți panco, sos Sweet-Chilli',
  ),
  Product(
    brand: Brand.sushi,
    id: 'bao-burger',
    categoryId: SushiCategoryIds.gustari,
    name: 'Bao Burger',
    priceBani: 8500,
    image: '${_img}bao-burger.webp',
    weight: '400g, 50g',
    description:
        'Ingrediente: chiflă bao, pârjoală de pui, roșii, castraveți, frunză '
        'de salată, sos sweet-chilli, sos tartar, cartofi pai',
  ),
  Product(
    brand: Brand.sushi,
    id: 'bao-cu-creveti',
    categoryId: SushiCategoryIds.gustari,
    name: 'Bao cu creveți',
    priceBani: 7000,
    image: '${_img}bao-cu-creveti.webp',
    weight: '220g',
    description:
        'Ingrediente: Chifle Bao, creveți panați, mix de salată, sos Unaghi, '
        'susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'bao-cu-pui',
    categoryId: SushiCategoryIds.gustari,
    name: 'Bao cu pui',
    priceBani: 6000,
    image: '${_img}bao-cu-pui.webp',
    weight: '250g',
    description:
        'Ingrediente: Chifle Bao, carne de pui, frișcă, mix de salată, sos de '
        'nuci, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'burger-cu-pui',
    categoryId: SushiCategoryIds.gustari,
    name: 'Burger cu pui',
    priceBani: 10500,
    image: '${_img}burger-cu-pui.webp',
    weight: '100g, 400g, 50g',
    description:
        'Ingrediente: chiflă burger, pârjoală de pui, sos tartar, roșii, '
        'rucola, cașcaval cheddar, castraveți marinați, ceapă marinată, '
        'cartofi pai, sos Ketchup',
  ),
  Product(
    brand: Brand.sushi,
    id: 'burger-cu-vita',
    categoryId: SushiCategoryIds.gustari,
    name: 'Burger cu vită',
    priceBani: 13500,
    image: '${_img}burger-cu-vita.webp',
    weight: '100g, 400g, 50g',
    description:
        'Ingrediente: chiflă burger, ceapă caramelizată, pârjoală de vită, '
        'cașcaval dorblu, castraveți marinați, frunză de salată, roșii, '
        'bacon, rucola, cartofi pai, sos Ketchup',
  ),
  Product(
    brand: Brand.sushi,
    id: 'cartofi-pai',
    categoryId: SushiCategoryIds.gustari,
    name: 'Cartofi pai',
    priceBani: 3500,
    image: '${_img}cartofi-pai.webp',
    weight: '150g, 50g',
    description: 'Ingrediente: cartofi pai, sos ketchup',
  ),
  Product(
    brand: Brand.sushi,
    id: 'fileu-de-pui-crispy',
    categoryId: SushiCategoryIds.gustari,
    name: 'Fileu de pui Crispy',
    priceBani: 7500,
    image: '${_img}fileu-de-pui-crispy.webp',
    weight: '150g, 50g',
    description: 'Ingrediente: fileu de pui panat, sos picant',
  ),
  Product(
    brand: Brand.sushi,
    id: 'inele-de-calmar',
    categoryId: SushiCategoryIds.gustari,
    name: 'Inele de calmar',
    priceBani: 7500,
    image: '${_img}inele-de-calmar.webp',
    weight: '150g, 50g',
    description: 'Ingrediente: calmari panați, sos sweet-chilli',
  ),
  Product(
    brand: Brand.sushi,
    id: 'mozzarella-pane',
    categoryId: SushiCategoryIds.gustari,
    name: 'Mozzarella pane',
    priceBani: 5000,
    image: '${_img}mozzarella-pane.webp',
    weight: '150g, 50g',
    description: 'Ingrediente: mozzarella panată, sos sweet-chilli',
  ),
  Product(
    brand: Brand.sushi,
    id: 'nughete',
    categoryId: SushiCategoryIds.gustari,
    name: 'Nughete',
    priceBani: 7500,
    image: '${_img}nughete.webp',
    weight: '150g, 50g',
    description: 'Ingrediente: nughete din carne de pui, sos TarTar',
  ),
  Product(
    brand: Brand.sushi,
    id: 'popcorn-creveti',
    categoryId: SushiCategoryIds.gustari,
    name: 'Popcorn Creveți',
    priceBani: 7500,
    image: '${_img}popcorn-creveti.webp',
    weight: '150g, 50g',
    description: 'Ingrediente: creveți panați, sos wasabi dulce',
  ),
  Product(
    brand: Brand.sushi,
    id: 'spring-roll-cu-pui',
    categoryId: SushiCategoryIds.gustari,
    name: 'Spring roll cu pui',
    priceBani: 7500,
    image: '${_img}spring-roll-cu-pui.webp',
    weight: '200g, 50g',
    description:
        'Ingrediente: foi de orez, carne de pui, morcov, ardei, ciuperci, '
        'mozzarella, maioneză japoneză, susan, sos de soia',
  ),
  Product(
    brand: Brand.sushi,
    id: 'sushi-burger-creveti',
    categoryId: SushiCategoryIds.gustari,
    name: 'Sushi Burger Creveți',
    priceBani: 14900,
    image: '${_img}sushi-burger-creveti.webp',
    weight: '400g',
    description:
        'Ingrediente: nori, orez, castraveți, tobico, creveți, cremă de '
        'brânză, sos unaghi, sos spicy, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'sushi-burger',
    categoryId: SushiCategoryIds.gustari,
    name: 'Sushi Burger Somon',
    priceBani: 14900,
    image: '${_img}sushi-burger.webp',
    weight: '400g',
    description:
        'Ingrediente: nori, orez, castraveți, tobico, cremă de brânză, sos '
        'unaghi, sos spicy, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'sushi-burger-somon-grill',
    categoryId: SushiCategoryIds.gustari,
    name: 'Sushi Burger Somon Grill',
    priceBani: 14500,
    image: '${_img}sushi-burger-somon-grill.webp',
    weight: '400g',
    description:
        'Ingrediente: nori, orez, castraveți, tobico, somon grill, cremă de '
        'brânză, sos unaghi, sos spicy, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'sushi-burger-ton',
    categoryId: SushiCategoryIds.gustari,
    name: 'Sushi Burger Ton',
    priceBani: 14900,
    image: '${_img}sushi-burger-ton.webp',
    weight: '400g',
    description:
        'Ingrediente: nori, orez, castraveți, tobico, ton, cremă de brânză, '
        'sos unaghi, sos spicy, susan',
  ),
  Product(
    brand: Brand.sushi,
    id: 'sushi-burger-tipar',
    categoryId: SushiCategoryIds.gustari,
    name: 'Sushi burger Țipar',
    priceBani: 19000,
    image: '${_img}sushi-burger-somon-grill.webp',
    weight: '400g',
    description:
        'Ingrediente: nori, orez, castraveți, tobico, țipar, cremă de brânză, '
        'sos unaghi, sos spicy, susan',
  ),
  // --- Deserturi ---
  Product(
    brand: Brand.sushi,
    id: 'cheescake',
    categoryId: SushiCategoryIds.deserturi,
    name: 'Cheesecake',
    priceBani: 7000,
    image: '${_img}cheescake.webp',
    weight: '150g, 50g',
    description:
        'Ingrediente: cremă de brânză, frișcă, unt, ouă, biscuiți, dulceață',
  ),
  Product(
    brand: Brand.sushi,
    id: 'cherry-roll',
    categoryId: SushiCategoryIds.deserturi,
    name: 'Cherry roll',
    priceBani: 8500,
    image: '${_img}cherry-roll.webp',
    weight: '200g',
    description:
        'Ingrediente: foaie de orez, cremă de brânză, kiwi, banană, vișină, '
        'topping de ciocolată',
  ),
  Product(
    brand: Brand.sushi,
    id: 'choco-roll',
    categoryId: SushiCategoryIds.deserturi,
    name: 'Choco roll',
    priceBani: 8500,
    image: '${_img}choco-roll.webp',
    weight: '200g',
    description:
        'Ingrediente: foaie de orez, cremă de brânză, nutella, kiwi, banană, '
        'ananas, topping de caramelă',
  ),
  Product(
    brand: Brand.sushi,
    id: 'minari-roll',
    categoryId: SushiCategoryIds.deserturi,
    name: 'Minari roll',
    priceBani: 8500,
    image: '${_img}minari-roll.webp',
    weight: '200g',
    description:
        'Ingrediente: foaie de orez, cremă de brânză, kiwi, banană, ananas, '
        'topping de ciocolată',
  ),
  Product(
    brand: Brand.sushi,
    id: 'motti',
    categoryId: SushiCategoryIds.deserturi,
    name: 'Motti',
    priceBani: 3000,
    image: '${_img}motti.webp',
    weight: '40g',
  ),
  // --- Băuturi ---
  Product(
    brand: Brand.sushi,
    id: 'coca-cola-250ml',
    categoryId: SushiCategoryIds.bauturi,
    name: 'Coca Cola 250ml',
    priceBani: 2300,
    image: '${_img}coca-cola-250ml.webp',
  ),
  Product(
    brand: Brand.sushi,
    id: 'coca-cola-500ml',
    categoryId: SushiCategoryIds.bauturi,
    name: 'Coca Cola 500ml',
    priceBani: 2500,
    image: '${_img}coca-cola-500ml.webp',
  ),
  Product(
    brand: Brand.sushi,
    id: 'fanta-250ml',
    categoryId: SushiCategoryIds.bauturi,
    name: 'Fanta 250ml',
    priceBani: 2300,
    image: '${_img}fanta-250ml.webp',
  ),
  Product(
    brand: Brand.sushi,
    id: 'fanta-500ml',
    categoryId: SushiCategoryIds.bauturi,
    name: 'Fanta 500ml',
    priceBani: 2500,
    image: '${_img}fanta-500ml.webp',
  ),
  Product(
    brand: Brand.sushi,
    id: 'schweppes-mohito',
    categoryId: SushiCategoryIds.bauturi,
    name: 'Schweppes Mohito',
    priceBani: 2800,
    image: '${_img}schweppes-mohito.webp',
    weight: '330ml',
  ),
  Product(
    brand: Brand.sushi,
    id: 'schweppes-pomegranate',
    categoryId: SushiCategoryIds.bauturi,
    name: 'Schweppes Pomegranate',
    priceBani: 2800,
    image: '${_img}schweppes-pomegranate.webp',
    weight: '330ml',
  ),
  Product(
    brand: Brand.sushi,
    id: 'sprite-250ml',
    categoryId: SushiCategoryIds.bauturi,
    name: 'Sprite 250ml',
    priceBani: 2300,
    image: '${_img}sprite-250ml.webp',
  ),
  Product(
    brand: Brand.sushi,
    id: 'sprite-500ml',
    categoryId: SushiCategoryIds.bauturi,
    name: 'Sprite 500ml',
    priceBani: 2500,
    image: '${_img}sprite-500ml.webp',
  ),
  Product(
    brand: Brand.sushi,
    id: 'vinaria-din-vale-feteasca-alba',
    categoryId: SushiCategoryIds.bauturi,
    name: 'Vinăria din vale – Feteasca Albă',
    priceBani: 22500,
    image: '${_img}vinaria-din-vale-feteasca-alba.webp',
  ),
  Product(
    brand: Brand.sushi,
    id: 'vinaria-din-vale-feteasca-neagra',
    categoryId: SushiCategoryIds.bauturi,
    name: 'Vinăria din vale – Feteasca Neagră',
    priceBani: 22500,
    image: '${_img}vinaria-din-vale-feteasca-neagra.webp',
  ),
  Product(
    brand: Brand.sushi,
    id: 'vinaria-din-vale-rose',
    categoryId: SushiCategoryIds.bauturi,
    name: 'Vinăria din vale – Rose',
    priceBani: 22500,
    image: '${_img}vinaria-din-vale-rose.webp',
  ),
];

/// Home's first row, and this brand's share of the hub's "pentru tine": the
/// first product of each section of the site's menu bar, in its order.
const sushiPopularProductIds = <String>[
  'alasca',
  'davidan-set',
  'orez-cu-fructe-de-mare',
  'ramen-cu-pui',
  'chuka',
  'poke-bowl-creveti',
  'aripioare-crocante',
  'cheescake',
];
