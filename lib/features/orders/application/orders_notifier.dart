import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/data/models/brand.dart';
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

/// Orders not yet completed, from every brand, newest first: the hub's strip
/// of orders on their way.
final activeOrdersProvider = Provider<List<Order>>(
  (ref) => [
    for (final order in ref.watch(ordersProvider))
      if (order.status != OrderStatus.completed) order,
  ],
);

/// Sorts oldest first, the way the shop and couriers work through orders.
/// Orders placed in the same instant keep their number order.
int byPlacementTime(Order a, Order b) {
  final byTime = a.createdAt.compareTo(b.createdAt);
  return byTime != 0 ? byTime : a.id.compareTo(b.id);
}

/// Every order in the demo, newest first, saved to local storage on every
/// change. The customer app, courier app and store panel all share this one
/// list, so a status change made in one shows up in the others.
class OrdersNotifier extends Notifier<List<Order>> {
  static const _firstNumber = 1001;

  @override
  List<Order> build() =>
      ref.watch(localStoreProvider).read(StorageKeys.orders, _decode) ??
      const [];

  /// Creates an order of [brand]'s products with status [OrderStatus.placed]
  /// and returns it. The total is the sum of [items] at their recorded prices.
  Order place({
    required Brand brand,
    required List<OrderItem> items,
    required Fulfilment fulfilment,
    required PaymentMethod payment,
    DateTime? scheduledFor,
  }) {
    assert(items.isNotEmpty, 'An order needs at least one item');
    final now = ref.read(clockProvider)();
    final order = Order(
      // Orders are never deleted (only a demo reset clears them all), so the
      // count gives the next free number.
      id: 'DD-${_firstNumber + state.length}',
      brand: brand,
      createdAt: now,
      items: items,
      totalBani: items.fold(0, (sum, item) => sum + item.totalBani),
      fulfilment: fulfilment,
      payment: payment,
      status: OrderStatus.placed,
      scheduledFor: scheduledFor,
      statusChangedAt: now,
    );
    _save([order, ...state]);
    return order;
  }

  /// Moves the order one step along its [Order.statusFlow], recording when:
  /// the store panel accepts, prepares and readies it; the courier app
  /// delivers it, or the customer picks it up. Does nothing for a completed
  /// or unknown order.
  void advance(String orderId) {
    final index = state.indexWhere((order) => order.id == orderId);
    if (index < 0) return;
    final next = state[index].nextStatus;
    if (next == null) return;
    _save(
      [...state]
        ..[index] = state[index].copyWith(
          status: next,
          statusChangedAt: ref.read(clockProvider)(),
        ),
    );
  }

  /// Moves orders on along their [Order.statusFlow] while [nextStepAt] says
  /// a step is due by [now], recording each step at the time it fell due. An
  /// order left while the app was closed catches up at once, as if the shop
  /// and courier had kept working. The order simulation calls this.
  void advanceDue(DateTime now, DateTime? Function(Order order) nextStepAt) {
    final orders = [...state];
    var changed = false;
    for (final (index, placed) in state.indexed) {
      var order = placed;
      while (true) {
        final next = order.nextStatus;
        final at = nextStepAt(order);
        if (next == null || at == null || at.isAfter(now)) break;
        order = order.copyWith(status: next, statusChangedAt: at);
      }
      if (!identical(order, placed)) {
        orders[index] = order;
        changed = true;
      }
    }
    if (changed) _save(orders);
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
