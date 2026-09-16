// Checks the mock data against the files it comes from: the bundled images,
// davidan.md's water listing, davidansushi.md's menu and legal pages, and
// davidanrentcar.md's fleet and legal pages in docs/sources/. Reads files,
// so it runs on the VM and `--platform chrome` skips it:
//   flutter test test/data/mock_data_test.dart
@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:davidan_prototype/core/theme/app_assets.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/data/mock/mock_catalogs.dart';
import 'package:davidan_prototype/data/mock/rental/rental_cars.dart';
import 'package:davidan_prototype/data/mock/rental/rental_info.dart';
import 'package:davidan_prototype/data/mock/sushi/sushi_categories.dart';
import 'package:davidan_prototype/data/mock/sushi/sushi_info.dart';
import 'package:davidan_prototype/data/mock/sushi/sushi_products.dart';
import 'package:davidan_prototype/data/mock/water/water_catalog.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/rental_car.dart';
import 'package:davidan_prototype/features/rental/application/rental_providers.dart';

void main() {
  test(
    'every image the mock data names is a file in a bundled asset folder',
    () {
      final folders = [
        for (final match in RegExp(
          r'^\s+- (assets/\S+/)$',
          multiLine: true,
        ).allMatches(File('pubspec.yaml').readAsStringSync()))
          match.group(1)!,
      ];
      final images = {
        AppAssets.logo,
        AppAssets.logoOnDark,
        AppAssets.sushiLogo,
        AppAssets.sushiLogoOnDark,
        AppAssets.splashBackground,
        for (final intro in brandIntros.values) ?intro.image,
        for (final car in rentalCars) car.image,
        for (final catalog in mockCatalogs.values) ...[
          for (final product in catalog.products) ?product.image,
          for (final category in catalog.categories) category.image,
          for (final banner in catalog.banners) banner.image,
        ],
      };

      expect(images.length, greaterThan(160));
      for (final image in images) {
        expect(File(image).existsSync(), isTrue, reason: image);
        expect(
          folders.contains('${File(image).parent.path}/'),
          isTrue,
          reason: '$image is not in a pubspec.yaml asset folder',
        );
      }
    },
  );

  test('Apa DaviDan sells davidan.md\'s two waters at its price, named as the '
      'bakery names the same bottles', () {
    final shop = jsonDecode(
      File('docs/sources/data/davidan_md_products.json').readAsStringSync(),
    ) as Map<String, Object?>;
    final listing = [
      for (final product in shop['products']! as List<Object?>)
        product! as Map<String, Object?>,
    ].singleWhere((product) => product['handle'] == 'dorna');
    expect(
      [
        for (final variant in listing['variants']! as List<Object?>)
          (
            (variant! as Map<String, Object?>)['title'],
            (variant as Map<String, Object?>)['price'],
          ),
      ],
      [('Naturală', '15.00'), ('Gazată', '15.00')],
    );

    final bakery = {
      for (final product in mockCatalogs[Brand.bakery]!.products)
        product.id: product,
    };
    expect(
      [for (final p in waterProducts) p.name],
      ['Apa DaviDan naturală', 'Apa DaviDan gazată'],
    );
    for (final water in waterProducts) {
      expect(water.priceBani, 1500, reason: water.id);
      expect(bakery[water.id]?.name, water.name, reason: water.id);
      expect(bakery[water.id]?.image, water.image, reason: water.id);
    }
    expect(mockCatalogs[Brand.water]!.popularProductIds, [
      for (final p in waterProducts) p.id,
    ]);
  });

  group('DaviDan Sushi matches davidansushi.md', () {
    final source = jsonDecode(
      File('docs/sources/davidansushi_md_menu.json').readAsStringSync(),
    ) as Map<String, Object?>;
    final siteCategories = [
      for (final category in source['categories']! as List<Object?>)
        category! as Map<String, Object?>,
    ];
    final siteProducts = [
      for (final product in source['products']! as List<Object?>)
        product! as Map<String, Object?>,
    ];

    /// The top category a site category sits under.
    String topCategoryOf(Object? categoryId) {
      final category = siteCategories.firstWhere((c) => c['id'] == categoryId);
      return category['parent'] == 0
          ? category['slug']! as String
          : topCategoryOf(category['parent']);
    }

    /// The site's "Masa" or "Bucăți" for a product, or null.
    String? attribute(Map<String, Object?> product, String name) {
      for (final pair in product['attributes_ro']! as List<Object?>) {
        final [label, value] = (pair! as List<Object?>).cast<String>();
        if (label == name) return value;
      }
      return null;
    }

    test('all 102 products, in the site\'s order, with its ids, prices, '
        'weights, pieces and categories', () {
      expect(sushiProducts, hasLength(102));
      expect(
        [for (final p in sushiProducts) p.id],
        [for (final p in siteProducts) p['slug']],
      );
      for (final (index, site) in siteProducts.indexed) {
        final product = sushiProducts[index];
        final reason = product.id;
        expect(product.brand, Brand.sushi, reason: reason);
        expect(
          product.priceBani,
          ((site['price_mdl']! as num) * 100).round(),
          reason: reason,
        );
        expect(product.weight, attribute(site, 'Masa'), reason: reason);
        expect(product.pieces, attribute(site, 'Bucăți'), reason: reason);
        expect(
          product.categoryId,
          topCategoryOf(site['leaf_category_id']),
          reason: reason,
        );
        // The one name corrected: "Cheescake".
        expect(
          product.name,
          site['name_ro'] == 'Cheescake' ? 'Cheesecake' : site['name_ro'],
          reason: reason,
        );
      }
    });

    test('text only where the site has some, under the site\'s label, with '
        'its obvious typos corrected', () {
      for (final (index, site) in siteProducts.indexed) {
        final product = sushiProducts[index];
        final lines = site['description_ro_lines']! as List<Object?>;
        if (lines.isEmpty) {
          expect(product.description, isNull, reason: product.id);
          continue;
        }
        final label = (lines.first! as String)
            .replaceAll('*', '')
            .replaceAll(':', '')
            .trim();
        expect(product.description, startsWith('$label: '), reason: product.id);
        // Every item of the site's list is there, give or take a fix.
        expect(
          product.description!.split(', ').length,
          greaterThanOrEqualTo(lines.length - 1),
          reason: product.id,
        );
      }

      final text = [for (final p in sushiProducts) ?p.description].join('\n');
      for (final typo in [
        'cream de',
        'brnânză',
        'crema de brinza',
        'castrevete',
        'castraveti',
        'sos spisy',
        'parmenzan',
        'sus de soia',
        'rosii',
        'pesmeti',
        'pirjoală',
        'champinion',
        'Avokado',
        'ţ',
        ',,',
        ', ,',
        '.,',
        ';,',
      ]) {
        expect(text, isNot(contains(typo)), reason: typo);
      }
    });

    test('the site\'s nine top categories, in its menu\'s order, each with '
        'products, and home\'s first row from them', () {
      expect(
        [for (final c in sushiCategories) c.id],
        [
          SushiCategoryIds.sushi,
          SushiCategoryIds.seturi,
          SushiCategoryIds.bucateThai,
          SushiCategoryIds.supe,
          SushiCategoryIds.salate,
          SushiCategoryIds.pokeBowl,
          SushiCategoryIds.gustari,
          SushiCategoryIds.deserturi,
          SushiCategoryIds.bauturi,
        ],
      );
      for (final category in sushiCategories) {
        final site = siteCategories.firstWhere((c) => c['slug'] == category.id);
        expect(category.name, site['name_ro'], reason: category.id);
        expect(
          sushiProducts.where((p) => p.categoryId == category.id).length,
          site['count'],
          reason: category.id,
        );
      }
      final ids = {for (final p in sushiProducts) p.id};
      expect(ids.containsAll(sushiPopularProductIds), isTrue);
    });

    test('the legal pages are the site\'s, line for line', () {
      final notes = File('docs/sources/davidansushi_md.md').readAsStringSync();

      /// The quoted lines of a section of the notes, as plain text: links
      /// become their label, and headings and bold-only lines are left out,
      /// as the app's headings are.
      List<String> quoted(String from, String to) => [
        for (final line
            in notes
                .substring(notes.indexOf(from), notes.indexOf(to))
                .split('\n'))
          if (line.startsWith('>'))
            if (line
                    .substring(1)
                    .trim()
                    .replaceAllMapped(
                      RegExp(r'\[([^\]]+)\]\([^)]+\)'),
                      (m) => m.group(1)!,
                    )
                case final text
                when text.isNotEmpty &&
                    !text.startsWith('#') &&
                    !RegExp(r'^\*\*[^*]+\*\*$').hasMatch(text))
              text
                  // The obvious typos the app corrects.
                  .replaceAll('acestă', 'această')
                  .replaceAll('Chişinău', 'Chișinău')
                  .replaceAll(
                    '”Moldova – Agroindbank„',
                    '„Moldova – Agroindbank”',
                  ),
      ];
      List<String> inApp(String text) => [
        for (final line in text.split('\n'))
          if (line.trim().isNotEmpty && !line.startsWith('# ')) line.trim(),
      ];

      final [terms, privacy] = sushiInfo.documents;
      expect(terms.id, 'termeni-si-conditii');
      expect(inApp(terms.text), quoted('### 4.2 Termeni', '### 4.3 Politica'));
      expect(privacy.id, 'politica-de-confidentialitate');
      expect(
        inApp(privacy.text),
        quoted('### 4.3 Politica', '## 5. Operational'),
      );
    });
  });
  group('DaviDan Rent Car matches davidanrentcar.md', () {
    final notes = File('docs/sources/davidanrentcar_md.md').readAsStringSync();

    String section(String from, String to) =>
        notes.substring(notes.indexOf(from), notes.indexOf(to));

    /// The data rows of the first markdown table in [text], cells trimmed.
    List<List<String>> rows(String text) => [
      for (final line in text.split('\n'))
        if (line.startsWith('| ') &&
            !line.startsWith('| # ') &&
            !line.startsWith('| Name '))
          [for (final cell in line.split('|').skip(1)) cell.trim()]
            ..removeLast(),
    ];

    /// "70,00 €" → 70.
    int euros(String cell) =>
        int.parse(RegExp(r'^(\d+),00 €').firstMatch(cell)!.group(1)!);

    /// The site's obvious typos the app corrects.
    String fixed(String text) => switch (text) {
      'Manuala' => 'Manuală',
      'Aier conditionat' => 'Aer condiționat',
      'Airbag frontal si lateral' => 'Airbag frontal și lateral',
      'Sistem de asistenta la mentinerea benzii' =>
        'Sistem de asistență la menținerea benzii',
      _ => text,
    };

    test('all 11 cars, with the site\'s slugs, specs, equipment and '
        'description lines', () {
      final summary = rows(section('### 1.1 Summary table', '### 1.2 Tiered'));
      final details = section('### 1.4 Per-car detail', '## 2. Booking flow');
      expect(rentalCars, hasLength(11));
      expect(summary, hasLength(11));
      for (final (index, row) in summary.indexed) {
        final [
          _,
          name,
          slug,
          _,
          _,
          _,
          year,
          fuel,
          gearbox,
          consumption,
          passengers,
          engine,
          doors,
          mileage,
        ] = row;
        final car = rentalCars[index];
        final reason = car.id;
        expect(car.name, name, reason: reason);
        expect(car.id, slug.replaceAll('`', ''), reason: reason);
        expect(car.image, 'assets/images/cars/${car.id}.webp', reason: reason);
        expect(
          [for (final (_, value) in car.specs) value],
          [
            year,
            fuel,
            fixed(gearbox),
            consumption,
            passengers,
            engine,
            doors,
            mileage,
          ],
          reason: reason,
        );

        final block = details.substring(details.indexOf('#### $name\n'));
        final features = RegExp(r'- Feature ticks \(other features\): (.*)')
            .firstMatch(block)!
            .group(1)!;
        expect(car.features, [
          for (final match in RegExp(r'"([^"]+)"').allMatches(features))
            fixed(match.group(1)!),
        ], reason: reason);
        expect(
          car.tagline,
          RegExp(r'- SEO meta description: "(.*)"').firstMatch(block)!.group(1),
          reason: reason,
        );
      }
    });

    test('every price per day, and what the site\'s cart charged for 1 day: '
        'the day, the location fee and the car\'s insurance amount', () {
      final tiers = {
        for (final row in rows(section('### 1.2 Tiered', '**How the tiers')))
          row.first: row,
      };
      final fees = {
        for (final row in rows(
          section('### 1.3 Fees added', '- "Taxa de locație" was'),
        ))
          row.first: row,
      };
      for (final car in rentalCars) {
        final [_, normal, day1, day4, day11, day21] = tiers[car.name]!;
        final [_, _, locationFee, insurance, _, oneDayTotal] = fees[car.name]!;
        final reason = car.id;
        expect(car.dayRatesEur, {
          RentalTier.days1to3: euros(day1),
          RentalTier.days4to10: euros(day4),
          RentalTier.days11to20: euros(day11),
          RentalTier.days21plus: euros(day21),
        }, reason: reason);
        expect(car.lowestDayRateEur, euros(normal), reason: reason);
        expect(car.insuranceEur, euros(insurance), reason: reason);
        expect(RentalTerms.locationFeeEur, euros(locationFee), reason: reason);
        expect(
          quoteRental(car, days: 1, extras: const {}).totalEur,
          euros(oneDayTotal),
          reason: reason,
        );
      }
    });

    test('the legal pages are the site\'s, line for line, and the driver\'s '
        'documents are quoted from them', () {
      /// A block of the notes between its BEGIN and END markers, as plain
      /// lines: no list marks, heading marks, bold marks or rules.
      List<String> quoted(String name) {
        final text = notes.substring(
          notes.indexOf('<!-- BEGIN VERBATIM $name -->'),
          notes.indexOf('<!-- END VERBATIM $name -->'),
        );
        return [
          for (final line in text.split('\n').skip(1))
            if (line
                    .trim()
                    .replaceFirst(RegExp(r'^(##### |- |– )'), '')
                    .replaceAll('**', '')
                    .replaceAll('Chişinău', 'Chișinău')
                case final plain when plain.isNotEmpty && plain != '---')
              plain,
        ];
      }

      List<String> inApp(String text) => [
        for (final line in text.split('\n'))
          if (line.replaceFirst(RegExp(r'^(# |– )'), '').replaceAll('**', '')
              case final plain when plain.isNotEmpty)
            plain,
      ];

      final [terms, privacy] = rentalInfo.documents;
      expect(terms.id, 'termeni-si-conditii');
      // The app leaves out the page's own title.
      expect(inApp(terms.text), quoted('T&C').skip(1));
      expect(privacy.id, 'politica-de-confidentialitate');
      expect(inApp(privacy.text), quoted('PRIVACY'));

      for (final document in RentalTerms.documents) {
        expect(inApp(terms.text), contains(document));
      }
    });
  });
}
