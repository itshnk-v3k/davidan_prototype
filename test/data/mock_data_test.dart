// Checks the mock data against the files it comes from: the bundled images,
// and davidansushi.md's menu and legal pages in docs/sources/. Reads files,
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
import 'package:davidan_prototype/data/mock/sushi/sushi_categories.dart';
import 'package:davidan_prototype/data/mock/sushi/sushi_info.dart';
import 'package:davidan_prototype/data/mock/sushi/sushi_products.dart';
import 'package:davidan_prototype/data/models/brand.dart';

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
        for (final catalog in mockCatalogs.values) ...[
          for (final product in catalog.products) ?product.image,
          for (final category in catalog.categories) category.image,
          for (final banner in catalog.banners) banner.image,
        ],
      };

      expect(images.length, greaterThan(150));
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
}
