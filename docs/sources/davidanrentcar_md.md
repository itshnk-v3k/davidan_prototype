# DaviDan Rent Car — source data from davidanrentcar.md

Collected 2026-09-16 with raw `curl` of the live site (HTML + WordPress/WooCommerce REST endpoints). All quoted text is copied verbatim from the site (including its typos/inconsistencies). Anything not found on the site is marked **NOT FOUND**. Editor notes are in *italics* or under "Notes"; they are not site copy.

Raw downloads, extracted text and helper scripts live next to this file in `research/rentcar/`.

## 0. Platform and language scheme

- **Platform:** WordPress (generator meta "WordPress 7.1") + WooCommerce 10.6.1, theme **Ireca** by Ovatheme (`/wp-content/themes/ireca`, child theme `ireca-child`) with the Ovatheme car-rental plugin **ova-crs** (products are WooCommerce type `ovacrs_car_rental`). Also: Elementor 4.0.0, Slider Revolution 6.7.37 (SR7 markup), Contact Form 7 6.1.5 + wpcf7-redirect, Rank Math SEO, Jetpack, LiteSpeed Cache, GTranslate, `maib-payment-gateway-for-woocommerce-main` (MAIB card gateway). Footer credit: "Site realizat de INOVEX.md" (https://inovex.md).
- **Data endpoints that work publicly:** `https://davidanrentcar.md/wp-json/wc/store/v1/products?per_page=100` (11 products, prices, images, categories), `https://davidanrentcar.md/wp-json/wp/v2/pages`, `https://davidanrentcar.md/wp-json/wp/v2/product`, sitemap index `https://davidanrentcar.md/sitemap_index.xml` (Rank Math). `/wp-sitemap.xml` also resolves to the Rank Math index.
- **Languages:** the only authored language is **Romanian** (`<html lang="ro-RO">`, `og:locale` `ro_RO`). There are **no hreflang tags**, no `/ru/` or `/en/` URLs (both 404), and `?lang=ru` returns the Romanian page. The header menu has a **GTranslate** flag switcher configured as:
  `{"default_language":"ro","languages":["ro","ru","en"],"url_structure":"none",...}`
  `url_structure: "none"` means RU and EN are produced **client-side by Google Translate machine translation** at view time; no Russian or English text exists in the site's HTML or database.
  → **Russian copy: NOT FOUND (machine translation only). English copy: NOT FOUND (machine translation only).** Nothing in this document is translated; every quote is the Romanian original.
- Leftover theme demo content (not DaviDan copy): blog posts "Hello world!", "Tout Terrain gold city", "How to drive a car ?", "Drive a boat by yourself", "Luxury yacht ocean" etc. (dated 2018/2023/2025), categories Boat/Car/Motobike. ova-crs "vehicle" ID posts (`/vehicle/…`: Honda, BMW, Mercedes-Benz, Lexus CT200h – Hybrid, Dacia 1.0 Benzină + GPL, Porsche Cayenne Plug-in Hybrid, Toyota RAV4 Plug-in, Audi Q5) are empty inventory IDs, not public listings. There is no Honda or Lexus product for sale.

## 1. Fleet (11 cars)

Sources: https://davidanrentcar.md/toate-masinile/ ("Afișez toate cele 11 rezultate"), each product page `https://davidanrentcar.md/produs/<slug>/`, and `wc/store/v1/products`. Currency on the site is EUR (`currency_code":"EUR"`), displayed as `30,00 €`.

### 1.1 Summary table (verbatim values)

| # | Name (h1) | Slug | WC id | Brand category | Price shown | Anul mașinii | Combustibil | Cutie de viteze | Consum | Max pasageri | Capacitatea motorului | Uși | Kilometraj |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Audi Q5 2012 | `audi-q5-2012` | 3773 | Audi | 30,00 € / Ziua | 2012 | Benzină | Automată | 10 l/100 km | 5 | 2.0 | 5 | Nelimitat |
| 2 | Audi Q5 2021 | `audi-q5-2021` | 3689 | Audi | 45,00 € / Ziua | 2021 | Benzină | Automată | 10 l/100 km | 5 | 2.0 | 5 | Nelimitat |
| 3 | BMW X5 | `bmw-x5` | 4749 | BMW | 60,00 € / Ziua | 2017 | Benzină | Automată | 10 l/100 km | 5 | 2.0 | 5 | Nelimitat |
| 4 | Dacia Lodgy | `dacia-lodgy` | 4774 | Dacia | 19,00 € / Ziua | 2016 | Diesel | Manuala | 10 l/100 km | 7 | 1.5 | 5 | Nelimitat |
| 5 | Dacia Logan | `dacia-1-0-benzina-gpl-2022` | 3743 | Dacia | 19,00 € / Ziua | 2022 | Benzină/GPL | Manuală | 5 l/100 km | 5 | 1.0 | 5 | Nelimitat |
| 6 | Dacia Sandero | `dacia-sandero` | 4767 | Dacia | 19,00 € / Ziua | 2015 | Benzină | Manuala | 10 l/100 km | 5 | 1.0 | 5 | Nelimitat |
| 7 | Ford Focus | `ford-focus` | 4757 | Ford | 28,00 € / Ziua | 2018 | Diesel | Automată | 10 l/100 km | 5 | 2.0 | 5 | Nelimitat |
| 8 | Ford Kuga | `ford-kuga` | 4781 | Ford | 30,00 € / Ziua | 2021 | Diesel | Automată | 10 l/100 km | 5 | 1.5 | 5 | Nelimitat |
| 9 | Mercedes-Benz | `mercedes-benz-e-class-2017-diesel` | 3763 | Mercedes-Benz | 40,00 € / Ziua | 2017 | Diesel | Automată | 7 l/100 km | 5 | 2.0 | 5 | Nelimitat |
| 10 | Porsche Cayenne | `porsche-cayenne-3-0-plug-in-hybrid` | 3736 | Porsche | 60,00 € / Ziua | 2017 | Benzină/Plug-in Hybrid | Automată | 10 l/100 km | 5 | 3.0 | 5 | Nelimitat |
| 11 | Toyota RAV4 | `toyota-rav4-2-5-plug-in` | 3724 | Toyota | 45,00 € / Ziua | 2020 | Benzină/Plug-in Hybrid | Automată | 10 l/100 km | 5 | 2.5 | 5 | Nelimitat |

Spec labels exactly as on the product page: "Anul mașinii:", "Combustibil:", "Cutie de viteze:", "Consumul de combustibil:", "Max pasageri:", "Capacitatea motorului:", "Uși:", "Kilometraj:". Engine capacity has no unit on the site (e.g. "2.0").

**Category / class:** the only taxonomy is WooCommerce product categories = brand names (Audi, BMW, Dacia, Ford, Mercedes-Benz, Porsche, Toyota; plus an unused "Car" category). **Vehicle class (economy/SUV/premium etc.): NOT FOUND.** (The only class words on the site are in the T&C cleaning fee: "sedan", "SUV", "alte categorii".)

### 1.2 Tiered daily pricing ("Tabel de Prețuri pe Zile")

Verbatim table on every product page: heading "Tabel de Prețuri pe Zile", then "Preț normal/zi:" and a table titled "Reducere globală" with columns "Durata (zile)" / "Pret/zi". The site shows only the starting day count of each row.

| Name | Preț normal/zi | Durata 1 | Durata 4 | Durata 11 | Durata 21 |
|---|---|---|---|---|---|
| Audi Q5 2012 | 30,00 € | 70,00 € | 50,00 € | 40,00 € | 30,00 € |
| Audi Q5 2021 | 45,00 € | 100,00 € | 60,00 € | 50,00 € | 45,00 € |
| BMW X5 | 60,00 € | 150,00 € | 80,00 € | 70,00 € | 60,00 € |
| Dacia Lodgy | 19,00 € | 30,00 € | 25,00 € | 23,00 € | 19,00 € |
| Dacia Logan | 19,00 € | 30,00 € | 25,00 € | 23,00 € | 19,00 € |
| Dacia Sandero | 19,00 € | 30,00 € | 25,00 € | 23,00 € | 19,00 € |
| Ford Focus | 28,00 € | 60,00 € | 45,00 € | 35,00 € | 28,00 € |
| Ford Kuga | 30,00 € | 70,00 € | 50,00 € | 40,00 € | 30,00 € |
| Mercedes-Benz | 40,00 € | 80,00 € | 60,00 € | 50,00 € | 40,00 € |
| Porsche Cayenne | 60,00 € | 150,00 € | 90,00 € | 70,00 € | 60,00 € |
| Toyota RAV4 | 45,00 € | 100,00 € | 60,00 € | 50,00 € | 45,00 € |

**How the tiers apply (checked in a live test cart, not site copy):** a Dacia Logan rental was priced at 30,00 €/day for 1 and 3 days, 25,00 €/day for 4 and 10 days, 23,00 €/day for 11 days and 19,00 €/day for 21 days. So the rows mean **1–3 days / 4–10 days / 11–20 days / 21+ days**, and the "Preț normal/zi" (the price on listings, e.g. "19,00 € / Ziua", and the "De la 19 € / ziua" slider copy) is the **21+ day rate**. A 1-day rental of each car was priced at its "Durata 1" rate (see 1.3). A rental of 1 day + 4 hours (10-04-2027 09:00 → 11-04-2027 13:00) was charged as "2 Zile obișnuite".

### 1.3 Fees added at cart (observed, 1-day test rental per car)

Cart line labels verbatim: "Taxa de locație:", "Suma de asigurare:", "Id Vehicul:", "Resursă suplimentară:", "Zile obișnuite". Both fees are included in the line total. Observed on 2026-09-16; nothing was ordered and the test cart was emptied afterwards.

| Name | Id Vehicul (internal) | Taxa de locație | Suma de asigurare | 1-day rate | 1-day line total |
|---|---|---|---|---|---|
| Audi Q5 2012 | Audi555 | 11,00 € | 200,00 € | 70,00 € | 281,00 € |
| Audi Q5 2021 | Audi555 | 11,00 € | 200,00 € | 100,00 € | 311,00 € |
| BMW X5 | BMW | 11,00 € | 200,00 € | 150,00 € | 361,00 € |
| Dacia Lodgy | Dacia1.0BenzinăGPL2022 | 11,00 € | 150,00 € | 30,00 € | 191,00 € |
| Dacia Logan | Dacia1.0BenzinăGPL2022 | 11,00 € | 150,00 € | 30,00 € | 191,00 € |
| Dacia Sandero | Dacia1.0BenzinăGPL2022 | 11,00 € | 150,00 € | 30,00 € | 191,00 € |
| Ford Focus | Honda | 11,00 € | 200,00 € | 60,00 € | 271,00 € |
| Ford Kuga | Honda | 11,00 € | 200,00 € | 70,00 € | 281,00 € |
| Mercedes-Benz | Mercedes-Benz | 11,00 € | 200,00 € | 80,00 € | 291,00 € |
| Porsche Cayenne | PorscheCayenne3.0Plug-inHybrid | 11,00 € | 300,00 € | 150,00 € | 461,00 € |
| Toyota RAV4 | ToyotaRAV42.5Plugin | 11,00 € | 200,00 € | 100,00 € | 311,00 € |

- "Taxa de locație" was 11,00 € for every combination tried: Chișinău→Chișinău, Aeroport Chisinău→Aeroport Chisinău, Aeroport Chisinău→Chișinău, Chișinău→Aeroport Chisinău.
- "Suma de asigurare" is 150,00 € (Dacia Logan/Lodgy/Sandero), 200,00 € (Ford Kuga, Ford Focus, BMW X5, both Audi Q5, Mercedes-Benz, Toyota RAV4), 300,00 € (Porsche Cayenne). The site does not explain on the product page whether this is refundable. The T&C section V says: "Garanția este o sumă de bani blocată pe durata închirierii." and "Valoarea garanției variază în funcție de modelul vehiculului, vechimea permisului și vârsta clientului." *(No explicit link between "Suma de asigurare" and "Garanția" is stated on the site.)*
- Extras test (Dacia Logan 1 day, Aeroport Chisinău→Chișinău, both extras, "Plătiți Avans"): 30 + 10 (Scaun pentru copii) + 5 (Kilometri nelimitați) + 11 + 150 = 206 €. The cart showed the line as "50,00 €" and the totals block showed "Rămânând 156,00 €", so **"Plătiți Avans" charges a fixed 50,00 € upfront** (matches the form text "Opțiunea de avans 50,00 € pentru rezervarea maşinii"). *This contradicts the T&C, which say "avans de 50%".*

### 1.4 Per-car detail (verbatim)

#### Audi Q5 2012

- URL: https://davidanrentcar.md/produs/audi-q5-2012/  |  slug `audi-q5-2012`  |  WooCommerce id 3773  |  category: Audi
- Price line: "30,00 € / Ziua"
- Specs: "Anul mașinii: 2012"; "Combustibil: Benzină"; "Cutie de viteze: Automată"; "Consumul de combustibil: 10 l/100 km"; "Max pasageri: 5"; "Capacitatea motorului: 2.0"; "Uși: 5"; "Kilometraj: Nelimitat"
- Feature ticks (other features): "Scaune din piele"; "Aer condiționat automat"; "Senzori de parcare"; "Cameră marșarier"; "Pilot automat"; "Sistem audio premium"; "Bluetooth"; "Navigație GPS"
- Tier table: "Preț normal/zi: 30,00 €" | 1 → 70,00 € | 4 → 50,00 € | 11 → 40,00 € | 21 → 30,00 €
- Booking form extras ("Serviciu suplimentar"): "Scaun pentru copii — 10,00 € / Total"; "Kilometri nelimitați — 5,00 € / Ziua"
- Deposit block: "Opțiunea de avans 50,00 € pentru rezervarea maşinii"
- SEO meta description: "Audi Q5 2.0 Benzină 2012 – Confort și Fiabilitate!"
- Images (gallery order, first = featured): https://davidanrentcar.md/wp-content/uploads/2025/02/Q52012.jpg, https://davidanrentcar.md/wp-content/uploads/2025/02/Q52012.1-600-x-600-px.jpg, https://davidanrentcar.md/wp-content/uploads/2025/02/Q52012.2-600-x-600-px.jpg
- Description tab ("Descriere"), verbatim:

  > Audi Q5 2.0 Benzină 2012 – Confort și Fiabilitate!
  > - Detalii: An fabricație: 2012
  > - Motorizare: 2.0 TFSI Benzină
  > - Transmisie: Automată / Tracțiune integrală Quattro
  > - Consum echilibrat și întreținere impecabilă
  > - Dotări: Aer condiționat automat, scaune din piele, senzori de parcare, cameră marșarier, pilot automat, sistem audio premium, Bluetooth, navigație GPS

#### Audi Q5 2021

- URL: https://davidanrentcar.md/produs/audi-q5-2021/  |  slug `audi-q5-2021`  |  WooCommerce id 3689  |  category: Audi
- Price line: "45,00 € / Ziua"
- Specs: "Anul mașinii: 2021"; "Combustibil: Benzină"; "Cutie de viteze: Automată"; "Consumul de combustibil: 10 l/100 km"; "Max pasageri: 5"; "Capacitatea motorului: 2.0"; "Uși: 5"; "Kilometraj: Nelimitat"
- Feature ticks (other features): "Scaune din piele"; "Climatizare automată pe 3 zone"; "Senzori de parcare față/spate"; "Cameră marșarier"; "Faruri LED Matrix"; "Hayon electric"; "Pilot automat adaptiv"; "Sistem audio premium"; "Apple CarPlay / Android Auto"; "Navigație GPS"
- Tier table: "Preț normal/zi: 45,00 €" | 1 → 100,00 € | 4 → 60,00 € | 11 → 50,00 € | 21 → 45,00 €
- Booking form extras ("Serviciu suplimentar"): "Scaun pentru copii — 10,00 € / Total"
- Request form extras (differs): "Scaun pentru copii — 10,00 € / Total"; "kilo — 5,00 € / Ziua"
- Deposit block: "Opțiunea de avans 50,00 € pentru rezervarea maşinii"
- SEO meta description: "Audi Q5 2.0 Benzină 2021 – Lux și Performanță!"
- Images (gallery order, first = featured): https://davidanrentcar.md/wp-content/uploads/2025/02/Q7-900-x-600-px.jpg, https://davidanrentcar.md/wp-content/uploads/2025/02/Q52021.1-600-x-600-px.jpg, https://davidanrentcar.md/wp-content/uploads/2025/02/Q52021.2-600-x-600-px.jpg
- Description tab ("Descriere"), verbatim:

  > Audi Q5 2.0 Benzină 2021 – Lux și Performanță!
  > - Detalii: An fabricație: 2021
  > - Motorizare: 2.0 TFSI Benzină
  > - Transmisie: Automată / Tracțiune integrală Quattro
  > - Consum eficient și confort de top
  > - Dotări premium: Scaune din piele, climatizare automată pe 3 zone, senzori de parcare față/spate, cameră marșarier, faruri LED Matrix, hayon electric, pilot automat adaptiv, sistem audio premium, Apple CarPlay / Android Auto, navigație GPS

#### BMW X5

- URL: https://davidanrentcar.md/produs/bmw-x5/  |  slug `bmw-x5`  |  WooCommerce id 4749  |  category: BMW
- Price line: "60,00 € / Ziua"
- Specs: "Anul mașinii: 2017"; "Combustibil: Benzină"; "Cutie de viteze: Automată"; "Consumul de combustibil: 10 l/100 km"; "Max pasageri: 5"; "Capacitatea motorului: 2.0"; "Uși: 5"; "Kilometraj: Nelimitat"
- Feature ticks (other features): "Scaune din piele"; "Climatizare automată pe 3 zone"; "Senzori de parcare față/spate"; "Cameră marșarier"; "Faruri LED Matrix"; "Hayon electric"; "Pilot automat adaptiv"; "Sistem audio premium"; "Apple CarPlay / Android Auto"; "Navigație GPS"
- Tier table: "Preț normal/zi: 60,00 €" | 1 → 150,00 € | 4 → 80,00 € | 11 → 70,00 € | 21 → 60,00 €
- Booking form extras ("Serviciu suplimentar"): "Scaun pentru copii — 10,00 € / Total"; "Kilometri nelimitați — 5,00 € / Ziua"
- Deposit block: "Opțiunea de avans 50,00 € pentru rezervarea maşinii"
- SEO meta description: "BMW X5 2.0 Benzină Plug-in Hybrid – Putere și Eficiență!"
- Images (gallery order, first = featured): https://davidanrentcar.md/wp-content/uploads/2025/05/BMW-1.jpg, https://davidanrentcar.md/wp-content/uploads/2025/05/X5-2.jpg, https://davidanrentcar.md/wp-content/uploads/2025/05/X5-4.jpg, https://davidanrentcar.md/wp-content/uploads/2025/05/X5-5.jpg, https://davidanrentcar.md/wp-content/uploads/2025/05/X5-3.jpg, https://davidanrentcar.md/wp-content/uploads/2025/05/X5-6.jpg
- Description tab ("Descriere"), verbatim:

  > BMW X5 2.0 Benzină Plug-in Hybrid – Putere și Eficiență!
  >
  > Detalii:
  > •An fabricație:2017
  > •Motorizare: 2.0 Benzină + Plug-in Hybrid (xDrive40e)
  > •Transmisie: Automată / Tracțiune integrală xDrive
  > •Autonomie electrică + motor termic pentru un consum optimizat
  > •Dotări premium: Scaune din piele, climatizare automată pe 4 zone, sistem multimedia cu ecran tactil, Apple CarPlay / Android Auto, senzori de parcare, hayon electric

#### Dacia Lodgy

- URL: https://davidanrentcar.md/produs/dacia-lodgy/  |  slug `dacia-lodgy`  |  WooCommerce id 4774  |  category: Dacia
- Price line: "19,00 € / Ziua"
- Specs: "Anul mașinii: 2016"; "Combustibil: Diesel"; "Cutie de viteze: Manuala"; "Consumul de combustibil: 10 l/100 km"; "Max pasageri: 7"; "Capacitatea motorului: 1.5"; "Uși: 5"; "Kilometraj: Nelimitat"
- Feature ticks (other features): "7 locuri"; "Geamuri electrice"; "Senzori de parcare"; "Bluetooth"; "USB"; "ABS"; "Pilot automat"; "Sistem multimedia cu ecran tactil"; "ESP"; "Aier conditionat"
- Tier table: "Preț normal/zi: 19,00 €" | 1 → 30,00 € | 4 → 25,00 € | 11 → 23,00 € | 21 → 19,00 €
- Booking form extras ("Serviciu suplimentar"): "Scaun pentru copii — 10,00 € / Total"; "Kilometri nelimitați — 5,00 € / Ziua"
- Deposit block: "Opțiunea de avans 50,00 € pentru rezervarea maşinii"
- SEO meta description: "Dacia Lodgy 1.5 Diesel 2016 – Spațioasă și Economică!"
- Images (gallery order, first = featured): https://davidanrentcar.md/wp-content/uploads/2025/05/L1.jpg, https://davidanrentcar.md/wp-content/uploads/2025/05/l2.jpg, https://davidanrentcar.md/wp-content/uploads/2025/05/l3.jpg, https://davidanrentcar.md/wp-content/uploads/2025/05/l4.jpg, https://davidanrentcar.md/wp-content/uploads/2025/05/L5.jpg
- Description tab ("Descriere"), verbatim:

  > Dacia Lodgy 1.5 Diesel 2016 – Spațioasă și Economică!
  >
  > • Detalii:
  > • An fabricație: 2016
  > • Motorizare: 1.5 dCi Diesel
  > • Transmisie: Manuală
  > • Consum redus și întreținere accesibilă
  > • Dotări: 7 locuri, aer condiționat, geamuri electrice, senzori de parcare, cameră marșarier, sistem multimedia cu ecran tactil, Bluetooth, USB, pilot automat, ABS, ESP, airbag-uri frontale și laterale

#### Dacia Logan

- URL: https://davidanrentcar.md/produs/dacia-1-0-benzina-gpl-2022/  |  slug `dacia-1-0-benzina-gpl-2022`  |  WooCommerce id 3743  |  category: Dacia
- Price line: "19,00 € / Ziua"
- Specs: "Anul mașinii: 2022"; "Combustibil: Benzină/GPL"; "Cutie de viteze: Manuală"; "Consumul de combustibil: 5 l/100 km"; "Max pasageri: 5"; "Capacitatea motorului: 1.0"; "Uși: 5"; "Kilometraj: Nelimitat"
- Feature ticks (other features): "Consum redus"; "Autonomie extinsă"
- Tier table: "Preț normal/zi: 19,00 €" | 1 → 30,00 € | 4 → 25,00 € | 11 → 23,00 € | 21 → 19,00 €
- Booking form extras ("Serviciu suplimentar"): "Scaun pentru copii — 10,00 € / Total"; "Kilometri nelimitați — 5,00 € / Ziua"
- Deposit block: "Opțiunea de avans 50,00 € pentru rezervarea maşinii"
- SEO meta description: "Dacia 1.0 Benzină + GPL 2022 – Economică și Fiabilă!"
- Images (gallery order, first = featured): https://davidanrentcar.md/wp-content/uploads/2025/02/Dacia.jpg, https://davidanrentcar.md/wp-content/uploads/2025/02/Dacia1-600-x-600-px.jpg, https://davidanrentcar.md/wp-content/uploads/2025/02/Dacia2-600-x-600-px.jpg
- Description tab ("Descriere"), verbatim:

  > Dacia 1.0 Benzină + GPL 2022 – Economică și Fiabilă!
  > - Detalii: An fabricație: 2022
  > - Motorizare: 1.0 TCe Benzină + GPL
  > - Transmisie: Manuală
  > - Consum redus și autonomie extinsă datorită sistemului GPL

#### Dacia Sandero

- URL: https://davidanrentcar.md/produs/dacia-sandero/  |  slug `dacia-sandero`  |  WooCommerce id 4767  |  category: Dacia
- Price line: "19,00 € / Ziua"
- Specs: "Anul mașinii: 2015"; "Combustibil: Benzină"; "Cutie de viteze: Manuala"; "Consumul de combustibil: 10 l/100 km"; "Max pasageri: 5"; "Capacitatea motorului: 1.0"; "Uși: 5"; "Kilometraj: Nelimitat"
- Feature ticks (other features): "Aier conditionat"; "Geamuri electrice"; "Senzori de parcare"; "Bluetooth"; "USB"; "ABS"; "Pilot automat"; "Sistem multimedia"; "ESP"; "Airbag frontal si lateral"
- Tier table: "Preț normal/zi: 19,00 €" | 1 → 30,00 € | 4 → 25,00 € | 11 → 23,00 € | 21 → 19,00 €
- Booking form extras ("Serviciu suplimentar"): "Scaun pentru copii — 10,00 € / Total"; "Kilometri nelimitați — 5,00 € / Ziua"
- Deposit block: "Opțiunea de avans 50,00 € pentru rezervarea maşinii"
- SEO meta description: "Dacia Sandero 1.0 Turbo Benzină 2015 – Economică și Fiabilă!"
- Images (gallery order, first = featured): https://davidanrentcar.md/wp-content/uploads/2025/05/S2.jpg, https://davidanrentcar.md/wp-content/uploads/2025/05/S3.jpg, https://davidanrentcar.md/wp-content/uploads/2025/05/S4.jpg, https://davidanrentcar.md/wp-content/uploads/2025/05/S5.jpg
- Description tab ("Descriere"), verbatim:

  > Dacia Sandero 1.0 Turbo Benzină 2015 – Economică și Fiabilă!
  >
  > •Detalii:
  > • An fabricație: 2015
  > • Motorizare: 1.0 TCe Turbo Benzină
  > • Transmisie: Manuală
  > • Consum redus și întreținere accesibilă
  > • Dotări: Aer condiționat, geamuri electrice, senzori de parcare, sistem multimedia cu ecran tactil, Bluetooth, USB, pilot automat, ABS, ESP, airbag-uri frontale și laterale

#### Ford Focus

- URL: https://davidanrentcar.md/produs/ford-focus/  |  slug `ford-focus`  |  WooCommerce id 4757  |  category: Ford
- Price line: "28,00 € / Ziua"
- Specs: "Anul mașinii: 2018"; "Combustibil: Diesel"; "Cutie de viteze: Automată"; "Consumul de combustibil: 10 l/100 km"; "Max pasageri: 5"; "Capacitatea motorului: 2.0"; "Uși: 5"; "Kilometraj: Nelimitat"
- Feature ticks (other features): "Scaune Sport"; "Climatizare automată"; "Senzori de parcare față/spate"; "Cameră marșarier"; "Faruri LED"; "Hayon electric"; "Pilot automat adaptiv"; "Sistem audio premium"; "Apple CarPlay / Android Auto"; "Navigație GPS"
- Tier table: "Preț normal/zi: 28,00 €" | 1 → 60,00 € | 4 → 45,00 € | 11 → 35,00 € | 21 → 28,00 €
- Booking form extras ("Serviciu suplimentar"): "Scaun pentru copii — 10,00 € / Total"; "Kilometri nelimitați — 5,00 € / Ziua"
- Deposit block: "Opțiunea de avans 50,00 € pentru rezervarea maşinii"
- SEO meta description: "Ford Focus 2.0 Diesel 2018 ST-Line – Sportivitate și Eficiență!"
- Images (gallery order, first = featured): https://davidanrentcar.md/wp-content/uploads/2025/05/titlu.jpg, https://davidanrentcar.md/wp-content/uploads/2025/05/2.jpg, https://davidanrentcar.md/wp-content/uploads/2025/05/4.jpg, https://davidanrentcar.md/wp-content/uploads/2025/05/3.jpg, https://davidanrentcar.md/wp-content/uploads/2025/05/1.jpg
- Description tab ("Descriere"), verbatim:

  > Ford Focus 2.0 Diesel 2018 ST-Line – Sportivitate și Eficiență!
  >
  > •Detalii:
  > •An fabricație: 2018
  > •Motorizare: 2.0 TDCi Diesel
  > •Transmisie: Automată
  > •Consum redus și performanță optimă
  > •Dotări ST-Line: Scaune sport, volan multifuncțional îmbrăcat în piele, suspensie sport, climatizare automată, senzori de parcare față/spate, cameră marșarier, faruri LED, pilot automat, Apple CarPlay / Android Auto, navigație GPS

#### Ford Kuga

- URL: https://davidanrentcar.md/produs/ford-kuga/  |  slug `ford-kuga`  |  WooCommerce id 4781  |  category: Ford
- Price line: "30,00 € / Ziua"
- Specs: "Anul mașinii: 2021"; "Combustibil: Diesel"; "Cutie de viteze: Automată"; "Consumul de combustibil: 10 l/100 km"; "Max pasageri: 5"; "Capacitatea motorului: 1.5"; "Uși: 5"; "Kilometraj: Nelimitat"
- Feature ticks (other features): "Scaune Sport"; "Climatronic dual zone"; "Senzori de parcare față/spate"; "Cameră marșarier"; "Faruri LED"; "Sistem de asistenta la mentinerea benzii"; "Pilot automat adaptiv"; "Sistem multimedia"; "Apple CarPlay / Android Auto"; "Navigație GPS"
- Tier table: "Preț normal/zi: 30,00 €" | 1 → 70,00 € | 4 → 50,00 € | 11 → 40,00 € | 21 → 30,00 €
- Booking form extras ("Serviciu suplimentar"): "Scaun pentru copii — 10,00 € / Total"; "Kilometri nelimitați — 5,00 € / Ziua"
- Deposit block: "Opțiunea de avans 50,00 € pentru rezervarea maşinii"
- SEO meta description: "Ford Kuga 2021 – Modernă, Confortabilă și Pregătită de Aventură!"
- Images (gallery order, first = featured): https://davidanrentcar.md/wp-content/uploads/2025/05/k1.jpg, https://davidanrentcar.md/wp-content/uploads/2025/05/k2.jpg, https://davidanrentcar.md/wp-content/uploads/2025/05/k3.jpg, https://davidanrentcar.md/wp-content/uploads/2025/05/k4.jpg, https://davidanrentcar.md/wp-content/uploads/2025/05/k5.jpg
- Description tab ("Descriere"), verbatim:

  > Ford Kuga 2021 – Modernă, Confortabilă și Pregătită de Aventură!
  >
  > • Detalii:
  > • An fabricație: 2021
  > • Motorizare: 1.5 Diesel
  > • Transmisie: Automată
  > • Consum eficient și performanță excelentă
  > • Dotări: climatronic dual-zone, geamuri electrice, senzori parcare față/spate, cameră marșarier, sistem multimedia cu ecran tactil, Bluetooth, USB, pilot automat adaptiv, sistem de asistență la menținerea benzii, ABS, ESP, airbag-uri frontale și laterale de parcare față/spate, cameră marșarier, faruri LED, pilot automat, Apple CarPlay / Android Auto, navigație GPS

#### Mercedes-Benz

- URL: https://davidanrentcar.md/produs/mercedes-benz-e-class-2017-diesel/  |  slug `mercedes-benz-e-class-2017-diesel`  |  WooCommerce id 3763  |  category: Mercedes-Benz
- Price line: "40,00 € / Ziua"
- Specs: "Anul mașinii: 2017"; "Combustibil: Diesel"; "Cutie de viteze: Automată"; "Consumul de combustibil: 7 l/100 km"; "Max pasageri: 5"; "Capacitatea motorului: 2.0"; "Uși: 5"; "Kilometraj: Nelimitat"
- Feature ticks (other features): "Scaune din piele"; "Climatizare automată pe zone"; "Sistem audio premium"; "Navigație GPS"; "Apple CarPlay/Android Auto"
- Tier table: "Preț normal/zi: 40,00 €" | 1 → 80,00 € | 4 → 60,00 € | 11 → 50,00 € | 21 → 40,00 €
- Booking form extras ("Serviciu suplimentar"): "Scaun pentru copii — 10,00 € / Total"; "Kilometri nelimitați — 5,00 € / Ziua"
- Deposit block: "Opțiunea de avans 50,00 € pentru rezervarea maşinii"
- SEO meta description: "Mercedes-Benz E-Class 2017 Diesel – Eleganță și Performanță!"
- Images (gallery order, first = featured): https://davidanrentcar.md/wp-content/uploads/2025/02/Mercedes-E.jpg, https://davidanrentcar.md/wp-content/uploads/2025/02/Mercedes-Benz2-600-x-600-px.jpg, https://davidanrentcar.md/wp-content/uploads/2025/02/Mercedes-Benz1-600-x-600-px.jpg
- Description tab ("Descriere"), verbatim:

  > Mercedes-Benz E-Class 2017 Diesel – Eleganță și Performanță!
  > - Detalii: An fabricație: 2017
  > - Motorizare: Diesel 2.0
  > - Transmisie: Automată 9G-Tronic
  > - Consum redus și confort premium, ideal pentru orice tip de călătorie
  > - Dotări de lux: Scaune din piele încălzite, climatizare automată pe zone, sistem audio premium, navigație GPS, Apple CarPlay/Android Auto

#### Porsche Cayenne

- URL: https://davidanrentcar.md/produs/porsche-cayenne-3-0-plug-in-hybrid/  |  slug `porsche-cayenne-3-0-plug-in-hybrid`  |  WooCommerce id 3736  |  category: Porsche
- Price line: "60,00 € / Ziua"
- Specs: "Anul mașinii: 2017"; "Combustibil: Benzină/Plug-in Hybrid"; "Cutie de viteze: Automată"; "Consumul de combustibil: 10 l/100 km"; "Max pasageri: 5"; "Capacitatea motorului: 3.0"; "Uși: 5"; "Kilometraj: Nelimitat"
- Feature ticks (other features): "Scaune din piele încălzite"; "Climatizare pe zone"; "Suspensie pneumatică"; "Sistem audio premium"; "Senzori parcare"; "Navigație GPS"
- Tier table: "Preț normal/zi: 60,00 €" | 1 → 150,00 € | 4 → 90,00 € | 11 → 70,00 € | 21 → 60,00 €
- Booking form extras ("Serviciu suplimentar"): "Scaun pentru copii — 10,00 € / Total"
- Request form extras (differs): "Scaun pentru copii — 10,00 € / Total"; "kilo — 5,00 € / Ziua"
- Deposit block: "Opțiunea de avans 50,00 € pentru rezervarea maşinii"
- SEO meta description: "Porsche Cayenne 3.0 Plug-in Hybrid 2017 – Lux și Performanță!"
- Images (gallery order, first = featured): https://davidanrentcar.md/wp-content/uploads/2025/02/Porsche.jpg, https://davidanrentcar.md/wp-content/uploads/2025/02/Porsche2-600-x-600-px.jpg, https://davidanrentcar.md/wp-content/uploads/2025/02/Porsche1-600-x-600-px.jpg
- Description tab ("Descriere"), verbatim:

  > Porsche Cayenne 3.0 Plug-in Hybrid 2017 – Lux și Performanță!
  > - Detalii: An fabricație: 2017
  > - Motorizare: 3.0 Plug-in Hybrid (benzină + electric)
  > - Transmisie: Automată, tracțiune integrală (AWD)
  > - Consum redus și putere impresionantă – ideal pentru oraș și drumuri lungi
  > - Dotări premium: Scaune din piele încălzite, climatizare pe zone, suspensie pneumatică, sistem audio premium, senzori parcare, navigație GPS, etc.

#### Toyota RAV4

- URL: https://davidanrentcar.md/produs/toyota-rav4-2-5-plug-in/  |  slug `toyota-rav4-2-5-plug-in`  |  WooCommerce id 3724  |  category: Toyota
- Price line: "45,00 € / Ziua"
- Specs: "Anul mașinii: 2020"; "Combustibil: Benzină/Plug-in Hybrid"; "Cutie de viteze: Automată"; "Consumul de combustibil: 10 l/100 km"; "Max pasageri: 5"; "Capacitatea motorului: 2.5"; "Uși: 5"; "Kilometraj: Nelimitat"
- Feature ticks (other features): "Aer condiționat"; "Senzori de parcare"; "Sistem de navigație GPS"; "Bluetooth"; "Sistem de asistență la condus (Toyota Safety Sense)"; "Sistem audio premium"
- Tier table: "Preț normal/zi: 45,00 €" | 1 → 100,00 € | 4 → 60,00 € | 11 → 50,00 € | 21 → 45,00 €
- Booking form extras ("Serviciu suplimentar"): "Scaun pentru copii — 10,00 € / Total"
- Request form extras (differs): "Scaun pentru copii — 10,00 € / Total"; "kilo — 5,00 € / Ziua"
- Deposit block: "Opțiunea de avans 50,00 € pentru rezervarea maşinii"
- SEO meta description: "Toyota RAV4 2.5 Plug-in Hybrid – Confort și Siguranță!"
- Images (gallery order, first = featured): https://davidanrentcar.md/wp-content/uploads/2025/02/Rav4.jpg, https://davidanrentcar.md/wp-content/uploads/2025/02/Toyota2-600-x-600-px.jpg, https://davidanrentcar.md/wp-content/uploads/2025/02/Toyota1-600-x-600-px.jpg
- Description tab ("Descriere"), verbatim:

  > Toyota RAV4 2.5 Plug-in Hybrid – Confort și Siguranță!
  > - Detalii: An fabricație: 2020
  > - Motorizare: 2,5 Plug-in Hybrid
  > - Transmisie: Automată
  > - Consum redus datorită tehnologiei hibride și întreținerii impecabile
  > - Dotări: Aer condiționat, senzori de parcare, sistem de navigație GPS, conectivitate Bluetooth, sistem de asistență la condus (Toyota Safety Sense) și multe altele

## 2. Booking flow

Sources: any product page (e.g. https://davidanrentcar.md/produs/ford-kuga/), cart https://davidanrentcar.md/cos/, checkout https://davidanrentcar.md/finalizare-comanda/, thank-you page https://davidanrentcar.md/pagina-de-multumire/. All labels below are verbatim Romanian; **RU/EN labels: NOT FOUND** (GTranslate machine translation only).

**Summary:** there are three ways to book or ask on each product page. (1) **"Formular de rezervare"** adds the rental to the WooCommerce cart ("Rezervare" button) and goes to checkout with **online card payment via MAIB** ("Achită Online", "Achită cu Visa / Mastercard / Apple Pay / Google Pay"). The customer picks either the fixed 50 € advance or the full amount. (2) **"Cerere de rezervare"** tab: a request form that is emailed to the company ("Trimiteți-ne cererea dvs. Vom verifica e-mailul și vă vom contacta în curând."). (3) **"Formular de contact"** tab: a general Contact Form 7 form. The T&C say that after booking and payment "clientul va fi contactat de un reprezentant al companiei" to check the driving licence and ID.

### 2.1 Product page, top

- Button under the title: "Rezervați acum"
- Price: e.g. "30,00 € / Ziua"
- Availability calendar legend: "Este disponibilitate" / "Nu este disponibilitate: Nu poți închiria (selectează zilele disponibile din calendar). Închiriere pe oră: posibil, dar verifică telefonic." (calendar "Mai mult" link text)

### 2.2 "Formular de rezervare" (booking form → cart)

| Field label (verbatim) | Control | Options / format |
|---|---|---|
| Locația de ridicare | select `ovacrs_pickup_loc`, required | "Selectați Locație" / "Aeroport Chisinău" / "Chișinău" |
| Locație de predare | select `ovacrs_pickoff_loc`, required | "Selectați Locație" / "Aeroport Chisinău" / "Chișinău" |
| Data ridicării | date+time picker `ovacrs_pickup_date`, required | placeholder "d-m-Y"; date format `d-m-Y`, time format `H:i`, default hour 09:00, 30-minute steps; time list runs 07:00, 07:30 … 23:30, 00:00, 00:30 … 06:30 (all 48 half-hours); no weekdays disabled |
| Data de predare | date+time picker `ovacrs_pickoff_date`, required | same as above |
| Serviciu suplimentar | checkboxes | "Scaun pentru copii" 10,00 € / Total; "Kilometri nelimitați" 5,00 € / Ziua (not shown on Audi Q5 2021, Porsche Cayenne, Toyota RAV4, see 1.4) |
| Opțiunea de avans 50,00 € pentru rezervarea maşinii | radio `ova_type_deposit` | "Plătiți Avans" (value `deposit`, pre-selected) / "Suma întreagă" (value `full`) |
| (submit) | button | "Rezervare" |

Validation message: "Acest câmp este obligatoriu." Rental type is fixed to days (`ovacrs_rental_type=day`). Adding to cart shows "„Dacia Logan” a fost adăugat în coș. Continuă cumpărăturile". Unavailable dates show "Acest Vehicul este indisponibil".

### 2.3 Cart ("Coș") and checkout ("Finalizare comandă")

Cart line meta (verbatim labels): "Locația de ridicare:", "Locație de predare:", "Data ridicării:", "Data de predare:", "Id Vehicul:", "Cantitate:", "Resursă suplimentară:", "Taxa de locație:", "Suma de asigurare:", then the day rate and "N Zile obișnuite". Totals: "Total coș", "Sub-total", "Total", "Să plătească", "Rămânând", button "Continuă cu finalizarea comenzii". Empty cart: "Coșul tău este în prezent gol." / "Înapoi la magazin"; mini-cart "Coșul este gol".

Checkout page, verbatim:

- Login prompt: "Ești client care se întoarce? Dă clic aici pentru a te autentifica." / "Dacă ai făcut cumpărături de la noi mai înainte, te rog să-ți introduci detaliile mai jos. Dacă ești un client nou, te rog să continui la secțiunea Facturare."
- "### Detalii pentru facturare": "Prenume *", "Nume *", "Țară/regiune *" (select, "Selectează o țară/regiune..."), "Stradă *" (placeholder "Adresă, nume stradă, număr etc."), "Municipiu/localitate *", "Municipalitate/județ *" (select: "Selectează o opțiune..." / "Chișinău"), "Cod poștal *", "Telefon *", "Adresă email *"
- "### Informații suplimentare": "Note comandă (opțional)" (placeholder "Note referitoare la comanda ta, de exemplu: anumite note pentru livrare.")
- "### Comanda ta": columns "produs" / "Sub-total"
- Payment (only one method, `maib`): "Achită Online" [maib logo] with the text "Achită cu Visa / Mastercard / Apple Pay / Google Pay"
- Privacy text: "Datele personale vor fi folosite pentru a procesa comanda, pentru a-ți susține experiența pe acest site web și pentru alte scopuri descrise în politică de confidențialitate."
- Required checkbox: "Am citit și sunt de acord cu termeni și condiții site-ului web *" (links to /termeni-si-conditii/). The full T&C text is also embedded in a hidden scroll box.
- Submit button: "Plasează comanda"
- *Checkout settings seen in page JS: `option_guest_checkout":"no"`; default billing country MD, state C (Chișinău); `needs_shipping: false`.*
- Footer payment logos image (https://davidanrentcar.md/wp-content/uploads/2025/02/logo.png): VISA, Mastercard, G Pay, Apple Pay.

### 2.4 "Cerere de rezervare" tab (request form, emailed)

Heading: "Trimiteți-ne cererea dvs. Vom verifica e-mailul și vă vom contacta în curând."

| Label | Placeholder | Required |
|---|---|---|
| Nume | Numele dumneavoastră | yes |
| E-mail | E-mailul dvs | yes |
| Număr | Telefonul dvs | no |
| Adresa | Adresa ta | no |
| Locația de ridicare | Selectați Locație / Aeroport Chisinău / Chișinău | yes |
| Locație de predare | Selectați Locație / Aeroport Chisinău / Chișinău | yes |
| Data ridicării | d-m-Y (+ time, same list as above) | yes |
| Data de predare | d-m-Y (+ time) | yes |
| Serviciu suplimentar | "Scaun pentru copii" 10,00 € / Total; "Kilometri nelimitați" 5,00 € / Ziua (label shows raw "kilo" on Audi Q5 2021, Porsche Cayenne, Toyota RAV4) | no |
| (textarea) | Informații suplimentare | no |
| button | Trimite | |

Thank-you page (https://davidanrentcar.md/pagina-de-multumire/): "Am primit mailul dvs. Vă vom contacta în curând." / "Mulțumim!" / button "Vezi mai multe automobile".

### 2.5 "Formular de contact" tab (Contact Form 7, id 3214)

Heading: "Trimiteți-ne cererea dvs. Vom verifica e-mailul și vă vom contacta în curând." Fields (placeholders only, no labels): "Numele/Prenumele" (required), "Numărul de telefon" (required, tel), "Email" (required), "Subiectul tău", "Mesajul dvs"; submit "Trimite". reCAPTCHA + Akismet honeypot.

### 2.6 Account page (https://davidanrentcar.md/contul-meu/)

"Autentificare": "Nume utilizator sau adresă email *Obligatoriu", "Parolă *Obligatoriu", "Ține-mă minte", button "Autentificare", link "Ai uitat parola?". SEO title "Davidan Rent Car - Gestionare Rezervări în contul personal", meta "Accesează contul tău pentru a verifica rezervările, actualiza datele și gestiona închirierile auto rapid și ușor."

### 2.7 Booking items not on the site

- Extras GPS / additional driver / insurance upgrades as options: **NOT FOUND** (only "Scaun pentru copii" and "Kilometri nelimitați").
- Delivery-to-address as a booking field: **NOT FOUND** in the booking form (address appears only in the request form "Adresa" and in checkout billing). Delivery terms are in the T&C, section IV.
- Hourly rental in the form: **NOT FOUND** (legend says "Închiriere pe oră: posibil, dar verifică telefonic.").

## 3. Legal and policy pages (verbatim)

Pages that exist: **Termeni și Condiții** (https://davidanrentcar.md/termeni-si-conditii/, page id 359, modified 2025-03-13) and **Politica de Confidențialitate** (https://davidanrentcar.md/politica-de-confidentialitate/, page id 3, modified 2025-02-26). Both are Romanian only (**RU/EN: NOT FOUND**). There are no separate pages for rental conditions, booking policy, deposit, insurance, fuel, cross-border, cancellation or delivery; all of these topics are sections of the T&C page (index below).

### 3.1 Topic index (where each topic lives in the T&C)

| Topic | T&C section | Key verbatim fact |
|---|---|---|
| Driver age | V.1 | "vârsta minimă variază între 21 și 25 de ani, în funcție de tipul automobilului" |
| Driving experience | V.1 | "Un permis de conducere valid, eliberat cu cel puțin 3 ani" |
| Documents | V.1, III.3 | licence + "Buletinul de identitate"; copies/photos requested after booking |
| Deposit / guarantee | V.2, IX | "Garanția este o sumă de bani blocată pe durata închirierii." Amount "variază în funcție de modelul vehiculului, vechimea permisului și vârsta clientului" (no figure) |
| Advance payment | III.2, XV, XVI | "avans de 50%" (the booking form actually offers a fixed 50,00 €, see 1.3) |
| Cancellation | III.2.3, XVI | free within "24 de ore" of booking; afterwards "avansul achitat nu se returnează" |
| Insurance / accidents | VI | call 112; "daunele se vor acoperi prin RCA-ul vinovatului" |
| Fuel policy | X.1 | same fuel level; lower level charged "la prețul de piață"; excess not refunded |
| Mileage | X.2 | "400 de kilometri gratuiti pe zi"; extra km "0,10 euro (plus TVA, după caz)"; unlimited "5 euro pe zi" |
| Cross-border | XI | "exclusiv pe teritoriul Republicii Moldova"; abroad or Transnistria needs "acordul scris din partea Locatorului" |
| Speed limit | XI | max "130 km/h"; three violations can end the contract |
| Late return | XII | "25% din valoarea chiriei pentru fiecare oră de întârziere (până la maximum 3 ore consecutiv)"; over 3 h = one full day |
| Cleaning fee | XII | "250 lei" sedan / "300 lei" SUV / "350 lei" other |
| Early return | VIII, XIII | unused days not refunded; notify "cu cel puțin 24 de ore înainte" |
| Extension | VII | only by "act adițional" |
| Delivery | IV | within Chișinău "3-5 ore", "între orele 07:00 și 00:00", "taxă fixă de 11 euro"; none on Sundays or national holidays |
| Airport delivery fee | — | **NOT FOUND** as a separate rule (cart "Taxa de locație" is 11,00 € for airport too; homepage meta says "livrare Aeroport 24/7") |
| Payment methods | III.1, XV | cash, card on pickup, bank transfer (companies), online card (Visa/Maestro/Mastercard), 3D-Secure; currency of transaction "MDL" |
| Right to refuse | XVI | "fără a oferi explicații suplimentare" |

### 3.2 Termeni și Condiții — full text

Source: https://davidanrentcar.md/termeni-si-conditii/ (also via `https://davidanrentcar.md/wp-json/wp/v2/pages/359`). List numbering added automatically by the browser is left out; every number shown below is part of the text. The page heading above the content reads "TERMENI ȘI CONDIȚII"; breadcrumb "Acasă > Termeni și Condiții". SEO meta: "Citește termenii și condițiile pentru închirierea auto. Află informații despre rezervări, plată, garanții și utilizarea mașinii în siguranță."

<!-- BEGIN VERBATIM T&C -->
**TERMENI ȘI CONDIȚII**

Prezenții Termeni și Condiții de utilizare a magazinului online www.davidanrentcar.md sunt aplicabili comenzilor pentru închirierea automobilelor oferite de compania **DAVIDAN RENT CAR SRL** prin intermediul site-ului. Pentru folosirea în bune condiții a site-ului, vă recomandăm familiarizarea atentă cu termenii și condițiile prezentate. Ne rezervăm dreptul de a modifica aceste prevederi fără notificare prealabilă.

---

##### I. DISPOZIȚII GENERALE
- **Proprietatea Site-ului**
   1.1. Site-ul este deținut de **DAVIDAN RENT CAR SRL**.
   1.2. La înregistrarea comenzii în magazinul online, Cumpărătorul acceptă Termenii și Condițiile de vânzare a bunurilor/produselor și/sau prestare a serviciilor, întocmite în baza legislației Republicii Moldova (Legea nr. 284/2004 privind Comerțul Electronic, Legea nr. 105/2003 privind Protecția drepturilor consumatorului și alte acte normative aplicabile).
   1.3. Vânzătorul își rezervă dreptul de a modifica unilateral prezentii Termeni și Condiții, iar Cumpărătorul este obligat să monitorizeze periodic eventualele modificări.

---

##### II. PROTECȚIA DATELOR CU CARACTER PERSONAL
- **Colectare și Prelucrare**
   1.1. Prin utilizarea site-ului, utilizatorul consimte la colectarea și prelucrarea datelor cu caracter personal necesare pentru procesarea, confirmarea și executarea comenzilor.
   1.2. Datele personale sunt prelucrate exclusiv în scopuri legitime, precum:
   - Furnizarea produselor/serviciilor comandate;
   - Transmiterea de promoții și notificări (inclusiv newsletter);
   - Utilizarea Google Analytics și gestionarea cookie-urilor.
- **Stocare și Securitate**
   2.1. Informațiile care conțin date cu caracter personal sunt stocate și utilizate doar pentru perioada necesară atingerii scopurilor pentru care au fost colectate, în conformitate cu Legea nr. 133/2011.
   2.2. Se folosesc măsuri comerciale de securitate pentru a preveni accesul neautorizat, însă, ca în orice transmisie de date pe internet sau prin rețele wireless, protecția absolută nu poate fi garantată.

---

##### III. ÎNREGISTRAREA ȘI ACHITAREA COMENZII
- **Achitarea**
   1.1. Achitarea comenzilor se poate efectua cu cardul de plată; la primirea comenzii, clientul primește un bon fiscal care confirmă plata.
   1.2. Plata online se realizează în condiții de maximă siguranță, utilizând standardul 3D-Secure (redirecționare către o pagină securizată pentru autentificarea printr-un cod unic de unică folosință).
   1.3. Rambursarea mijloacelor bănești se efectuează exclusiv pe cardul de plată utilizat la achiziție.
   1.4. Pentru efectuarea plății, se solicită:
   - Numărul cardului (16 cifre);
   - Data expirării (lună și an);
   - Codul CVC/CVV (3 cifre);
   - Numele și prenumele de pe card.

1.5. În cazul în care valuta cardului diferă de cea a tranzacției (MDL), la conversie se aplică condițiile băncii emitente.
- **Modalități de Plată**
   2.1. Clientul poate opta pentru:
   - Achitarea integrală a costului închirierii;
   - Plata unui avans de 50% la momentul rezervării, cu plata restului sumei la semnarea contractului și înainte de predarea automobilului.

2.2. Se confirmă că **avansul de 50% sau suma integrală achitată nu sunt rambursabile**, cu excepția cazului în care închirierea este refuzată de companie din motive legate de neeligibilitatea clientului (de exemplu, stagiul insuficient de conducere, lipsa unui permis de conducere valid etc.).

2.3. În conformitate cu cerințele sistemelor de plată, clientul beneficiază de un termen de **24 de ore** pentru anularea gratuită a rezervării, fără a suporta penalități sau taxe suplimentare. Anularea trebuie efectuată înainte de expirarea acestui interval pentru a evita costuri adiționale.
- **Verificarea Documentelor și Eligibilitatea**
   3.1. După efectuarea rezervării și a plății (indiferent dacă este integrală sau doar avans), clientul va fi contactat de un reprezentant al companiei.
   3.2. În cadrul acestui contact, i se va solicita transmiterea unei copii/fotografii a:
   - Permisului de conducere;
   - Buletinului de identitate.

3.3. Scopul acestei verificări este de a confirma valabilitatea documentelor și stagiul de conducere.
3.4. În cazul în care se constată că clientul nu îndeplinește condițiile (ex.: permisul nu este valid, stagiul de conducere este insuficient etc.), închirierea va fi **refuzată**, iar suma achitată va fi **returnată integral**.

---

##### IV. LIVRAREA AUTOMOBILULUI
- **Informarea și Programarea Livrării**
   1.1. După înregistrarea comenzii, clientul este informat despre data preconizată de transmitere a comenzii de către curieri sau serviciul de livrare.
   1.2. Livrarea în raza municipiului Chișinău se efectuează în termen de **3-5 ore** de la confirmarea comenzii, între orele **07:00 și 00:00**, contra o taxă fixă de 11 euro.
   1.3. În zilele de duminică sau sărbători naționale, livrarea nu se efectuează.
   1.4. În situații izolate (ex.: condiții meteo nefavorabile, sărbători legale, probleme tehnice), termenul de livrare se poate extinde, iar clientul va fi notificat în prealabil.
- **Detalii privind Adresa de Livrare**
   2.1. Clientul poate alege orice adresă pentru livrare, fiind acceptată o singură adresă per comandă.
   2.2. Pentru livrări la adrese diferite, este necesară înregistrarea unor comenzi separate.
- **Verificarea Vehiculului la Predare**
   3.1. La primirea automobilului, în prezența livratorului, se va verifica integritatea, starea vehiculului și prezența bonului fiscal.
   3.2. Orice pretenție ulterioară privind aceste aspecte nu va fi acceptată.

---

##### V. ACTE NECESARE ȘI GARANȚIE
- **Acte Necesare pentru Închiriere**
   1.1. La ridicarea automobilului, clientul trebuie să prezinte:
   - Un permis de conducere valid, eliberat cu cel puțin **3 ani**;
   - Buletinul de identitate (vârsta minimă variază între 21 și 25 de ani, în funcție de tipul automobilului).
- **Garanția sau Depozitul**
   2.1. Garanția este o sumă de bani blocată pe durata închirierii.
   2.2. În cazul în care automobilul este returnat fără daune, garanția este deblocată la returnare.
   2.3. Valoarea garanției variază în funcție de modelul vehiculului, vechimea permisului și vârsta clientului.
   2.4. Plata pentru locațiune și garanție se efectuează la semnarea contractului de închiriere.

---

##### VI. INCIDENTE ȘI ACCIDENTE
- **Procedură în Caz de Accident**
   1.1. În caz de accident rutier, clientul este obligat să apeleze numărul de urgență **112** și să informeze imediat managerul companiei.
   1.2. Dacă clientul este considerat vinovat, daunele se vor acoperi prin RCA-ul vinovatului, iar garanția nu va fi reținută, cu condiția respectării contractului.

---

##### VII. PROCEDURA DE PRELUNGIRE A ÎNCHIRIERII
- **Prelungirea Perioadei de Închiriere**
   1.1. Contractul de închiriere se încheie pentru perioada stabilită inițial, fără a permite o prelungire unilaterală.
   1.2. În cazul în care clientul dorește prelungirea, se va proceda la semnarea unui act adițional la contract, cu tarife suplimentare comunicate în prealabil.
   1.3. Fără actul adițional, vehiculul trebuie returnat conform termenilor inițiali.

---

##### VIII. CONDIȚIILE DE RETURNARE ANTERIOARĂ A AUTOMOBILULUI
- **Returnarea Anticipată**
   1.1. Dacă automobilul este returnat înainte de termenul stabilit, clientul va urma pașii de notificare și semnarea actului de predare-primire.
   1.2. Indiferent de momentul returnării, costul total al închirierii rămâne fix, iar costul zilelor neutilizate nu se rambursează.

---

##### IX. RETENȚII PENTRU DAUNE
- **Evaluarea și Rambursarea Daunelor**
   1.1. În cazul producerii unor daune la automobil, Locatorul va efectua o evaluare a pagubelor printr-o firmă specializată.
   1.2. Suma aferentă daunelor se va reține din depozitul blocat.
   1.3. Dacă valoarea daunelor depășește suma depozitului, clientul se obligă să achite diferența prin plată suplimentară.

---

##### X. DETALIERI TARIFE SUPLIMENTARE
- **Nivelul de Combustibil**
   1.1. Vehiculul trebuie returnat cu același nivel de combustibil cu care a fost eliberat.
   1.2. În caz contrar, dacă nivelul este inferior, clientul va suporta costul reconstituirii la prețul de piață.
   1.3. În cazul în care vehiculul este returnat cu un exces de combustibil, DAVIDAN RENT CAR SRL nu rambursează suma corespunzătoare surplusului.
- **Kilometri Suplimentari**
   2.1. **Kilometri Gratuiti:**
   – Clientul beneficiază de **400 de kilometri gratuiti pe zi**, incluși în prețul de bază al închirierii.
   2.2. **Kilometri Suplimentari:**
   – Pentru fiecare kilometru parcurs peste cei 400 de kilometri gratuiti pe zi, se aplică un tarif de **0,10 euro (plus TVA, după caz)**, calculat și facturat la momentul returnării vehiculului.
   2.3. **Opțiunea de Kilometraj Nelimitat:**
   – Clientul poate opta pentru un pachet de kilometraj nelimitat la un cost fix de **5 euro pe zi**. Această opțiune, care înlocuiește beneficiul celor 400 de kilometri gratuiti, trebuie agreată în prealabil și va fi adăugată la tariful de închiriere.
   2.4. **Condiții Suplimentare:**
   – Toate prevederile referitoare la limita gratuită de kilometri, tariful pentru kilometri suplimentari și opțiunea de kilometraj nelimitat sunt stipulate în contractul de închiriere. Clientul este responsabil să se informeze și să accepte în mod expres aceste condiții înainte de semnarea contractului.

---

##### XI. DREPTURILE ȘI OBLIGAȚIILE LOCATARULUI

Clientul se obligă să:
- **Utilizare Corectă:**
   - Utilizeze automobilul conform destinației și să respecte regulile tehnice, regulamentul de circulație rutieră și prevederile prezentului contract.
- **Interdicții de Utilizare:**
   - Nu utilizeze automobilul pentru remorcarea altor mijloace de transport;
   - Nu conducă în stare de ebrietate sau sub influența drogurilor, substanțelor narcotice sau psihotrope;
   - Nu utilizeze automobilul ca TAXI sau pentru instruire auto;
   - Nu participe la curse, testări sau competiții sportive cu automobilul.
- **Circulație:**
   - Utilizeze automobilul exclusiv pe teritoriul Republicii Moldova. Pentru deplasări în afara granițelor sau în regiuni speciale (ex. Transnistria), este necesară informarea și obținerea acordului scris din partea Locatorului.
- **Returnare:**
   - Returneze automobilul la expirarea termenului stabilit, în aceeași stare în care a fost preluat, ținând cont de uzura normală.
- **Respectarea Limitelor de Viteză:**
   - Nu depășească viteza maximă de 130 km/h. În caz de trei încălcări ale acestei limite, contractul poate fi reziliat unilateral fără restituirea sumelor plătite.
- **Manipularea Vehiculului:**
   - Nu deschidă capota motorului fără acordul prealabil;
   - Nu cedeze automobilul în folosință unor terți fără acordul scris al Locatorului.
- **Întreținere:**
   - Mențină automobilul curat și în stare bună de funcționare, asigurându-i paza corespunzătoare.

---

##### XII. RĂSPUNDEREA PĂRȚILOR
- **Daune Materiale:**
   - În cazul în care automobilul este returnat într-o stare deteriorată, clientul este obligat să repare prejudiciul material și să restituie vehiculul în starea inițială.
- **Accidente:**
   - Dacă automobilul este implicat în accidente rutier și clientul este considerat vinovat, acesta va fi responsabil de toate pagubele.
- **Daune Terțe:**
   - Clientul răspunde pentru daunele materiale și morale cauzate terților, direct legate de utilizarea automobilului.
- **Întârziere:**
   - În caz de întârziere la returnare, se va percepe o penalitate de 25% din valoarea chiriei pentru fiecare oră de întârziere (până la maximum 3 ore consecutiv). Dacă întârzierea depășește 3 ore, penalitatea va fi echivalentă cu valoarea chiriei pentru o zi întreagă.
- **Stare de Curățenie:**
   - Dacă automobilul este returnat murdar sau cu urme de murdărie, se va percepe o taxă suplimentară de 250 lei pentru automobile tip sedan, 300 lei pentru automobile SUV sau 350 lei pentru alte categorii.
- **Monitorizare GPS:**
   - Având în vedere că vehiculul este echipat cu sistem GPS, clientul consimte ca datele privind viteza și locația să fie prelucrate. În caz de încălcare a regulilor de utilizare, clientul se obligă să achite penalitățile corespunzătoare.

---

##### XIII. TRANSMITEREA ȘI RESTITUIREA AUTOMOBILULUI
- **Predare:**
   - Predarea automobilului către client se efectuează printr-un act de predare-primire, semnat de ambele părți, care include data și ora transmiterii.
- **Returnare:**
   - La returnare, dacă se constată semne vizibile de deteriorare sau lipsuri, acestea vor fi consemnate într-un act de restituire. Vehiculul va fi evaluat de o firmă specializată pentru stabilirea pagubelor.
- **Procedură în Cazul Returnării Anticipate:**
   - În cazul returnării anticipate, clientul va urma pașii de notificare (cu cel puțin 24 de ore înainte) și semnarea actului de predare-primire. Costul total al închirierii rămâne fix, iar costul zilelor neutilizate nu se rambursează.

---

##### XIV. POLITICA DE CONFIDENȚIALITATE
- **Dispoziții Generale:**
   - În conformitate cu Legea nr. 133/2011 privind protecția datelor cu caracter personal, Davidan Rent Car SRL prelucrează datele personale cu bună-credință, prin mijloace automate și manuale, asigurând securitatea, confidențialitatea și respectarea drepturilor persoanelor vizate.
- **Colectarea Datelor:**
   - Se colectează doar datele personale furnizate de consumatori la efectuarea comenzii (nume, prenume, vârstă, număr de telefon, adresă, adresă poștală etc.).
- **Scopul Colectării:**
   - Scopul colectării datelor este administrarea site-ului, livrarea comenzilor și contactarea consumatorilor pentru executarea livrărilor.
- **Divulgarea Datelor:**
   - Datele nu vor fi divulgate terților fără acordul expres al consumatorilor, cu excepția situațiilor prevăzute de lege (ex. solicitări din partea instituțiilor publice sau instanțelor de judecată).
- **Drepturile Persoanelor Vizate:**
   - Conform Legii nr. 133/2011, subiectul datelor are dreptul la informare, acces la date, intervenție, opoziție și dreptul de a nu fi supus unei decizii individuale.
- **Securitatea Datelor:**
   - Davidan Rent Car SRL se obligă să protejeze datele împotriva pierderii, distrugerii, distorsionării sau divulgării, iar angajații sunt obligați să respecte confidențialitatea datelor personale.

---

##### XV. ACHITARE
- **Modalități de Plată:**
   - **Numerar (cash):** La primirea automobilului, se eliberează bonul fiscal care confirmă plata.
   - **Card:** La primirea automobilului se emite bonul fiscal care confirmă plata.
   - **Transfer bancar (persoane juridice):** Se poate solicita un cont de plată pentru achitarea sumei aferente, urmând emiterea facturii fiscale.
   - **Plata online cu cardul (Visa / Maestro / Mastercard).**
- **Avans și Condiții de Plată:**
   - Clientul poate opta pentru achitarea integrală a costului închirierii sau pentru plata unui avans de **50%** la momentul rezervării, urmând ca restul sumei să fie achitat la semnarea contractului și înainte de predarea automobilului.
   - Se confirmă că **avansul de 50% sau suma integrală achitată nu sunt rambursabile**, cu excepția cazului în care închirierea este refuzată de companie din motive legate de neeligibilitatea clientului (ex.: stagiul insuficient de conducere, lipsa unui permis de conducere valid etc.).
   - În conformitate cu cerințele sistemelor de plată, clientul beneficiază de un termen de **24 de ore** pentru anularea gratuită a rezervării, fără a suporta penalități sau taxe suplimentare. Anularea trebuie efectuată înainte de expirarea acestui interval pentru a evita costuri adiționale.

---

##### XVI. POLITICA DE REZERVARE
- **Rezervare Online:**
   - Rezervările se efectuează online prin completarea formularului disponibil pe site.
   - După completare, rezervarea este confirmată de un reprezentant al Davidan Rent Car SRL prin metoda de contact indicată de client (telefon, e-mail).
- **Avans pentru Rezervare:**
   - Pentru finalizarea rezervării, este necesară plata unui avans de 50%, care asigură rezervarea clasei de automobil dorite.
   - Avansul nu garantează disponibilitatea unui model specific, ci doar a clasei selectate.
- **Politica de Anulare:**
   - În cazul anulării rezervării, avansul achitat nu se returnează.
   - Clientul beneficiază de anulare gratuită în termen de **24 de ore** de la rezervare, fără penalități sau taxe suplimentare.
- **Dreptul de Refuz:**
   - Davidan Rent Car SRL își rezervă dreptul de a refuza închirierea unui automobil către orice client, fără a oferi explicații suplimentare.

---

##### XVII. CLAUZE FINALE
- **Acordul Integral:**
   - Acești Termeni și Condiții constituie acordul integral dintre client și Davidan Rent Car SRL, înlocuind orice alt acord sau înțelegere anterioară, scrisă sau verbală.
- **Modificări ale Termenilor și Condițiilor:**
   - Davidan Rent Car SRL își rezervă dreptul de a modifica oricând acești Termeni și Condiții, fără notificare prealabilă.
   - Orice modificare va fi afișată pe această pagină, iar utilizarea continuă a site-ului constituie acceptarea modificărilor.
- **Legislația Aplicabilă:**
   - Orice situație neprevăzută va fi soluționată conform legislației în vigoare a Republicii Moldova.
- **Limitarea Răspunderii:**
   - Davidan Rent Car SRL nu își asumă responsabilitatea pentru erorile tehnice sau comerciale care pot duce la indisponibilitatea temporară sau permanentă a site-ului.
- **Contact:**
   - Pentru orice nelămuriri sau informații suplimentare referitoare la acești Termeni și Condiții, clientul poate contacta:
      - **Email:** davidanrentcar@gmail.com
      - **Telefon:** +373 79 816 666

---

##### XVIII. CONTACTE
- **Informații Companie:**
   - **Denumirea juridică:** DAVIDAN RENT CAR SRL
   - **IDNO:** 1025600000297
   - **Adresa juridică:** or. Chișinău, str. Vlaicu Pârcălab 52
   - **Telefon de contact:** +373 79 816 666
<!-- END VERBATIM T&C -->

### 3.3 Politica de Confidențialitate — full text

Source: https://davidanrentcar.md/politica-de-confidentialitate/ (also `https://davidanrentcar.md/wp-json/wp/v2/pages/3`). Breadcrumb "Acasă > Politica de Confidențialitate". SEO meta: "Află cum protejăm datele tale personale. Citește politica noastră de confidențialitate privind colectarea, utilizarea și securitatea informațiilor." (Bold formatting removed; text unchanged.)

<!-- BEGIN VERBATIM PRIVACY -->
În conformitate cu prevederile Legii Nr.133/2011 privind protecția datelor cu caracter personal, furnizorul de servicii prelucrează date cu caracter personal. Datele cu caracter personal sunt prelucrate cu buna-credință și se face în temeiul și în conformitate cu prevederile legale. Prelucrarea datelor cu caracter personal se realizează prin mijloace mixte (automate și manuale), cu respectarea cerințelor legale și în condiții care să asigure securitatea, confidențialitatea și respectarea drepturilor persoanelor vizate.

Furnizorul colectează și prelucrează doar datele personale furnizate de consumatori la efectuarea comenzii: nume, prenume, număr de telefon, adresa, adresa poștală.

Datele personale sunt utilizate exclusiv în scopul administrării site-ului, pentru a permite accesul la informații special, pentru livrarea comenzilor sau pentru a contacta consumatorul în vederea executării livrării. Prin prezenta informare, utilizatorii și consumatorii iau cunoștință despre faptul că li se vor prelucra și utiliza datele cu caracter personal (nume, prenume, număr de telefon, adresa, adresa poștală). Furnizorul de servicii prelucrează datele cu caracter personal ale utilizatorilor și consumatorilor care sunt furnizate prin navigarea, folosirea și înregistrarea pe site-ul www.davidanrentcar.md

Orice informație furnizată de către utilizatorii și consumatorii site-ului www.davidanrentcar.md, va fi considerată și va reprezenta consimțământul expres ca datele personale să fie folosite de Furnizor.

Furnizorul nu va dezvălui unei terțe părți niciuna dintre datele deținute, fără acordul persoanelor vizate și nu va comercializa, schimba, divulga aceste date cu alte persoane, cu excepțiile prevăzute de legislația în vigoare (la solicitarea instituțiilor publice ale statului, organele de drept, instanțelor de judecată, de asemenea autorizate să prelucreze date cu caracter personal).

Datele cu caracter personal pot fi prelucrate și utilizate de către Furnizor și în scopuri statistice și de promovare ulterioară.

Furnizorul de servicii îndeplinește cerințele de securitate a datelor cu caracter personal și asigură protecția datelor consumatorilor și le protejează pentru a nu fi pierdute, distruse, distorsionate/falsificate sau divulgate terțelor persoane.

Angajații furnizorului de servicii sunt obligați să respecte confidențialitatea datelor personale ale consumatorilor. Prelucrarea datelor cu caracter personal va fi realizată de persoana împuternicită a Furnizorului.

Furnizorul utilizează metode și tehnologii de securitate conform prevederilor legale în vigoare.

Furnizorul nu colectează informații referitoare la tranzacții, cum ar fi nr. la card, data expirării, țara de origine.

Pentru mai multe detalii și informații orice persoană interesată se poate adresa printr-un email la davidanrentcar@gmail.com sau prin telefon la numărul +373 79 816 666
DATELE DE CONTACT

Denumirea juridica a companiei: DAVIDAN RENT CAR SRL

IDNO: 1025600000297

Adresa juridica: or. Chişinău str. Vlaicu Pârcălab 52

Email de contact: davidanrentcar@gmail.com
<!-- END VERBATIM PRIVACY -->

### 3.4 Policy pages not found

Separate pages for "Condiții de închiriere", booking policy, deposit, insurance (CASCO/franchise amounts), fuel, cross-border, cancellation, late return, delivery, cookies: **NOT FOUND** (everything that exists is inside the T&C above). Insurance excess/franchise amount: **NOT FOUND**. Deposit amount as a number in policy text: **NOT FOUND** (only the cart's "Suma de asigurare" 150/200/300 €).

## 4. Contact and operational facts (verbatim)

Sources: header and footer on every page (e.g. https://davidanrentcar.md/), T&C section XVIII, privacy page "DATELE DE CONTACT".

**Header top bar:** "davidanrentcar@gmail.com" (mailto) · "+373 79 816 666" (`tel:+37379816666`)

**Main menu:** "Toate mașinile" (/toate-masinile/) · "Termeni și Condiții" (/termeni-si-conditii/) · "Chirie auto Aeroport" (links to /toate-masinile/, no separate airport page) · "Contul meu" (/contul-meu/) · GTranslate flags (ro/ru/en) · cart icon.

**Footer (verbatim, in order):**

```
DAVIDAN RENT CAR
WhatsApp +373 79 816 666          -> https://wa.me/37379816666
davidanrentcar@gmail.com

Contactează-ne
Chișinău, Republica Moldova
+373 79 816 666
davidanrentcar@gmail.com
Găsiți-ne pe hartă                -> https://www.google.com/maps/dir/  (empty directions link, no coordinates)

Informații
DAVIDAN RENT CAR SRL
C/F 1025600000297
R. Moldova, mun. Chișinău
str. Vlaicu Pîrcălab 52

Linkuri utile
Termeni și Condiții
Politica de Confidențialitate
Chirie auto Aeroport
Toate mașinile
Contul meu

Program de lucru
Departamentul de închirieri:
Lucrăm 24/24
Service Centre:
Luni - Vineri: 08.00 to 18.00
Luni & Vineri: Închis

Instagram  -> https://www.instagram.com/davidanrentcar/
Facebook   -> #   (no URL)
TikTok     -> https://www.tiktok.com/@davidan.rentcar
Youtube    -> #   (no URL)
[payment logos image]
Toate drepturile rezervate © 2025 Davidan Rent Car
Site realizat de INOVEX.md
```

*Notes: the "Service Centre" lines are contradictory as published ("Luni - Vineri: 08.00 to 18.00" then "Luni & Vineri: Închis"), mixed English "to", and look like leftover theme template text. The footer spells the street "Vlaicu Pîrcălab"; the T&C and privacy page spell it "Vlaicu Pârcălab" (privacy page: "or. Chişinău str. Vlaicu Pârcălab 52"). A hidden "Log in Register" link sits in the footer (CSS `visibility: hidden`).*

**T&C section XVIII "CONTACTE":** "Denumirea juridică: DAVIDAN RENT CAR SRL" · "IDNO: 1025600000297" · "Adresa juridică: or. Chișinău, str. Vlaicu Pârcălab 52" · "Telefon de contact: +373 79 816 666". T&C XVII: "Email: davidanrentcar@gmail.com", "Telefon: +373 79 816 666".

**Privacy page "DATELE DE CONTACT":** "Denumirea juridica a companiei: DAVIDAN RENT CAR SRL" · "IDNO: 1025600000297" · "Adresa juridica: or. Chişinău str. Vlaicu Pârcălab 52" · "Email de contact: davidanrentcar@gmail.com"

- Phone numbers: only **+373 79 816 666** (also the WhatsApp number). A second phone: **NOT FOUND**.
- Email: **davidanrentcar@gmail.com** (only one).
- Hours: rental department "Lucrăm 24/24"; homepage meta "livrare Aeroport 24/7"; /toate-masinile/ meta "Disponibil 24/7". T&C delivery window "între orele 07:00 și 00:00". Office opening hours for pickup: **NOT FOUND** beyond these.
- Pickup/return locations (booking form): "Aeroport Chisinău", "Chișinău" (the location pages /location/aeroport-chisinau/ and /location/chisinau/ have no content). Map coordinates: **NOT FOUND** (Rank Math `locations.kml` is empty).
- Social: Instagram https://www.instagram.com/davidanrentcar/, TikTok https://www.tiktok.com/@davidan.rentcar. Facebook and YouTube icons have no URL (`#`).
- FAQ: **NOT FOUND** (no FAQ page or section).

## 5. Homepage copy, about, advantages, brand colours

Source: https://davidanrentcar.md/ (Elementor page id 1837, modified 2025-05-06).

**SEO:** title "Davidan Rent Car - Mașini de Închiriat Rapid și Simplu"; meta description / og:description "Chirie auto in Chisinau cu livrare Aeroport 24/7. Oferim masini in chirie la preturi accesibile. Rezervă acum online pentru o experiență fără griji!"; keywords (JSON-LD) "rent,car,chirie auto,chisinau". /toate-masinile/ meta: "Mașini de închiriat - Rezervă rapid online, direct pe site-ul nostru! Disponibil 24/7 pentru o experiență simplă și comodă. WhatsApp +373 79 816 666".

**Hero slider (Slider Revolution, 5 slides), verbatim layer text:**

| Slide | Title | Price line | Feature chips | Buttons (→ link) |
|---|---|---|---|---|
| 1 | Audi Q5 | De la 45 € / ziua | Cameră marșarier · Pilot automat adaptiv · Apple CarPlay/Android · Faruri LED Matrix · Climatizare automată · Combustibil: benzină · ABS · Cutie de viteze automată | "Vezi mai multe" → /toate-masinile/ · "Închiriază Acum" → /produs/audi-q5-2021/ |
| 2 | Dacia Logan 2022 | De la 19 € / ziua | 5 Uși · autonomie extinsă · Economică și Fiabilă · Consum redus · Benzină/GPL · Transmisie manuală | "Vezi mai multe" · "Închiriază acum" → /produs/dacia-1-0-benzina-gpl-2022/ |
| 3 | Porsche Cayenne | De la 60 € / ziua | 5 Uși · autonomie extinsă · Economică și Fiabilă · Consum redus · Benzină/Plug-in · Transmisie automată | "Vezi mai multe" · "Închiriază acum" → /produs/porsche-cayenne-3-0-plug-in-hybrid/ |
| 4 | Toyota Rav 4 | De la 45 € / ziua | Cameră marșarier · Sistem de asistență · Sistem audio premium · Faruri LED · Climatizare automată · Combustibil: Hibryd · ABS · Cutie de viteze automată | "Vezi mai multe" · "Închiriază Acum" → /produs/toyota-rav4-2-5-plug-in/ |
| 5 | Mercedes-Benz E Class | De la 40 € / ziua | Cameră · Cruise Conrol · Apple CarPlay/Android · Faruri LED · Climatizare automată · Combustibil: diesel · ABS · Cutie de viteze automată | "Vezi mai multe" · "Închiriază Acum" → /produs/mercedes-benz-e-class-2017-diesel/ |

*(Typos "Hibryd", "Cruise Conrol" and the Porsche slide reusing Dacia chips "Economică și Fiabilă / Consum redus" are on the live site.)*

**Car filter section:** heading "Închiriere Pentru Tine" with span "Oferte", sub-text "Ce fel de mașină vrei?"; brand tabs "Audi", "Porsche", "BMW", "Dacia", "Toyota", "Mercedes-Benz", "Ford"; cards show "Închiriază", price "30,00 €/ Ziua", name and the 8 spec icons; mobile carousel label "Este disponibilitate N articole" (N = cars in that brand tab: Audi 2, Porsche 1, BMW 1, Dacia 3, Toyota 1, Mercedes-Benz 1, Ford 2). Button "VEZI MAI MULTE AUTOMOBILE" → /toate-masinile/.

**Gallery slider (3 slides):** captions "Porsche" / "Davidan Rent Car" / "Davidan Rent Car"; "Mercedes-Benz" / "Davidan Rent Car" / "Davidan Rent Car"; "Audi Q7" / "Davidan rent car" / "Davidan Rent Car" (the "Audi Q7" slide links to /produs/audi-q5-2012/). CTA button "ÎNCHIRIAZĂ ACUM" → /toate-masinile/.

- About / "Despre noi" text: **NOT FOUND** (no about page or section).
- Advantages / "De ce noi" blurbs: **NOT FOUND**.
- Testimonials/reviews: **NOT FOUND** (all products `review_count: 0`).

### 5.1 Brand colours (from CSS and logo pixels)

| Use | Hex | Source |
|---|---|---|
| Logo red (car key) | `#F8001B` | pixel colours of https://davidanrentcar.md/wp-content/uploads/2025/02/Davidan-logo-300x300.png (favicon/site icon) and header logo Design-fara-titlu-16.png |
| Logo "D" (light-background version) | `#030304` (near-black) | Davidan-logo-300x300.png |
| Logo "D" (header, dark-background version) | `#FFFFFF` | https://davidanrentcar.md/wp-content/uploads/2025/02/Design-fara-titlu-16.png (130×60, white D + red key) |
| **Primary button background** ("Rezervați acum" `.woo_rent_top .booking_btn`, "Rezervare" `.ireca_booking_form button.submit`, request-form "Trimite" `.request_booking button.submit`); also active menu item, hover text, brand filter tabs, mini-cart buttons, borders, CF7 "Trimite" button, calendar legend swatch | `#dd3333` | inline `ireca_style-inline-css` (theme customizer); `wp-custom-css` (`.ova-contact-form-tabs-update .wpcf7-form-control.wpcf7-submit { background-color: #dd3333 }`); legend span `style="background-color:#dd3333;"` |
| Primary button **hover** background; also price amounts (`.ireca_woo_price .amount`), heading accent span ("Oferte"), cart count badge, mini-cart checkout button | `#e82930` | `ireca_style-inline-css` |
| Booked-day event background in availability calendar | `#dc3545`, text `#ffffff` | `data-event_background` / `data-text_color` on `#calendar` |
| Homepage Elementor buttons ("VEZI MAI MULTE AUTOMOBILE", "ÎNCHIRIAZĂ ACUM") | bg `#D63637`, hover bg `#000000` with text `#D63637` | Elementor page CSS (elementor-1837) |
| Header / footer background | `#141414` (`rgb(20,20,20)`), footer text `#c1c1c1` | theme inline CSS + custom CSS `footer.footer` |
| Dark text / headings | `#343434` | theme inline CSS |
| Deposit option labels bg | `#343a40` | custom CSS `.ovacrs-deposit label` |
| Light section bg | `#f3f3f3`, `rgb(245,245,245)` | theme inline CSS |

Fonts: **Teko** (headings, prices, titles) and **Poppins** (body), per theme inline CSS; the Google Fonts request also loads Open Sans 400. Elementor global kit colours are Elementor defaults (#6EC1E4, #54595F, #7A7A7A, #61CE70) and are not used as brand colours.

Logo files: header https://davidanrentcar.md/wp-content/uploads/2025/02/Design-fara-titlu-16.png · schema logo https://davidanrentcar.md/wp-content/uploads/2025/02/Design-fara-titlu-14.png · site icon https://davidanrentcar.md/wp-content/uploads/2025/02/Davidan-logo-300x300.png (also -100x100). Brand name forms used on the site: "Davidan Rent Car", "DAVIDAN RENT CAR", "DAVIDAN RENT CAR SRL".

## 6. Links to other DaviDan brands

Checked all hrefs on the homepage, all 8 pages, all 11 product pages and checkout. The only external links are Instagram, TikTok, WhatsApp, Google Maps, inovex.md and plugin credits. **Links to DaviDan bakery / sushi / water or any other DaviDan domain: NOT FOUND.** No mention of those businesses in the text either.

## 7. Corrections to the "known so far" brief

| Brief said | Site actually says |
|---|---|
| Audi Q5 45€/day | There are **two** Audi Q5 listings: "Audi Q5 2012" **30,00 €** (2012, Benzină, Automată, 2.0) and "Audi Q5 2021" **45,00 €** (2021). |
| Dacia Logan/Sandero/Lodgy 19€ | Correct (19,00 € / Ziua), but that is the 21+ day rate; 1–3 days is 30,00 €/day. Logan 2022 Benzină/GPL Manuală 1.0 5 l/100 km; Sandero 2015 Benzină "Manuala" 1.0; Lodgy 2016 Diesel "Manuala" 1.5, 7 seats. |
| Porsche Cayenne 60€ | 60,00 € (21+ days); 1–3 days 150,00 €. 2017, "Benzină/Plug-in Hybrid", 3.0. |
| Toyota RAV4 45€ | 45,00 € (21+ days); 1–3 days 100,00 €. 2020, "Benzină/Plug-in Hybrid", 2.5. |
| Mercedes-Benz E Class 40€ | Product title is just "Mercedes-Benz" (slug `mercedes-benz-e-class-2017-diesel`; description "Mercedes-Benz E-Class 2017 Diesel"; slider "Mercedes-Benz E Class"). 40,00 € (21+); 1–3 days 80,00 €. |
| BMW X5 60€ | 60,00 € (21+); 1–3 days 150,00 €. Spec says "Benzină", but the description says "2.0 Benzină + Plug-in Hybrid (xDrive40e)". |
| Ford Kuga/Focus 28–30€ | Focus **28,00 €** (2018 Diesel Automată 2.0), Kuga **30,00 €** (2021 Diesel Automată 1.5); 1–3 days 60 € / 70 €. |
| Mileage "Nelimitat" | Every spec list says "Kilometraj: Nelimitat", **but** the T&C say "400 de kilometri gratuiti pe zi" and the booking form sells "Kilometri nelimitați" for 5,00 € / Ziua. The site contradicts itself. |
| Booking department 24/7 | Footer: "Departamentul de închirieri: Lucrăm 24/24". Meta: "livrare Aeroport 24/7", "Disponibil 24/7". |
| Address str. Vlaicu Pârcălab 52 | Legal address "or. Chișinău, str. Vlaicu Pârcălab 52" (T&C); footer spells it "str. Vlaicu Pîrcălab 52". |
| Phone +373 79 816 666 | Correct; also the WhatsApp number. |
| (not in brief) | Every booking also gets "Taxa de locație" 11,00 € and "Suma de asigurare" 150/200/300 €. Advance is a fixed 50,00 € in the form but "50%" in the T&C. |

## 8. NOT FOUND summary

- Any Russian or English authored text (the site uses GTranslate/Google machine translation only): fleet, booking labels, T&C, privacy, contact, homepage.
- Vehicle class/category (economy, SUV, premium…); only brand categories exist.
- Deposit/guarantee amount stated in policy text (only the cart "Suma de asigurare" 150/200/300 €).
- Insurance details: CASCO, franchise/excess amounts, what "Suma de asigurare" covers.
- Per-car minimum driver age (T&C only give the 21–25 range "în funcție de tipul automobilului").
- A separate airport delivery fee or airport delivery rules (only the 11 € "Taxa de locație" and the "livrare Aeroport 24/7" meta).
- Extras besides child seat and unlimited km (GPS, additional driver, etc.).
- Hourly rental prices (legend: "Închiriere pe oră: posibil, dar verifică telefonic.").
- Seasonal/special pricing (the "Special Time with Price" block is empty on all cars).
- FAQ, About/"Despre noi", advantages, testimonials.
- Facebook and YouTube URLs (icons link to "#").
- Second phone number, map coordinates, pickup-office opening hours (only "Lucrăm 24/24" and the contradictory "Service Centre" lines).
- Links or mentions of other DaviDan brands (bakery, sushi, water).

## 9. Method notes

- All HTML was fetched with `curl -sL` on 2026-09-16 (LiteSpeed cache hits). Text was extracted with the Python stdlib HTMLParser and not paraphrased.
- Tier semantics, fees and the fixed 50 € advance were checked by adding rentals (dates in Nov 2026 – May 2027) to an anonymous WooCommerce cart session. No checkout was submitted, no order was placed, and all cart items were removed afterwards.
- Raw files: `research/rentcar/home.html`, `page_*.html`, `products/*.html`, `checkout.html`, `cart_full.html`, `cart_full2.html`, `store_products.json`, `tc.json`, `pp.json`; extracted text `*.txt`, `tc.md`, `pp.md`.
