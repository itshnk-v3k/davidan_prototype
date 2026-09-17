import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/data/models/rental_car.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/rental/application/rental_providers.dart';

/// What was typed, and where: one brand's pages, or every brand (null) from
/// the hub.
typedef SearchQuery = ({Brand? brand, String text});

/// The products and cars a [SearchQuery] finds, best matches first.
typedef SearchResults = ({List<Product> products, List<RentalCar> cars});

/// Searches the menus (and, from the hub or Rent Car, the fleet) in the app's
/// language. Every word typed has to be found; a product whose name has them
/// all comes before one found by its category or ingredients. Case and the
/// Romanian letters' marks don't matter, so "placinta" finds "Plăcintă".
final searchResultsProvider = Provider.autoDispose
    .family<SearchResults, SearchQuery>((ref, query) {
      final words = searchWords(query.text);
      if (words.isEmpty) return (products: const [], cars: const []);
      bool allIn(String text) => words.every(text.contains);

      final byName = <Product>[];
      final byOther = <Product>[];
      for (final brand in query.brand == null ? Brand.values : [query.brand!]) {
        final categoryNames = {
          for (final category in ref.watch(categoriesProvider(brand)))
            category.id: category.name,
        };
        for (final product in ref.watch(productsProvider(brand))) {
          if (allIn(searchable(product.name))) {
            byName.add(product);
          } else if (allIn(
            searchable(
              '${product.name} ${categoryNames[product.categoryId] ?? ''} '
              '${product.description ?? ''}',
            ),
          )) {
            byOther.add(product);
          }
        }
      }

      final withCars = query.brand == null || query.brand == Brand.carRental;
      return (
        products: [...byName, ...byOther],
        cars: [
          if (withCars)
            for (final car in ref.watch(rentalCarsProvider))
              if (allIn(searchable('${car.name} ${car.gearbox} ${car.fuel}')))
                car,
        ],
      );
    });

/// [text] as search compares it: lower case, Romanian letters without their
/// marks and Russian ё as е.
String searchable(String text) {
  const plain = {
    'ă': 'a',
    'â': 'a',
    'î': 'i',
    'ș': 's',
    'ş': 's',
    'ț': 't',
    'ţ': 't',
    'ё': 'е',
  };
  return [for (final char in text.toLowerCase().split('')) plain[char] ?? char]
      .join();
}

/// The words of a query, as [searchable] text.
List<String> searchWords(String query) => [
  for (final word in searchable(query).split(RegExp(r'\s+')))
    if (word.isNotEmpty) word,
];
