import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/data/models/cart_item.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';

/// An order's items with their products looked up in its brand's catalog, at
/// the prices recorded when the order was placed. Items whose product has
/// since left the catalog are skipped.
final orderLinesProvider = Provider.family<List<CartLine>, String>((
  ref,
  orderId,
) {
  final order = ref.watch(orderByIdProvider(orderId));
  if (order == null) return const [];
  final products = ref.watch(productsByIdProvider(order.brand));
  return [
    for (final item in order.items)
      if (products[item.productId] case final product?)
        (product: product, quantity: item.quantity, priceBani: item.priceBani),
  ];
});
