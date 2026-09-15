import 'package:flutter/foundation.dart';

import 'package:davidan_prototype/data/models/product.dart';

/// A product line in the cart. Its price follows the catalog; a placed order
/// stores OrderItem instead, which records the price.
@immutable
class CartItem {
  const CartItem({required this.productId, required this.quantity});

  factory CartItem.fromJson(Map<String, Object?> json) => CartItem(
    productId: json['productId']! as String,
    quantity: json['quantity']! as int,
  );

  final String productId;
  final int quantity;

  CartItem copyWith({int? quantity}) =>
      CartItem(productId: productId, quantity: quantity ?? this.quantity);

  Map<String, Object?> toJson() => {
    'productId': productId,
    'quantity': quantity,
  };
}

/// A line ready to display: the product looked up in the catalog, the
/// quantity, and the unit price (the catalog price for the cart, the recorded
/// price for a placed order).
typedef CartLine = ({Product product, int quantity, int priceBani});
