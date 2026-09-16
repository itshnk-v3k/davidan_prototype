import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';

final favoritesProvider = NotifierProvider<FavoritesNotifier, List<ProductKey>>(
  FavoritesNotifier.new,
);

/// Favourite products, for the hearts on cards and the product page.
final favoriteKeysProvider = Provider<Set<ProductKey>>(
  (ref) => ref.watch(favoritesProvider).toSet(),
);

/// Favourite products of every brand, most recently saved first.
final favoriteProductsProvider = Provider<List<Product>>(
  (ref) => [
    for (final key in ref.watch(favoritesProvider))
      ?ref.watch(productByIdProvider(key)),
  ],
);

/// The products the customer saved with a heart, of any brand, most recently
/// saved first. Kept apart from the carts: a favourite is a bookmark, not
/// something to order now. Saved to local storage on every change, like the
/// carts.
class FavoritesNotifier extends Notifier<List<ProductKey>> {
  @override
  List<ProductKey> build() {
    final saved =
        ref.watch(localStoreProvider).read(StorageKeys.favorites, _decode) ??
        const [];
    // Drop products that have since left the mock catalog.
    return [
      for (final key in saved)
        if (ref.watch(productByIdProvider(key)) != null) key,
    ];
  }

  /// Saves the product, or removes it if it is already saved.
  void toggle(ProductKey product) => _save(
    state.contains(product)
        ? [
            for (final key in state)
              if (key != product) key,
          ]
        : [product, ...state],
  );

  void _save(List<ProductKey> products) {
    state = products;
    ref.read(localStoreProvider).write(StorageKeys.favorites, [
      for (final key in products) {'brand': key.brand.name, 'id': key.id},
    ]);
  }

  static List<ProductKey> _decode(Object? json) => [
    for (final entry in json! as List<Object?>)
      if (entry case {'brand': final String brand, 'id': final String id})
        (brand: Brand.values.byName(brand), id: id),
  ];
}
