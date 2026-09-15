import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/data/models/cart_item.dart';
import 'package:davidan_prototype/features/client/application/catalog_providers.dart';

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(
  CartNotifier.new,
);

/// Total number of items in the cart, for the tab bar badge.
final cartCountProvider = Provider<int>(
  (ref) => ref.watch(cartProvider).fold(0, (sum, item) => sum + item.quantity),
);

/// Quantity per product id, so product cards can show a stepper.
final cartQuantitiesProvider = Provider<Map<String, int>>(
  (ref) => {
    for (final item in ref.watch(cartProvider)) item.productId: item.quantity,
  },
);

/// Cart lines with their products, in the order they were added.
final cartLinesProvider = Provider<List<CartLine>>((ref) {
  final products = ref.watch(productsByIdProvider);
  return [
    for (final item in ref.watch(cartProvider))
      if (products[item.productId] case final product?)
        (
          product: product,
          quantity: item.quantity,
          priceBani: product.priceBani,
        ),
  ];
});

/// Cart total in bani.
final cartTotalProvider = Provider<int>(
  (ref) => ref
      .watch(cartLinesProvider)
      .fold(0, (sum, line) => sum + line.priceBani * line.quantity),
);

/// Cart lines, saved to local storage on every change and restored on start.
class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    final saved =
        ref.watch(localStoreProvider).read(StorageKeys.cart, _decode) ??
        const [];
    final products = ref.watch(productsByIdProvider);
    // Drop lines whose product has since been removed from the mock catalog.
    return [
      for (final item in saved)
        if (products.containsKey(item.productId)) item,
    ];
  }

  void add(String productId, {int quantity = 1}) {
    assert(quantity > 0, 'Use removeOne to decrease a quantity');
    final inCart = state.any((item) => item.productId == productId);
    _save(
      inCart
          ? [
              for (final item in state)
                item.productId == productId
                    ? item.copyWith(quantity: item.quantity + quantity)
                    : item,
            ]
          : [...state, CartItem(productId: productId, quantity: quantity)],
    );
  }

  /// Removes one unit; the line disappears when its quantity reaches zero.
  void removeOne(String productId) {
    _save([
      for (final item in state)
        if (item.productId != productId)
          item
        else if (item.quantity > 1)
          item.copyWith(quantity: item.quantity - 1),
    ]);
  }

  /// Removes the whole line, whatever its quantity.
  void remove(String productId) {
    _save([
      for (final item in state)
        if (item.productId != productId) item,
    ]);
  }

  void clear() => _save(const []);

  void _save(List<CartItem> items) {
    state = items;
    ref.read(localStoreProvider).write(StorageKeys.cart, [
      for (final item in items) item.toJson(),
    ]);
  }

  static List<CartItem> _decode(Object? json) => [
    for (final entry in json! as List<Object?>)
      CartItem.fromJson(entry! as Map<String, Object?>),
  ];
}
