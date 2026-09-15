import 'package:flutter/foundation.dart';

import 'package:davidan_prototype/data/models/product.dart';

/// A product line in the cart. Orders reuse it for their line items.
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

/// A cart line with its product looked up in the catalog, ready to display.
typedef CartLine = ({Product product, int quantity});
