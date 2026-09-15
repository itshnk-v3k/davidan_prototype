import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/client/application/catalog_providers.dart';

final favoritesProvider = NotifierProvider<FavoritesNotifier, List<String>>(
  FavoritesNotifier.new,
);

/// Favourite product ids, for the hearts on cards and the product page.
final favoriteIdsProvider = Provider<Set<String>>(
  (ref) => ref.watch(favoritesProvider).toSet(),
);

/// Favourite products, most recently saved first.
final favoriteProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productsByIdProvider);
  return [for (final id in ref.watch(favoritesProvider)) ?products[id]];
});

/// Ids of the products the customer saved with a heart, most recently saved
/// first. Kept apart from the cart: a favourite is a bookmark, not something
/// to order now. Saved to local storage on every change, like the cart.
class FavoritesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    final saved =
        ref.watch(localStoreProvider).read(StorageKeys.favorites, _decode) ??
        const [];
    final products = ref.watch(productsByIdProvider);
    // Drop products that have since left the mock catalog.
    return [
      for (final id in saved)
        if (products.containsKey(id)) id,
    ];
  }

  /// Saves the product, or removes it if it is already saved.
  void toggle(String productId) => _save(
    state.contains(productId)
        ? [
            for (final id in state)
              if (id != productId) id,
          ]
        : [productId, ...state],
  );

  void _save(List<String> productIds) {
    state = productIds;
    ref.read(localStoreProvider).write(StorageKeys.favorites, productIds);
  }

  static List<String> _decode(Object? json) => [
    for (final id in json! as List<Object?>) id! as String,
  ];
}
