import 'package:davidan_prototype/data/mock/ru/bakery_ru.dart';
import 'package:davidan_prototype/data/mock/ru/brands_ru.dart';
import 'package:davidan_prototype/data/mock/ru/rental_ru.dart';
import 'package:davidan_prototype/data/mock/ru/sushi_ru.dart';
import 'package:davidan_prototype/data/mock/ru/water_ru.dart';

/// The mock content in Russian, keyed by the Romanian it translates. A text
/// two brands share (a drink, "Băuturi") is in both brands' maps with the same
/// Russian; test/data/ru_content_test.dart checks they agree.
final ruContent = <String, String>{
  ...brandsRu,
  ...bakeryRu,
  ...sushiRu,
  ...waterRu,
  ...rentalRu,
};
