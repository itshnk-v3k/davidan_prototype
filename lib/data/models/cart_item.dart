import 'package:flutter/foundation.dart';

/// A product line in the cart. Orders will reuse it for their line items.
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
