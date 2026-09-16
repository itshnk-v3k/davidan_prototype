import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/data/models/product.dart';

/// Quantity picked on a product's detail screen before it goes into the cart.
/// Auto-disposed when the screen closes, so every visit starts at 1. The cart
/// itself stays in CartNotifier.
final productQuantityProvider = NotifierProvider.autoDispose
    .family<ProductQuantityNotifier, int, ProductKey>(
      ProductQuantityNotifier.new,
    );

class ProductQuantityNotifier extends Notifier<int> {
  ProductQuantityNotifier(this.product);

  static const max = 99;

  final ProductKey product;

  @override
  int build() => 1;

  void increment() {
    if (state < max) state++;
  }

  void decrement() {
    if (state > 1) state--;
  }
}
