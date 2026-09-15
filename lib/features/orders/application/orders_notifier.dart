import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/data/models/cart_item.dart';
import 'package:davidan_prototype/data/models/order.dart';

final ordersProvider = NotifierProvider<OrdersNotifier, List<Order>>(
  OrdersNotifier.new,
);

/// Null when no order has this id (e.g. a hand-edited link).
final orderByIdProvider = Provider.family<Order?, String>(
  (ref, orderId) => ref
      .watch(ordersProvider)
      .where((order) => order.id == orderId)
      .firstOrNull,
);

/// Every order in the demo, newest first, saved to local storage on every
/// change. The customer app, courier app and store panel all share this one
/// list, so a status change made in one shows up in the others.
class OrdersNotifier extends Notifier<List<Order>> {
  static const _firstNumber = 1001;

  @override
  List<Order> build() =>
      ref.watch(localStoreProvider).read(StorageKeys.orders, _decode) ??
      const [];

  /// Creates an order with status [OrderStatus.placed] and returns it.
  Order place({
    required List<CartItem> items,
    required int totalBani,
    required Fulfilment fulfilment,
    required PaymentMethod payment,
    DateTime? scheduledFor,
  }) {
    assert(items.isNotEmpty, 'An order needs at least one item');
    final order = Order(
      // Orders are never deleted (only a demo reset clears them all), so the
      // count gives the next free number.
      id: 'DD-${_firstNumber + state.length}',
      createdAt: ref.read(clockProvider)(),
      items: items,
      totalBani: totalBani,
      fulfilment: fulfilment,
      payment: payment,
      status: OrderStatus.placed,
      scheduledFor: scheduledFor,
    );
    _save([order, ...state]);
    return order;
  }

  void _save(List<Order> orders) {
    state = orders;
    ref.read(localStoreProvider).write(StorageKeys.orders, [
      for (final order in orders) order.toJson(),
    ]);
  }

  static List<Order> _decode(Object? json) => [
    for (final entry in json! as List<Object?>)
      Order.fromJson(entry! as Map<String, Object?>),
  ];
}
