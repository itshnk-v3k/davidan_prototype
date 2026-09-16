# DaviDan Sushi (davidansushi.md): source data, verbatim

- Fetched: 2026-09-16 with raw `curl -sL` (no WebFetch). Every name, price, weight and text below was copied programmatically from the live HTML/JSON.
- Raw evidence (HTML/JSON/CSS as downloaded): `research/dsraw/` (product pages in `dsraw/prod/<id>_ro.html` and `<id>_ru.html`; parsing scripts in `dsraw/scripts/`).
- Machine-readable menu (same data as section 2, includes the raw description HTML): `research/davidansushi_md_menu.json`.
- "NOT FOUND" means that I searched the fetched pages and the site did not say it.

---

## 0. Platform and URL scheme

| Item | Finding | Evidence |
|---|---|---|
| CMS | WordPress 6.8.8 + WooCommerce + Elementor / Pro Elements | `wp-content/plugins/woocommerce`, `elementor`, `pro-elements`; `wp-includes/.../style.min.css?ver=6.8.8` |
| Theme | Woodmart 7.3.4, renamed folder `wp-content/themes/davidansushi` | `css/parts/*.min.css?ver=7.3.4`, `wd-*` classes, `xts-theme_settings_default` CSS |
| Multilingual | TranslatePress (`translatepress-multilingual` 3.3.4). It translates rendered strings, and product slugs stay the same in both languages. | body class `translatepress-ro_RO` / `translatepress-ru_RU` |
| Other plugins seen | The SEO Framework (meta), Hostinger Reach (CSS only), Google Tag Manager | page head |
| Language scheme | RO is the default at the root, RU sits under the `/ru/` prefix. hreflang: `ro-RO`/`ro` → `https://davidansushi.md/`, `ru-RU`/`ru` → `https://davidansushi.md/ru/`. The switcher link reads "RU" on RO pages and "RO" on RU pages. | `<link rel="alternate" hreflang=...>` |
| URL patterns | Product `https://davidansushi.md/product/<slug>/` ↔ `https://davidansushi.md/ru/product/<slug>/`. Category `…/meniu/<parent>/<child>/` ↔ `…/ru/meniu/<parent>/<child>/`. Pages `…/livrare-si-achitare/` ↔ `…/ru/livrare-si-achitare/` (same slug). | links in the pages |
| Data endpoints | `GET /wp-json/wc/store/v1/products?per_page=100&page=1..2` (X-WP-Total: **102**), `GET /wp-json/wc/store/v1/products/categories?per_page=100` (19 terms), `GET /wp-json/wp/v2/pages` (8 pages), `sitemap.xml` (home, 3 pages, 102 products). `/ru/wp-json/...` returns the same JSON with some words run through TranslatePress, so it is **not** reliable for RU. RU data below comes from the rendered `/ru/product/<slug>/` HTML. | |
| Ordering on site | **Catalog mode is ON**: body class `catalog-mode-on`, and none of the 102 product pages has an add-to-cart button. `/cos/` (cart) and `/finalizare-comanda/` (checkout), in RO and RU, both redirect to the homepage. The header still shows a cart widget "0 items 0,00 MDL". The site acts as a menu/catalog, and the delivery page sends customers to Glovo and Straus (section 5). | `prod/*.html`, curl `url_effective` |
| Currency display | RO `145,00 MDL`, RU `145,00 лей` (identical numbers on all 102 products) | product pages |
| Matching RO↔RU | By WooCommerce post ID (`postid-NNNN` body class, `data-id`), which is identical on both language pages. All 102 IDs matched, with no guessing. | |

WP pages (from `/wp-json/wp/v2/pages`): `acasa` (id 23, home), `meniu` (11), `livrare-si-achitare` (21, modified 2025-07-14), `termeni-si-conditii` (47, 2024-01-09), `politica-de-confidentialitate` (28, 2024-04-05), `cos` (12), `finalizare-comanda` (13), `contul-meu` (14). No blog posts (`/wp/v2/posts` is empty). There is **no** separate returns page, FAQ or About page.

---

## 1. Category tree (RO / RU), counts and price ranges

Names come from the "Categorii de produse" / "Категории товаров" widget on `/meniu/` and `/ru/meniu/`. The same term can appear under a different label in the header nav, on homepage section headings or on homepage tabs. Those variants are listed verbatim.

| Cat ID | slug | Parent | RO name (category) | RU name (category) | Products | Price range (MDL) | Other labels seen on site (verbatim) |
|---|---|---|---|---|---|---|---|
| 52 | `sushi` | — | Sushi | Суши | 32 | 50–200 | — |
| 37 | `roluri` | 52 | Roluri | Ролы | 20 | 120–200 | homepage tab RO "Roluri", RU "Ролы" |
| 38 | `tempura` | 52 | Tempura | Темпура | 6 | 120–155 | — |
| 39 | `maki` | 52 | Maki | Маки | 6 | 50–90 | — |
| 50 | `seturi` | — | Seturi | Сеты | 9 | 125–900 | — |
| 53 | `bucate-thai` | — | Bucate Thai | Тайские блюда | 13 | 85–135 | — |
| 44 | `orez` | 53 | Orez | Рис | 3 | 85–115 | — |
| 45 | `soba` | 53 | Soba | Soba (untranslated) | 3 | 100–130 | homepage tab RO "Sobă", RU "Соба" |
| 46 | `udon` | 53 | Udon | Удон | 4 | 100–130 | — |
| 54 | `funcioza` | 53 | Funcioza | Фунчоза | 3 | 100–135 | — |
| 51 | `supe` | — | Supe | Супы | 5 | 70–130 | RO desktop nav "Supă", homepage heading "Supa", mobile nav "Supe". RU desktop nav and homepage heading "Cупы" (**first letter is Latin "C" U+0043**), mobile nav "Супы" (Cyrillic) |
| 47 | `salate` | — | Salate | Салаты | 6 | 75–129 | — |
| 48 | `poke-bowl` | — | Poke bowl | Poke bowl | 3 | 155–165 | nav/heading "Poke Bowl" in both languages |
| 42 | `gustari` | — | Gustări | Закуски | 18 | 35–190 | RO homepage heading "Gustari" (no diacritic) |
| 49 | `deserturi` | — | Deserturi | Десерты | 5 | 30–85 | — |
| 93 | `bauturi` | — | Băuturi | Напитки | 11 | 23–225 | **not in the header nav** (the nav has 8 items). Shown only as a homepage section and in the category widget |
| 97 | `bauturi-racoritoare` | 93 | Băuturi răcoritoare | Безалкогольные напитки | 8 | 23–28 | — |
| 102 | `bauturi-cu-alcool` | 93 | Băuturi cu alcool | Băuturi cu alcool (**untranslated on RU**) | 3 | 225 | — |
| 99 | `vin` | 102 | Vin | Vin (**untranslated on RU**) | 3 | 225 | — |

Header nav order (desktop and mobile, both languages): Sushi, Seturi, Bucate Thai, Supă/Supe, Salate, Poke Bowl, Gustări, Deserturi → RU: Суши, Сеты, Тайские блюда, Cупы/Супы, Салаты, Poke Bowl, Закуски, Десерты. Anchors: `/#sushi`, `/#seturi`, `/#bucate-thai`, `/#supa`, `/#salate`, `/#poke-bowl`, `/#gustari`, `/#deserturi` (mobile: `/#msushi` …).

Nav icons (same for RO/RU): Sushi `https://davidansushi.md/wp-content/uploads/2023/12/sushi-1.png`, Seturi `…/2023/12/maki-1.png`, Bucate Thai `…/2023/12/poke.png`, Supe `…/2023/12/hot-soup.png`, Salate `…/2023/12/asian-salad.png`, Poke Bowl `…/2023/12/ramen.png`, Gustări `…/2023/12/french-fries.png`, Deserturi `…/2023/12/futomaki.png`. (The category term image for `sushi` in the API is `…/2023/12/sushi.png`, while the nav uses `sushi-1.png`.)

The homepage shows 77 of the 102 products, from the default tab of each section. The other 25 sit behind AJAX tabs (Tempura, Maki, Soba, Udon, Funcioza, Băuturi cu alcool): the 6 Tempura products including SushiDog, 6 Maki, 3 Soba, 4 Udon, 3 Funcioza and 3 wines. Every product has its own product page.

---

## 2. Full menu: every product, RO + RU

Notes on reading the tables:
- **ID** = WooCommerce post ID (the key that links RO and RU). **slug** is identical in both languages.
- Products are sorted alphabetically by RO name, which is the order the category archive pages use (checked on `/meniu/sushi/roluri/`).
- Each product sits in its deepest (leaf) category. WooCommerce also tags some products with the parent (e.g. 12 rolls are tagged both `roluri` and `sushi`), and the JSON has `category_ids`.
- Attributes: RO labels `Masa` (weight/volume) and `Bucăți` (pieces). RU labels `Вес` and `Количество`. Units are verbatim (RU mixes `g`/`г`, `ml`/`мл`, `buc`/`шт`).
- RU text on the site is **only partly translated** (TranslatePress works word by word). Many RU names and ingredients are still in Romanian. That is what the RU site actually shows, so it is reproduced as-is.
- Descriptions: every product has an empty long description and no description tab. The only text is the WooCommerce short description, shown below.

### Sushi / Суши  (top category id 52, slug `sushi`)

RO: https://davidansushi.md/meniu/sushi/ · RU: https://davidansushi.md/ru/meniu/sushi/ · 32 products · 50–200 MDL

#### Roluri / Ролы  (category id 37, slug `roluri`, parent id 52) — 20 products, 120–200 MDL

RO: https://davidansushi.md/meniu/sushi/roluri/ · RU: https://davidansushi.md/ru/meniu/sushi/roluri/

| ID | slug | RO name | RU name | Price RO / RU | RO attributes | RU attributes | Image (full size) |
|---|---|---|---|---|---|---|---|
| 5210 | `alasca` | Alasca | Аляска | 170,00 MDL / 170,00 лей | Masa: 250g | Вес: 250г | https://davidansushi.md/wp-content/uploads/2024/10/Alaska.jpg |
| 5207 | `california-creveti` | California Creveți | California Creveți | 165,00 MDL / 165,00 лей | Masa: 270g | Вес: 270g | https://davidansushi.md/wp-content/uploads/2024/10/California-Tobico.jpg |
| 5208 | `canada` | Canada | Канада | 200,00 MDL / 200,00 лей | Masa: 270g | Вес: 270g | https://davidansushi.md/wp-content/uploads/2024/10/Canada-min.jpg |
| 5366 | `canada-creveti` | Canada Creveți | Canada Creveți | 200,00 MDL / 200,00 лей | Masa: 270g | Вес: 270g | https://davidansushi.md/wp-content/uploads/2024/10/canada-cu-cerveti-1-1.jpg |
| 5442 | `chyka-roll` | Chyka Roll | Chyka Roll | 120,00 MDL / 120,00 лей | Masa: 300g | Вес: 300г | https://davidansushi.md/wp-content/uploads/2024/10/chuka_roll-min.jpg |
| 7194 | `crunchy-tony` | Crunchy Tony | Crunchy Tony | 149,00 MDL / 149,00 лей | Masa: 260g | Вес: 260g | https://davidansushi.md/wp-content/uploads/2025/09/crunchy_tony-min-scaled.jpg |
| 5211 | `dragon-verde` | Dragon Verde | Зеленый Дракон | 145,00 MDL / 145,00 лей | Masa: 280g | Вес: 280г | https://davidansushi.md/wp-content/uploads/2024/10/Dragon-Verde-min.jpg |
| 5209 | `ebi-roll` | Ebi Roll | Еби ролл | 160,00 MDL / 160,00 лей | Masa: 280g | Вес: 280г | https://davidansushi.md/wp-content/uploads/2024/10/Ebi-Roll-min.jpg |
| 5213 | `haruto` | Haruto | Харуто | 200,00 MDL / 200,00 лей | Masa: 320g | Вес: 320г | https://davidansushi.md/wp-content/uploads/2024/10/Haruto-min.jpg |
| 5367 | `kyoto` | Kyoto | Kyoto | 180,00 MDL / 180,00 лей | Masa: 270g | Вес: 270g | https://davidansushi.md/wp-content/uploads/2024/10/kyoto-min.jpg |
| 7200 | `oh-my-cheeseus` | Oh my cheeseus | Oh my cheeseus | 169,00 MDL / 169,00 лей | Masa: 355g | Вес: 355g | https://davidansushi.md/wp-content/uploads/2025/09/ooooohhhhhhhhh-min-scaled.jpg |
| 5205 | `philadelphia-classic` | Philadelphia Classic | Филадельфия Классик | 145,00 MDL / 145,00 лей | Masa: 280g | Вес: 280г | https://davidansushi.md/wp-content/uploads/2024/10/Philadephia-Classic-min.jpg |
| 5441 | `philadelphia-cu-creveti` | Philadelphia cu Creveți | Philadelphia cu Creveți | 170,00 MDL / 170,00 лей | Masa: 320g | Вес: 320г | https://davidansushi.md/wp-content/uploads/2024/10/philadelphia_creveti-min.jpg |
| 5206 | `philadelphia-ebi` | Philadelphia Ebi | Филадельфия Эби | 160,00 MDL / 160,00 лей | Masa: 280g | Вес: 280г | https://davidansushi.md/wp-content/uploads/2024/10/Philla-Ebi-min.jpg |
| 5364 | `philadelphia-flambe` | Philadelphia Flambe | Philadelphia Flambe | 150,00 MDL / 150,00 лей | Masa: 280g | Вес: 280г | https://davidansushi.md/wp-content/uploads/2024/10/philadelphia-flambe-min.jpg |
| 7206 | `salmon-bliss` | Salmon Bliss | Salmon Bliss | 169,00 MDL / 169,00 лей | Masa: 350g | Вес: 350g | https://davidansushi.md/wp-content/uploads/2025/09/salmon_bliss-min-scaled.jpg |
| 7209 | `salmon-explosion` | Salmon Explosion | Salmon Explosion | 179,00 MDL / 179,00 лей | Masa: 285g | Вес: 285g | https://davidansushi.md/wp-content/uploads/2025/09/salmon_explosion-min-scaled.jpg |
| 7203 | `shrimps-explosion` | Shrimps Explosion | Shrimps Explosion | 179,00 MDL / 179,00 лей | Masa: 270g | Вес: 270g | https://davidansushi.md/wp-content/uploads/2025/09/shrimps_explosion-min-scaled.jpg |
| 7197 | `spicy-tuna` | Spicy Tuna | Spicy Tuna | 149,00 MDL / 149,00 лей | Masa: 320g | Вес: 320г | https://davidansushi.md/wp-content/uploads/2025/09/spicy_tuna-min-scaled.jpg |
| 5212 | `tuna-roll` | Tuna Roll | Туна Ролл | 140,00 MDL / 140,00 лей | Masa: 270g | Вес: 270g | https://davidansushi.md/wp-content/uploads/2024/10/Tuna-Roll-min.jpg |

Composition (verbatim short description; bold = `<strong>` label, ` · ` separates `<li>` items; commas/periods/typos are the site's own):

| ID | RO name | RO composition | RU composition |
|---|---|---|---|
| 5210 | Alasca | **Ingrediente:** nori · orez · cremă de brânză · castravete · somon · tobico | **Ингредиенты:** нори · рис · сливочный сыр · огурец · лосось · тобико |
| 5207 | California Creveți | **Ingrediente:** nori · orez · cream de brânză · castraveți · maioneză japoneză · creveți · tobico | **Ингредиенты:** нори · рис · cream de brânză · огурцы · maioneză japoneză · креветки · тобико |
| 5208 | Canada | **Ingrediente:** nori · orez · cremă de brânză · castravete · somon · țipar · sos unaghi · susan | **Ингредиенты:** нори · рис · сливочный сыр · огурец · лосось · угорь · соус унаги · кунжут |
| 5366 | Canada Creveți | **Ingrediente:** nori · orez · cremă de brânză · creveți · țipar · tobico · sos unaghi · castravete · susan | **Ингредиенты:** нори · рис · сливочный сыр · креветки · угорь · тобико · соус унаги · огурец · кунжут |
| 5442 | Chyka Roll | **Ingrediente** orez, nori · cremă de brânză · avocado · somon grill · chyka · susan · sos de nuci | **Ingrediente** orez, nori · сливочный сыр · авокадо · somon grill · chyka · кунжут · sos de nuci |
| 7194 | Crunchy Tony | **Ingrediente** nori · orez · ton · daicon murat · sos Sriracha · Masago Arare · susan | **Ingrediente** нори · рис · тунец · daicon murat · sos Sriracha · Masago Arare · кунжут |
| 5211 | Dragon Verde | **Ingrediente:** nori · orez · cremă de brânză · avocado · castravete · somon · sos unaghi · susan | **Ингредиенты:** нори · рис · сливочный сыр · авокадо · огурец · лосось · соус унаги · кунжут |
| 5209 | Ebi Roll | **Ingrediente:** nori · orez · cremă de brânză · castraveți · somon · creveți | **Ингредиенты:** нори · рис · сливочный сыр · огурцы · лосось · креветки |
| 5213 | Haruto | **Ingrediente:** nori · orez · cremă de brânză · castraveți · avocado · ton · somon · țipar · tobico · mango gem | **Ингредиенты:** нори · рис · сливочный сыр · огурцы · авокадо · тунец · лосось · угорь · тобико · джем из манго |
| 5367 | Kyoto | **Ingrediente:** nori · orez · cremă de brânză · castraveți · somon grill · somon · țipar · sos unaghi · susan | **Ингредиенты:** нори · рис · сливочный сыр · огурцы · somon grill · лосось · угорь · соус унаги · кунжут |
| 7200 | Oh my cheeseus | **Ingrediente** nori · orez · cheddar · creveți pane · cremă de brânză · castraveți · fidea de boabe · sos unaghi · sos Kimchi Maio | **Ingrediente** нори · рис · cheddar · креветки в панировке · сливочный сыр · огурцы · fidea de boabe · соус унаги · sos Kimchi Maio |
| 5205 | Philadelphia Classic | **Ingrediente:** nori, · orez, · cremă de brânză, · castravete, · avocado, · somon | **Ингредиенты:** нори · рис · сливочный сыр · огурец · авокадо · лосось |
| 5441 | Philadelphia cu Creveți | **Ingrediente:** orez · nori · cremă de brânză · castraveți · avocado · somon · creveți · sos unaghi · sos spisy | **Ингредиенты:** рис · нори · сливочный сыр · огурцы · авокадо · лосось · креветки · соус унаги · sos spisy |
| 5206 | Philadelphia Ebi | **Ingrediente:** nori · orez · cremă de brânză · castraveți · creveți pane · somon | **Ингредиенты:** нори · рис · сливочный сыр · огурцы · креветки в панировке · лосось |
| 5364 | Philadelphia Flambe | **Ingrediente:** nori · orez · cream de brânză · avocado · somon · sos spicy | **Ингредиенты:** нори · рис · cream de brânză · авокадо · лосось · sos spicy |
| 7206 | Salmon Bliss | **Ingrediente** nori · orez · somon copt · ardei california · cremă de brânză · sos Maio Dulce · sos Sriracha · sos Unaghi · Masago Arare | **Ingrediente** нори · рис · somon copt · ardei california · сливочный сыр · sos Maio Dulce · sos Sriracha · sos Unaghi · Masago Arare |
| 7209 | Salmon Explosion | **Ingrediente** nori · orez · somon · chuka · sos Kimchi Maio · sos unaghi · togarashi · tobico | **Ingrediente** нори · рис · лосось · chuka · sos Kimchi Maio · соус унаги · togarashi · тобико |
| 7203 | Shrimps Explosion | **Ingrediente** nori · orez · creveți · sos Kimchi Maio · maioneză japoneză · sos unaghi · togarashi | **Ingrediente** нори · рис · креветки · sos Kimchi Maio · maioneză japoneză · соус унаги · togarashi |
| 7197 | Spicy Tuna | **Ingrediente** nori · orez · ton · creveți pane · chuka · maioneză japoneză · sos Sriracha · susan | **Ingrediente** нори · рис · тунец · креветки в панировке · chuka · maioneză japoneză · sos Sriracha · кунжут |
| 5212 | Tuna Roll | **Ingrediente:** nori · orez · cremă de brânză · castravete · ton · somon · mango gem | **Ингредиенты:** нори · рис · сливочный сыр · огурец · тунец · лосось · джем из манго |

#### Tempura / Темпура  (category id 38, slug `tempura`, parent id 52) — 6 products, 120–155 MDL

RO: https://davidansushi.md/meniu/sushi/tempura/ · RU: https://davidansushi.md/ru/meniu/sushi/tempura/

| ID | slug | RO name | RU name | Price RO / RU | RO attributes | RU attributes | Image (full size) |
|---|---|---|---|---|---|---|---|
| 5368 | `sushidog` | SushiDog | SushiDog | 145,00 MDL / 145,00 лей | Masa: 300g | Вес: 300г | https://davidansushi.md/wp-content/uploads/2024/10/SushiDog-min.jpg |
| 5217 | `tempura-creveti` | Tempura Creveți | Tempura Creveți | 140,00 MDL / 140,00 лей | Masa: 300g | Вес: 300г | https://davidansushi.md/wp-content/uploads/2024/10/Tempura-cu-creveti-min.jpg |
| 5215 | `tempura-somon` | Tempura Somon | Tempura Somon | 145,00 MDL / 145,00 лей | Masa: 300g | Вес: 300г | https://davidansushi.md/wp-content/uploads/2024/10/Tempura-cu-somon-min.jpg |
| 5384 | `tempura-somon-grill` | Tempura Somon Grill | Tempura Somon Grill | 120,00 MDL / 120,00 лей | Masa: 300g | Вес: 300г | https://davidansushi.md/wp-content/uploads/2024/10/tempura-cu-somon-grill-min.jpg |
| 5216 | `tempura-ton` | Tempura Ton | Tempura Ton | 140,00 MDL / 140,00 лей | Masa: 300g | Вес: 300г | https://davidansushi.md/wp-content/uploads/2024/10/Tempura-cu-creveti-min.jpg |
| 5218 | `tempura-tipar` | Tempura Țipar | Tempura Țipar | 155,00 MDL / 155,00 лей | Masa: 300g | Вес: 300г | https://davidansushi.md/wp-content/uploads/2024/10/Tempura-cu-tipar-min.jpg |

Composition (verbatim short description; bold = `<strong>` label, ` · ` separates `<li>` items; commas/periods/typos are the site's own):

| ID | RO name | RO composition | RU composition |
|---|---|---|---|
| 5368 | SushiDog | **Ingrediente:** nori · orez · cream de brânză · castraveți · maioneză japoneză · tobico · creveți · somon · sos sriracha · sos spicy · sos unaghi · susan | **Ингредиенты:** нори · рис · cream de brânză · огурцы · maioneză japoneză · тобико · креветки · лосось · sos sriracha · sos spicy · соус унаги · кунжут |
| 5217 | Tempura Creveți | **Ingrediente:** nori · orez · cremă de brânză · tobico · castraveți · creveți · sos unaghi · susan | **Ингредиенты:** нори · рис · сливочный сыр · тобико · огурцы · креветки · соус унаги · кунжут |
| 5215 | Tempura Somon | **Ingrediente:** nori · orez · cremă de brânză · tobico · castraveți · somon · sos unaghi · susan | **Ингредиенты:** нори · рис · сливочный сыр · тобико · огурцы · лосось · соус унаги · кунжут |
| 5384 | Tempura Somon Grill | **Ingrediente:** nori · orez · cremă de brânză · tobico · castraveți · somon grill · sos unaghi · susan | **Ингредиенты:** нори · рис · сливочный сыр · тобико · огурцы · somon grill · соус унаги · кунжут |
| 5216 | Tempura Ton | **Ingrediente:** nori · orez · cremă de brânză · tobico · castraveți · ton · sos unaghi · susan | **Ингредиенты:** нори · рис · сливочный сыр · тобико · огурцы · тунец · соус унаги · кунжут |
| 5218 | Tempura Țipar | **Ingrediente:** nori · orez · cremă de brânză · tobico · castraveți · țipar · sos unaghi · susan | **Ингредиенты:** нори · рис · сливочный сыр · тобико · огурцы · угорь · соус унаги · кунжут |

#### Maki / Маки  (category id 39, slug `maki`, parent id 52) — 6 products, 50–90 MDL

RO: https://davidansushi.md/meniu/sushi/maki/ · RU: https://davidansushi.md/ru/meniu/sushi/maki/

| ID | slug | RO name | RU name | Price RO / RU | RO attributes | RU attributes | Image (full size) |
|---|---|---|---|---|---|---|---|
| 5224 | `avocado-maki` | Avocado Maki | Avocado Maki | 55,00 MDL / 55,00 лей | Masa: 130g | Вес: 130g | https://davidansushi.md/wp-content/uploads/2024/10/Avocado-Maki-min.jpg |
| 5222 | `ebi-maki` | Ebi Maki | Ebi Maki | 75,00 MDL / 75,00 лей | Masa: 130g | Вес: 130g | https://davidansushi.md/wp-content/uploads/2024/10/Ebi-Maki-min.jpg |
| 5223 | `kappa-maki` | Kappa Maki | Kappa Maki | 50,00 MDL / 50,00 лей | Masa: 130g | Вес: 130g | https://davidansushi.md/wp-content/uploads/2024/10/Kappa-Maki-min.jpg |
| 5219 | `somon-maki` | Somon Maki | Somon Maki | 75,00 MDL / 75,00 лей | Masa: 130g | Вес: 130g | https://davidansushi.md/wp-content/uploads/2024/10/Somon-Maki-min-1.jpg |
| 5221 | `ton-maki` | Ton Maki | Ton Maki | 70,00 MDL / 70,00 лей | Masa: 130g | Вес: 130g | https://davidansushi.md/wp-content/uploads/2024/10/Somon-Maki-min.jpg |
| 5220 | `unaghi-maki` | Unaghi Maki | Unaghi Maki | 90,00 MDL / 90,00 лей | Masa: 130g | Вес: 130g | https://davidansushi.md/wp-content/uploads/2024/10/Unaghi-Maki-min.jpg |

Composition (verbatim short description; bold = `<strong>` label, ` · ` separates `<li>` items; commas/periods/typos are the site's own):

| ID | RO name | RO composition | RU composition |
|---|---|---|---|
| 5224 | Avocado Maki | **Ingrediente:** nori · orez · avocado | **Ингредиенты:** нори · рис · авокадо |
| 5222 | Ebi Maki | **Ingrediente:** nori · orez · creveți | **Ингредиенты:** нори · рис · креветки |
| 5223 | Kappa Maki | **Ingrediente:** nori · orez · castravete | **Ингредиенты:** нори · рис · огурец |
| 5219 | Somon Maki | **Ingrediente:** nori · orez · somon | **Ингредиенты:** нори · рис · лосось |
| 5221 | Ton Maki | **Ingrediente:** nori · orez · ton | **Ингредиенты:** нори · рис · тунец |
| 5220 | Unaghi Maki | **Ingrediente:** nori · orez · țipar · sos unaghi · susan | **Ингредиенты:** нори · рис · угорь · соус унаги · кунжут |

### Seturi / Сеты  (top category id 50, slug `seturi`)

RO: https://davidansushi.md/meniu/seturi/ · RU: https://davidansushi.md/ru/meniu/seturi/ · 9 products · 125–900 MDL

| ID | slug | RO name | RU name | Price RO / RU | RO attributes | RU attributes | Image (full size) |
|---|---|---|---|---|---|---|---|
| 5363 | `davidan-set` | Davidan Set | Davidan Set | 900,00 MDL / 900,00 лей | Bucăți: 48 buc; Masa: 1900g | Количество: 48 buc; Вес: 1900g | https://davidansushi.md/wp-content/uploads/2024/10/davidan-set-1.jpg |
| 5308 | `gunkan-set` | Gunkan Set | Гункан Сет | 235,00 MDL / 235,00 лей | Bucăți: 4 buc; Masa: 280g | Количество: 4 шт; Вес: 280г | https://davidansushi.md/wp-content/uploads/2024/10/Gunkan-Set.jpg |
| 5401 | `love-story-set` | Love Story Set | Love Story Set | 460,00 MDL / 460,00 лей | Bucăți: 32 buc; Masa: 950g | Количество: 32 buc; Вес: 950g | https://davidansushi.md/wp-content/uploads/2024/10/Set-love-story.jpg |
| 5290 | `maki-set` | Maki Set | Маки сет | 185,00 MDL / 185,00 лей | Bucăți: 24 buc; Masa: 390g | Количество: 24 шт; Вес: 390g | https://davidansushi.md/wp-content/uploads/2024/10/Maki-Set.jpg |
| 5309 | `nigiri-set` | Nigiri Set | Нигири Сет | 125,00 MDL / 125,00 лей | Bucăți: 4 buc; Masa: 230g | Количество: 4 шт; Вес: 230g | https://davidansushi.md/wp-content/uploads/2024/10/Nigiri-Set.jpg |
| 5306 | `phila-ebi-set` | Phila-Ebi Set | Фила-Эби Сет | 400,00 MDL / 400,00 лей | Bucăți: 24 buc; Masa: 850g | Количество: 24 шт; Вес: 850g | https://davidansushi.md/wp-content/uploads/2024/10/Phila-Ebi-Set.jpg |
| 5443 | `philadelphia-set` | Philadelphia Set | Philadelphia Set | 525,00 MDL / 525,00 лей | Bucăți: 32 buc; Masa: 1200g | Количество: 32 buc; Вес: 1200g | https://davidansushi.md/wp-content/uploads/2024/10/philadelphia_set-min.jpg |
| 5307 | `sacura-set` | Sacura Set | Сакура Сет | 440,00 MDL / 440,00 лей | Bucăți: 24 buc; Masa: 850g | Количество: 24 шт; Вес: 850g | https://davidansushi.md/wp-content/uploads/2024/10/Sakura-Set.jpg |
| 5305 | `tempura-set` | Tempura Set | Темпура Сет | 360,00 MDL / 360,00 лей | Bucăți: 24 buc; Masa: 900g | Количество: 24 шт; Вес: 900г | https://davidansushi.md/wp-content/uploads/2024/10/Tempura-Set.jpg |

Composition (verbatim short description; bold = `<strong>` label, ` · ` separates `<li>` items; commas/periods/typos are the site's own):

| ID | RO name | RO composition | RU composition |
|---|---|---|---|
| 5363 | Davidan Set | **Componența setului:** Haruto – 8 bucăți · Philadelphia Classic – 8 bucăți · California Creveți – 8 bucăți · Chyka Roll – 8 bucăți · Salmon Bliss – 8 bucăţi · Oh my cheeseus – 8 bucăţi | **Состав:** Haruto – 8 bucăți · Philadelphia Classic – 8 bucăți · California Creveți – 8 bucăți · Chyka Roll – 8 bucăți · Salmon Bliss – 8 bucăţi · Oh my cheeseus – 8 bucăţi |
| 5308 | Gunkan Set | **Componența setului:** orez · nori · tobico · maioneză japoneză · creveți · ton · somon · țipar · sos unaghi · susan | **Состав:** рис · нори · тобико · maioneză japoneză · креветки · тунец · лосось · угорь · соус унаги · кунжут |
| 5401 | Love Story Set | **Componența setului:** Dragon Verde 8 bucăți · Philadelphia Flambe 8 bucăți · California Creveți – 8 bucăți · Kappa Maki 4 bucăți · Avokado Maki 4 bucăți | **Состав:** Dragon Verde 8 bucăți · Philadelphia Flambe 8 bucăți · California Creveți – 8 bucăți · Kappa Maki 4 bucăți · Avokado Maki 4 bucăți |
| 5290 | Maki Set | **Componența setului:** Somon Maki 4 bucăți, · Ton Maki 4 bucăți, · Ebi Maki 4 bucăți, · Unaghi Maki 4 bucăți, · Kappa Maki 4 bucăți, · Avocado Maki 4 bucăți. | **Состав:** Somon Maki 4 bucăți, · Ton Maki 4 bucăți, · Ebi Maki 4 bucăți, · Unaghi Maki 4 bucăți, · Kappa Maki 4 bucăți, · Avocado Maki 4 bucăți. |
| 5309 | Nigiri Set | **Componența setului:** Nigiri somon · Nigiri ton · Nigiri creveți · Nigiri țipar | **Состав:** Nigiri somon · Nigiri ton · Nigiri creveți · Nigiri țipar |
| 5306 | Phila-Ebi Set | **Componența setului:** Philadelphia Classic 8 bucăți; · Ebi Roll 8 bucăți; · Tempura cu somon grill 8 bucăți. | **Состав:** Филадельфия Классик 8 шт · Ebi Roll 8 bucăți; · Темпура с лососем на гриле 8 шт |
| 5443 | Philadelphia Set | **Componența setului** Tempura Somon Grill – 8 bucăți · Tempura Somon – 8 bucăți · Philadelphia cu Creveți – 8 bucăți · Philadelphia Classic – 8 bucăți | **Componența setului** Tempura Somon Grill – 8 bucăți · Tempura Somon – 8 bucăți · Philadelphia cu Creveți – 8 bucăți · Philadelphia Classic – 8 bucăți |
| 5307 | Sacura Set | **Componența setului:** Dragon Verde 8 bucăți · Tuna Roll 8 bucăți · Canada 8 bucăți | **Состав:** Dragon Verde 8 bucăți · Tuna Roll 8 bucăți · Canada 8 bucăți |
| 5305 | Tempura Set | **Componența setului:** Tempura Somon 8 bucăți · Tempura Ton 8 bucăți · Tempura Creveți 8 bucăți | **Состав:** Tempura Somon 8 bucăți · Tempura Ton 8 bucăți · Tempura Creveți 8 bucăți |

### Bucate Thai / Тайские блюда  (top category id 53, slug `bucate-thai`)

RO: https://davidansushi.md/meniu/bucate-thai/ · RU: https://davidansushi.md/ru/meniu/bucate-thai/ · 13 products · 85–135 MDL

#### Orez / Рис  (category id 44, slug `orez`, parent id 53) — 3 products, 85–115 MDL

RO: https://davidansushi.md/meniu/bucate-thai/orez/ · RU: https://davidansushi.md/ru/meniu/bucate-thai/orez/

| ID | slug | RO name | RU name | Price RO / RU | RO attributes | RU attributes | Image (full size) |
|---|---|---|---|---|---|---|---|
| 5233 | `orez-cu-fructe-de-mare` | Orez cu fructe de mare | Рис с морепродуктами | 115,00 MDL / 115,00 лей | Masa: 350g | Вес: 350g | https://davidansushi.md/wp-content/uploads/2024/10/Orez-cu-fructe-de-mare.jpg |
| 5231 | `orez-cu-pui` | Orez cu pui | Рис с курицей | 85,00 MDL / 85,00 лей | Masa: 350g | Вес: 350g | https://davidansushi.md/wp-content/uploads/2024/10/Orez-cu-pui.jpg |
| 5232 | `orez-cu-vita` | Orez cu vită | Рис с говядиной | 110,00 MDL / 110,00 лей | Masa: 350g | Вес: 350g | https://davidansushi.md/wp-content/uploads/2024/10/Orez-cu-vita.jpg |

Composition (verbatim short description; bold = `<strong>` label, ` · ` separates `<li>` items; commas/periods/typos are the site's own):

| ID | RO name | RO composition | RU composition |
|---|---|---|---|
| 5233 | Orez cu fructe de mare | **Ingrediente:** orez · midii · calmari · creveți · somon · morcov · păstăi · ardei · sos sriracha · sus de soia · susan | **Ингредиенты:** рис · midii · calmari · креветки · лосось · morcov · păstăi · ardei · sos sriracha · sus de soia · кунжут |
| 5231 | Orez cu pui | **Ingrediente:** orez · carne de pui · morcov · păstăi · ardei · sos sriracha · sus de soia · susan | **Ингредиенты:** рис · carne de pui · morcov · păstăi · ardei · sos sriracha · sus de soia · кунжут |
| 5232 | Orez cu vită | **Ingrediente:** orez · carne de vită · morcov · păstăi · ardei · sos sriracha · sus de soia · susan | **Ингредиенты:** рис · carne de vită · morcov · păstăi · ardei · sos sriracha · sus de soia · кунжут |

#### Soba / Soba  (category id 45, slug `soba`, parent id 53) — 3 products, 100–130 MDL

RO: https://davidansushi.md/meniu/bucate-thai/soba/ · RU: https://davidansushi.md/ru/meniu/bucate-thai/soba/

| ID | slug | RO name | RU name | Price RO / RU | RO attributes | RU attributes | Image (full size) |
|---|---|---|---|---|---|---|---|
| 5248 | `soba-cu-fructe-de-mare` | Soba cu fructe de mare | Soba cu fructe de mare | 130,00 MDL / 130,00 лей | Masa: 320g | Вес: 320г | https://davidansushi.md/wp-content/uploads/2024/10/Soba-cu-fructe-de-mare.jpg |
| 5234 | `soba-cu-pui` | Soba cu pui | Soba cu pui | 100,00 MDL / 100,00 лей | Masa: 350g | Вес: 350g | https://davidansushi.md/wp-content/uploads/2024/10/Soba-cu-pui.jpg |
| 5247 | `soba-cu-vita` | Soba cu vită | Soba cu vită | 110,00 MDL / 110,00 лей | Masa: 350g | Вес: 350g | https://davidansushi.md/wp-content/uploads/2024/10/Soba-cu-vita.jpg |

Composition (verbatim short description; bold = `<strong>` label, ` · ` separates `<li>` items; commas/periods/typos are the site's own):

| ID | RO name | RO composition | RU composition |
|---|---|---|---|
| 5248 | Soba cu fructe de mare | **Ingrediente:** fidea de hrișcă · creveți · somon · midii · calmari · ciuperci shitake · morcov · ardei · tulpină de țelină · susan · sos lunch-king · sos sriracha | **Ингредиенты:** fidea de hrișcă · креветки · лосось · midii · calmari · ciuperci shitake · morcov · ardei · tulpină de țelină · кунжут · sos lunch-king · sos sriracha |
| 5234 | Soba cu pui | **Ingrediente:** fidea de hrișcă · carne de pui · ciuperci shitake · morcov · ardei · tulpină de țelină · susan · sos lunch-king · sos sriracha | **Ингредиенты:** fidea de hrișcă · carne de pui · ciuperci shitake · morcov · ardei · tulpină de țelină · кунжут · sos lunch-king · sos sriracha |
| 5247 | Soba cu vită | **Ingrediente:** fidea de hrișcă · carne de vită · ciuperci shitake · morcov · ardei · tulpină de țelină · susan · sos lunch-king · sos sriracha | **Ингредиенты:** fidea de hrișcă · carne de vită · ciuperci shitake · morcov · ardei · tulpină de țelină · кунжут · sos lunch-king · sos sriracha |

#### Udon / Удон  (category id 46, slug `udon`, parent id 53) — 4 products, 100–130 MDL

RO: https://davidansushi.md/meniu/bucate-thai/udon/ · RU: https://davidansushi.md/ru/meniu/bucate-thai/udon/

| ID | slug | RO name | RU name | Price RO / RU | RO attributes | RU attributes | Image (full size) |
|---|---|---|---|---|---|---|---|
| 5250 | `udon-cu-carne-de-vita` | Udon cu carne de vită | Удон с говядиной | 110,00 MDL / 110,00 лей | Masa: 350g | Вес: 350g | https://davidansushi.md/wp-content/uploads/2024/10/Udon-cu-vita-min.jpg |
| 5251 | `udon-cu-fructe-de-mare` | Udon cu fructe de mare | Удон с морепродуктами | 130,00 MDL / 130,00 лей | Masa: 350g | Вес: 350g | https://davidansushi.md/wp-content/uploads/2024/10/Udon-cu-fructe-de-mare-min.jpg |
| 5249 | `udon-cu-pui` | Udon cu pui | Удон с курицей | 100,00 MDL / 100,00 лей | Masa: 350g | Вес: 350g | https://davidansushi.md/wp-content/uploads/2024/10/Udon-cu-pui-min.jpg |
| 5386 | `udon-cu-spanac-si-creveti` | Udon cu spanac și creveți | Udon cu spanac și creveți | 120,00 MDL / 120,00 лей | Masa: 350g | Вес: 350g | https://davidansushi.md/wp-content/uploads/2024/10/Udon-cu-creveti-si-spanac-min.jpg |

Composition (verbatim short description; bold = `<strong>` label, ` · ` separates `<li>` items; commas/periods/typos are the site's own):

| ID | RO name | RO composition | RU composition |
|---|---|---|---|
| 5250 | Udon cu carne de vită | **Ingrediente:** fidea de grâu · carne de vită · ciuperci · morcov · ardei · păstăi · susan · sos sriracha · sos lunch-king | **Ингредиенты:** fidea de grâu · carne de vită · ciuperci · morcov · ardei · păstăi · кунжут · sos sriracha · sos lunch-king |
| 5251 | Udon cu fructe de mare | **Ingrediente:** fidea de grâu · creveți · somon · midii · calmari · ciuperci · morcov · ardei · păstăi · susan · sos sriracha · sos lunch-king | **Ингредиенты:** fidea de grâu · креветки · лосось · midii · calmari · ciuperci · morcov · ardei · păstăi · кунжут · sos sriracha · sos lunch-king |
| 5249 | Udon cu pui | **Ingrediente:** fidea de grâu · carne de pui · ciuperci · morcov · ardei · păstăi · susan · sos sriracha · sos lunch-king | **Ингредиенты:** fidea de grâu · carne de pui · ciuperci · morcov · ardei · păstăi · кунжут · sos sriracha · sos lunch-king |
| 5386 | Udon cu spanac și creveți | **Ingrediente:** fidea de grâu · spanac · creveți · parmenzan · frișcă · ceapă · usturoi · susan | **Ингредиенты:** fidea de grâu · spanac · креветки · parmenzan · frișcă · ceapă · usturoi · кунжут |

#### Funcioza / Фунчоза  (category id 54, slug `funcioza`, parent id 53) — 3 products, 100–135 MDL

RO: https://davidansushi.md/meniu/bucate-thai/funcioza/ · RU: https://davidansushi.md/ru/meniu/bucate-thai/funcioza/

| ID | slug | RO name | RU name | Price RO / RU | RO attributes | RU attributes | Image (full size) |
|---|---|---|---|---|---|---|---|
| 5387 | `funcioza-cu-fructe-de-mare` | Funcioza cu fructe de mare | Funcioza cu fructe de mare | 135,00 MDL / 135,00 лей | Masa: 300g | Вес: 300г | https://davidansushi.md/wp-content/uploads/2024/10/Funcioza-cu-fructe-de-mare.jpg |
| 5310 | `funcioza-cu-pui` | Funcioza cu pui | Фунчоза с курицей | 100,00 MDL / 100,00 лей | Masa: 320g | Вес: 320г | https://davidansushi.md/wp-content/uploads/2024/10/Funcioza-cu-pui.jpg |
| 5311 | `funcioza-cu-vita` | Funcioza cu vită | Фунчоза с говядиной | 115,00 MDL / 115,00 лей | Masa: 300g | Вес: 300г | https://davidansushi.md/wp-content/uploads/2024/10/Funcizoa-cu-vita.jpg |

Composition (verbatim short description; bold = `<strong>` label, ` · ` separates `<li>` items; commas/periods/typos are the site's own):

| ID | RO name | RO composition | RU composition |
|---|---|---|---|
| 5387 | Funcioza cu fructe de mare | **Ingrediente:** fidea de boabe · fructe de mare · morcov · tulpină de țelină · sos sriracha · sos lunch-king · ardei · susan | **Ингредиенты:** fidea de boabe · fructe de mare · morcov · tulpină de țelină · sos sriracha · sos lunch-king · ardei · кунжут |
| 5310 | Funcioza cu pui | **Ingrediente:** fidea de boabe · carne de pui · morcov · tulpină de țelină · sos sriracha · sos lunch-king · ardei · susan | **Ингредиенты:** fidea de boabe · carne de pui · morcov · tulpină de țelină · sos sriracha · sos lunch-king · ardei · кунжут |
| 5311 | Funcioza cu vită | **Ingrediente:** fidea de boabe · carne de vită · morcov · tulpină de țelină · sos sriracha · sos lunch-king · ardei · susan | **Ингредиенты:** fidea de boabe · carne de vită · morcov · tulpină de țelină · sos sriracha · sos lunch-king · ardei · кунжут |

### Supe / Супы  (top category id 51, slug `supe`)

RO: https://davidansushi.md/meniu/supe/ · RU: https://davidansushi.md/ru/meniu/supe/ · 5 products · 70–130 MDL

| ID | slug | RO name | RU name | Price RO / RU | RO attributes | RU attributes | Image (full size) |
|---|---|---|---|---|---|---|---|
| 5324 | `ramen-cu-pui` | Ramen cu pui | Куриный рамен | 75,00 MDL / 75,00 лей | Masa: 400ml | Вес: 400ml | https://davidansushi.md/wp-content/uploads/2024/10/Ramen-min.jpg |
| 5266 | `supa-crema-cu-spanac` | Supă cremă cu spanac | Шпинатный крем суп | 70,00 MDL / 70,00 лей | Masa: 300ml | Вес: 350мл | https://davidansushi.md/wp-content/uploads/2024/10/Supa-crema-de-spanac-min.jpg |
| 5388 | `supa-crema-cu-spanac-si-creveti` | Supă cremă cu spanac și creveți | Supă cremă cu spanac și creveți | 100,00 MDL / 100,00 лей | Masa: 350ml, 50g | Вес: 350ml, 50g | https://davidansushi.md/wp-content/uploads/2024/10/supa-crema-cu-spanac-si-creveti-min.jpg |
| 5265 | `tom-yam-cu-fructe-de-mare` | Tom Yam cu fructe de mare | Том Ям с морепродуктами | 130,00 MDL / 130,00 лей | Masa: 400ml | Вес: 400ml | https://davidansushi.md/wp-content/uploads/2024/10/TM-cu-fructe-de-mare-min.jpg |
| 5252 | `tom-yam-cu-pui` | Tom Yam cu pui | Том Ям с курицей | 90,00 MDL / 90,00 лей | Masa: 400ml | Вес: 400ml | https://davidansushi.md/wp-content/uploads/2024/10/TM-cu-pui-min.jpg |

Composition (verbatim short description; bold = `<strong>` label, ` · ` separates `<li>` items; commas/periods/typos are the site's own):

| ID | RO name | RO composition | RU composition |
|---|---|---|---|
| 5324 | Ramen cu pui | **Ingrediente:** bulion de găină · ouă · fidea de grâu · fileu de pui pane · ceapă verde · ardei iute · susan | **Ингредиенты:** bulion de găină · ouă · fidea de grâu · fileu de pui pane · ceapă verde · ardei iute · кунжут |
| 5266 | Supă cremă cu spanac | **Ingrediente:** frișcă · spanac · parmezan · ceapă · usturoi · susan · pesmeți | **Ингредиенты:** frișcă · spanac · parmezan · ceapă · usturoi · кунжут · pesmeți |
| 5388 | Supă cremă cu spanac și creveți | **Ingrediente:** frișcă · spanac · creveți · parmezan · ceapă · usturoi · susan · pesmeți | **Ингредиенты:** frișcă · spanac · креветки · parmezan · ceapă · usturoi · кунжут · pesmeți |
| 5265 | Tom Yam cu fructe de mare | **Ingrediente:** lapte de cocos, · sos Tom Yam, · bulion din creveți · creveți · calmari · somon · midii · ciuperci champignon · orez | **Ингредиенты:** кокосовое молоко · соус Том Ям · bulion din creveți · креветки · calmari · лосось · midii · ciuperci champignon · рис |
| 5252 | Tom Yam cu pui | **Ingrediente:** lapte de cocos · sos Tom Yam · bulion din creveți · carne de pui · ciuperci champignon · orez | **Ингредиенты:** lapte de cocos · sos Tom Yam · bulion din creveți · carne de pui · ciuperci champignon · рис |

### Salate / Салаты  (top category id 47, slug `salate`)

RO: https://davidansushi.md/meniu/salate/ · RU: https://davidansushi.md/ru/meniu/salate/ · 6 products · 75–129 MDL

| ID | slug | RO name | RU name | Price RO / RU | RO attributes | RU attributes | Image (full size) |
|---|---|---|---|---|---|---|---|
| 5267 | `chuka` | Chuka | Чука | 75,00 MDL / 75,00 лей | Masa: 200g, 30g | Вес: 200g, 30g | https://davidansushi.md/wp-content/uploads/2024/10/Chuka-min.jpg |
| 5268 | `mixt-salata-cu-pui` | Mix salată cu pui | Mix salată cu pui | 85,00 MDL / 85,00 лей | Masa: 250g | Вес: 250г | https://davidansushi.md/wp-content/uploads/2024/10/Mix-Salata-cu-pui-min.jpg |
| 5459 | `salata-caesar-cu-creveti` | Salată Caesar cu Creveți | Salată Caesar cu Creveți | 120,00 MDL / 120,00 лей | Masa: 320g | Вес: 320г | https://davidansushi.md/wp-content/uploads/2024/10/caesar-creveti.jpg |
| 5476 | `salata-caesar-cu-pui` | Salată Caesar cu Pui | Salată Caesar cu Pui | 100,00 MDL / 100,00 лей | Masa: 320g | Вес: 320г | https://davidansushi.md/wp-content/uploads/2024/10/salata_caesar-min.jpg |
| 7178 | `salata-cu-creveti` | Salată cu creveți | Salată cu creveți | 129,00 MDL / 129,00 лей | Masa: 280g | Вес: 280г | https://davidansushi.md/wp-content/uploads/2025/09/salata_creveti-min.jpg |
| 7175 | `salata-cu-somon` | Salată cu somon | Salată cu somon | 129,00 MDL / 129,00 лей | Masa: 225g | Вес: 225g | https://davidansushi.md/wp-content/uploads/2025/09/salata_somon-min.jpg |

Composition (verbatim short description; bold = `<strong>` label, ` · ` separates `<li>` items; commas/periods/typos are the site's own):

| ID | RO name | RO composition | RU composition |
|---|---|---|---|
| 5267 | Chuka | **Ingrediente:** frunză de salată · alge chuka · susan · lămâie · sos de nuci | **Ингредиенты:** frunză de salată · alge chuka · кунжут · lămâie · sos de nuci |
| 5268 | Mix salată cu pui | **Ingrediente:** mix salată · carne de pui panată · avocado · ciuperci champinion · roșii cherry · ulei de măsline · nuci caju · susan | **Ингредиенты:** mix salată · carne de pui panată · авокадо · ciuperci champinion · roșii cherry · ulei de măsline · nuci caju · кунжут |
| 5459 | Salată Caesar cu Creveți | **Ingrediente** Mix salată · rosii cherry · pesmeti · creveți · sos caesar · parmesan | **Ingrediente** Mix salată · rosii cherry · pesmeti · креветки · sos caesar · parmesan |
| 5476 | Salată Caesar cu Pui | **Ingrediente** Mix salată · rosii cherry · pesmeti · carne de pui grill · sos caesar · parmesan | **Ingrediente** Mix salată · rosii cherry · pesmeti · carne de pui grill · sos caesar · parmesan |
| 7178 | Salată cu creveți | **Ingrediente** mix de salată · quinoa · creveți · avocado · roșii cherry · mango · dressing pentru salată · sos Unaghi | **Ingrediente** mix de salată · quinoa · креветки · авокадо · roșii cherry · mango · dressing pentru salată · sos Unaghi |
| 7175 | Salată cu somon | **Ingrediente** mix de salată · somon slab sărat · mozzarella · roșii cherry · castraveți · nuci caju · dressing pentru salată | **Ingrediente** mix de salată · somon slab sărat · mozzarella · roșii cherry · огурцы · nuci caju · dressing pentru salată |

### Poke bowl / Poke bowl  (top category id 48, slug `poke-bowl`)

RO: https://davidansushi.md/meniu/poke-bowl/ · RU: https://davidansushi.md/ru/meniu/poke-bowl/ · 3 products · 155–165 MDL

| ID | slug | RO name | RU name | Price RO / RU | RO attributes | RU attributes | Image (full size) |
|---|---|---|---|---|---|---|---|
| 5285 | `poke-bowl-creveti` | Poke bowl creveți | Poke bowl с креветками | 155,00 MDL / 155,00 лей | Masa: 450g | Вес: 450g | https://davidansushi.md/wp-content/uploads/2024/10/Pokebowl-cu-creveti-min.jpg |
| 5284 | `poke-bowl-somon` | Poke bowl somon | Poke bowl с лососем | 165,00 MDL / 165,00 лей | Masa: 450g | Вес: 450g | https://davidansushi.md/wp-content/uploads/2024/10/Pokebowl-cu-somon-min.jpg |
| 5270 | `poke-bowl-ton` | Poke bowl ton | Poke bowl с тунцом | 155,00 MDL / 155,00 лей | Masa: 450g | Вес: 450g | https://davidansushi.md/wp-content/uploads/2024/10/Pokebowl-cu-ton-min.jpg |

Composition (verbatim short description; bold = `<strong>` label, ` · ` separates `<li>` items; commas/periods/typos are the site's own):

| ID | RO name | RO composition | RU composition |
|---|---|---|---|
| 5285 | Poke bowl creveți | **Ingrediente:** orez · creveți · mango · boabe edamame · avocado · nori · ghimbir marinat · alge wakame · castrevete · cremă de brnânză · sos poke · sos soia · nuci caju · sos unaghi · susan | **Ингредиенты:** рис · креветки · mango · boabe edamame · авокадо · нори · ghimbir marinat · alge wakame · castrevete · cremă de brnânză · sos poke · sos soia · nuci caju · соус унаги · кунжут |
| 5284 | Poke bowl somon | **Ingrediente:** orez · somon · mango · boabe edamame · avocado · nori · ghimbir marinat · alge wakame · castrevete · cremă de brnânză · sos poke · sos soia · nuci caju · sos unaghi · susan | **Ингредиенты:** рис · лосось · mango · boabe edamame · авокадо · нори · ghimbir marinat · alge wakame · castrevete · cremă de brnânză · sos poke · sos soia · nuci caju · соус унаги · кунжут |
| 5270 | Poke bowl ton | **Ingrediente:** orez · ton · mango · boabe edamame · avocado · nori · ghimbir marinat · alge wakame · castrevete · cremă de brnânză · sos poke · sos soia · nuci caju · sos unaghi · susan | **Ингредиенты:** рис · тунец · mango · boabe edamame · авокадо · нори · ghimbir marinat · alge wakame · castrevete · cremă de brnânză · sos poke · sos soia · nuci caju · соус унаги · кунжут |

### Gustări / Закуски  (top category id 42, slug `gustari`)

RO: https://davidansushi.md/meniu/gustari/ · RU: https://davidansushi.md/ru/meniu/gustari/ · 18 products · 35–190 MDL

| ID | slug | RO name | RU name | Price RO / RU | RO attributes | RU attributes | Image (full size) |
|---|---|---|---|---|---|---|---|
| 5433 | `aripioare-crocante` | Aripioare Crocante | Aripioare Crocante | 75,00 MDL / 75,00 лей | Masa: 250g, 50g | Вес: 250g, 50g | https://davidansushi.md/wp-content/uploads/2024/10/aripioare-pane-min.jpg |
| 5440 | `bao-burger` | Bao Burger | Bao Burger | 85,00 MDL / 85,00 лей | Masa: 400g, 50g | Вес: 400g, 50g | https://davidansushi.md/wp-content/uploads/2024/10/bao-burgher.jpg |
| 5436 | `bao-cu-creveti` | Bao cu creveți | Bao cu creveți | 70,00 MDL / 70,00 лей | Masa: 220g | Вес: 220г | https://davidansushi.md/wp-content/uploads/2024/10/bao-cu-creveti-min.jpg |
| 5435 | `bao-cu-pui` | Bao cu pui | Bao cu pui | 60,00 MDL / 60,00 лей | Masa: 250g | Вес: 250г | https://davidansushi.md/wp-content/uploads/2024/10/bao-cu-pui-min.jpg |
| 5478 | `burger-cu-pui` | Burger cu pui | Burger cu pui | 105,00 MDL / 105,00 лей | Masa: 100g, 400g, 50g | Вес: 100g, 400g, 50g | https://davidansushi.md/wp-content/uploads/2024/10/burger_pui-min.jpg |
| 5479 | `burger-cu-vita` | Burger cu vită | Burger cu vită | 135,00 MDL / 135,00 лей | Masa: 100g, 400g, 50g | Вес: 100g, 400g, 50g | https://davidansushi.md/wp-content/uploads/2024/10/burger_vita-min.jpg |
| 5229 | `cartofi-pai` | Cartofi pai | Картофель фри | 35,00 MDL / 35,00 лей | Masa: 150g, 50g | Вес: 150г, 50г | https://davidansushi.md/wp-content/uploads/2024/10/Cartofi-pai-min.jpg |
| 5226 | `fileu-de-pui-crispy` | Fileu de pui Crispy | Fileu de pui Crispy | 75,00 MDL / 75,00 лей | Masa: 150g, 50g | Вес: 150г, 50г | https://davidansushi.md/wp-content/uploads/2024/10/Nuggets-min.jpg |
| 5227 | `inele-de-calmar` | Inele de calmar | Кольца кальмара | 75,00 MDL / 75,00 лей | Masa: 150g, 50g | Вес: 150г, 50г | https://davidansushi.md/wp-content/uploads/2024/10/Inele-de-calmar-min.jpg |
| 5228 | `mozzarella-pane` | Mozzarella pane | Моцарелла Пане | 50,00 MDL / 50,00 лей | Masa: 150g, 50g | Вес: 150г, 50г | https://davidansushi.md/wp-content/uploads/2024/10/Mozzarella-Pane-min.jpg |
| 5434 | `nughete` | Nughete | Наггетсы | 75,00 MDL / 75,00 лей | Masa: 150g, 50g | Вес: 150г, 50г | https://davidansushi.md/wp-content/uploads/2024/10/new-nughete-min.jpg |
| 5437 | `popcorn-creveti` | Popcorn Creveți | Popcorn Creveți | 75,00 MDL / 75,00 лей | Masa: 150g, 50g | Вес: 150г, 50г | https://davidansushi.md/wp-content/uploads/2024/10/popcorn-creveti-min.jpg |
| 5230 | `spring-roll-cu-pui` | Spring roll cu pui | Спринг-ролл с курицей | 75,00 MDL / 75,00 лей | Masa: 200g, 50g | Вес: 200г, 50г | https://davidansushi.md/wp-content/uploads/2024/10/Spring-Roll-min.jpg |
| 7183 | `sushi-burger-creveti` | Sushi Burger Creveți | Sushi Burger Creveți | 149,00 MDL / 149,00 лей | Masa: 400g | Вес: 400г | https://davidansushi.md/wp-content/uploads/2025/09/sushi_burger_creveti-min-scaled.jpg |
| 5457 | `sushi-burger` | Sushi Burger Somon | Sushi Burger Somon | 149,00 MDL / 149,00 лей | Masa: 400g | Вес: 400г | https://davidansushi.md/wp-content/uploads/2024/10/sushi_burger_somon-min.jpg |
| 7192 | `sushi-burger-somon-grill` | Sushi Burger Somon Grill | Sushi Burger Somon Grill | 145,00 MDL / 145,00 лей | Masa: 400g | Вес: 400г | https://davidansushi.md/wp-content/uploads/2025/09/sushi_burger_blur-min-scaled.jpg |
| 7186 | `sushi-burger-ton` | Sushi Burger Ton | Sushi Burger Ton | 149,00 MDL / 149,00 лей | Masa: 400g | Вес: 400г | https://davidansushi.md/wp-content/uploads/2025/09/sushi_burger_ton-min.jpg |
| 7189 | `sushi-burger-tipar` | Sushi burger Țipar | Sushi burger Țipar | 190,00 MDL / 190,00 лей | Masa: 400g | Вес: 400г | https://davidansushi.md/wp-content/uploads/2025/09/sushi_burger_blur-min-scaled.jpg |

Composition (verbatim short description; bold = `<strong>` label, ` · ` separates `<li>` items; commas/periods/typos are the site's own):

| ID | RO name | RO composition | RU composition |
|---|---|---|---|
| 5433 | Aripioare Crocante | **Ingrediente:** aripioare de pui · pesmeți panco · sos Sweet-Chilli | **Ингредиенты:** aripioare de pui · pesmeți panco · sos Sweet-Chilli |
| 5440 | Bao Burger | **Ingrediente** chiflă bao · pârjoală de pui · roșii · castraveți · frunză de salată · sos sweet-chilli · sos tartar · cartofi pai | **Ingrediente** chiflă bao · pârjoală de pui · roșii · огурцы · frunză de salată · sos sweet-chilli · sos tartar · cartofi pai |
| 5436 | Bao cu creveți | **Ingrediente:** Chifle Bao · creveți panați · mix de salată · sos Unaghi · susan | **Ингредиенты:** Chifle Bao · creveți panați · mix de salată · sos Unaghi · кунжут |
| 5435 | Bao cu pui | **Ingrediente:** Chifle Bao · carne de pui · frișcă · mix de salată · sos de nuci · susan | **Ингредиенты:** Chifle Bao · carne de pui · frișcă · mix de salată · sos de nuci · кунжут |
| 5478 | Burger cu pui | **Ingrediente** chiflă burger · pirjoală de pui · sos tartar · roșii · rucola · cașcaval cheddar · castraveți marinați · ceapă marinată · cartofi pai · sos Ketchup | **Ingrediente** chiflă burger · pirjoală de pui · sos tartar · roșii · rucola · cașcaval cheddar · castraveți marinați · ceapă marinată · cartofi pai · sos Ketchup |
| 5479 | Burger cu vită | **Ingrediente** chiflă burger · ceapă caramelizată · pârjoală de vită · cașcaval dorblu · castraveți marinați · frunză de salată · roșii · bacon · rucola · cartofi pai · sos Ketchup | **Ingrediente** chiflă burger · ceapă caramelizată · pârjoală de vită · cașcaval dorblu · castraveți marinați · frunză de salată · roșii · bacon · rucola · cartofi pai · sos Ketchup |
| 5229 | Cartofi pai | **Ingrediente:** cartofi pai · sos ketchup | **Ингредиенты:** cartofi pai · sos ketchup |
| 5226 | Fileu de pui Crispy | **Ingrediente:** fileu de pui panat · sos picant | **Ингредиенты:** fileu de pui panat · sos picant |
| 5227 | Inele de calmar | **Ingrediente:** calmari panați · sos sweet-chilli | **Ингредиенты:** calmari panați · sos sweet-chilli |
| 5228 | Mozzarella pane | **Ingrediente:** mozzarella panată · sos sweet-chilli | **Ингредиенты:** mozzarella panată · sos sweet-chilli |
| 5434 | Nughete | **Ingrediente:** nughete din carne de pui · sos TarTar | **Ингредиенты:** nughete din carne de pui · sos TarTar |
| 5437 | Popcorn Creveți | **Ingrediente:** creveți panați · sos wasabi dulce | **Ингредиенты:** creveți panați · sos wasabi dulce |
| 5230 | Spring roll cu pui | **Ingrediente:** foi de orez · carne de pui · morcov · ardei · ciuperci · mozzarella · maioneză japoneză · susan · sos de soia | **Ингредиенты:** foi de orez · carne de pui · morcov · ardei · ciuperci · mozzarella · maioneză japoneză · кунжут · sos de soia |
| 7183 | Sushi Burger Creveți | **Ingrediente** nori · orez · castraveți · tobico · creveti · cremă de brânză · sos unaghi · sos spicy · susan | **Ingrediente** нори · рис · огурцы · тобико · creveti · сливочный сыр · соус унаги · sos spicy · кунжут |
| 5457 | Sushi Burger Somon | **Ingrediente** nori · orez · castraveti · tobico · crema de brinza · sos unaghi · sos spicy · susan | **Ingrediente** нори · рис · castraveti · тобико · crema de brinza · соус унаги · sos spicy · кунжут |
| 7192 | Sushi Burger Somon Grill | **Ingrediente** nori · orez · castraveți · tobico · somon grill · cremă de brânză · sos unaghi · sos spicy · susan | **Ingrediente** нори · рис · огурцы · тобико · somon grill · сливочный сыр · соус унаги · sos spicy · кунжут |
| 7186 | Sushi Burger Ton | **Ingrediente** nori · orez · castraveți · tobico · ton · cremă de brânză · sos unaghi · sos spicy · susan | **Ingrediente** нори · рис · огурцы · тобико · тунец · сливочный сыр · соус унаги · sos spicy · кунжут |
| 7189 | Sushi burger Țipar | **Ingrediente** nori · orez · castraveți · tobico · țipar · cremă de brânză · sos unaghi · sos spicy · susan | **Ingrediente** нори · рис · огурцы · тобико · угорь · сливочный сыр · соус унаги · sos spicy · кунжут |

### Deserturi / Десерты  (top category id 49, slug `deserturi`)

RO: https://davidansushi.md/meniu/deserturi/ · RU: https://davidansushi.md/ru/meniu/deserturi/ · 5 products · 30–85 MDL

| ID | slug | RO name | RU name | Price RO / RU | RO attributes | RU attributes | Image (full size) |
|---|---|---|---|---|---|---|---|
| 5389 | `cheescake` | Cheescake | Cheescake | 70,00 MDL / 70,00 лей | Masa: 150g, 50g | Вес: 150г, 50г | https://davidansushi.md/wp-content/uploads/2024/10/Cheesecake-min.jpg |
| 5287 | `cherry-roll` | Cherry roll | Cherry roll | 85,00 MDL / 85,00 лей | Masa: 200g | Вес: 200г | https://davidansushi.md/wp-content/uploads/2024/10/Cherry-Roll-min-600x400-1.png |
| 5288 | `choco-roll` | Choco roll | Choco roll | 85,00 MDL / 85,00 лей | Masa: 200g | Вес: 200г | https://davidansushi.md/wp-content/uploads/2024/10/Choco-Roll-min-600x400-1.png |
| 5289 | `minari-roll` | Minari roll | Minari roll | 85,00 MDL / 85,00 лей | Masa: 200g | Вес: 200г | https://davidansushi.md/wp-content/uploads/2024/10/Minari-Roll-min-600x400-1.png |
| 5286 | `motti` | Motti | Мотти | 30,00 MDL / 30,00 лей | Masa: 40g | Вес: 40г | https://davidansushi.md/wp-content/uploads/2024/10/Motti-min-600x400-1.png |

Composition (verbatim short description; bold = `<strong>` label, ` · ` separates `<li>` items; commas/periods/typos are the site's own):

| ID | RO name | RO composition | RU composition |
|---|---|---|---|
| 5389 | Cheescake | **Ingrediente:** cremă de brânză · frișcă · unt · ouă · biscuiți · dulceață | **Ингредиенты:** сливочный сыр · frișcă · unt · ouă · biscuiți · dulceață |
| 5287 | Cherry roll | **Ingrediente:** foaie de orez · cremă de brânză · kiwi · banană · vișină · topping de ciocolată | **Ингредиенты:** foaie de orez · сливочный сыр · kiwi · banană · vișină · topping de ciocolată |
| 5288 | Choco roll | **Ingrediente:** foaie de orez, · cremă de brânză, · nutella, · kiwi, · banană, · ananas, · topping de caramelă | **Ингредиенты:** рисовый лист · сливочный сыр · nutella, · киви · банан · ананас · topping de caramelă |
| 5289 | Minari roll | **Ingrediente:** foaie de orez · cremă de brânză · kiwi · banană · ananas · topping de ciocolată | **Ингредиенты:** foaie de orez · сливочный сыр · kiwi · banană · ananas · topping de ciocolată |
| 5286 | Motti | —(empty on site) | —(empty on site) |

### Băuturi / Напитки  (top category id 93, slug `bauturi`)

RO: https://davidansushi.md/meniu/bauturi/ · RU: https://davidansushi.md/ru/meniu/bauturi/ · 11 products · 23–225 MDL

#### Băuturi răcoritoare / Безалкогольные напитки  (category id 97, slug `bauturi-racoritoare`, parent id 93) — 8 products, 23–28 MDL

RO: https://davidansushi.md/meniu/bauturi/bauturi-racoritoare/ · RU: https://davidansushi.md/ru/meniu/bauturi/bauturi-racoritoare/

| ID | slug | RO name | RU name | Price RO / RU | RO attributes | RU attributes | Image (full size) |
|---|---|---|---|---|---|---|---|
| 5325 | `coca-cola-250ml` | Coca Cola 250ml | Coca Cola 250ml | 23,00 MDL / 23,00 лей | —(none on site) | —(none on site) | https://davidansushi.md/wp-content/uploads/2024/10/cola-0.3.jpg |
| 5326 | `coca-cola-500ml` | Coca Cola 500ml | Coca Cola 500ml | 25,00 MDL / 25,00 лей | —(none on site) | —(none on site) | https://davidansushi.md/wp-content/uploads/2024/10/cola-0.5.jpg |
| 5327 | `fanta-250ml` | Fanta 250ml | Fanta 250ml | 23,00 MDL / 23,00 лей | —(none on site) | —(none on site) | https://davidansushi.md/wp-content/uploads/2024/10/fanta-250.jpg |
| 5328 | `fanta-500ml` | Fanta 500ml | Fanta 500ml | 25,00 MDL / 25,00 лей | —(none on site) | —(none on site) | https://davidansushi.md/wp-content/uploads/2024/10/fanta-0.5.jpg |
| 5343 | `schweppes-mohito` | Schweppes Mohito | Schweppes Mohito | 28,00 MDL / 28,00 лей | Masa: 330ml | Вес: 330ml | https://davidansushi.md/wp-content/uploads/2024/10/Schweppes-mohito-1.jpg |
| 5344 | `schweppes-pomegranate` | Schweppes Pomegranate | Schweppes Pomegranate | 28,00 MDL / 28,00 лей | Masa: 330ml | Вес: 330ml | https://davidansushi.md/wp-content/uploads/2024/10/schweppes-pomegranate-1.jpg |
| 5329 | `sprite-250ml` | Sprite 250ml | Sprite 250ml | 23,00 MDL / 23,00 лей | —(none on site) | —(none on site) | https://davidansushi.md/wp-content/uploads/2024/10/sprite-250.jpg |
| 5342 | `sprite-500ml` | Sprite 500ml | Sprite 500ml | 25,00 MDL / 25,00 лей | —(none on site) | —(none on site) | https://davidansushi.md/wp-content/uploads/2024/10/sprite-0.5.jpg |

Composition (verbatim short description; bold = `<strong>` label, ` · ` separates `<li>` items; commas/periods/typos are the site's own):

| ID | RO name | RO composition | RU composition |
|---|---|---|---|
| 5325 | Coca Cola 250ml | —(empty on site) | —(empty on site) |
| 5326 | Coca Cola 500ml | —(empty on site) | —(empty on site) |
| 5327 | Fanta 250ml | —(empty on site) | —(empty on site) |
| 5328 | Fanta 500ml | —(empty on site) | —(empty on site) |
| 5343 | Schweppes Mohito | —(empty on site) | —(empty on site) |
| 5344 | Schweppes Pomegranate | —(empty on site) | —(empty on site) |
| 5329 | Sprite 250ml | —(empty on site) | —(empty on site) |
| 5342 | Sprite 500ml | —(empty on site) | —(empty on site) |

#### Băuturi cu alcool / Băuturi cu alcool  (category id 102, slug `bauturi-cu-alcool`, parent id 93) — has only the sub-category below (3 products)

RO: https://davidansushi.md/meniu/bauturi/bauturi-cu-alcool/ · RU: https://davidansushi.md/ru/meniu/bauturi/bauturi-cu-alcool/

#### Vin / Vin  (category id 99, slug `vin`, parent id 102) — 3 products, 225–225 MDL

RO: https://davidansushi.md/meniu/bauturi/bauturi-cu-alcool/vin/ · RU: https://davidansushi.md/ru/meniu/bauturi/bauturi-cu-alcool/vin/

| ID | slug | RO name | RU name | Price RO / RU | RO attributes | RU attributes | Image (full size) |
|---|---|---|---|---|---|---|---|
| 5345 | `vinaria-din-vale-feteasca-alba` | Vinăria din vale – Feteasca Albă | Vinăria din vale – Feteasca Albă | 225,00 MDL / 225,00 лей | —(none on site) | —(none on site) | https://davidansushi.md/wp-content/uploads/2024/10/MOTIVE-Feteasca-Alba.jpg |
| 5346 | `vinaria-din-vale-feteasca-neagra` | Vinăria din vale – Feteasca Neagră | Vinăria din vale – Feteasca Neagră | 225,00 MDL / 225,00 лей | —(none on site) | —(none on site) | https://davidansushi.md/wp-content/uploads/2024/10/MOTIVE-Feteasca-Neagra.jpg |
| 5347 | `vinaria-din-vale-rose` | Vinăria din vale – Rose | Vinăria din vale – Rose | 225,00 MDL / 225,00 лей | —(none on site) | —(none on site) | https://davidansushi.md/wp-content/uploads/2024/10/MOTIVE-Rose.jpg |

Composition (verbatim short description; bold = `<strong>` label, ` · ` separates `<li>` items; commas/periods/typos are the site's own):

| ID | RO name | RO composition | RU composition |
|---|---|---|---|
| 5345 | Vinăria din vale – Feteasca Albă | —(empty on site) | —(empty on site) |
| 5346 | Vinăria din vale – Feteasca Neagră | —(empty on site) | —(empty on site) |
| 5347 | Vinăria din vale – Rose | —(empty on site) | —(empty on site) |

---

## 3. Data-quality notes and RO↔RU alignment

- **Alignment is 1:1.** All 102 products exist on both `/product/<slug>/` and `/ru/product/<slug>/` with the same post ID, the same price, the same image and the same number of attributes and description lines. No product exists in only one language.
- **Store API vs RO HTML:** all 102 prices, names and images match. The one difference is whitespace: the API name of 5251 is `Udon  cu fructe de mare` with a double space, and the HTML collapses it. No product is on sale (`regular_price` = `price` for all).
- **RO vs RU value mismatch (site data bug):** 5266 *Supă cremă cu spanac*: RO `Masa: 300ml`, RU `Вес: 350мл`.
- **Same image on two products (site data):** 5216 *Tempura Ton* and 5217 *Tempura Creveți* both use `…/2024/10/Tempura-cu-creveti-min.jpg`. 7189 *Sushi burger Țipar* and 7192 *Sushi Burger Somon Grill* share `…/2025/09/sushi_burger_blur-min-scaled.jpg`.
- **Products without description:** Motti (5286), all 8 soft drinks and all 3 wines. **Without attributes:** Coca Cola/Fanta/Sprite 250ml & 500ml and the 3 wines (their volume is only in the name, where there is one).
- **Mixed-language RU examples:** the RU label is left as Romanian "Ingrediente" on 19 products (Chyka Roll, Crunchy Tony, Oh my cheeseus, Salmon Bliss, Salmon Explosion, Shrimps Explosion, Spicy Tuna, both Caesar salads, Salată cu creveți, Salată cu somon, Bao Burger, Burger cu pui, Burger cu vită, and all 5 Sushi Burgers) and as "Componența setului" on Philadelphia Set, while the other products use "Ингредиенты:" / "Состав:". RU set compositions keep "8 bucăți". Davidan Set RU `Количество: 48 buc`. Category names "Soba", "Băuturi cu alcool" and "Vin" are untranslated.
- **Typos are verbatim** (e.g. `cremă de brnânză`, `castrevete`, `sos spisy`, `parmenzan`, `sus de soia`, `Cheescake`, `Avokado Maki`). Do not "fix" them if the rule is to trace text to the site.
- The RO name `Alasca` (slug `alasca`) is shown as `Аляска` on RU. The image file is named `Alaska.jpg`.
- Products have SEO tags (e.g. `sushi-ton`, `tuna-roll`), which the CSS hides (`span.tagged_as {display:none}`). They are not reproduced here.

---

## 4. Legal / policy pages (verbatim)

| Page | RO URL | RU URL | Language actually shown on RU | Gist |
|---|---|---|---|---|
| Livrare și Achitare | https://davidansushi.md/livrare-si-achitare/ | https://davidansushi.md/ru/livrare-si-achitare/ | **Romanian** (body untranslated, only the header/footer are RU) | Delivery via Glovo and Straus. A hidden block holds 10:00–22:00, a 40 lei fee, free delivery over 500 lei, and suburb fees |
| Termeni și Condiții | https://davidansushi.md/termeni-si-conditii/ | https://davidansushi.md/ru/termeni-si-conditii/ | **Romanian** (only the in-text link label is RU) | Brand run by S.R.L. DANVAL BAKERY; prices in lei incl. VAT excl. transport; cash/card; food not returnable; legal entity details |
| Politica de Confidențialitate | https://davidansushi.md/politica-de-confidentialitate/ | https://davidansushi.md/ru/politica-de-confidentialitate/ | **Romanian** (identical) | Personal data used for stats, marketing, orders, feedback; IP/browser data for analytics |
| Returns | NOT FOUND as a separate page. The only returns clause is inside Termeni și Condiții ("Returnarea produselor"). | — | — | — |

Footer link labels: RO `politica de confidențialitate | termeni și condiții | livrare și achitare`; RU `политика конфиденциальности | условия использования | доставка и оплата`. Header nav: RO "Livrare și Achitare", RU "Доставка и оплата". Mobile toolbar: RO "Livrare", RU "Доставка".

### 4.1 Livrare și Achitare

Source: https://davidansushi.md/livrare-si-achitare/ (RU URL shows the identical Romanian body). `<title>`: `DaviDan Sushi - Livrare Sushi în Chișinău și Suburbii`. Meta description: `Profită de livrarea rapidă și metodele comode de achitare pentru sushi și WOK în Chișinău. Gustul perfect, direct la ușa ta.`

**Visible part** (Elementor container `bee008a`):

> or. Chișinău
>
> Livrare disponibilă prin Glovo și Straus
>
> Acum poți comanda produsele noastre rapid și ușor prin intermediul aplicației Glovo. Vizitează Davidan Sushi pe [Glovo](https://glovoapp.com/md/ro/chisinau/davidan-sushi-ksn/) sau [Straus](https://straus.md/en/restaurant/davidan-sushi) pentru livrare direct la tine acasă!

It is followed by two linked logo images: `https://davidansushi.md/wp-content/uploads/2025/07/glovo-1024x451.png` → Glovo link, and `https://davidansushi.md/wp-content/uploads/2025/07/straus-1024x424.png` → Straus link.

**Hidden part.** It is present in the HTML, but its Elementor container `81d3423` has the classes `elementor-hidden-desktop elementor-hidden-tablet elementor-hidden-mobile`, so **no visitor sees it on any device**. Treat it as legacy or disabled content:

> ##### Livrare și achitare
>
> Livrarea se face zilnic între orele 10:00 - 22:00.
> Plata produselor se face prin achitarea cu numerar la curier sau card bancar la plasarea comenzii online.
>
> **Livrare în raza orașului Chișinău:**
>
> - Tarif: 40 lei
> - Livrare gratuită pentru comenzi ce depășesc valoarea minimă de 500 de lei
>
> **Livrare în zonele adiacente orașului:**
>
> - Stauceni, Durlești, Codru: tariful este de 100 lei, nu este disponibilă opțiunea de livrare gratuită.
> - Cricova, Bubuieci: tariful este de 120 lei, nu este disponibilă opțiunea de livrare gratuită.
>
> În alte locații decât cele specificate mai sus, livrarea nu se face.

### 4.2 Termeni și Condiții

Source: https://davidansushi.md/termeni-si-conditii/. `<title>`: `DaviDan Sushi - Termeni și Condiții`. RU URL https://davidansushi.md/ru/termeni-si-conditii/ shows the identical Romanian text. The only change is that the link label `politica de confidențialitate` becomes `политика конфиденциальности` → `/ru/politica-de-confidentialitate/`. Lines are split where the site uses `<br>`. Note: the link text `www.davidansushi.md` actually points to `https://mistyrose-horse-112944.hostingersite.com` (a Hostinger temporary domain).

Verbatim below. `**…**` = `<strong>`, `[label](href)` = link, and each quoted line is one site line.

> ##### TERMENI ȘI CONDIȚII  
>
> **DaviDan Sushi** este un brand operat de compania **S.R.L. DANVAL BAKERY**, comercializează produse alimentare în conformitate cu regulile prezentate pe acestă pagină.  
> **Obiective generale**  
> **Produsele:** DaviDan Sushi comercializează produse alimentare, conform descrierii și specificațiilor afișate pe site-ul localului ([www.davidansushi.md](https://mistyrose-horse-112944.hostingersite.com)).  
> **Prețurile:** Prețurile produselor sunt afișate în lei, includ TVA și nu includ costul transportului. Davidansushi.md își rezervă dreptul de a modifica prețurile produselor fără o notificare prealabilă.  
> **Comenzile:** Prin plasarea unei comenzi, clientul își exprimă acordul de a achiziționa produsele comandate și de a plăti contravaloarea acestora. Comanda este considerată acceptată de către local doar după confirmarea acesteia prin email sau apel telefonic.  
> **Plata:** Plata produselor se poate prin numerar la curier sau cu card bancar la plasarea comenzii. Acestea sunt metodele de plată acceptate de Davidansushi.md.  
> **Livrarea:** Produsele comandate vor fi livrate la adresa specificată de către client în momentul plasării comenzii. Costurile de livrare vor fi suportate de client și vor fi afișate în momentul plasării comenzii.  
> **Returnarea produselor:** Produsele alimentare nu pot fi returnate din motive de igienă și siguranță alimentară. Produsele nealimentare pot fi returnate în termen de 14 zile de la primirea lor, dacă nu corespund descrierii afișate pe site-ul localului.  
> **Confidențialitatea datelor:** Davidan Sushi respectă confidențialitatea datelor personale ale clienților și se angajează să le protejeze conform legii mai multe detalii găsiți pe pagina [politica de confidențialitate](/politica-de-confidentialitate/).  
> **Litigii:** Orice litigiu între client și Davidansushi.md va fi soluționat pe cale amiabilă. În caz contrar, litigiul va fi soluționat conform legislației Republicii Moldova în vigoare.  
> **Modificări:** Davidansushi.md își rezervă dreptul de a modifica prezentul regulament fără o notificare prealabilă. Orice modificare va fi publicată pe site-ul davidansushi.md și va fi aplicată din momentul publicării.  
>
> ##### Informații despre persoana juridică:  
>
> Denumire: S.R.L. DANVAL BAKERY  
> C/F: 1023600044712  
> Adresa: mun. Chişinău, sec. Botanica, str. Decebal bd., 91/4  
> IBAN: MD30AG000000022585652023  
> BIC: AGRNMD2X  
> BC ”Moldova – Agroindbank„ S.A.  


### 4.3 Politica de Confidențialitate

Source: https://davidansushi.md/politica-de-confidentialitate/. `<title>`: `DaviDan Sushi - Protecția datelor la Davidan Sushi`. Meta description: `Angajamentul nostru pentru protecția datelor tale personale este esențial. Află cum gestionăm informațiile tale atunci când comanzi de la noi.` The RU URL https://davidansushi.md/ru/politica-de-confidentialitate/ shows the identical Romanian text, and no RU version exists. Lines are split where the site uses `<br>`.

Verbatim below. Each quoted line is one site line.

> ##### POLITICA DE CONFIDENȚIALITATE  
>
> Davidansushi.md respectă dreptul consumatorului de a proteja datele cu caracter personal și asigură o confidențialitate sporită a informațiilor furnizate de clienții companiei. Prin urmare, ne asumăm întreaga răspundere că toate informațiile primite de la utilizator în timpul utilizării site-ului web Davidansushi.md vor fi utilizate strict în scopul prevăzut și protejate în mod fiabil de accesul neautorizat de către terți.  
> Clienții Davidansushi.md trebuie să știe că datele lor personale vor fi stocate și prelucrate pentru a:  
> – Completarea bazei de informații a companiei pentru pregătirea rapoartelor statistice;  
> – Informarea despre noi oferte profitabile, reduceri, promoții ale Davidansushi.md și alte evenimente organizate de compania noastră prin diferite canale de comunicare (e-mail, mesaje SMS, notificări push etc.).  
> Colectarea și prelucrarea datelor cu caracter personal se efectuează folosind diverse metode și instrumente specifice, precum: stocarea formularelor completate de utilizatori, sondaje online în baza de date a companiei, urmărirea traficului site-ului folosind software profesional, gestionarea buletinelor informative, utilizarea aplicațiilor speciale etc.  
> Unele secțiuni ale site-ului necesită înregistrare sau abonament, pentru care utilizatorul este solicitat pentru anumite date. Informațiile solicitate sunt utilizate pentru identificarea, confirmarea, completarea contului. Anularea abonamentului poate fi efectuată imediat, fără a fi necesară nicio altă confirmare suplimentară.  
> Toate datele sunt utilizate pentru informarea și îmbunătățirea serviciului. Termenii politicii de confidențialitate se aplică numai datelor furnizate de utilizator în mod voluntar.  
> Astfel, magazinul online Davidansushi.md colectează datele personale ale utilizatorilor obținute cu acordul lor voluntar pentru următoarele:  
> – Confirmare / trimitere / depunere factură;  
> – Rezolvarea problemelor apărute în ceea ce privește comenzile plasate, serviciile și bunurile achiziționate;  
> – Furnizarea accesului la anumite servicii;  
> – Trimiterea periodică de știri sau alte informații despre reducerile viitoare, promoții, bonusuri în formă electronică;  
> – Feedbackul clienților;  
> – Obiective statistice.  
> În unele cazuri, Davidansushi.md folosește adresele IP ale utilizatorilor (Internet Protocol Address) și alte date care nu au nicio legătură cu informațiile personale fără consimțământul lor voluntar. De exemplu, ora de vizitare a site-ului, locul de unde a fost introdus site-ul, versiunea browserului, sistemul de operare, este utilizată pentru a monitoriza următoarele aspecte:  
> – Administrarea site-ului;  
> – Analiza, identificarea intereselor utilizatorilor;  
> – Utilizarea datelor pentru statistici demografice;  
> – Îmbunătățirea navigării pe site.  


---

## 5. Operational facts (verbatim quotes)

| Topic | Verbatim quote (RO) | RU on site | Source / caveat |
|---|---|---|---|
| How to order / delivery channel | "Livrare disponibilă prin Glovo și Straus" / "Acum poți comanda produsele noastre rapid și ușor prin intermediul aplicației Glovo. Vizitează Davidan Sushi pe Glovo sau Straus pentru livrare direct la tine acasă!" | same RO text | `/livrare-si-achitare/` (visible). Glovo: https://glovoapp.com/md/ro/chisinau/davidan-sushi-ksn/ · Straus: https://straus.md/en/restaurant/davidan-sushi. The site itself takes no orders (catalog mode, cart and checkout redirect home). |
| City served | "or. Chișinău" | same | `/livrare-si-achitare/` (visible) |
| Delivery hours | "Livrarea se face zilnic între orele 10:00 - 22:00." | same RO text | `/livrare-si-achitare/`, **hidden block** (not shown to visitors) |
| Delivery fee (Chișinău) | "Tarif: 40 lei" | same | hidden block |
| Free-delivery threshold | "Livrare gratuită pentru comenzi ce depășesc valoarea minimă de 500 de lei" | same | hidden block |
| Delivery zones and suburb fees | "Stauceni, Durlești, Codru: tariful este de 100 lei, nu este disponibilă opțiunea de livrare gratuită." / "Cricova, Bubuieci: tariful este de 120 lei, nu este disponibilă opțiunea de livrare gratuită." / "În alte locații decât cele specificate mai sus, livrarea nu se face." | same | hidden block |
| Minimum order | NOT FOUND. The only "minimă" wording is the 500 lei free-delivery threshold above. | — | — |
| Delivery time / ETA | NOT FOUND | — | — |
| Working hours (restaurant / pickup) | NOT FOUND. Only the delivery hours above exist. | — | — |
| Payment methods | Hidden delivery block: "Plata produselor se face prin achitarea cu numerar la curier sau card bancar la plasarea comenzii online." Terms: "Plata produselor se poate prin numerar la curier sau cu card bancar la plasarea comenzii. Acestea sunt metodele de plată acceptate de Davidansushi.md." Footer payment image (`/wp-content/uploads/2023/12/metode.png`, alt `visa-mastercard`) has the title: "Site-ul davidansushi.md permite utilizarea cardurilor Visa și Mastercard pentru achitarea produselor" | same RO text (the image title is identical on RU) | The theme CSS also styles a `payment_method_paynet` checkout option, but checkout is disabled, so this is CSS evidence only. |
| Delivery cost in prices | Terms: "Prețurile produselor sunt afișate în lei, includ TVA și nu includ costul transportului." / "Costurile de livrare vor fi suportate de client și vor fi afișate în momentul plasării comenzii." | same RO | `/termeni-si-conditii/` |
| Order confirmation | Terms: "Comanda este considerată acceptată de către local doar după confirmarea acesteia prin email sau apel telefonic." | same RO | `/termeni-si-conditii/` |
| Returns | Terms: "Produsele alimentare nu pot fi returnate din motive de igienă și siguranță alimentară. Produsele nealimentare pot fi returnate în termen de 14 zile de la primirea lor, dacă nu corespund descrierii afișate pe site-ul localului." | same RO | `/termeni-si-conditii/` |
| Pickup / takeaway | NOT FOUND | — | — |
| Discounts (pickup discount, promo codes, etc.) | NOT FOUND. The privacy policy only mentions sending info about "reduceri, promoții", and no active discount is stated. | — | — |
| Phone | Footer: "+373 (67) 808 080" (`tel:+37367808080`). Header nav item labelled "Phone" → `tel:+37367808080` | Footer "+373 (67) 808 080", header "Phone" | all pages |
| Email | "info@davidan.md" (`mailto:info@davidan.md`) | same | footer |
| Address | "Strada Vlaicu Pârcălab 52" / "Etajul 2" (two lines) | "ул. Vlaicu Pârcălab 52" / "Второй этаж" | footer. Google Maps link: `https://www.google.com/maps?ll=47.023773,28.837116&z=16&t=m&hl=en&gl=US&mapclient=embed&q=Vlaicu+Pircalab+St+52+Chișinău`. Yandex `https://yandex.com/maps/-/CDuUrBn0`. Waze `https://waze.com/ul/hu8ke80qmy` (map icons are mobile-only) |
| Legal entity | "Denumire: S.R.L. DANVAL BAKERY" · "C/F: 1023600044712" · "Adresa: mun. Chişinău, sec. Botanica, str. Decebal bd., 91/4" · "IBAN: MD30AG000000022585652023" · "BIC: AGRNMD2X" · "BC ”Moldova – Agroindbank„ S.A." | same RO | `/termeni-si-conditii/` |
| Copyright line | "Copyright © 2024 DaviDan Sushi \| DANVAL BAKERY S.R.L" | "Все права защищены  © 2024 DaviDan Sushi \| DANVAL BAKERY S.R.L" (double space as in source) | footer |
| Social | Instagram only: https://www.instagram.com/davidansushi.md (footer icon + JSON-LD `sameAs`). Facebook / TikTok / Telegram / Viber / WhatsApp: NOT FOUND | same | footer |
| Account | `/contul-meu/` is a WooCommerce login form ("Autentificare", "Nume utilizator sau adresă email *", "Password *", "Log in", "Lost your password?", "Remember me"). No registration form. | — | `/contul-meu/` |

---

## 6. Homepage: banners, promos, blurbs, SEO text

Source: https://davidansushi.md/ and https://davidansushi.md/ru/

**Hero slider** (Woodmart slider id 16, a single slide id 43). Background image `https://davidansushi.md/wp-content/uploads/2023/12/home-desert-slider-min.jpg`, mobile `https://davidansushi.md/wp-content/uploads/2023/12/h2-phone.jpg`.

| | RO | RU |
|---|---|---|
| Title (h4) | Dulciuri Nipone | Японские сладости |
| Text | Vă invităm să vă delectați cu o selecție rafinată de deserturi japoneze, unde fiecare delicatesă reflectă armonia și perfecțiunea gastronomiei nipone. Descoperiți eleganța și subtilitatea aromelor într-o experiență culinară distinctă și memorabilă. | Приглашаем вас насладиться изысканным выбором японских десертов, где каждое лакомство отражает гармонию и совершенство японской гастрономии. Откройте для себя тонкость вкусов и погрузитесь в атмосферу азиатской кухни. |
| Button (desktop only) | vezi meniul → `/meniu/` | посмотреть меню → `/ru/meniu/` |

(The two versions differ in meaning in the second sentence: RU says "immerse yourself in the atmosphere of Asian cuisine".)

**Homepage sections** (each heading followed by a product carousel): RO "Sushi" (tabs Roluri / Tempura / Maki), "Seturi", "Bucate Thai" (tabs Orez / Sobă / Udon / Funcioza), "Supa", "Salate", "Poke Bowl", "Gustari", "Deserturi", "Băuturi" (tabs Băuturi răcoritoare / Băuturi cu alcool). RU: "Суши" (Ролы / Темпура / Маки), "Сеты", "Тайские блюда" (Рис / Соба / Удон / Фунчоза), "Cупы", "Салаты", "Poke Bowl", "Закуски", "Десерты", "Напитки" (Безалкогольные напитки / Băuturi cu alcool). There is no about-us or blurb section.

**Popup** (Elementor popup id 4460, triggers on page load, once per session). The text is identical on RO and RU (untranslated):
> Deschiderea DaviDan Sushi
> șos. Hâncești
>
> 24.01.2025
>
> [button] DaviDan Sushi șos. Hâncești → https://sh.davidansushi.md

Background image `https://davidansushi.md/wp-content/uploads/2024/05/depositphotos_434004872-stock-photo-christmas-food-sushi-set-and.webp`, button colour `#942222`. (This is a stale announcement from January 2025 that is still live.)

**SEO / meta** (RU pages reuse the RO meta):
- `<title>`: "Davidan Sushi | Experiența Autentică a Sushiului Japonez"
- meta description: "Cu pasiune și respect pentru tradițiile gastronomiei nipone, vă invităm să descoperiți autenticitatea și rafinamentul bucătăriei japoneze la noi."
- og:site_name "DaviDan Sushi"; og:image `https://davidansushi.md/wp-content/uploads/2024/01/soc_davidan.jpg`
- JSON-LD Organization name "DaviDan Sushi", logo `https://davidansushi.md/wp-content/uploads/2023/12/cropped-FAVICON.png`

**City selector** (header dropdown, current "Chișinău"): Căușeni, Șoldănești, Ungheni, Ștefan Vodă, Fălești, Ialoveni, Ciorescu, Măgdăceşti, șos. Hâncești, Telenești. See section 8.

---

## 7. Brand colours and assets

| Token | Value | Source |
|---|---|---|
| **Primary colour** (`--wd-primary-color`) | `rgb(221,51,51)` = **#DD3333** | `wp-content/uploads/2025/10/xts-theme_settings_default-1760437231.css` |
| Header banner bg | `rgb(221,51,51)` = #DD3333 | same |
| City-menu pill bg | `#dd33339e` (#DD3333 at ~62% alpha), text #fff | same (custom CSS) |
| Alternative colour (`--wd-alternative-color`) | `#fbbc34` | same |
| **Accented (primary) button bg** (`--btn-accented-bgcolor` and hover) | `rgb(20,3,3)` = **#140303**, text `#fff`, radius 5px | same |
| Default button bg / hover | `#f7f7f7` / `#efefef`, text `#333` | same |
| Link colour / hover | `rgb(51,51,51)` #333333 / `#242424` | same |
| Title / text colour | `#242424` / `#777777` | same |
| Footer bg | `rgb(30,30,30)` = #1E1E1E | same |
| Page title bg | `#0a0a0a` | same |
| Header rows | top bar `rgba(33,33,33,0.94)`, general header `rgba(0,0,0,0.69)`, bottom (category nav) `rgba(0,0,0,1)` | `wp-content/uploads/2024/12/xts-header_838355-1733572793.css` |
| Product card bg | `#040404c2`, radius 12px | theme custom CSS |
| Page background | black textured paper image `https://davidansushi.md/wp-content/uploads/2024/01/black-smooth-textured-paper-background-2048x1365-1.jpg` (shop/product: `…/2023/12/black-smooth-textured-paper-background-scaled.jpg`) | theme CSS |
| Success / warning notices | `#459647` / `#E0B252` | theme CSS |
| Fonts | Roboto (text, titles, header). RU h2–h4 forced to 'Rubik' 600. `p.top-header-text` uses "Londrina Solid" 35px. The popup uses "Agbalumo". | theme CSS / popup CSS |
| **Logo** | `https://davidansushi.md/wp-content/uploads/2024/04/logo-red.png` (800×206 RGBA). Opaque pixels: **#F5F6F7** (near-white, 85.5%) + **#FF1235** (red, 14.3%). It is designed for a dark background. | pixel count of the downloaded PNG |
| Favicon / JSON-LD logo | `https://davidansushi.md/wp-content/uploads/2023/12/cropped-FAVICON.png` (512×512): #FCFCFC (67%) + #1F191A (26%) | pixel count |

Elementor kit globals (`post-9.css`: #6EC1E4, #54595F, #7A7A7A, #61CE70) are Elementor defaults and are **not** brand colours.

---

## 8. Links to other DaviDan properties

- **davidan.md (bakery), rent car, water, restaurant: NOT FOUND.** No link to any of them exists on the homepage, the menu, the 3 policy pages, the account page or the 204 product pages. The only DaviDan-related links are the email domain `info@davidan.md` and the legal entity "S.R.L. DANVAL BAKERY".
- **City sites of the same sushi brand** (header "choose city" menu). I only checked each homepage for `<title>`, the footer address, the header "Phone" link and the footer phone, and did not scrape their menus or delivery terms. Note that Ștefan Vodă and Măgdăceşti both show "Strada Libertății 2", as on the sites:

| Label in menu | URL | Footer address (verbatim) | Header "Phone" href | Footer phone: displayed text → href |
|---|---|---|---|---|
| Căușeni | https://cs.davidansushi.md/ | Bulevardul Mihai Eminescu 10P | tel:+37367808080 | "+373 (67) 707 070" → tel:+37367707070 |
| Șoldănești | https://soldanesti.davidansushi.md/ | or. Șoldănești str. Păcii 2 | tel:+37367808080 | "+373 (60) 000 901" → tel:+37360000901 |
| Ungheni | https://un.davidansushi.md/ | Strada Nationala 15 Ungheni | tel:+37367808080 | "+373 (69) 335 233" → tel:+37369335233 |
| Ștefan Vodă | https://sv.davidansushi.md/ | Strada Libertății 2 | tel:+37367818181 | "+373 (67) 818 181" → tel:+37367808080 (text and href disagree on the site) |
| Fălești | http://falesti.davidansushi.md/ | Strada Mihai Eminescu 1 | tel:+37378737588 | broken markup: renders "+373 (76) 007 334" with hrefs tel:+37378737588 and a Google-search link (aria-label "Apelează numărul de telefon 0787 37 588") |
| Ialoveni | https://il.davidansushi.md | Bulevardul Alexandru cel Bun 43 | tel:+37379566566 | "+373 (79) 566 566" → tel:+37379566566 |
| Ciorescu | https://cu.davidansushi.md | Stradela Alexandru cel Bun 23 | tel:+37362069696 | "+373 (62) 069 696" → tel:+37362069696 |
| Măgdăceşti | https://mg.davidansushi.md | Strada Libertății 2 | tel:+37367808080 | "+373 (68) 320 003" → tel:+37368320003 |
| șos. Hâncești | https://sh.davidansushi.md | șos. Hâncești | tel:+37361120212 | "+373 (61) 120 212" (plain text) |
| Telenești | https://tl.davidansushi.md | (no address in footer) | tel:+37367600613 | "+373 (67) 600 613" split across hrefs `tel:+373 (67) 600 613` and `tel:067600613` |

(Ungheni and Măgdăceşti homepages contain a "Program de sărbători" / "Programul de lucru de sărbători" element. It was not examined further.)

---

## 9. Corrections to the "known so far" list (from /ru)

| Claim | Verdict | Site says |
|---|---|---|
| Суши: ~20 rolls, 120–200 lei | **Incomplete.** That covers only the Ролы tab. | Суши has **32** products: Ролы 20 (120–200), Темпура 6 (120–155, includes SushiDog 145), Маки 6 (50–90). Whole category 50–200. |
| Canada Creveți 200, Alaska 170, Philadelphia Classic 145, Dragon Verde 145 | Prices ✔. Names: the RU site shows **"Аляска"**, **"Филадельфия Классик"**, **"Зеленый Дракон"**, and "Canada Creveți" is untranslated. RO names: "Alasca", "Philadelphia Classic", "Dragon Verde", "Canada Creveți". | product pages 5210, 5205, 5211, 5366 |
| Сеты: Philadelphia Set 525, Davidan Set 900, Nigiri Set 125… | ✔ (9 sets, 125–900). RU names: "Philadelphia Set", "Davidan Set", "Нигири Сет". | |
| Тайские блюда 85–115 | **Wrong.** 85–115 covers only the Рис tab. | 13 products, **85–135**: Рис 85–115, Soba 100–130, Удон 100–130 (4 items incl. "Udon cu spanac și creveți" 120), Фунчоза 100–135 |
| Cупы 70–130 | ✔ 5 products. Note the header/heading spelling "Cупы" starts with a **Latin C**, while the category and mobile nav use "Супы". | |
| Салаты 75–129 | ✔ 6 products | |
| Poke Bowl 155–165 | ✔ 3 products | |
| Закуски 35–190 | ✔ 18 products | |
| Десерты 30–85 | ✔ 5 products | |
| Напитки 23–28 | **Incomplete.** That covers only the soft drinks tab. | 11 products, **23–225**: Безалкогольные напитки 8 (23–28) + "Băuturi cu alcool" → "Vin" 3 wines at 225 |
| Address str. Vlaicu Pârcălab 52 | ✔ plus a second line: RO "Strada Vlaicu Pârcălab 52" / "Etajul 2", RU "ул. Vlaicu Pârcălab 52" / "Второй этаж" | footer |
| Phone +373 67 808 080 | ✔ displayed as "+373 (67) 808 080" | footer |
| (implicit) the site takes online orders | **No.** WooCommerce catalog mode, and cart/checkout redirect home. Delivery goes through Glovo / Straus. | section 0, 5 |

---

## 10. NOT FOUND (searched, absent)

- Minimum order value (only a free-delivery threshold, in a hidden block)
- Delivery ETA / preparation time
- Restaurant / pickup working hours (only the hidden "Livrarea se face zilnic între orele 10:00 - 22:00.")
- Pickup / takeaway option, and any pickup discount
- Any active promo, discount or promo code
- A separate returns/refund page (returns only as one clause in Terms)
- RU translations of the delivery, terms and privacy pages (the RU URLs show Romanian text)
- RU translation of the popup and of the SEO meta title/description
- Social networks other than Instagram
- Links to davidan.md (bakery), rent car, water or restaurant sub-brands
- An About / "Despre noi" text
- Long product descriptions (all empty); descriptions for Motti, soft drinks and wines; volume attributes for Coca Cola/Fanta/Sprite and wines
