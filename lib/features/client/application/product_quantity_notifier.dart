import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Quantity picked on a product's detail screen before it goes into the cart.
/// Auto-disposed when the screen closes, so every visit starts at 1. The cart
/// itself stays in CartNotifier.
final productQuantityProvider = NotifierProvider.autoDispose
    .family<ProductQuantityNotifier, int, String>(ProductQuantityNotifier.new);

class ProductQuantityNotifier extends Notifier<int> {
  ProductQuantityNotifier(this.productId);

  static const max = 99;

  final String productId;

  @override
  int build() => 1;

  void increment() {
    if (state < max) state++;
  }

  void decrement() {
    if (state > 1) state--;
  }
}
