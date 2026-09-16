# Apa DaviDan / DaviDan Water: source research

All sources accessed **2026-09-16** unless noted. Quotes are verbatim (diacritics, spacing and typos as in the source, including missing diacritics such as "acceseaza").
Raw downloads (HTML/JSON/images) are in `research/water_raw/`.

---

## 0. Bottom line

| Question | Answer |
|---|---|
| Is there a live dedicated water website? | **No.** `davidanwater.md` did exist (WordPress, archived Aug 2024 to May 2025) but is **no longer registered** (NXDOMAIN, and whois.nic.md says "No entries found"). `water.davidan.md` has a DNS record but only returns **403 Forbidden** (empty Hostinger host). No other candidate domain resolves. |
| Where is water actually sold online? | davidan.md (Shopify), category "Băuturi": **"Apa DaviDan", 15.00 MDL, variants "Naturală" / "Gazată"**, 0,5L bottles per the product images. |
| How do they tell people to order water? | Through the Telegram channel **t.me/davidanwater**: davidan.md header, archived davidanwater.md. Instagram bio says you can order **19l** water by phone, but the bio text itself has no number. |
| Telegram post content | **Not readable.** The web preview is disabled (`/s/` redirects), and each post embed says "Please open Telegram to view this post". Only 9 post IDs exist, dated 2024-06-06 to 2025-02-20. |
| Languages | **Romanian only** in every readable source. No Russian water copy found anywhere. davidan.md has no `/ru` (404), and its hreflang lists only en/ro, both serving Romanian text. |

---

## 1. Dedicated water website

### 1.1 Domains tried (curl + dig, 2026-09-16)

| Domain | Result |
|---|---|
| davidanwater.md / www.davidanwater.md | **NXDOMAIN** (also via 8.8.8.8 / 1.1.1.1). `whois -h whois.nic.md davidanwater.md` gives "No entries found [ No match for ]". Still indexed by search engines as "DaviDan Water". |
| water.davidan.md | DNS gives 185.224.138.85. HTTP: `403 Forbidden`, headers `Server: LiteSpeed`, `platform: hostinger`, `panel: hpanel`. HTTPS: TLS handshake error. `/index.php`, `/wp-login.php`, `/robots.txt`, `/sitemap.xml` all 404. **No content.** (Random subdomains of davidan.md do not resolve, so this is a deliberate record.) |
| apadavidan.md, davidan-water.md, davidanapa.md, apa-davidan.md, davidan-apa.md, apa.davidan.md, davidanwater.com, apadavidan.com, davidanwater.store | No DNS (curl exit 6) |
| voda/rent/sushi/shop/api/admin/order/comenzi.davidan.md | No DNS |
| davidan.md/pages/apa | 404 |

### 1.2 davidanwater.md, archived (Wayback Machine)

CDX captures: 2024-08-26 through 2025-05-18. Built on WordPress + Elementor. Posts were authored by WP user `cleaneco250@gmail.com` (author archive URL `https://davidanwater.md/author/cleaneco250gmail-com/`).

**Landing page** (the same text in captures of 2024-10-04, 2025-02-12 and 2025-02-27)
Source: https://web.archive.org/web/20241004143327/https://davidanwater.md/
- `<title>`: "davidanwater.md"
- H2: "DaviDan Water"
- Paragraph (bold, with a line break after "nostru"):
  > "Pentru a comanda apa DaviDan, acceseaza grupul nostru
  > de Telegram folosind butonul de mai jos !"
- Button text "DaviDan Water", linking to `https://t.me/davidanwater`
- There is no price, phone, address, delivery or product information on the landing page.

**Earlier home** (2024-08-26 capture, https://web.archive.org/web/20240826090854/https://davidanwater.md/): a default blog listing ("Archives" … "All rights reserved") with 6 posts.

**Blog posts** (all RO). ⚠️ **These look auto-generated SEO text.** The excerpts contain stray "“`html" markdown artifacts and the misspelling "Davindan". The claims are generic and contradict each other: "izvoare naturale" vs "osmoza inversă". None has a price, phone, zone or schedule. **Do not use them as policy.** The only concrete fact they consistently support is the **0.5 L and 19 L formats**.

| Title (verbatim) | URL / capture |
|---|---|
| De Ce Să Alegi Apa Davidan: Opțiuni de 0.5 și 19 Litri | /de-ce-sa-alegi-apa-davidan-optiuni-de-0-5-si-19-litri/ (2025-02-12, 2025-05-18) |
| De ce să alegi apa Davindan în format de 0.5 sau 19 litri? | /de-ce-sa-alegi-apa-davindan-in-format-de-0-5-sau-19-litri/ (2025-02-12) |
| De ce să alegi apa Davidan: acum disponibilă în sticle de 0.5 și 19 litri | /de-ce-sa-alegi-apa-davidan-acum-disponibila-in-sticle-de-0-5-si-19-litri/ (2024-11-04, 2025-03-25) |
| De Ce Să Alegi Apa Davidan de 0.5 sau 19 Litri: Avantaje și Utilizări | /de-ce-sa-alegi-apa-davidan-de-0-5-sau-19-litri-avantaje-si-utilizari/ (2025-02-12, 2025-04-24) |
| De ce să alegi apa Davidan în sticle de 0.5 litri sau bidoane de 19 litri | /de-ce-sa-alegi-apa-davidan-in-sticle-de-0-5-litri-sau-bidoane-de-19-litri/ (2025-01-25, 2025-04-24) |
| De ce să alegi apa Davidan: 0.5 litri sau 19 litri pentru nevoile tale | /de-ce-sa-alegi-apa-davidan-0-5-litri-sau-19-litri-pentru-nevoile-tale/ (2024-11-04, 2025-03-25) |

Sample sentences, verbatim, for tone reference only (not facts):
- "Apa Davidan de 0.5 litri reprezintă soluția ideală pentru persoanele aflate mereu în mișcare." (…-0-5-litri-sau-19-litri-pentru-nevoile-tale/, capture 2025-03-25)
- "Metodele de purificare utilizate sunt riguroase și includ filtrarea prin tehnologii moderne, cum ar fi osmoza inversă și tratarea cu raze UV." (…-avantaje-si-utilizari/, capture 2025-04-24)
- "Există diverse opțiuni pentru livrarea regulată a buteliilor de 19 litri, fie prin magazine fizice, fie prin comenzi online cu livrare la domiciliu." (same post). This is generic text, **not** a stated DaviDan policy.
- "Compoziția chimică a apei Davidan oferă un aport constant de minerale vitale precum calciul, magneziul și potasiul…" (…-acum-disponibila-in-sticle-de-0-5-si-19-litri/, capture 2025-03-25). No figures are given.

**Form page** /metform-form/new-form-1728214146/ (capture 2025-02-12): the stock MetForm contact template in English ("First Name", "Last Name", "Email Address", "Subject", "Comments / Questions", "Send Message"). It is not linked from the landing page and is not an order form.

---

## 2. Telegram: t.me/davidanwater

Sources: https://t.me/davidanwater, https://t.me/s/davidanwater, https://t.me/davidanwater/N?embed=1 (N = 1..400)

- Title: **"💦 DaviDan Water 💦"**
- Subscribers: **"1 367 subscribers"** (2026-09-16). Wayback: "1 632 subscribers" (2024-10-04), "1 639 subscribers" (2025-07-08). Telegram labels them "subscribers", so this is a **channel**, although davidan.md calls it "grupul de Telegram".
- Description: **none** (no `tgme_page_description`, in the live page or either archived capture).
- Avatar image: a rendered office-building mock-up with the "DAVIDAN" logo and blue water drops. https://cdn4.telesco.pe/file/utQsTuva_k8f… (full URL in `water_raw/tg.html`)
- `https://t.me/s/davidanwater` returns **302 to https://t.me/davidanwater**, so the public post preview is disabled and no post text is available on the web.
- The post IDs that exist are listed below; every other ID in 2–10 and 19–400 is "Post not found". Each existing post renders only **"Please open Telegram to view this post"**, and the non-embed post pages carry no og:description. Nothing about the content can be extracted.

| Post | Date (UTC) |
|---|---|
| /1 | 2024-06-06 14:04 (channel creation) |
| /11 | 2024-06-11 20:43 |
| /12 | 2024-06-11 20:43 |
| /13 | 2024-06-13 12:54 |
| /14 | 2024-06-27 07:54 |
| /15 | 2024-09-09 08:12 |
| /16 | 2024-12-27 08:04 |
| /17 | 2024-12-27 08:04 |
| /18 | 2025-02-20 19:11 (latest) |

→ Product range, prices, delivery terms, deposit and schedule from Telegram: **NOT FOUND (not publicly readable)**. Reading them requires opening the channel in the Telegram app.

---

## 3. Instagram and other social

### 3.1 @davidanwater: https://www.instagram.com/davidanwater/
- Counts (og:description, crawler UA, 2026-09-16): **"7,562 Followers, 543 Following, 14 Posts"**. Display name: empty. Not verified.
- **Bio** (Instagram blocks raw JSON with 401 "require_login". The text below came from the WebFetch tool, which renders the page through a model, so treat it as near-verbatim, not byte-exact):
  > "▫️Comandă apa DaviDan de 19l la numărul de telefon
  > ▫️Fă ce-ți place și fă-o des 🔥"
  - The bio text contains **no phone number**. It may sit in a contact button that isn't visible without login: **NOT FOUND**.
  - Bio link: WebFetch reported only a Threads profile link (@davidanwater). No website link was found.
- Latest 6 posts. These are **all videos/reels**, taken from the public profile embed https://www.instagram.com/davidanwater/embed/. Captions are verbatim:

| Shortcode | Date (UTC) | Caption |
|---|---|---|
| DGVk8sJsjKz | 2025-02-21 | "Călătorește în siguranță cu @etnolines.md 🔥\n#apadavidan #davidan" |
| DGSkmDlgOF9 | 2025-02-20 | "📍Cahul 🔥\n______________\n \n☎️ 067402313 \n\n#apadavidan #davidan" (location tag: Cahul) |
| DGSd5YCg9N0 | 2025-02-20 | "Șoseaua Hîncești 216 🔥💧\n#davidan #apadavidan" |
| DFxuHryscqE | 2025-02-07 | "#apadavidan 🔥" |
| DFdFfQzMcqh | 2025-01-30 | "#apadavidan Șoseaua Hâncești 216 🔥🔥🔥" |
| DFVgWxYszOL | 2025-01-27 | "Vă așteptăm cu mare drag pe adresa Șoseaua Hâncești 216 🔥💦\n#apadavidan" |

  Context: "șos. Hâncești 216" is a **DaviDan patiserie** address on https://davidan.md/pages/loca%C8%9Bii-chi%C8%99inau (listed twice, with "+373 69 765 805" and "+373 60 111 717"). It is not a water depot. The Cahul caption phone "067402313" **does not match** the Cahul patiserie phone on davidan.md, "+373 78 402 313" (https://davidan.md/pages/loca%C8%9Bii-cahul). Its purpose is unknown, so don't use it as a water-order number. The other 8 of the 14 posts are not visible without login.
- Hashtag used: **#apadavidan**

### 3.2 Threads @davidanwater: https://www.threads.com/@davidanwater
- "332 Followers • 0 Threads." No bio text in the page.

### 3.3 Other handles tried
- `davidan.water`, `apa_davidan`, `davidan_apa`, `davidan_water`, `apadavidan`: login-walled pages. No og data was returned, so there is no evidence that these accounts exist.
- `@davidan._magdacesti`: a search-engine result title reads "Water DAVIDAN🔥💪 068320003 #apa#sanatate#moldova ..." (https://www.instagram.com/davidan._magdacesti/p/DBcKvW9CSG_/). The post itself couldn't be loaded (login wall). Its affiliation is **unverified**. davidan.md's `locații-magdacești` page lists "sat. Porumbeni", "+373 60 068 292", not that number.

### 3.4 TikTok (@davidan.bakery), captions only, via oEmbed
- https://www.tiktok.com/@davidan.bakery/video/7394491429965532422: "#davidan #davidanbakery #water #davidanwater "
- https://www.tiktok.com/@davidan.bakery/video/7411130645663042822: "#davidan #DaviDan #davidanwater #sea #perfectview #water #tiktok "

---

## 4. davidan.md (Shopify)

### 4.1 Products (https://davidan.md/products.json?limit=250; 62 products in total, only these 2 are water)

Both are in collection **"Băuturi"** (`/collections/meniu-bauturi`). Both have `body_html` = "" (empty description) and page "Descriere" tabs with no text. Currency on the page: "15.00 MDL".

**A) handle `dorna`, id 6801486545068** (https://davidan.md/products/dorna)
- title: "Apa DaviDan"
- vendor: "La Dănuț"
- option name: "Tip"; variants:
  - "Naturală": price "15.00", available true (variant id 40518802768044)
  - "Gazată": price "15.00", available true (variant id 40518802800812)
- created 2021-07-03, published 2024-08-24T16:54:15+03:00, image updated 2025-12-06
- image: https://cdn.shopify.com/s/files/1/0580/2777/0028/files/davidan_1_2.png?v=1765018747 (457×685)
  - It shows a **blue** PET bottle, blue cap. Label text: "DAVIDAN" / "Apă potabilă" / "Necarbogazificată" / "0,5L" (read from the image; small print)

**B) handle `apa-davidan`, id 8427081728172** (https://davidan.md/products/apa-davidan)
- title: "Apa DaviDan"
- vendor: "La Danuț" (spelled without ă)
- variants: "Default Title", price "15.00", available true (variant id 45108185465004)
- created/published 2025-12-06T13:01
- image: https://cdn.shopify.com/s/files/1/0580/2777/0028/files/davidan_1_3.png?v=1765018857 (457×685)
  - It shows a **green** PET bottle, green cap. Label text: "DAVIDAN" / "Apa potabilă" / "Carbogazificată" / "0,5L"

⚠️ The catalog is inconsistent: listing A offers both Naturală and Gazată but shows the still (blue) image, while listing B is a single-variant duplicate that shows the sparkling (green) image. Both cost 15.00 MDL.

### 4.2 Blog post: "Apa DaviDan, puritate și refrescare în fiecare sticlă"
https://davidan.md/blogs/news/apa-davidan-puritate-%C8%99i-refrescare-in-fiecare-sticla. Author "DaviDan Bakery". Published 2024-08-24T13:33:18+03:00, updated 2025-12-06 (from `/blogs/news.atom`).
> "Apa DaviDan este mai mult decât o simplă băutură – este o experiență de răcorire pură și revitalizantă. Îmbuteliată la sursă, apa noastră oferă o puritate impecabilă și un gust proaspăt care vă va răcori în orice moment al zilei. DaviDan se angajează să ofere apa de cea mai înaltă calitate, asigurându-se că fiecare sticlă este supusă unor teste riguroase pentru a garanta un produs sigur și sănătos. Indiferent dacă sunteți acasă sau în mișcare, apa DaviDan este alegerea ideală pentru hidratarea și răcorirea dumneavoastră."

- Image: https://davidan.md/cdn/shop/articles/photo_5294145748012305182_y.jpg?v=1765019167 (832×832). It shows the blue "Necarbogazificată 0,5L" and green "Carbogazificată 0,5L" bottles side by side on white.

### 4.3 Site-wide header notice (every davidan.md page, e.g. /products/dorna)
```html
<p>Comandă apa DaviDan în grupul de <a href="https://t.me/davidanwater" title="https://t.me/davidanwater">Telegram</a></p>
```

### 4.4 "Despre Noi" card (https://davidan.md/pages/despre-noi)
- Heading: "Apa DaviDan"
- Text: "Puritate naturală, îmbuteliată pentru hidratare premium în fiecare sticlă."
- Image: //davidan.md/cdn/shop/files/Captura_de_ecran_din_2024-08-23_la_17.02.13.png?v=1724425366

### 4.5 Delivery (the shop-wide page, not water-specific; it never mentions water)
https://davidan.md/pages/livrare-%C8%99i-achitare
> "Livrarea comenzilor se face prin intermediul curierului sau prin intermediul unui serviciu de livrare rapidă. Costul livrării va fi calculat în funcție de greutatea totală a comenzii și de adresa de livrare. Prețul livrării este de 35 lei în raza orașului Chișinău."
> "În general, termenul de livrare este de 5/60 minute pentru comenzile plasate în orașul Chișinău."
> "Comenzile pot fi achitate prin intermediul plății în numerar sau prin intermediul POS-ului la curier."

---

## 5. Company registry / listings

**S.R.L. "DAVIDAN WATER"**
Sources: https://www.infodebit.md/1023600006491/societatea-cu-raspundere-limitata-davidan-water (updated 2026-09-14) and https://www.data2b.md/ro/companies/1023600006491/srl-davidan-water
- IDNO: 1023600006491
- Status: "Activa"
- Registered: 2023-02-15
- Legal address: "MD-6825, rl. Ialoveni, s. Ruseștii Noi"
- Main activity: "Alte activităţi de alimentaţie". The activity list also includes "Producţia de băuturi răcoritoare nealcoolice; producţia de ape minerale şi alte ape îmbuteliate" and "Comerţ cu ridicata al băuturilor".
- The registry names one administrator and a 100% founder, both individuals. Their names are not needed for the app, so they are omitted here.
- ⚠️ A web-search summary claimed the address is "Calea Ieșilor 10B, MD-2069". **That is Infodebit's own office address** from the site header, not the company's. Don't use it.

**Google Business / 999.md / Yandex Maps:** no water-specific listing (no "DaviDan Water" place, and no 999.md ad for DaviDan water). Yandex/Google results for "DaviDan" are bakery branches. **NOT FOUND.**

---

## 6. NOT FOUND (what a water mini-app would need but no public source provides)

- **19 L jug**: price, availability, or whether it is still/sparkling. The format is mentioned only in the Instagram bio ("apa DaviDan de 19l") and the auto-generated davidanwater.md SEO posts.
- **Other sizes** (1.5 L, 5 L, 6-packs/cases). Only 0,5L appears, on the bottle images.
- **Jug/bottle deposit, empty-jug return or exchange policy**
- **Dispenser/cooler** sale, rental, or free loan
- **Water-specific delivery terms**: zones, minimum order, free-delivery threshold, delivery days/time slots, lead time. Only the generic bakery-shop page exists: 35 lei in Chișinău, "5/60 minute", cash/POS.
- **Subscription / regular delivery** offers
- **Promotions/discounts** for water
- **Water-order phone number** (the Instagram bio references one but shows none; the "067402313" caption is unverified), plus any Telegram bot or order form (the archived MetForm is an unused stock template)
- **Source/spring name, mineral composition** (mg/L values, pH, TDS), shelf life, certification. Only the vague "Îmbuteliată la sursă" on davidan.md.
- **Water depot / pickup address and hours.** Șos. Hâncești 216 is a bakery, and the registry legal address is in s. Ruseștii Noi.
- **Russian-language** copy for anything water-related
- **Telegram post content**: prices, announcements, etc. (the channel blocks web preview)
