// Checks the Russian of the mock content (lib/data/mock/ru/): that every
// Romanian text the app translates has Russian, that sushi keeps
// davidansushi.md/ru's Russian wherever the site translated, and that
// docs/sources/ru_translations.md lists every translation for review. Reads
// files, so it runs on the VM and `--platform chrome` skips it:
//   flutter test test/data/ru_content_test.dart
@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:davidan_prototype/data/mock/bakery/bakery_shops.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/data/mock/mock_catalogs.dart';
import 'package:davidan_prototype/data/mock/rental/rental_cars.dart';
import 'package:davidan_prototype/data/mock/ru/bakery_ru.dart';
import 'package:davidan_prototype/data/mock/ru/brands_ru.dart';
import 'package:davidan_prototype/data/mock/ru/rental_ru.dart';
import 'package:davidan_prototype/data/mock/ru/ru_content.dart';
import 'package:davidan_prototype/data/mock/ru/sushi_ru.dart';
import 'package:davidan_prototype/data/mock/ru/water_ru.dart';
import 'package:davidan_prototype/data/mock/sushi/sushi_categories.dart';
import 'package:davidan_prototype/data/mock/sushi/sushi_products.dart';
import 'package:davidan_prototype/data/mock/water/water_catalog.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/l10n/content.dart';

void main() {
  /// Every Romanian text the app passes through the content translator: the
  /// same projections the providers and widgets use, over all the mock data,
  /// plus the page texts widgets translate themselves.
  Set<String> translatedTexts() {
    final texts = <String>{};
    final recorder = ContentTranslator((ro) {
      texts.add(ro);
      return ro;
    });
    for (final catalog in mockCatalogs.values) {
      catalog.categories.forEach(recorder.category);
      catalog.products.forEach(recorder.product);
      catalog.banners.forEach(recorder.banner);
    }
    bakeryShops.forEach(recorder.shop);
    rentalCars.forEach(recorder.car);
    for (final brand in Brand.values) {
      recorder
        ..introOf(brand)
        ..infoOf(brand);
    }
    [
      BrandFacts.tagline,
      WaterPage.title,
      WaterPage.line,
      RentalPage.line,
      ...RentalTerms.documents,
    ].forEach(recorder.text);
    return texts;
  }

  const brandMaps = {
    'brands': brandsRu,
    'bakery': bakeryRu,
    'sushi': sushiRu,
    'water': waterRu,
    'rental': rentalRu,
  };

  test('every Romanian text the app translates has Russian, and no Russian '
      'is left over', () {
    final texts = translatedTexts();
    expect(texts.length, greaterThan(350));
    expect(texts.where((ro) => !ruContent.containsKey(ro)), isEmpty);
    expect(ruContent.keys.where((ro) => !texts.contains(ro)), isEmpty);
  });

  test('a text in two brands\' maps has the same Russian in both', () {
    final seen = <String, String>{};
    for (final map in brandMaps.values) {
      for (final MapEntry(key: ro, value: ru) in map.entries) {
        expect(seen.putIfAbsent(ro, () => ru), ru, reason: ro);
      }
    }
  });

  test('the Russian has no cedilla ş or ţ, and nothing is left empty', () {
    for (final MapEntry(key: ro, value: ru) in ruContent.entries) {
      expect(ru.trim(), isNotEmpty, reason: ro);
      expect(ru, isNot(matches('[şţŞŢ]')), reason: ru);
    }
  });

  test('legal pages keep their Romanian text in Russian, under a translated '
      'title', () {
    final russian = ContentTranslator.russian;
    for (final brand in brandInfos.keys) {
      final romanian = brandInfos[brand]!.documents;
      final translated = russian.infoOf(brand)!.documents;
      for (final (index, document) in romanian.indexed) {
        expect(translated[index].text, document.text);
        expect(translated[index].title, isNot(document.title));
      }
    }
  });

  group('DaviDan Sushi keeps davidansushi.md/ru\'s Russian', () {
    final source = jsonDecode(
      File('docs/sources/davidansushi_md_menu.json').readAsStringSync(),
    ) as Map<String, Object?>;
    final siteProducts = {
      for (final product in source['products']! as List<Object?>)
        (product! as Map<String, Object?>)['slug']:
            product as Map<String, Object?>,
    };
    final cyrillic = RegExp('[А-Яа-яЁё]');

    test('for every category and every name the site translated', () {
      final siteCategories = {
        for (final category in source['categories']! as List<Object?>)
          (category! as Map<String, Object?>)['slug']:
              category as Map<String, Object?>,
      };
      for (final category in sushiCategories) {
        expect(
          sushiRu[category.name],
          siteCategories[category.id]!['name_ru'],
          reason: category.id,
        );
      }
      var translatedBySite = 0;
      for (final product in sushiProducts) {
        final siteName = siteProducts[product.id]!['name_ru']! as String;
        if (!cyrillic.hasMatch(siteName)) continue;
        translatedBySite++;
        expect(sushiRu[product.name], siteName, reason: product.id);
      }
      expect(translatedBySite, greaterThan(30));
    });

    test('for every ingredient the site translated, and in no ingredient '
        'list is a Romanian word left', () {
      /// The items of a joined description, after its label.
      List<String> items(String description) =>
          description.substring(description.indexOf(': ') + 2).split(', ');
      final romanianLetters = RegExp('[ăâîșțĂÂÎȘȚ]');

      for (final product in sushiProducts) {
        final description = product.description;
        if (description == null) continue;
        final russian = sushiRu[description]!;
        expect(russian, isNot(matches(romanianLetters)), reason: product.id);
        final siteItems = _siteItems(siteProducts[product.id]!);
        final appItems = items(russian);
        expect(appItems, hasLength(items(description).length));
        for (final (index, item) in items(description).indexed) {
          final site = siteItems[index];
          // Set contents ("Haruto – 8 bucăți") use the rolls' names.
          if (!cyrillic.hasMatch(site) || item.contains('bucăți')) continue;
          final forms = {
            for (final other in sushiProducts)
              if (other.description case final otherDescription?)
                for (final (i, otherItem) in items(otherDescription).indexed)
                  if (otherItem == item)
                    ?_cyrillicOrNull(_siteItems(siteProducts[other.id]!)[i]),
          };
          expect(
            forms,
            contains(appItems[index]),
            reason: '${product.id}: $item',
          );
        }
      }
    });

    test('weights and pieces are the Romanian values with Russian units', () {
      String units(String value) => value
          .replaceAll('ml', 'мл')
          .replaceAll('g', 'г')
          .replaceAll('buc', 'шт')
          .replaceAll('L', 'л');
      for (final product in [
        ...sushiProducts,
        ...mockCatalogs[Brand.water]!.products,
      ]) {
        for (final value in [?product.weight, ?product.pieces]) {
          expect(ruContent[value], units(value), reason: product.id);
        }
      }
    });
  });

  test('docs/sources/ru_translations.md lists every translation, UI text '
      'and content alike', () {
    final doc = File('docs/sources/ru_translations.md').readAsStringSync();
    String cell(String text) => text.replaceAll('\n', '<br>');

    for (final MapEntry(key: ro, value: ru) in ruContent.entries) {
      expect(
        doc,
        contains('| ${cell(ro)} | ${cell(ru)} |'),
        reason: 'ru_translations.md has no row "| $ro | $ru |"',
      );
    }

    Map<String, String> messages(String language) => {
      for (final MapEntry(:key, :value) in (jsonDecode(
        File('lib/l10n/app_$language.arb').readAsStringSync(),
      ) as Map<String, Object?>).entries)
        if (!key.startsWith('@')) key: value! as String,
    };
    final romanian = messages('ro');
    final russian = messages('ru');
    for (final MapEntry(:key, value: ro) in romanian.entries) {
      expect(
        doc,
        contains('| $key | ${cell(ro)} | ${cell(russian[key]!)} |'),
        reason: 'ru_translations.md has no up-to-date row for "$key"',
      );
    }
  });
}

/// The site's Russian ingredients of [product], in order. A line of the site's
/// list can hold more than one ("- orez, nori").
List<String> _siteItems(Map<String, Object?> product) => [
  for (final line
      in (product['description_ru_lines']! as List<Object?>)
          .cast<String>()
          .skip(1))
    for (final item in line.replaceFirst('- ', '').split(','))
      if (item.trim().replaceAll(RegExp(r'[;.]+$'), '') case final trimmed
          when trimmed.isNotEmpty)
        trimmed,
];

String? _cyrillicOrNull(String item) =>
    RegExp('[А-Яа-яЁё]').hasMatch(item) ? item : null;
