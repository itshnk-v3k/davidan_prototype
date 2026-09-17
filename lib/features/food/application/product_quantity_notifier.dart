import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';

/// Quantity picked on a product's detail screen. For a product not in the cart
/// it's how many to add, starting at 1. For one already in the cart it's the
/// cart's quantity, which the screen then sets, down to 0 to take the product
/// out. Auto-disposed when the screen closes, so every visit starts again from
/// the cart.
final productQuantityProvider = NotifierProvider.autoDispose
    .family<ProductQuantityNotifier, int, ProductKey>(
      ProductQuantityNotifier.new,
    );

class ProductQuantityNotifier extends Notifier<int> {
  ProductQuantityNotifier(this.product);

  static const max = 99;

  final ProductKey product;

  /// The cart's quantity when the screen opened; 0 when it wasn't in the cart.
  int _inCartAtOpen = 0;

  int get _min => _inCartAtOpen > 0 ? 0 : 1;

  @override
  int build() {
    // Read once: the screen edits a copy, and the cart changes only when the
    // customer confirms.
    _inCartAtOpen =
        ref.read(cartQuantitiesProvider(product.brand))[product.id] ?? 0;
    return _inCartAtOpen > 0 ? _inCartAtOpen : 1;
  }

  bool get canDecrement => state > _min;

  void increment() {
    if (state < max) state++;
  }

  void decrement() {
    if (state > _min) state--;
  }
}
