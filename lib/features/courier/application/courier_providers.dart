import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';

/// Orders waiting on a courier: delivery orders that are ready at the shop or
/// already on the way. Pickup orders never get here, because the shop hands
/// them over itself. Deliveries on the way come first, then the rest, oldest
/// first within each.
final courierOrdersProvider = Provider<List<Order>>((ref) {
  int onTheWayFirst(Order order) =>
      order.status == OrderStatus.onTheWay ? 0 : 1;

  return [
    for (final order in ref.watch(ordersProvider))
      if (order.nextStepBy == OrderActor.courier) order,
  ]..sort((a, b) {
    final byStatus = onTheWayFirst(a).compareTo(onTheWayFirst(b));
    return byStatus != 0 ? byStatus : byPlacementTime(a, b);
  });
});
