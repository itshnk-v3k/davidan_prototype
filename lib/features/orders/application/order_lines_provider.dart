import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/data/models/cart_item.dart';
import 'package:davidan_prototype/features/client/application/catalog_providers.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';

/// An order's items with their products looked up in the catalog, at the
/// prices recorded when the order was placed. Items whose product has since
/// left the catalog are skipped.
final orderLinesProvider = Provider.family<List<CartLine>, String>((
  ref,
  orderId,
) {
  final items = ref.watch(orderByIdProvider(orderId))?.items ?? const [];
  final products = ref.watch(productsByIdProvider);
  return [
    for (final item in items)
      if (products[item.productId] case final product?)
        (product: product, quantity: item.quantity, priceBani: item.priceBani),
  ];
});
