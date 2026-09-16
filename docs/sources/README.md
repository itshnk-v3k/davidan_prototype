# Content sources

Where the prototype's copy, prices and policies come from. Every product name,
price, blurb and legal text in `lib/data/mock/` and `assets/legal/` must trace
back to one of these files. When something isn't in them, the app says so or
leaves it out; it is never invented.

Collected on 2026-09-16 with raw `curl` (not a summarising fetcher), so quoted
text is byte-for-byte what the sites served that day. The notes mention raw
downloads and scripts under `research/raw/`, `research/dsraw/`,
`research/rentcar/` and `research/water_raw/`: those were working files and
were not kept (about 78 MB of HTML).

## Brand sources

| File | Brand | What it covers |
|---|---|---|
| [davidan_md.md](davidan_md.md) | Bakery (davidan.md) | 62 products in 4 collections, the empty Restaurant tile, legal pages, delivery, the missing Russian version, shops |
| [davidansushi_md.md](davidansushi_md.md) | Sushi (davidansushi.md) | 102 products in Romanian and Russian, legal pages, the hidden delivery block, contacts, colours |
| [davidanrentcar_md.md](davidanrentcar_md.md) | Car rental (davidanrentcar.md) | 11 cars with price tiers and fees, booking and request forms, full Termeni și Condiții |
| [davidan_water.md](davidan_water.md) | Water | No website exists; davidan.md listings, Telegram, Instagram, company registry |

## Structured data

| File | Source endpoint |
|---|---|
| [davidansushi_md_menu.json](davidansushi_md_menu.json) | davidansushi.md WooCommerce store API plus the rendered `/ru/` product pages, matched by product ID |
| [data/davidan_md_products.json](data/davidan_md_products.json) | `https://davidan.md/products.json?limit=250` (Shopify) |
| [data/davidanrentcar_md_products.json](data/davidanrentcar_md_products.json) | `https://davidanrentcar.md/wp-json/wc/store/v1/products` (WooCommerce) |

## Research behind the structure

| File | Topic |
|---|---|
| [superapp_ux.md](superapp_ux.md) | Hub home screens, entering a brand, carts and order history in multi-service apps (Yandex Go, Glovo, Wolt, Uber, Grab) |
| [flutter_l10n.md](flutter_l10n.md) | gen-l10n with material_ui, Romanian and Russian plurals, locale persistence, font coverage |

## Known problems in the sources

Reported to the client; the app works around them as noted.

- **Bakery legal pages name another shop.** davidan.md's Termeni și Condiții
  and Politica de confidențialitate refer to "Magazinul online La Dănuț" and
  ladanut.md. The app leaves them out.
- **Delivery fees are not shown.** The bakery's 35 lei and the sushi site's
  40 lei / free over 500 lei (in a block the site hides) are the client's
  pricing decision, so the app shows no delivery fee.
- **Restaurant has no menu anywhere.** The app shows "În curând" with the
  site's one sentence and photo.
- **Water has only the 0,5L bottles.** The 19 L jug is mentioned on Instagram
  without a price, so the app doesn't offer it.
- **Car rental contradicts itself.** Listings say "Kilometraj: Nelimitat" while
  the T&C allow 400 km/day. The booking form takes a 50 € advance while the T&C
  say 50%.
- **Russian is mostly ours.** Only davidansushi.md has a Russian version, and
  it is partly untranslated. No site has Russian legal pages. Our translations
  are listed in `ru_translations.md` for the client to review.
