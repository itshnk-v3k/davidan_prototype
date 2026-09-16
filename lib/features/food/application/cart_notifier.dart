import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/cart_item.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';

/// One cart per brand, the way delivery apps keep one basket per shop: each
/// brand has its own kitchen, delivery and checkout.
final cartProvider =
    NotifierProvider.family<CartNotifier, List<CartItem>, Brand>(
      CartNotifier.new,
    );

/// Total number of items in the brand's cart, for the cart button's badge.
final cartCountProvider = Provider.family<int, Brand>(
  (ref, brand) => ref
      .watch(cartProvider(brand))
      .fold(0, (sum, item) => sum + item.quantity),
);

/// Quantity per product id in the brand's cart, so product cards can show a
/// stepper.
final cartQuantitiesProvider = Provider.family<Map<String, int>, Brand>(
  (ref, brand) => {
    for (final item in ref.watch(cartProvider(brand)))
      item.productId: item.quantity,
  },
);

/// The brand's cart lines with their products, in the order they were added.
final cartLinesProvider = Provider.family<List<CartLine>, Brand>((ref, brand) {
  final products = ref.watch(productsByIdProvider(brand));
  return [
    for (final item in ref.watch(cartProvider(brand)))
      if (products[item.productId] case final product?)
        (
          product: product,
          quantity: item.quantity,
          priceBani: product.priceBani,
        ),
  ];
});

/// The brand's cart total in bani.
final cartTotalProvider = Provider.family<int, Brand>(
  (ref, brand) => ref
      .watch(cartLinesProvider(brand))
      .fold(0, (sum, line) => sum + line.priceBani * line.quantity),
);

/// One brand's cart lines, saved to local storage on every change and
/// restored on start.
class CartNotifier extends Notifier<List<CartItem>> {
  CartNotifier(this.brand);

  final Brand brand;

  @override
  List<CartItem> build() {
    final saved =
        ref
            .watch(localStoreProvider)
            .read(StorageKeys.cartOf(brand), _decode) ??
        const [];
    final products = ref.watch(productsByIdProvider(brand));
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
    ref.read(localStoreProvider).write(StorageKeys.cartOf(brand), [
      for (final item in items) item.toJson(),
    ]);
  }

  static List<CartItem> _decode(Object? json) => [
    for (final entry in json! as List<Object?>)
      CartItem.fromJson(entry! as Map<String, Object?>),
  ];
}
