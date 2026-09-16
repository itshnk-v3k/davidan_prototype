# davidan.md — source data capture

Captured 2026-09-16 (~14:54–15:02 EEST) with raw `curl -sL`, not WebFetch. Everything in blockquotes and tables is copied from the site programmatically: HTML tags are stripped and runs of whitespace/nbsp collapsed, but wording, spelling, typos and diacritics are left as they are (including the site's own typos). Raw downloads are in `research/raw/`.

**Locale warning:** the root URLs (`https://davidan.md/...`, Shopify locale `en`) carry the original Romanian text. The `/ro/...` mirror is a machine-translated copy with degraded wording (e.g. product "Red Bull" becomes "Taur rosu", "Contact" becomes "a lua legatura"). **Use the root URLs as the source of truth.** Section 5 has the details.

Store identity from `https://davidan.md/meta.json`:

> {"id":58027770028,"name":"DaviDan Bakery","city":"Chișinău","province":"Alba","country":"RO","currency":"MDL","domain":"davidan.md","url":"https:\/\/davidan.md","myshopify_domain":"ladanutmd.myshopify.com","description":"","ships_to_countries":["MD"],"money_format":"{{amount}} MDL","published_collections_count":4,"published_products_count":62,"shopify_pay_enabled_card_brands":[],"offers_shop_pay_installments":false}

---

## 1. Category (collection) structure

Sources: https://davidan.md/collections.json , https://davidan.md/collections/<handle>/products.json?limit=250 , https://davidan.md/products.json?limit=250&page=1..3 (pages 2 and 3 are empty), https://davidan.md/sitemap_collections_1.xml , https://davidan.md/collections

There are exactly **4 published collections**, and the sitemap lists the same 4. `products.json` returns **62 products**, and every one of them belongs to exactly one of the 4 collections, so there are no orphans. `product_type` is empty (`""`) on all 62 products, and **no product has any tags**. Vendors: `DaviDan` (37), `La Dănuț` (23), `La Danuț` (2, without the breve).

| Collection title | Handle | `products_count` in collections.json | Products actually returned by the collection feed | Description |
|---|---|---|---|---|
| Băuturi | `meniu-bauturi` | 28 | 25 | *(empty string on site)* |
| Cofetărie | `meniu-dulciuri` | 33 | 11 | *(empty string on site)* |
| Kurtos | `meniu-kurtos` | 8 | 7 | *(empty string on site)* |
| Patiserie | `meniu-placinte-panini` | 21 | 19 | *(empty string on site)* |

Note: `products_count` in collections.json is higher than the number of products the public feed and pages return (28 vs 25, 33 vs 11, 8 vs 7, 21 vs 19). The extra items are not public anywhere I could reach: not in `products.json`, the collection feeds, the sitemap or the collection HTML pages. They are most likely unpublished or hidden products, so their names and prices are NOT FOUND.

Order and labels on https://davidan.md/collections (verbatim): "Băuturi", "Cofetărie", "Kurtos", "Patiserie", each with a "Vezi mai mult" link.

Main nav menu (header, verbatim labels → href): "Acasă" → `/`, "Patiserie" → `/collections`, "Despre Noi" → `/pages/despre-noi`, "Carieră" → `/pages/vino-in-echipa`, "Locații" → `/pages/locatii`, "Contact" → `/pages/contact`. There is **no** Restaurant, Sushi or Water item in the nav.

Homepage services block (verbatim). All three "links" point to `/collections`:

> Specializați în Coacerea și Comercializarea Kurtosului  
> Meniu Kurtos — Descoperiți selecția noastră variată de kurtosuri, coapte perfect și aromate, gata să răsfețe papilele gustative.  
> Meniu Plăcinte & Panini — Savurați plăcintele noastre proaspete și panini-urile delicioase, preparate cu ingrediente de calitate și multă pasiune.  
> Meniu Dulciuri — Încântați-vă cu gama noastră de dulciuri fine, fiecare fiind o explozie de arome și texturi de neuitat.  
> CATALOG produse

(The " — " separators are mine. On the site each title and description are separate elements.)

### Full product tables per collection

Prices are the Shopify variant prices in MDL. The site renders them as e.g. "19.00 MDL". `compare_at_price` is null for every product (no discounts), and every variant is `available: true`. Where a product has variants, the option name and each variant are listed exactly as on the site. Description paragraphs are separated with `<br>`. Bold formatting was stripped.

#### Kurtos (`meniu-kurtos`), 7 products — https://davidan.md/collections/meniu-kurtos

| # | Name (title) | Price | Handle | Vendor | Description (verbatim, one line per paragraph) | Image URL(s) |
|---|---|---|---|---|---|---|
| 1 | Kurtos  cu fulgi de cocos | 36.00 MDL | `kurtos-cu-cocos` | DaviDan | Ingrediente:<br>făină de grâu c/s, zahăr cristal, apă potabilă, ulei de floarea-soarelui, fulgi de cocos, drojdie proaspătă p/u panificație, ouă de găină, lapte pasteurizat de vacă cu gr. 3,5%, aromă: vanilină; ameliorator p/u panificație, sare alimentară. Conține: grâu, ouă, lapte.<br>Poate conține urme de arahide, fistic, susan.<br>Declaratia nutritionala 100gr:<br>Valoarea energetica 1259 kcal.<br>Proteine 6.2 g, Grasimi 6.1 g din care acizi grasi saturati 4.8 g, Glucide 55.4 g din care zaharuri 19.4 g, Fibre 2.3 g, Sare 0.26g<br>Termen de valabilitate 12 ore<br>Masa neto:250 g | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/Kurtos_cu_cocos_-_36_Lei.jpg?v=1763646089 |
| 2 | Kurtos cu fulgi de ciocolată | 39.00 MDL | `kurtos-cu-ciocolata` | DaviDan | Ingrediente:<br>făină de grâu c/s, zahăr cristal, apă potabilă, glazură de ciocolată zahăr, uleiuri și grasimi vegetale total hidrogenate, pudră de cacao degresată, emulgatori: lecitină de soia, lecitine din floarea soarelui; sirop de glucoză, aromă: vanilină, ulei de floarea-soarelui, drojdie proaspătă p/u panificație, ouă de găină, lapte pasteurizat de vacă cu gr. 3,5%, aromă: vanilină; ameliorator p/u panificație sare alimentară. Conține: grâu, soia, ouă, lapte.<br>Poate conține urme de arahide, fistic, susan.<br>Declaratia nutritionala 100gr:<br>Valoarea energetica 1350.2 kcal.<br>Proteine 6 g, Grasimi 8.4 g din care acizi grasi saturati 7.2 g, Glucide 55.2 g din care zaharuri 22.3 , Fibre 1.8 g, Sare 0.24g<br>Termen de valabilitate 12 ore<br>Masa neto:250 g | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/Kurtos_cu_ciocolata_-_39_Lei.jpg?v=1763646169 |
| 3 | Kurtos cu zahăr și scorțișoară | 36.00 MDL | `kurtos-cu-scorțișoara` | DaviDan | Ingrediente:<br>făină de grâu c/s, zahăr cristal, apă potabilă, ulei de floarea-soarelui, drojdie proaspătă p/u panificație, ouă de găină, lapte pasteurizat de vacă, scorțișoară, aromă: vanilină; ameliorator p/u panificație, sare alimentară. Conține: grâu, ouă, lapte.<br>Poate conține urme de arahide, fistic, susan.<br>Declaratia nutritionala 100gr:<br>Valoarea energetica 1235.5 kcal.<br>Proteine 6.2 g, Grasimi 5.3 g din care acizi grasi saturati 4 g, Glucide 55.7 g din care zaharuri 18.6 , Fibre 2.4 g, Sare 0.26g<br>Termen de valabilitate 12 ore<br>Masa neto:230 g | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/Kurtos_cu_scortisoara_-_36_Lei.jpg?v=1763646301 |
| 4 | Kurtos cu arahide | 39.00 MDL | `kurtos-cu-nuca` | DaviDan | Ingrediente:<br>făină de grâu c/s, zahăr cristal, apă potabilă, arahide, ulei de floarea-soarelui, drojdie proaspătă p/u panificație, ouă de găină, lapte pasteurizat de vacă, aromă: vanilină; ameliorator p/u panificație, sare alimentară. Conține: grâu, arahide, ouă, lapte.<br>Poate conține urme de fistic, susan.<br>Declaratia nutritionala 100gr:<br>Valoarea energetica 1352.3 kcal.<br>Proteine 8.4 g, Grasimi 9.7 g din care acizi grasi saturati 4.5 g, Glucide 50.6 g din care zaharuri 17.2 g , Fibre 2.7 g, Sare 0.24g<br>Termen de valabilitate 12 ore<br>Masa neto:250 g | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/Kurtos_cu_arahide_-_39_Lei.jpg?v=1763646264 |
| 5 | Kurtos cu vanilie | 36.00 MDL | `kurtos-cu-vanilie` | DaviDan | Ingrediente:<br>făină de grâu c/s, zahăr cristal, apă potabilă, ulei de floarea-soarelui, drojdie proaspătă p/u panificație, ouă de găină, lapte pasteurizat de vacă, aromă: vanilină; ameliorator p/u panificație, sare alimentară. Conține: grâu, ouă, lapte.<br>Poate conține urme de arahide, fistic, susan.<br>Declaratia nutritionala 100gr:<br>Valoarea energetica 1235.5 kcal.<br>Proteine 6.2 g, Grasimi 5.3 g din care acizi grasi saturati 4 g, Glucide 55.7 g din care zaharuri 18.6 , Fibre 2.4 g, Sare 0.26g<br>Termen de valabilitate 12 ore<br>Masa neto:230 g | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/Kurtos_cu_vanilie_-_36_Lei.jpg?v=1763646127 |
| 6 | Kurtos cu fistic | 59.00 MDL | `kurtos-cu-fistic` | DaviDan | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/KurtosFistic-59Lei.jpg?v=1763646346 |
| 7 | Kurtos Rafaello | 55.00 MDL | `kurtos-rafaello` | DaviDan | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/KurtosRafaello-55Lei.jpg?v=1763646375 |

#### Patiserie (`meniu-placinte-panini`), 19 products — https://davidan.md/collections/meniu-placinte-panini

| # | Name (title) | Price | Handle | Vendor | Description (verbatim, one line per paragraph) | Image URL(s) |
|---|---|---|---|---|---|---|
| 1 | Plăcintă cu brânză | 22.00 MDL | `saralie-branza` | DaviDan | Ingrediente:<br>făină de grâu calitate superioara, brânză de vacă, apă potabilă, ouă, ulei de floarea soarelui, sare alimentară, semințe de mac, zahăr cristal, regulator de aciditate. Conține: grâu, ouă, lapte.<br>Poate conține urme de susan.<br>Declaratia nutritionala 100gr:<br>Valoarea energetica 835.1 kcal.<br>Proteine 10.8 g, Grasimi 7.3 g din care acizi grasi saturati 2 g, Glucide 22.8 g din care zaharuri 1.6 g , Fibre 1.2 g, Sare 0.83g.<br>Termen de valabilitate 24 ore<br>Masa neta:160 g | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/placintacubranzaz.jpg?v=1788203469 |
| 2 | Plăcintă cu varză | 18.00 MDL | `saralie-varza` | DaviDan | Ingrediente:<br>varză, făină de grâu calitate superioara, apă potabilă, ceapă, ulei de floarea soarelui, sare alimentară, ouă, semințe de susan, zahăr cristal, piper negru. Conține: grâu, ouă, susan.<br>Poate conține urme de lapte.<br>Declaratia nutritionala 100gr:<br>Valoarea energetica 715.5 kcal.<br>Proteine 4.3 g, Grasimi 6.3 g din care acizi grasi saturati 0.6 g, Glucide 24.4 g din care zaharuri 2.1 g , Fibre 2.3 g, Sare 1.4g<br>Termen de valabilitate 24 ore<br>Masa neto:160 g | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/placintacubranza.jpg?v=1788203031 |
| 3 | Plăcintă cu cartof | 18.00 MDL | `saralie-cartof` | DaviDan | Ingrediente:<br>cartofi, făină de grâu calitate superioara, apă potabilă, ulei de floarea soarelui, ceapă, ouă, sare alimentară, miez de floarea soarelui, zahăr cristal, regulator de aciditate, piper negru. Conține: grâu, ouă.<br>Poate conține urme de lapte, susan.<br>Declaratia nutritionala 100gr:<br>Valoarea energetica 758.1 kcal.<br>Proteine 4.4 g, Grasimi 5.2 g din care acizi grasi saturati 0.5 g, Glucide 29.3 g din care zaharuri 1.3g , Fibre 1.8 g, Sare 0.7g<br>Termen de valabilitate 24 ore<br>Masa neto:160 g | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/placintacucarto.jpg?v=1788202139 |
| 4 | Plăcintă cu brânză și verdeață | 22.00 MDL | `saralie-branza-și-verdeața` | DaviDan | Ingrediente:<br>făină de grâu calitatea superioara, brânză de vacă, apă potabilă, cu, ouă, ulei de floarea-soarelui, sare alimentară, semințe de in, semințe de susan, mărar verde, zahăr cristal, regulator de aciditate. Conține: grâu, ouă, lapte, susan.<br>Poate conține urme de susan.<br>Declaratia nutritionala 100gr:<br>Valoarea energetica 840.6 kcal.<br>Proteine 10.8 g, Grasimi 7.5 g din care acizi grasi saturati 2 g, Glucide 22.8 g din care zaharuri 1.6 g , Fibre 1.3 g, Sare 0.83g.<br>Termen de valabilitate 24 ore<br>Masa neta:160 g | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/placintacubranzasiverdeata.jpg?v=1788202969 |
| 5 | Plăcintă cu carne de pui | 24.00 MDL | `saralie-carne-de-pui` | DaviDan | Ingrediente:<br>carne pe pui, făină de grâu calitatea superioara, ceapă, apă potabilă, ulei de floarea-soarelui, ouă, sare alimentară, semințe de in, zahăr cristal, regulator de aciditate, piper negru. Conține: grâu, ouă,<br>Poate conține urme de lapte, susan.<br>Declaratia nutritionala 100gr:<br>Valoarea energetica 906.7 kcal.<br>Proteine 9 g, Grasimi 9.6 g din care acizi grasi saturati 1.9 g, acizi grasi trans 0.03, Glucide 23.4 g din care zaharuri 1.3g , Fibre 1.5 g, Sare 0.6g<br>Termen de valabilitate 24 ore<br>Masa neta:160 g | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/placintacucarnedepui.jpg?v=1788203290 |
| 6 | Plăcintă cu mere | 18.00 MDL | `placinta-cu-dovleac` | DaviDan | Ingrediente:<br>mere, făină de grâu calitatea superioara, apă potabilă, ulei de floarea soarelui, zahăr cristal, ouă, zahăr pudră decorative, nucă de cocos, sare alimentară, regulator de aciditate. Conține: grâu, ouă.<br>Poate conține urme de susan.<br>Declaratia nutritionala 100gr:<br>Valoarea energetica 1337.2 kcal.<br>Proteine 3.4 g, Grasimi 4.2 g din care acizi grasi saturati 0.4 g, Glucide 67.1 g din care zaharuri 24.6 g , Fibre 1.1 g, Sare 0.4g<br>Termen de valabilitate 24 ore<br>Masa neto:160 g | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/placintacumere_d0c48509-d22d-4137-961c-c0ec27622539.jpg?v=1788201998 |
| 7 | Plăcintă cu vișină | 25.00 MDL | `placinte-triunghi-cu-vișina` | DaviDan | Ingrediente:<br>vișine în suc propriu, făină de grâu c/s, apă potabilă, ulei de floarea soarelui, zahăr cristal, agent de îngroșare, ouă de găină, zahăr pudră decorative, zahăr, amidon, grăsimi vegetale, sare alimentară, regulator de aciditate. Conține: grâu, ouă.<br>Poate conține urme de susan.<br>Produsul poate conține sâmburi de vișină<br>Declaratia nutritionala 100gr:<br>Valoarea energetica 841,4 kcal.<br>Proteine 3.7 g, Grasimi 4.2 g din care acizi grasi saturati 0.4 g, Glucide 36,8 g din care zaharuri 4.9 g , Fibre 1.7 g, Sare 0.37g<br>Termen de valabilitate 24 ore<br>Masa neta:160 g | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/Gemini_Generated_Image_4uttai4uttai4uttcopy.jpg?v=1788196999 |
| 8 | Panini cu mușchi de porc | 36.00 MDL | `panini` | DaviDan | Ingrediente:<br>făină de grâu c/s, apă potabilă, maioneză brânză cu cheag tare, mușchi de porc fiert-afumat, frunze de salată, roșii proaspete, castraveți proaspeți, ulei de floarea-soarelui, sare alimentară, zahăr cristal, maia naturală, usturoi granulat, piper negru măcinat. Conține grâu, ouă, produs derivate al laptelui.<br>Poate conține urme de susan.<br>Declaratia nutritionala 100gr:<br>Valoarea energetica 1125.5 kcal.<br>Proteine 7.4 g, Grasimi 14.3 g din care acizi grasi saturati 0.4g,Acizi grasi trans 0g Glucide 23.9 g din care zaharuri 1.7 g , Fibre 0.3g, Sare 1.23g<br>Termen de valabilitate 12 ore<br>Masa neta:220 g | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/panini.jpg?v=1788199736 |
| 9 | Crenvurșcă în aluat | 21.00 MDL | `crenvuști-in-aluat` | DaviDan | Ingrediente:<br>crenvurști, făină de grâu c/s, ouă de găină, lapte pasteurizat de vacă, ulei de floarea-soarelui, semințe de susan, zahăr cristal, grăsime cu maia din grâu uleiuri vegetale rafin, apă, emulsifiant, sare iodată, aromă, antioxidant, conservant, acidifiant, colorant, maia de grâu, sare alimentară, drojdie proaspătă p/u panificație. Conține grâu, ouă, lapte, susan.<br>Poate conține urme de susan.<br>Declaratia nutritionala 100gr:<br>Valoarea energetica 1143.5 kcal.<br>Proteine 12.7 g, Grasimi 11.6 g din care acizi grasi saturati 1 g,Acizi grasi trans 0.05g Glucide 19.6 g din care zaharuri 1.7 g , Fibre 0.2 g, Sare 0.63g<br>Termen de valabilitate 12 ore<br>Masa neta:110 g | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/crenvushcainaluat.jpg?v=1788197741 |
| 10 | Sandwich cu pui Crispy | 40.00 MDL | `sandwich-crispy` | DaviDan | Ingrediente:<br>Făină de grâu c/s, apă potabilă, maioneză cu gr. 57% (ulei rafinat de floarea soarelui deodorizat, apă potabilă, gălbenuș de ou uscat, oțet de masă, sare alimentară, agenți de îngroșare: E1422, guma xantan, guma guar; arome, regulator de aciditate: acid lactic; conservant; acid sorbic; colorant: carotene; îndulcitor: zaharină), unt, zahăr cristal, ulei de floarea soarelui, drojdie de panificație, maia naturală (maia deshidratată din grâu dur, drojdie antioxidant: acid ascorbic; enzime), usturoi granulat, piper negru măcinat, amestec de semințe: mac, in , in galben, susan, floarea soarelui.Conține: grâu, ouă, produs derivat a laptelui, susan.<br>Poate conține urme de nuci.<br>Poate conține urme de susan.<br>Declaratia nutritionala la 100gr:<br>Valoarea energetica 1343.1 kJ(321kcal).<br>Proteine 5.7 g, Grasimi 15 g din care acizi grasi saturati 2.58g,Acizi grasi trans 0g Glucide 30.58 g din care zaharuri 1.9 g , Fibre 1.98g, Sare 1.43g<br>Termen de valabilitate 12 ore<br>Masa neta:200 g | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/puicrispy.jpg?v=1788200398 |
| 11 | Pizza  cu piept de pui | 35.00 MDL | `pizza` | DaviDan | Ingrediente:<br>făină de grâu c/s, ulei de floarea soarelui, brânză cu cheag tare cu gr. 50%, apă potabilă, piept de pui refrigerat, sos de roșii, roșii proaspete, gogoșari proaspeți, ulei de măsline, maia naturală, sare alimentară, zahăr cristal, condimente: oregano, piper negru. Conține grâu, produs derivate al laptelui.<br>Poate conține urme de susan, oua.<br>Declaratia nutritionala 100gr:<br>Valoarea energetica 1288.7 kcal.<br>Proteine 8.9 g, Grasimi 22.5 g din care acizi grasi saturati 1.7g,Acizi grasi trans 0g Glucide 17.3 g din care zaharuri 1.7 g , Fibre 1.6g, Sare 0.64g<br>Termen de valabilitate 12 ore<br>Masa neta:180 g | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/pizza.jpg?v=1788201631 |
| 12 | Foietaj Picnic | 25.00 MDL | `foietaj-picnic` | DaviDan | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/foietaj.jpg?v=1788201220 |
| 13 | Foietaj Rancho | 27.00 MDL | `foietaj-rancho` | DaviDan | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/FoietajRancho-27Lei.jpg?v=1763643728 |
| 14 | Foietaj Penovani | 26.00 MDL | `foietaj-penovani` | DaviDan | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/FoietajPenovani26Lei.jpg?v=1763643809 |
| 15 | Pretzel cu cașcaval | 20.00 MDL | `pretzel-cu-cașcaval` | DaviDan | Ingrediente:<br>făină de grâu c/s, zahăr cristal, grăsime cu maia din grâu, uleiuri vegetale rafinate, apă, emulsifiant, sare iodată, aromă, antioxidant, conservant, acidifiant, colorant maia de grâu, apă potabilă, drojdie proaspătă p/u panificație, unt din smântână dulce, caşcaval, amidon, grăsimi vegetale, sare alimentară, ameliorator. Contine: grâu, ouă, produs derivate al laptelui.<br>Poate conține urme de susan, oua.<br>Declaratia nutritionala 100gr:<br>Valoarea energetica 1447.7 kcal.<br>Proteine 4.4 g, Grasimi 14.7 g din care acizi grasi saturati 4.3g,Acizi grasi trans 1.02g Glucide 49.5 g din care zaharuri 20.6 g , Fibre 1g, Sare 0.81g<br>Termen de valabilitate 24 ore<br>Masa neta:130 g | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/Pretzelcucscaval-20Lei.jpg?v=1763645683 |
| 16 | Croisant XXL cu pui | 39.00 MDL | `croisant-xxl-cu-pui` | DaviDan | Ingrediente:<br>făină de grâu c/s, maioneză, apă potabilă, margarine, uleiuri vegetale rafinate, emulsifiant, sare iodată, acidifiant, conservant, antioxidant, aromă, colorant, brânză cu cheag tare, fileu de găină afumat-fiert, antioxidant: acid eritorbic, ardei gras, frunze de salată, castraveți proaspeți, zahăr cristal, drojdie proaspătă p/u panificație, unt din smântână dulce, sare alimentară, ouă de găină, usturoi granulat, piper negru măcinat, ameliorator făină de grâu, amidon de porumb, maltodextrină, emulgator. Conține grâu, ouă, produs derivate al laptelui.<br>Poate conține urme de susan.<br>Declaratia nutritionala 100gr:<br>Valoarea energetica 1222.1 kcal.<br>Proteine 7.1 g, Grasimi 20.2 g din care acizi grasi saturati 3.9 g,Acizi grasi trans 0.57g Glucide 19.8 g din care zaharuri 3.5 g , Fibre 0.4 g, Sare 1.1g<br>Termen de valabilitate 12 ore<br>Masa neta:180 g | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/CroisantXXLcupui-39.jpg?v=1763645717 |
| 17 | Plăcintă cu dovleac | 20.00 MDL | `placinta-cu-dovleac-1` | DaviDan | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/Placintacudovleac-20.jpg?v=1763645963 |
| 18 | Plăcintă cu cartofi si bacon | 23.00 MDL | `placinta-cu-cartofi-si-bacon` | DaviDan | Ingrediente:<br>cartofi, făină de grâu c/s, bacon de porc, apă potabilă, ulei de floarea soarelui, ceapă, sare alimentară, zahăr cristal, regulator de aciditate (acid acetic), piper negru. Conține: grâu.<br>Poate conține urme de seminte de susan, arahida, oua, lapte si produse derivate a acestora.<br>Declaratia nutritionala pe 100g:<br>Valoarea energetica 185 kcal.<br>Proteine 6.2 g, Grasimi 7 g din care acizi grasi saturati 1.2 g, Glucide 25.9 g din care zaharuri 1.1 g, fibre 1.3 g, Sare 1.4 g<br>Termen de valabilitate 24 ore<br>Masa neta: 190 g | *(no image on site)* |
| 19 | Pain Suisse  cu șuncă și cașcaval | 50.00 MDL | `pain-suisse-cu-șunca-și-cașcaval` | DaviDan | Ingrediente:<br>Faina de griu c/s, apa potabila, sare alimentara, Drojdie pentru panificatie, zahar tos, unt, ameliorator de panificatie (emulsificant, antiocsidanti, acid ascorbic), Umplutura de zmeura.<br>Poate contine urme de seminte de susan, arahida, oua, lapte si produse derivate a acestora.<br>Declaratia nutritionala pe 100g:<br>Valoarea energetica 143.2 kcal.<br>Proteine 6.2 g, Grasimi 17 g din care acizi grasi saturati 9.2 g, Acizi grasi trans 1.2 g, Glucide 35 g din care zaharuri 1.1 g, fibre 1.3 g, Sare 1.4 g<br>Termen de valabilitate 24 ore<br>Masa neta: 120 g | *(no image on site)* |

#### Cofetărie (`meniu-dulciuri`), 11 products — https://davidan.md/collections/meniu-dulciuri

| # | Name (title) | Price | Handle | Vendor | Description (verbatim, one line per paragraph) | Image URL(s) |
|---|---|---|---|---|---|---|
| 1 | Croissant cu ciocolată | 19.00 MDL | `croissant-nutella` | DaviDan | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/Croisant_cu_ciocolata_-_19_Lei.jpg?v=1763644022 |
| 2 | Pretzel cu plombir si migdale | 22.00 MDL | `pretzel-cu-plombir-si-migdale` | DaviDan | Ingrediente:<br>făină de grâu c/s, zahăr cristal, grăsime cu maia din grâu, uleiuri vegetale rafinate, apă, emulsifiant, sare iodată, aromă, antioxidant, conservant, acidifiant, colorant maia de grâu, apă potabilă, drojdie proaspătă p/u panificație, unt din smântână dulce, cremă de plombir, fugli de migdale, pudră decorativ zahăr, amidon, grăsimi vegetale, sare alimentară, ameliorator. Contine: grâu, ouă, produs derivate al laptelui.<br>Poate conține urme de susan, oua.<br>Declaratia nutritionala 100gr:<br>Valoarea energetica 1447.7 kcal.<br>Proteine 4.4 g, Grasimi 14.7 g din care acizi grasi saturati 4.3g,Acizi grasi trans 1.02g Glucide 49.5 g din care zaharuri 20.6 g , Fibre 1g, Sare 0.81g<br>Termen de valabilitate 24 ore<br>Masa neta:205 g | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/Pretzelcuplombirsimigdale-22Lei.jpg?v=1763645639 |
| 3 | New York Rolls cu mango și maracuja | 39.00 MDL | `new-york-rolls-cu-mango-și-maracuja` | DaviDan | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/NewYorkRolls-cumangosimaracuja-39Lei.jpg?v=1763645569 |
| 4 | New York Rolls cu fistic | 39.00 MDL | `new-york-rolls-cu-fistic` | DaviDan | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/NewYorkRolls-cufistic-39Lei.jpg?v=1763644719 |
| 5 | New York Rolls cu zmeură | 39.00 MDL | `new-york-rolls-cu-zmeura` | DaviDan | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/NewYorkRolls-cuzmeura-39Lei.jpg?v=1763644694 |
| 6 | New York Rolls cu ciocolată | 39.00 MDL | `new-york-rolls-cu-ciocolata` | DaviDan | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/NewYorkRolls-cuciocolata-39Lei.jpg?v=1763644566 |
| 7 | Danish cu fructe de pădure și vanilie | 24.00 MDL | `cosulet-cu-fructe` | DaviDan | Ingrediente:<br>făină degrâu c/s, apă potabilă, grăsime cu maia din grâu [uleiuri vegetale rafinate (palmier, floarea soareleui), apă, emulsifiant (lecitină de floarea soarelui, mono- și diglyceride ale acizilor grași), sare iodată, aromă, antioxidant (extract bogat in tocoferol, palmitat de L-ascorbil), conservant , acidifiant, colorant , maia de grâu], zahăr cristal, drojdie proaspătă p/u panificație, unt din smântână dulce, umplutură de vanilie (apă, zahăr alb cristalin, îngroșator de amidon îngroșat, zer pudrat demineralizat, grăsimi vegetale deodorizate, raffinate, sare alimentară, conservant de sorbat de potasiu, ,ouăde găină, sare alimentară, fructe de sezon(capșuni,mure,kiwi), mentă. Conține: grâu, produs derivat a laptelui, ouă, nuci.<br>Valorile nutritive medii la 100g:<br>Energie 1,170,26kJ(279,7ckal);<br>Grăsimi :5,32g; din care saturate 2,54g; Glucide 53,71g; Din care zahăruri:17,9g; Proteine: 5,51g; Sare : 0,86g;<br>Termen de valabilitate 12 ore<br>Masa neta:0,190 g | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/danish.jpg?v=1788197433 |
| 8 | Croissant Duo | 25.00 MDL | `croissant-duo` | DaviDan | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/CroisantDuo-25Lei.jpg?v=1763644094 |
| 9 | Croissant cu fistic | 22.00 MDL | `croissant-cu-fistic` | DaviDan | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/Croisantcufistic-22Lei.jpg?v=1763644070 |
| 10 | Donuts Oreo | 24.00 MDL | `donuts-oreo` | DaviDan | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/DonutsOreo-24Lei.jpg?v=1763642893 |
| 11 | Muffins Orange | 18.00 MDL | `muffins-orange` | DaviDan | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/MuffinOrange-18.jpg?v=1763642495 |

#### Băuturi (`meniu-bauturi`), 25 products — https://davidan.md/collections/meniu-bauturi

| # | Name (title) | Price | Handle | Vendor | Description (verbatim, one line per paragraph) | Image URL(s) |
|---|---|---|---|---|---|---|
| 1 | Coca Cola | 25.00 MDL | `coca-cola-0-5` | La Danuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/fanta11.png?v=1765018091 |
| 2 | Fanta | Tip: Portocală = 25.00 MDL<br>Sambuco = 25.00 MDL | `fanta` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/products/fanta11.jpg?v=1631443464 |
| 3 | Sprite | 25.00 MDL | `sprite` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/products/sprite.jpg?v=1631443582 |
| 4 | Apa DaviDan | Tip: Naturală = 15.00 MDL<br>Gazată = 15.00 MDL | `dorna` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/davidan_1_2.png?v=1765018747 |
| 5 | Apa DaviDan | 15.00 MDL | `apa-davidan` | La Danuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/davidan_1_3.png?v=1765018857 |
| 6 | Americano | Alege: Americano = 22.00 MDL<br>Americano dublu = 28.00 MDL<br>Americano decaff = 24.00 MDL<br>Americano dublu decaff = 28.00 MDL | `americano` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/products/AD6D808D-7AA9-476F-ABFB-E2F89ACDEFCA.jpg?v=1646209570 |
| 7 | Ciocolată fierbinte cu lapte | 24.00 MDL | `ciocolata-fierbinte-cu-lapte` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/products/04F7132A-A4E0-400B-BBE9-2255D8B99380.jpg?v=1646210850 |
| 8 | Macchiato | Alege: Espresso Macchiato = 25.00 MDL<br>Espresso Macchiato decaff = 28.00 MDL<br>Americano Macchiato = 25.00 MDL<br>Americano Macchiato decaff = 28.00 MDL | `macchiato` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/products/6AE4DE8B-9E71-42C3-8851-646B2E377251.jpg?v=1646210921 |
| 9 | Espresso | Alege: Espresso = 22.00 MDL<br>Espresso dublu = 28.00 MDL<br>Essoresso dublu decaff = 30.00 MDL<br>Espresso decaff = 24.00 MDL | `espresso` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/products/77A62573-71CB-44AD-ABA4-08AA902BA9CE.jpg?v=1646210653 |
| 10 | Flat White | Alege: Flat White = 33.00 MDL<br>Flat White vegetal = 45.00 MDL<br>Flat White f/a lactoza = 46.00 MDL<br>Flat White decaff = 40.00 MDL | `flat-white` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/images.jpg?v=1782070214 |
| 11 | Ceai natural | Ceai: Classic = 15.00 MDL<br>Fructe naturale = 25.00 MDL | `ceai` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/products/F62FFA84-C53D-44B7-8569-ACF6F28855FE.jpg?v=1646208798 |
| 12 | Ciocolată fierbinte | 24.00 MDL | `ciocolata-fierbinte` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/products/533B085B-B157-40B2-ABB4-1B11662278DD.jpg?v=1646210741 |
| 13 | Latte | Alege: Latte = 33.00 MDL<br>Latte decaff = 35.00 MDL<br>Latte vegetal = 50.00 MDL<br>Latte vegetal decaff = 53.00 MDL<br>Latte f/a lactoza = 35.00 MDL<br>Latte f/a lactoza decaff = 38.00 MDL<br>Latte dublu = 43.00 MDL | `latte` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/products/EE15B21F-47AA-444C-8BD5-65D716BC89C2.jpg?v=1646210392 |
| 14 | Cappuccino | Alege: Cappuccino = 28.00 MDL<br>Cappuccino dublu = 36.00 MDL<br>Cappuccino decaff = 30.00 MDL<br>Cappuccino dublu decaff = 52.00 MDL<br>Cappuccino vegetal = 40.00 MDL<br>Cappuccino vegetal dublu = 50.00 MDL<br>Cappuccino vegetal decaff = 53.00 MDL<br>Cappuccino vegetal decaff dublu = 55.00 MDL<br>Cappuccino f/a lactoza = 32.00 MDL<br>Cappuccino f/a lactoza dublu = 40.00 MDL<br>Cappuccino f/a lactoza decaff dublu = 48.00 MDL | `cappuccino` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/products/6C6750F4-530F-4839-95CA-AD6B4BD10FCD.jpg?v=1646208860 |
| 15 | Fuze Tea | Tip: Mango & Romaniță = 28.00 MDL<br>Lămâie = 28.00 MDL | `fuze-tea` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/products/fuze.jpg?v=1631444212 |
| 16 | Cappy Pulpy | Tip: Portocală = 25.00 MDL<br>Grapefruit = 25.00 MDL<br>Măr = 25.00 MDL | `cappy-pulpy` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/products/asd.jpg?v=1631443955<br>https://cdn.shopify.com/s/files/1/0580/2777/0028/products/capy2.jpg?v=1631443955<br>https://cdn.shopify.com/s/files/1/0580/2777/0028/products/capy3.jpg?v=1631443955 |
| 17 | Rich Kids | 12.00 MDL | `rich-kids` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/products/suc.jpg?v=1631444031 |
| 18 | Red Bull | 35.00 MDL | `red-bull-0-25l` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/products/red.jpg?v=1631443619 |
| 19 | Ice Latte | Ingrediente: Ciocolată / Biscuit = 30.00 MDL<br>Popcorn = 30.00 MDL<br>Caramelă / Nucușoare = 30.00 MDL | `ice-latte` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/products/1000.jpg?v=1625513273 |
| 20 | Lemonade | Ingrediente: Orangiada = 30.00 MDL<br>Pară / Pepene Galben = 30.00 MDL<br>Grapefruit / Pepene Verde = 30.00 MDL<br>Afine / Levănțică = 30.00 MDL | `lemonade` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/products/1005.jpg?v=1625512997<br>https://cdn.shopify.com/s/files/1/0580/2777/0028/products/1006.jpg?v=1625512997<br>https://cdn.shopify.com/s/files/1/0580/2777/0028/products/5007.png?v=1625512997<br>https://cdn.shopify.com/s/files/1/0580/2777/0028/products/1004.jpg?v=1625512997 |
| 21 | Mojito | Ingrediente: Pară / Pepene Galben = 32.00 MDL<br>Grapefruit / Pepene Verde = 32.00 MDL<br>Afine / Levănțică = 32.00 MDL | `mojito` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/products/1010.jpg?v=1625512285<br>https://cdn.shopify.com/s/files/1/0580/2777/0028/products/1009.jpg?v=1625512285<br>https://cdn.shopify.com/s/files/1/0580/2777/0028/products/1008.jpg?v=1625512285 |
| 22 | Burn 0.25l | 35.00 MDL | `burn-0-25l` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/products/burn.jpg?v=1631725768 |
| 23 | Pepsi | 25.00 MDL | `pepsi` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/products/pepsifv.jpg?v=1625304854 |
| 24 | Suc Davidan | Ingrediente: Mere = 25.00 MDL<br>Fructe de padure = 25.00 MDL | `lemonade-copy` | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/images_1.jpg?v=1782070931 |
| 25 | Compot Davidan | Alege: Compot = 25.00 MDL | `compot-davidan` | La Dănuț | *(empty on site)* | *(no image on site)* |

---

## 2. "Restaurant" / gastronomic / hot food: what really exists

**Verdict: there is no restaurant product feed on davidan.md. The "Restaurant" tile is a decorative homepage placeholder with an empty link. No restaurant, hot-food, salad, soup, rice or sushi products exist anywhere in the public store.**

Evidence:

1. **Homepage category slider** (https://davidan.md/). It has 4 tiles. Only the first links anywhere; the other three have `href=""` (empty, so clicking reloads the homepage). Raw HTML of the Restaurant tile:

```html
<a href="" class="cat-url" style="background-image: url('//davidan.md/cdn/shop/files/Orez-cu-pui.png?v=1724422332');">
  <div class="text-content">
    <span class="cat-title">Category</span>
    <h2 class="big-title"><span class="title-2">Restaurant</span></h2>
    <p class="cat-desc">Experiențe culinare de neuitat într-un ambient elegant și primitor.</p>
```

   All 4 tiles (verbatim; "small label" / title / description → href / background image):

   | Small label | Title | Description (verbatim) | href | Background image |
   |---|---|---|---|---|
   | Kurtos | Patiserie | Descoperă deliciile noastre proaspete și rafinate la Patiseria noastră | `/collections/meniu-kurtos` | https://davidan.md/cdn/shop/files/380520837_610910601256167_1781447760104501231_n.jpg?v=1724662291 |
   | Category | Apă naturală | Apa purificată și revitalizantă pe care o oferim este esențială pentru sănătatea ta | `""` (empty) | https://davidan.md/cdn/shop/files/photo_5294145748012305182_y.jpg?v=1765013807 |
   | Category | Sushi | Delicii proaspete, rafinate și autentice, direct din tradiția japoneză. | `""` (empty) | https://davidan.md/cdn/shop/files/Ebi-Roll-min-768x512_png.webp?v=1724422246 |
   | Category | Restaurant | Experiențe culinare de neuitat într-un ambient elegant și primitor. | `""` (empty) | https://davidan.md/cdn/shop/files/Orez-cu-pui.png?v=1724422332 |

   The Restaurant background image file is named `Orez-cu-pui.png` ("rice with chicken"). That filename is the only restaurant-dish hint on the site. No product, price or menu goes with it.

2. **Collections.** Only `meniu-bauturi`, `meniu-dulciuri`, `meniu-kurtos` and `meniu-placinte-panini` exist. `/collections/restaurant`, `/collections/bucatarie`, `/collections/meniu-restaurant`, `/collections/sushi`, `/collections/apa` and `/collections/frontpage` all return **404**.
3. **product_type / tags.** `product_type` is empty on all 62 products and there are no tags at all, so no hidden "restaurant" grouping exists.
4. **Keyword scan.** Searched the full `products.json` (titles, bodies, variants) for restaurant, gastronom, bucătări/bucatari, sushi, salat, orez, supă, meniu. The only hits are "frunze de salată" (lettuce leaves) inside the ingredient lists of `panini` and `croisant-xxl-cu-pui`. No dish products.
5. **Store search** (`/search/suggest.json`) for restaurant, gastronom, bucătărie, meniu, salată, supă, orez and sushi returns only fuzzy matches to existing bakery and drink products, plus the collection "Patiserie" for "meniu". No restaurant pages, articles or collections.
6. **Other places "Restaurant" appears (text only):**
   - https://davidan.md/pages/despre-noi, service list item, verbatim:

     > Restaurant Sushi  
     > Experiență culinară japoneză autentică, servită cu eleganță și rafinament.

   - Blog post https://davidan.md/blogs/news/o-experien%C8%9Ba-autentica-a-deliciilor-japoneze ("Sushi DaviDan"). Full text is in section 7. It mentions "gastronomia japoneză" and "bucătăriei japoneze", but no dishes, prices or ordering link.

Savoury, meal-like items that *do* exist are all bakery items in **Patiserie** (`meniu-placinte-panini`): Pizza cu piept de pui, Sandwich cu pui Crispy, Panini cu mușchi de porc, Croisant XXL cu pui, Crenvurșcă în aluat, Pain Suisse cu șuncă și cașcaval, and so on. See the table in section 1.

---

## 3. Legal / policy pages (verbatim, full text)

Shopify's standard policy URLs **all return 404**: `/policies/terms-of-service`, `/policies/privacy-policy`, `/policies/refund-policy`, `/policies/shipping-policy`, `/policies/contact-information`, `/policies/legal-notice`, `/policies/subscription-policy`. The legal texts live as regular pages linked from the footer "Informații" column:

| Footer label (verbatim) | href |
|---|---|
| Termeni și Condiții | `/pages/meniu-bauturi` (sic: the T&C page has the handle "meniu-bauturi") |
| Politica de confidențialitate | `/pages/politica-de-confiden%C8%9Bialitate` |
| Livrare și achitarea | `/pages/livrare-%C8%99i-achitare` (footer label says "achitarea"; the page heading says "achitare") |
| Carieră | `/pages/vino-in-echipa` |

There is **no separate returns/refund page**. The only return rule is clause 7 of Termeni și Condiții. The numbering below reproduces the site's `<ol>` numbering, including its gaps (the delivery page jumps from 3 to 5, and the privacy page starts at 2).

### 3.1 Termeni și Condiții — https://davidan.md/pages/meniu-bauturi

> **Termeni și Condiții**
>
> 1. Obiectul contractului: Magazinul online La Dănuț, înregistrat conform legii, oferă spre vânzare produse alimentare, în conformitate cu prezentul regulament.
>
> 2. Produsele: Magazinul online La Dănuț comercializează produse alimentare, conform descrierii și specificațiilor afișate pe site-ul magazinului.
>
> 3. Prețurile: Prețurile produselor sunt afișate în lei, includ TVA și nu includ costul transportului. Magazinul își rezervă dreptul de a modifica prețurile produselor fără o notificare prealabilă.
>
> 4. Comenzile: Prin plasarea unei comenzi, clientul își exprimă acordul de a achiziționa produsele comandate și de a plăti contravaloarea acestora. Comanda este considerată acceptată de către magazin doar după confirmarea acesteia prin email.
>
> 5. Plata: Plata produselor se poate prin (cash la curier sau card la curier) metodele de plată acceptate de magazin. Produsele comandate vor fi achitate la primirea comenzii
>
> 6. Livrarea: Produsele comandate vor fi livrate la adresa specificată de către client în momentul plasării comenzii. Costurile de livrare vor fi suportate de client și vor fi afișate în momentul plasării comenzii.
>
> 7. Returnarea produselor: Produsele alimentare nu pot fi returnate din motive de igienă și siguranță alimentară. Produsele nealimentare pot fi returnate în termen de 14 zile de la primirea lor, dacă nu corespund descrierii afișate pe site-ul magazinului.
>
> 8. Confidențialitatea datelor: Magazinul online de patiserie respectă confidențialitatea datelor personale ale clienților și se angajează să le protejeze conform legii.
>
> 9. Litigii: Orice litigiu între client și magazinul online de patiserie va fi soluționat pe cale amiabilă. În caz contrar, litigiul va fi soluționat conform legislației Republicii Moldova în vigoare.
>
> 10. Modificări: Magazinul online de patiserie își rezervă dreptul de a modifica prezentul regulament fără o notificare prealabilă. Orice modificare va fi publicată pe site-ul magazinului și va fi aplicată din momentul publicării.

Notes: the text names the shop "Magazinul online La Dănuț", not DaviDan. Clause 5 reads "se poate prin" as on the site (a word is missing there).

### 3.2 Politica de confidențialitate — https://davidan.md/pages/politica-de-confiden%C8%9Bialitate

> **Politica de confidențialitate**
>
> ladanut.md colectează și utilizează informațiile personale ale utilizatorilor site-ului pentru a furniza și îmbunătăți serviciile noastre, precum și pentru a informa utilizatorii despre noile produse și promoțiile oferite.
>
> 2. Date personale colectate
>
> Datele personale colectate includ, dar nu se limitează la, numele și prenumele, adresa de e-mail, adresa de facturare și de livrare, numărul de telefon și informații privind istoricul comenzilor.
>
> 3. Colectarea datelor personale
>
> Datele personale pot fi colectate prin intermediul formularelor de înscriere și de comandă, prin intermediul cookie-urilor și a altor tehnologii similare, precum și prin intermediul partenerilor noștri de afaceri.
>
> 4. Utilizarea datelor personale
>
> Utilizăm datele personale colectate pentru a procesa și a livra comenzile plasate de utilizatori, pentru a îmbunătăți serviciile noastre și pentru a informa utilizatorii despre noutățile și ofertele noastre. Datele personale pot fi folosite și în scopuri de marketing și publicitate.
>
> 5. Protecția datelor personale
>
> ladanut.md se angajează să protejeze datele personale ale utilizatorilor și să nu le divulge către terți fără acordul explicit al acestora, cu excepția cazurilor prevăzute de lege. Toate datele personale sunt stocate pe servere securizate și accesul la acestea este limitat la persoanele autorizate.
>
> 6. Modificări
>
> Politica de confidențialitate a magazinului online ladanut.md poate fi actualizată din când în când. Toate modificările vor fi publicate pe site și vor fi aplicate din momentul publicării.
>
> 7. Contact
>
> Dacă aveți întrebări sau comentarii cu privire la politica noastră de confidențialitate, vă rugăm să ne contactați prin intermediul formularului de contact disponibil pe site.

Note: the text refers to the domain **ladanut.md**, not davidan.md.

### 3.3 Livrare și achitare — https://davidan.md/pages/livrare-%C8%99i-achitare

> **Livrare și achitare**
>
> 1. Livrarea comenzilor
>
> Livrarea comenzilor se face prin intermediul curierului sau prin intermediul unui serviciu de livrare rapidă. Costul livrării va fi calculat în funcție de greutatea totală a comenzii și de adresa de livrare. Prețul livrării este de 35 lei în raza orașului Chișinău.
>
> 2. Termenul de livrare
>
> Termenul de livrare variază în funcție de adresa de livrare și de disponibilitatea produselor comandate. În general, termenul de livrare este de 5/60 minute pentru comenzile plasate în orașul Chișinău.
>
> 3. Achitarea comenzilor
>
> Comenzile pot fi achitate prin intermediul plății în numerar sau prin intermediul POS-ului la curier. Costul total al comenzii, inclusiv costul livrării, va fi afișat înainte de finalizarea comenzii.
>
> 5. Contact
>
> Dacă aveți întrebări sau comentarii cu privire la politica noastră de livrare și achitare, vă rugăm să ne contactați prin intermediul formularului de contact disponibil pe site.

Note: on the site, "3. Achitarea comenzilor" is a plain paragraph typed with "3." (not a list item), and the next list item starts at 5, so there is no item 4.

### 3.4 Returns / refunds

Dedicated page: NOT FOUND (`/policies/refund-policy` is 404 and no page exists in the sitemap). The only return rule, from T&C clause 7:

> Returnarea produselor: Produsele alimentare nu pot fi returnate din motive de igienă și siguranță alimentară. Produsele nealimentare pot fi returnate în termen de 14 zile de la primirea lor, dacă nu corespund descrierii afișate pe site-ul magazinului.

### 3.5 Contact page — https://davidan.md/pages/contact

> Telefon  
> [+373 69 765 805](tel:+373 69 765 805)  
> Oficiu central  
> str. Vlaicu Pârcălab 52  
> Email  
> [info@davidan.md](mailto:info@davidan.md)  
> Lasă-ne un mesaj iar noi revenim cu un răspuns!  
> Numele tău  
> Telefon  
> Prenume  
> Adresa de email  
> Comentariu / Mesaj  
> Trimite  

(The last five lines are contact form field labels plus the "Trimite" button.)

### 3.6 /ro mirror of the legal pages (do NOT use)

`https://davidan.md/ro/pages/meniu-bauturi`, `/ro/pages/politica-de-confiden%C8%9Bialitate` and `/ro/pages/livrare-%C8%99i-achitare` exist, but their text is a machine re-translation of the root text and garbles it. Examples, verbatim from /ro:

> Magazinul prețului dreptul de a modifica prețurile fără o notificare prealabilă.

> Pretul livrarii este de 35 lei in raza orasului Chisinau

> vă rugăm să nu contactați prin formularul de contact disponibil pe site.

The /ro versions of `despre-noi`, `contact` and `locatii` are identical to root.

---

## 4. Delivery & payment facts

| Topic | What the site says (verbatim) | Source URL |
|---|---|---|
| Delivery method | "Livrarea comenzilor se face prin intermediul curierului sau prin intermediul unui serviciu de livrare rapidă." | https://davidan.md/pages/livrare-%C8%99i-achitare |
| Delivery fee | "Costul livrării va fi calculat în funcție de greutatea totală a comenzii și de adresa de livrare. Prețul livrării este de 35 lei în raza orașului Chișinău." | https://davidan.md/pages/livrare-%C8%99i-achitare |
| Delivery fee borne by client | "Costurile de livrare vor fi suportate de client și vor fi afișate în momentul plasării comenzii." | https://davidan.md/pages/meniu-bauturi (T&C §6) |
| Delivery zone | Only Chișinău is named: "în raza orașului Chișinău" (fee) and "pentru comenzile plasate în orașul Chișinău" (time). Zones outside Chișinău: NOT FOUND. Shopify `ships_to_countries`: `["MD"]`. | livrare page; https://davidan.md/meta.json |
| Delivery time | "Termenul de livrare variază în funcție de adresa de livrare și de disponibilitatea produselor comandate. În general, termenul de livrare este de 5/60 minute pentru comenzile plasate în orașul Chișinău." ("5/60 minute" is verbatim and ambiguous) | https://davidan.md/pages/livrare-%C8%99i-achitare |
| Payment methods | "Comenzile pot fi achitate prin intermediul plății în numerar sau prin intermediul POS-ului la curier." | https://davidan.md/pages/livrare-%C8%99i-achitare |
| Payment methods (T&C) | "Plata produselor se poate prin (cash la curier sau card la curier) metodele de plată acceptate de magazin. Produsele comandate vor fi achitate la primirea comenzii" | https://davidan.md/pages/meniu-bauturi (T&C §5) |
| Total shown before checkout | "Costul total al comenzii, inclusiv costul livrării, va fi afișat înainte de finalizarea comenzii." | livrare page |
| Prices | "Prețurile produselor sunt afișate în lei, includ TVA și nu includ costul transportului." | T&C §3 |
| Order acceptance | "Comanda este considerată acceptată de către magazin doar după confirmarea acesteia prin email." | T&C §4 |
| Cart page notes | "Taxele de livrare sunt calculate automat" and heading "Comenzile online momentan sunt dezactivate !" | https://davidan.md/cart |
| Minimum order | NOT FOUND | — |
| Delivery hours | NOT FOUND | — |
| Free-delivery threshold | NOT FOUND | — |
| Pickup / self-collection | NOT FOUND in any customer-facing text. Technical hint: the store's UCP profile (https://davidan.md/.well-known/ucp) lists fulfillment `"method_combinations": [["shipping"]]` only, with no pickup method. | — |

**Important finding: online ordering is currently switched off.** The cart page (https://davidan.md/cart, checked with one item in a test cart, which was emptied afterwards) shows the heading, verbatim:

> Comenzile online momentan sunt dezactivate !

`/cart/shipping_rates.json` returned `{"shipping_rates":[]}` for a Chișinău/MD address, so no live shipping rate is configured or exposed. The "Finalizare" button still links to `/checkout`, which redirects to a Shopify checkout (`/checkouts/cn/.../en-md`). I did not go further.

Technical note, not customer copy: the auto-generated UCP profile lists Google Pay and Shopify card handlers (visa, master, american_express, discover, diners_club). These are most likely Shopify platform-level defaults and they conflict with the site's own text ("numerar" / "POS-ului la curier"). **Use the site text.**

---

## 5. Russian version check

**Verdict: NO, davidan.md has no Russian version.** Published locales are **`en` (root, default; its content is Romanian)** and **`ro` (`/ro`, machine-translated copy)**.

Evidence:

- `<head>` hreflang tags on https://davidan.md/ (identical on /ro and on `/?locale=ru`):

```html
<link rel="alternate" hreflang="x-default" href="https://davidan.md/">
<link rel="alternate" hreflang="en" href="https://davidan.md/">
<link rel="alternate" hreflang="ro" href="https://davidan.md/ro">
```

- `https://davidan.md/sitemap.xml` indexes only root sitemaps and `/ro/sitemap_*` sitemaps, with no `/ru/`.
- Root page: `<html ... lang="en">`, `Shopify.locale = "en"`, and it preloads `/checkouts/internal/preloads.js?locale=en-MD`. `/ro`: `<html ... lang="ro">`, `Shopify.locale = "ro"`.
- HTTP probes: `/ru` → 404, `/ru-md` → 404, `/ru-ru` → 404, `/ru/collections` → 404, `/ru/products/apa-davidan` → 404, `/en` → 404, `/en-md` → 404, `/ro-md` → 404, `/ro` → 200, `/ro/collections` → 200.
- `/?locale=ru` and `/?_locale=ru` → 200 but still `Shopify.locale = "en"`. Sending the `Accept-Language: ru` header → still `en`.
- No language or country switcher in the HTML: no `/localization` form, no `language_code` / `locale_code` inputs. `GET /localization` → 404. `/browsing_context_suggestions.json` returns `"suggestions":[]`.
- Differences on /ro are machine translations of product titles in `/ro/products.json`, verbatim root → /ro: "Donuts Oreo" → "Gogoși", "Muffins Orange" → "Briose", "Burn 0.25l" → "Arde 0,25 l", "Fuze Tea" → "ceaiul focos", "Rich Kids" → "Copii bogați", "Ice Latte" → "Latte cu gheață", "Lemonade" → "Limonadă", "Red Bull" → "Taur rosu". The menu item "Contact" becomes "a lua legatura".

Russian copy for the app: NOT FOUND on davidan.md. It would have to come from another source (e.g. the client).

---

## 6. Water (Apa DaviDan)

### 6.1 Products (collection Băuturi / `meniu-bauturi`)

| Name | Handle | Price | Variants (option "Tip") | Vendor | Description | Image URL | Label text visible in the image (read from the photo, NOT site text) |
|---|---|---|---|---|---|---|---|
| Apa DaviDan | `dorna` (sic: handle is `dorna`) | 15.00 MDL | Naturală = 15.00 MDL; Gazată = 15.00 MDL | La Dănuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/davidan_1_2.png?v=1765018747 | Blue bottle: "DAVIDAN", "Apă potabilă Necarbogazificată", "0,5L" |
| Apa DaviDan | `apa-davidan` | 15.00 MDL | none (Default Title) | La Danuț | *(empty on site)* | https://cdn.shopify.com/s/files/1/0580/2777/0028/files/davidan_1_3.png?v=1765018857 | Green bottle: "DAVIDAN", "Apa potabilă Carbogazificată", "0,5L" |

- There are two products with the identical title "Apa DaviDan" and the same price. The `dorna` product (created 2021-07-03) has Naturală/Gazată variants and a still-water (blue) photo. The `apa-davidan` product (created 2025-12-06) has no variants and a sparkling (green) photo.
- **Sizes: NOT FOUND in site text.** "0,5L" appears only printed on the bottle photos. No other sizes (1.5L, 5L, 19L etc.) are listed.
- Product-page text is empty ("Descriere" tab is blank). The product page shows "Brand:" as La Dănuț / La Danuț.
- Related DaviDan-branded drinks in the same collection: "Suc Davidan" (`lemonade-copy`, Ingrediente: Mere / Fructe de padure, 25.00 MDL each) and "Compot Davidan" (`compot-davidan`, Alege: Compot, 25.00 MDL, no image). See the Băuturi table.

### 6.2 Water copy on the site (verbatim)

Header top bar, on every page:

> Comandă apa DaviDan în grupul de Telegram

("Telegram" links to https://t.me/davidanwater)

Homepage slider tile (href empty):

> Apă naturală  
> Apa purificată și revitalizantă pe care o oferim este esențială pentru sănătatea ta

About page (https://davidan.md/pages/despre-noi):

> Apa DaviDan  
> Puritate naturală, îmbuteliată pentru hidratare premium în fiecare sticlă.

Blog post https://davidan.md/blogs/news/apa-davidan-puritate-%C8%99i-refrescare-in-fiecare-sticla (dated Aug 24, 2024, "By DaviDan Bakery", image https://davidan.md/cdn/shop/articles/photo_5294145748012305182_y.jpg?v=1765019167):

> **Apa DaviDan, puritate și refrescare în fiecare sticlă**  
> Apa DaviDan este mai mult decât o simplă băutură – este o experiență de răcorire pură și revitalizantă. Îmbuteliată la sursă, apa noastră oferă o puritate impecabilă și un gust proaspăt care vă va răcori în orice moment al zilei. DaviDan se angajează să ofere apa de cea mai înaltă calitate, asigurându-se că fiecare sticlă este supusă unor teste riguroase pentru a garanta un produs sigur și sănătos. Indiferent dacă sunteți acasă sau în mișcare, apa DaviDan este alegerea ideală pentru hidratarea și răcorirea dumneavoastră.

### 6.3 External water links

| Link | Where on davidan.md | Status when checked |
|---|---|---|
| https://t.me/davidanwater | Header top bar ("Comandă apa DaviDan în grupul de Telegram") | Live. Telegram page title "💦 DaviDan Water 💦", "1 367 subscribers", no channel description. |
| https://davidanwater.md | Homepage logo strip: the second logo (`alt="Logo 2"`, image https://davidan.md/cdn/shop/files/1-removebg-preview_1.png?v=1724423260) links here, `target="_blank"` | **Domain does not resolve.** Google DNS-over-HTTPS returns NXDOMAIN (Status 3) for A and NS, so the link is dead. |
| Water Instagram | — | NOT FOUND (the only Instagram link is the bakery's, see section 8) |

---

## 7. Other sub-brands (sushi, rent car, water, restaurant) and other pages

| Sub-brand | What exists on davidan.md | URL(s) |
|---|---|---|
| Sushi | Homepage slider tile "Sushi" (href empty); about-page item "Restaurant Sushi"; one blog post. No products, menu, prices, link or phone. | https://davidan.md/ , https://davidan.md/pages/despre-noi , https://davidan.md/blogs/news/o-experien%C8%9Ba-autentica-a-deliciilor-japoneze |
| Restaurant | Homepage slider tile only (href empty). See section 2. | https://davidan.md/ |
| Water | Two products, a Telegram link, a dead davidanwater.md link, a blog post. See section 6. | see §6 |
| Rent car | **NOT FOUND.** No page, link, product or text; store search for "rent" and "chirie" returns nothing. | — |
| Car wash ("Spălătoire Auto") | Page exists in the sitemap but **contains only its heading** "Spălătoire Auto" (sic). Not linked from the nav or footer. | https://davidan.md/pages/spalatorie-auto |
| Fruits & vegetables | Page exists with **only the heading** "Fructe si legume". Not linked from the nav or footer. | https://davidan.md/pages/fructe-si-legume |
| "Patiserie" page | Page exists with **only the heading** "Patiserie". | https://davidan.md/pages/patiserie |
| Store Locator | Page with a 2021 Storemapper widget (id 12358) that renders "Store Locator is loading from Storemapper store locator...". The widget API returned no data. Not linked from nav. | https://davidan.md/pages/store-locator |
| Careers | "Joburi vacante" heading plus an empty Elfsight widget container (jobs load via third-party JS, not in HTML). | https://davidan.md/pages/vino-in-echipa |

Homepage logo strip: `alt="Logo 1"` → https://davidan.md (image https://davidan.md/cdn/shop/files/Captura_de_ecran_din_2024-08-23_la_16.18.19-removebg-preview.png?v=1724422736) and `alt="Logo 2"` → https://davidanwater.md. There is no sushi or restaurant logo link.

### 7.1 About page — https://davidan.md/pages/despre-noi (verbatim)

> DaviDan - Pasiune pentru Patiserie !  
> La patiseria noastră, fiecare produs este o declarație de dragoste pentru arta patiseriei. Folosim doar ingrediente proaspete, de cea mai bună calitate, și ne mândrim cu rețete tradiționale transmise din generație în generație.  
> Fiecare prăjitură, fiecare croissant și fiecare tartă sunt create cu grijă și atenție la detalii, pentru a vă oferi momente dulci și delicioase.  
> Patiserie  
> Delicii proaspete, pregătite zilnic cu pasiune pentru gusturi autentice.  
> Apa DaviDan  
> Puritate naturală, îmbuteliată pentru hidratare premium în fiecare sticlă.  
> Restaurant Sushi  
> Experiență culinară japoneză autentică, servită cu eleganță și rafinament.  
> DaviDan Bakery  
> Există ceva bun pentru orice moment al zilei. Pentru dimineți grăbite, pentru pauze de răsfăț, pentru sărbători, pentru ceva frumos de sărbătorit sau pentru...pur și simplă poftă! Noi înțelegem toate acestea și, mai mult, ne pregătim în fiecare zi, în consecință. Cu o gamă variată și bogată de produse de patiserie, suntem alegerea ideală pentru tine și cei dragi, oricând ai nevoie de noi. Lucrând doar cu ingrediente de calitate, produsele noastre pot creea dependență. De fericire!  
> Mergi la produse  

(Both the image link and the "Mergi la produse" button have `href=""`.)

### 7.2 Blog posts (verbatim). All are dated Aug 24, 2024, "By DaviDan Bakery"

**O experiență autentică a deliciilor japoneze** — https://davidan.md/blogs/news/o-experien%C8%9Ba-autentica-a-deliciilor-japoneze (image https://davidan.md/cdn/shop/articles/Ebi-Roll-min-768x512_png.webp?v=1724495858)

> Sushi DaviDan aduce autenticitatea și rafinamentul bucătăriei japoneze direct în farfuria dumneavoastră. Fiecare rolă de sushi este preparată cu ingrediente proaspete și de calitate superioară, respectând rețetele tradiționale și tehnicile de preparare autentice. De la sushi-ul clasic la inovații culinare care îmbină arome și texturi, oferim o experiență culinară care încântă toate simțurile. La Sushi DaviDan, ne dedicăm pasiunii pentru gastronomia japoneză și ne angajăm să oferim preparate care sunt atât gustoase, cât și estetic plăcute. Experimentați rafinamentul și savoarea sushi-ului de la DaviDan și lăsați-vă răsfățați de deliciile noastre autentice.

**Găsește Deliciile Patiseriei DaviDan** — https://davidan.md/blogs/news/gase%C8%99te-deliciile-patiseriei-davidan (image https://davidan.md/cdn/shop/articles/403842529_885936499724538_7310870108387325035_n.jpg?v=1724495798)

> La Patiseria DaviDan, ne străduim să aducem în fiecare zi bucurie și savoare în viețile clienților noștri prin produsele noastre de patiserie artizanală. Cu o varietate de produse proaspete și delicioase, de la croissante fragede și pline de unt, la prăjituri sofisticate și pline de aromă, ne asigurăm că fiecare mușcătură este o experiență de neuitat. Folosim doar ingrediente de cea mai înaltă calitate și respectăm tradiții culinare testate pentru a oferi produse care nu doar că satisfac gusturile, dar și încântă simțurile. Veniți să experimentați și să vă răsfățați cu delicatesele noastre unice, doar la DaviDan.

**Apa DaviDan, puritate și refrescare în fiecare sticlă**: full text in §6.2.

---

## 8. Store / contact info

| Item | Verbatim value | Where |
|---|---|---|
| Phone (main) | +373 69 765 805 (`tel:+373 69 765 805`) | Header, mobile menu, contact page ("Telefon"), footer "Administrator:" |
| Phone (procurement) | Manager achiziții: +373 61 181 811 | Footer "Contacte" |
| Email | info@davidan.md | Header, mobile menu, contact page |
| Central office address | "Oficiu central" / "str. Vlaicu Pârcălab 52" | Contact page; header top bar shows "str. Vlaicu Pârcălab 52" |
| Opening hours (company / office) | NOT FOUND | — |
| Instagram | https://www.instagram.com/davidan.bakery/ (the footer `<li>` has class "pinterest" but the icon and link are Instagram). The profile page meta says "32K Followers, 3 Following, 99 Posts" as of the check. | Footer "Urmărește-ne" |
| Facebook | https://www.facebook.com/ (**generic placeholder, not a DaviDan page**) | Footer "Urmărește-ne" |
| Telegram (water) | https://t.me/davidanwater | Header top bar |
| Copyright line | "Copyright 2025 DaviDan Bakery SRL" (the "DaviDan Bakery SRL" text links to https://nextify.md, presumably the web agency) | Footer |
| Newsletter copy | "Abonează-te la noutăți" / "Abonează-te la noutăți pentru a nu rata cele mai tari oferte" / button "Trimite" | Footer |

Homepage stats block (verbatim; note the internal inconsistency between 5.060.000 and 2.000.000):

> 720 Angajați  
> Ne străduim să oferim cât mai multe locuri de muncă  
> 5.060.000 Kurtoşi  
> Am făcut și vândut peste 2.000.000 kurtóși pentru tine  
> 74 Locații  
> Ne-am extins și am ajuns la un număr de 74 locații

Homepage about banner (verbatim, also on /pages/despre-noi):

> Există ceva bun pentru orice moment al zilei. Pentru dimineți grăbite, pentru pauze de răsfăț, pentru sărbători, pentru ceva frumos de sărbătorit sau pentru...pur și simplă poftă! Noi înțelegem toate acestea și, mai mult, ne pregătim în fiecare zi, în consecință. Cu o gamă variată și bogată de produse de patiserie, suntem alegerea ideală pentru tine și cei dragi, oricând ai nevoie de noi. Lucrând doar cu ingrediente de calitate, produsele noastre pot creea dependență. De fericire!

### 8.1 Locations — https://davidan.md/pages/locatii

Index page, verbatim. Link targets are shown. The last four links (Ciorescu, Truseni, Telenesti, Sangera) return **404**.

> Locațiile Patiseriilor DaviDan  
> [Chișinău ( 36 patiserii)](https://davidan.md/pages/loca%C8%9Bii-chi%C8%99inau)  
> [Bălți (2 patiserii)](https://davidan.md/pages/loca%C8%9Bii-bal%C8%9Bi)  
> [Hîncești (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-hince%C8%99ti)  
> [Glodeni(1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-glodeni)  
> [Criuleni (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-magdace%C8%99ti)  
> [Orhei (2 patiserii)](https://davidan.md/pages/loca%C8%9Bii-orhei)  
> [Ungheni (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-ungheni)  
> [Soroca (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-soroca)  
> [Strășeni (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-stra%C8%99eni)  
> [Cricova (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-cricova)  
> [Leova (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-leova)  
> [Cahul (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-cahul)  
> [Călărași (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-calara%C8%99i)  
> [Căușeni (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-cau%C8%99eni)  
> [Ștefan Vodă (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-%C8%99tefan-voda)  
> [Drochia (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-drochia)  
> [Florești (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-flore%C8%99ti)  
> [Briceni (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-briceni)  
> [Șoldănești (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-%C8%99oldane%C8%99ti)  
> [Fălești (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-fale%C8%99ti)  
> [Anenii Noi (1 patiserie)](https://davidan.md/pages/locaa%C8%9Bii-anenii-noi)  
> [Sîngerei (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-singerei)  
> [Budești (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-bude%C8%99ti)  
> [Ialoveni (3 patiserii)](https://davidan.md/pages/loca%C8%9Bii-ialoveni)  
> [Ciorescu (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-ciorescu)  
> [Truseni (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-truseni)  
> [Telenesti (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-telenesti)  
> [Sangera (1 patiserie)](https://davidan.md/pages/loca%C8%9Bii-sangera)  

Data-quality notes (observations only, nothing changed): the "Criuleni" link goes to a page with handle `locații-magdacești`; the "Glodeni" page lists "Or.Sângerei"; the "Hîncești" page lists "OOr. Telenești"; the Chișinău page header claims 36 patiserii but lists 38 "or. Chișinău" entries plus 7 suburban ones; Budești and Strășeni repeat the same entry twice. Only Bălți, Briceni, Budești, Fălești, Florești, Șoldănești and Anenii Noi show "Program" (hours). **Chișinău shops have no hours listed.**

#### Chișinău — https://davidan.md/pages/loca%C8%9Bii-chi%C8%99inau

> Locații Chișinău  
> or. Chișinău  
> 📍 Adresa: str. Alexander Puşkin 44  
> 📱 Telefon: +373 69 050 752  
> or. Chișinău  
> 📍 Adresa: str. Armenească 55  
> 📱 Telefon: +373 79 736 779  
> or. Chișinău  
> 📍 Adresa: str. Bănulescu Bodoni 57  
> 📱 Telefon: +373 68 524 976  
> or. Chișinău  
> 📍 Adresa: str. Bănulescu Bodoni 45  
> 📱 Telefon: +373 69 650 627  
> or. Chișinău  
> 📍 Adresa: str. Burebista 93  
> 📱 Telefon: +373 69 650 627  
> or. Chișinău  
> 📍 Adresa: str. Calea Ieșilor 1A  
> 📱 Telefon: +373 79 841 704  
> or. Chișinău  
> 📍 Adresa: str. Calea Ieșilor 39/1  
> 📱 Telefon: +373 79 841 704  
> or. Chișinău  
> 📍 Adresa: str. Calea Moșilor 2A  
> 📱 Telefon: +373 76 982 319  
> or. Chișinău  
> 📍 Adresa: bd. Dacia 5/4  
> 📱 Telefon: +373 69 108 212  
> or. Chișinău  
> 📍 Adresa: bd. Dacia 14/1  
> 📱 Telefon: +373 69 108 212  
> or. Chișinău  
> 📍 Adresa: bd. Dacia 31  
> 📱 Telefon: +373 69 108 212  
> or. Chișinău  
> 📍 Adresa: bd. Decebal 80/1  
> 📱 Telefon: +373 69 895 936  
> or. Chișinău  
> 📍 Adresa: str. Decebal 91/4  
> 📱 Telefon: +373 69 765 805  
> or. Chișinău  
> 📍 Adresa: str. Eugen Coca 24  
> 📱 Telefon: +373 79 580 848  
> or. Chișinău  
> 📍 Adresa: bd. Grigore Vieru 24  
> 📱 Telefon: +373 76 570 635  
> or. Chișinău  
> 📍 Adresa: str. Ion Creangă 49  
> 📱 Telefon: +373 69 153 076  
> or. Chișinău  
> 📍 Adresa: str. Ion Creangă 64  
> 📱 Telefon: +373 69 153 076  
> or. Chișinău  
> 📍 Adresa: șos. Hâncești 216  
> 📱 Telefon: +373 69 765 805  
> or. Chișinău  
> 📍 Adresa: șos. Hâncești 364  
> 📱 Telefon: +373 69 765 805  
> or. Chișinău  
> 📍 Adresa: str. Ismail 55  
> 📱 Telefon: +373 68 013 399  
> or. Chișinău  
> 📍 Adresa: str. Ismail 86  
> 📱 Telefon: +373 68 940 666  
> or. Chișinău  
> 📍 Adresa: str. Kiev 16/1  
> 📱 Telefon: +373 79 580 848  
> or. Chișinău  
> 📍 Adresa: str. Mihai Eminescu 74  
> 📱 Telefon: +373 79 736 779  
> or. Chișinău  
> 📍 Adresa: str. Minsk 49/1  
> 📱 Telefon: +373 79 736 779  
> or. Chișinău  
> 📍 Adresa: str. Mircea cel Bătrân 22/3  
> 📱 Telefon: +373 69 765 805  
> or. Chișinău  
> 📍 Adresa: str. Mircea cel Bătrân 41A  
> 📱 Telefon: +373 69 867 009  
> or. Chișinău  
> 📍 Adresa: str. Mircea cel Bătrân 7  
> 📱 Telefon: +373 68 147 951  
> or. Chișinău  
> 📍 Adresa: str. Mitropolit Varlam 58  
> 📱 Telefon: +373 76 570 635  
> or. Chișinău  
> 📍 Adresa: bd. Moscova 28/2  
> 📱 Telefon: +373 79 580 848  
> or. Chișinău  
> 📍 Adresa: str. Nicolae Costin 67/2  
> 📱 Telefon: +373 60 009 360  
> or. Chișinău  
> 📍 Adresa: str. Nicolae Zelinschi 5/6  
> 📱 Telefon: +373 68 013 399  
> or. Chișinău  
> 📍 Adresa: str. Sprâncenoaia 1A  
> 📱 Telefon: +373 69 066 702  
> or. Chișinău  
> 📍 Adresa: bd. Ștefan cel Mare 194  
> 📱 Telefon: +373 69 230 713  
> or. Chișinău  
> 📍 Adresa: str. Vasile Alecsandri 78  
> 📱 Telefon: +373 69 993 881  
> or. Chișinău  
> 📍 Adresa: str. Vlaicu Pârcălab 45  
> 📱 Telefon: +373 67 131 614  
> or. Chișinău  
> 📍 Adresa: str. Vlaicu Pârcălab 52  
> 📱 Telefon: +373 78 256 509  
> or. Chișinău  
> 📍 Adresa: șos Hâncești 216  
> 📱 Telefon: +373 60 111 717  
> or. Chișinău  
> 📍 Adresa: șos Hâncești 60/4  
> 📱 Telefon: +373 69 511 909  
> S. Băcioi  
> 📍 Adresa: str. Independenței 68/2  
> 📱 Telefon: +373 68 568 563  
> Com. Budești  
> 📍 Adresa: str. Chişinăului 1/J  
> 📱 Telefon: +373 78 311 737  
> Com. Ciorescu  
> 📍 Adresa: str. Alexandru cel Bun 23  
> 📱 Telefon: +373 60 075 458  
> Or. Cricova  
> 📍 Adresa: str. Chișinăului 86/1  
> 📱 Telefon: +373 60 068 292  
> S.Ghidighici  
> 📍 Adresa: S.Ghidighici  
> 📱 Telefon: +373 60 068 292  
> Or.Sângera  
> 📍 Adresa: str. 31 August nr.3  
> 📱 Telefon: +373 679 713 172  
> S. Trușeni  
> 📍 Adresa: Strada Ștefan cel Mare 1B  
> 📱 Telefon: +373 69 430 237  

#### Bălți — https://davidan.md/pages/loca%C8%9Bii-bal%C8%9Bi

> Locații Bălți  
> mun. Bălți  
> Adresa: str. Decebal 126  
> Telefon: +373 68 444 250  
> Program: Luni - Dum: 08:00 - 21:00  
> mun. Bălți  
> Adresa: str. Independenței 37  
> Telefon: +373 68 444 250  
> Program: Luni - Dum: 08:00 - 21:00  

#### Hîncești — https://davidan.md/pages/loca%C8%9Bii-hince%C8%99ti

> Locații Hîncești  
> OOr. Telenești  
> 📍 Adresa: str. Dacia 15  
> 📱 Telefon: +373 76 721 765  

#### Glodeni — https://davidan.md/pages/loca%C8%9Bii-glodeni

> Locații Glodeni  
> Or.Sângerei  
> 📍 Adresa: str. Independenței 132B  
> 📱 Telefon: +373 76 721 765  

#### Criuleni (handle magdacești) — https://davidan.md/pages/loca%C8%9Bii-magdace%C8%99ti

> Locații Criuleni  
> or. Criuleni  
> 📍 Adresa: sat. Porumbeni  
> 📱 Telefon: +373 60 068 292  

#### Orhei — https://davidan.md/pages/loca%C8%9Bii-orhei

> Locații Orhei  
> or. Orhei  
> 📍 Adresa: str. Mihai Eminescu 10  
> 📱 Telefon: +373 79 198 954  

#### Ungheni — https://davidan.md/pages/loca%C8%9Bii-ungheni

> Locații Ungheni  
> mun. Ungheni  
> 📍 Adresa: str. Naționala 15  
> 📱 Telefon: +373 69 165 326  

#### Soroca — https://davidan.md/pages/loca%C8%9Bii-soroca

> Locații Soroca  
> or. Soroca  
> 📍 Adresa: str. Alecsandru cel Bun 2  
> 📱 Telefon: +373 68 442 591  
> or. Soroca  
> 📍 Adresa: str. Alhionia 10  
> 📱 Telefon: +373 68 442 591  

#### Strășeni — https://davidan.md/pages/loca%C8%9Bii-stra%C8%99eni

> Locații Strășeni  
> or. Strășeni  
> 📍 Adresa: str. Ștefan cel Mare 115  
> 📱 Telefon: +373 78 311 737  
> or. Strășeni  
> 📍 Adresa: str. Ștefan cel Mare 115  
> 📱 Telefon: +373 78 311 737  

#### Cricova — https://davidan.md/pages/loca%C8%9Bii-cricova

> Locații Cricova  
> or. Cricova  
> 📍 Adresa: str. Chișinăului 86/1  
> 📱 Telefon: +373 60 068 292  

#### Leova — https://davidan.md/pages/loca%C8%9Bii-leova

> Locații Leova  
> or. Leova  
> 📍 Adresa: str. Ștefan cel Mare 76  
> 📱 Telefon: +373 79 221 781  

#### Cahul — https://davidan.md/pages/loca%C8%9Bii-cahul

> Locații Cahul  
> or. Cahul  
> 📍 Adresa: str. 31 August 1989 4  
> 📱 Telefon: +373 78 402 313  

#### Călărași — https://davidan.md/pages/loca%C8%9Bii-calara%C8%99i

> Locații Călărași  
> or. Călărași  
> 📍 Adresa: str. Mihai Eminescu 20  
> 📱 Telefon: +373 67 280 861  

#### Căușeni — https://davidan.md/pages/loca%C8%9Bii-cau%C8%99eni

> Locații Căușeni  
> or. Căușeni  
> 📍 Adresa: bd. Mihai Eminescu 10/R  
> 📱 Telefon: +373 68 902 902  
> or. Căușeni  
> 📍 Adresa: bd. Mihai Eminescu 24  
> 📱 Telefon: +373 68 902 902  

#### Ștefan Vodă — https://davidan.md/pages/loca%C8%9Bii-%C8%99tefan-voda

> Locații Ștefan Vodă  
> or. Ștefan Vodă  
> 📍 Adresa: str. Libertății 2  
> 📱 Telefon: +373 69 894 267  

#### Drochia — https://davidan.md/pages/loca%C8%9Bii-drochia

> Locații Drochia  
> or. Drochia  
> 📍 Adresa: str. Independenței 8, nr3  
> 📱 Telefon: +373 69 560 392  

#### Florești — https://davidan.md/pages/loca%C8%9Bii-flore%C8%99ti

> Locații Florești  
> or. Florești  
> Adresa: str. Gării 3  
> Telefon: +373 67 604 059  
> Program: Luni - Dum: 07:00 - 21:00  

#### Briceni — https://davidan.md/pages/loca%C8%9Bii-briceni

> Locații Briceni  
> or. Briceni  
> Adresa: str. Prieteniei 3 B  
> Telefon: +373 69 233 281  
> Program: Luni - Dum: 07:00 - 21:00  

#### Șoldănești — https://davidan.md/pages/loca%C8%9Bii-%C8%99oldane%C8%99ti

> Locații Șoldănești  
> or. Șoldănești  
> Adresa: str. Păcii 2  
> Telefon: +373 69 209 119  
> Program: Luni - Dum: 08:00 - 21:00  

#### Fălești — https://davidan.md/pages/loca%C8%9Bii-fale%C8%99ti

> Locații Fălești  
> or. Fălești  
> Adresa: str. Mihai Eminescu 1  
> Telefon: +373 78 737 588  
> Program: Luni - Vin: 07:00 - 21:00  
> Sam - Dum: 08:00 - 21:00  

#### Anenii Noi — https://davidan.md/pages/locaa%C8%9Bii-anenii-noi

> Locații Anenii Noi  
> or. Anenii Noi  
> Adresa: str. Concilierii Nationale 8  
> Telefon: +373 78 109 669  
> Program: Luni - Dum: 08:00 - 21:00  
> or. Anenii Noi  
> Adresa: S. Chetrosu  
> Telefon: +373 78 109 669  
> Program: Luni - Dum: 08:00 - 21:00  
> or. Anenii Noi  
> Adresa: Satul Mereni  
> Telefon: +373 78 109 669  
> Program: Luni - Dum: 08:00 - 21:00  

#### Sîngerei — https://davidan.md/pages/loca%C8%9Bii-singerei

> Locații Sîngerei  
> Or.Sângerei  
> 📍 Adresa: str. Independenței 132B  
> 📱 Telefon: +373 76 721 765  

#### Budești — https://davidan.md/pages/loca%C8%9Bii-bude%C8%99ti

> Locații Budești  
> or. Budești  
> Adresa: str. Chişinăului 1/J  
> Telefon: +373 78 311 737  
> Program: Luni - Dum: 08:00 - 21:00  
> or. Budești  
> Adresa: str. Chişinăului 1/J  
> Telefon: +373 78 311 737  
> Program: Luni - Dum: 08:00 - 21:00  

#### Ialoveni — https://davidan.md/pages/loca%C8%9Bii-ialoveni

> Locații Ialoveni  
> or. Ialoveni  
> 📍 Adresa: r. Ialoveni  
> 📱 Telefon: +373 79 566 566  
> or. Ialoveni  
> 📍 Adresa: s. Costesti  
> 📱 Telefon: +373 69 157 247  
> or. Ialoveni  
> 📍 Adresa: s. Suruceni str. Olimpicilor 10  
> 📱 Telefon: +373 60 111 717  

---

## 9. Gaps: NOT FOUND on davidan.md

- Restaurant menu, dishes, prices or images (only a placeholder tile with an empty link and a `Orez-cu-pui.png` background)
- Sushi menu, products or prices
- Rent-car sub-brand (no mention at all)
- Russian locale or any Russian copy
- Minimum order value, free-delivery threshold, delivery hours, delivery zones outside Chișinău
- Pickup / self-collection option (in text)
- Dedicated returns/refund policy page (only T&C clause 7); all Shopify `/policies/*` URLs are 404
- Company opening hours; hours for Chișinău shops
- Water bottle sizes in text (0,5L only visible on product photos); water descriptions (empty)
- A working water website (davidanwater.md is NXDOMAIN); a real Facebook page (the link is a generic facebook.com placeholder)
- Collection descriptions (all 4 are empty strings)
- Names/prices of the extra items implied by collections.json `products_count` (not public)

## 10. Raw files

`research/raw/`: `home.html`, `collections.json`, `products_1.json`, `coll_<handle>.json`, `ro_products.json`, `sitemap.xml`, `pages/*.html|.txt`, `blogs/*`, `policies/*` (404 bodies), `locale/*` (locale probes), `ro/*` (the /ro legal pages), `search/*` (suggest results), `prod/*` (water product pages and images), `ucp.json`, `cart.html`, `tme.html`, `insta.html`, `agents.md`.
