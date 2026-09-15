import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';

/// The courier's deliveries in two groups, oldest first within each: those
/// already on the way, and those ready to collect from the shop. Pickup
/// orders never get here, because the shop hands them over itself.
final courierDeliveriesProvider =
    Provider<({List<Order> onTheWay, List<Order> ready})>((ref) {
      final deliveries = [
        for (final order in ref.watch(ordersProvider))
          if (order.nextStepBy == OrderActor.courier) order,
      ]..sort(byPlacementTime);
      return (
        onTheWay: [
          for (final order in deliveries)
            if (order.status == OrderStatus.onTheWay) order,
        ],
        ready: [
          for (final order in deliveries)
            if (order.status == OrderStatus.ready) order,
        ],
      );
    });
