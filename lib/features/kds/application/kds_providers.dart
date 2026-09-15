import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';

/// Columns of the store panel, left to right, and the statuses each holds.
/// Orders with the courier or completed are no longer the shop's work.
enum KdsColumn {
  incoming({OrderStatus.placed}),
  inKitchen({OrderStatus.accepted, OrderStatus.preparing}),
  ready({OrderStatus.ready});

  const KdsColumn(this.statuses);

  final Set<OrderStatus> statuses;
}

/// Orders in one column, oldest first: the shop works through them in the
/// order they came in. The demo shows every shop's orders on one panel.
final kdsColumnProvider = Provider.family<List<Order>, KdsColumn>(
  (ref, column) => [
    for (final order in ref.watch(ordersProvider))
      if (column.statuses.contains(order.status)) order,
  ]..sort(byPlacementTime),
);
