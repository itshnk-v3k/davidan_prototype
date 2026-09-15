import 'package:flutter/foundation.dart';

import 'package:davidan_prototype/data/models/geo_point.dart';

/// Where an order is in its lifecycle. Which statuses an order goes through
/// depends on how it is fulfilled: see [Order.statusFlow]. Saved by name, so
/// renaming or removing a value needs a LocalStore.schemaVersion bump.
enum OrderStatus {
  /// Created by the customer app, waiting for the shop.
  placed,

  /// Set by the store panel's "Accept" button.
  accepted,
  preparing,

  /// Packed, waiting for the customer (pickup) or the courier (delivery).
  ready,

  /// Delivery only: the courier has the order.
  onTheWay,

  /// Picked up in the shop, or handed over by the courier.
  completed,
}

/// Who moves an order on to its next status. The customer only places it.
enum OrderActor { store, courier }

/// Paid when the order is received. DaviDan takes no online payments.
enum PaymentMethod { cash, card }

/// How the customer gets the order.
@immutable
sealed class Fulfilment {
  const Fulfilment();

  factory Fulfilment.fromJson(Map<String, Object?> json) =>
      switch (json['type']) {
        'delivery' => HomeDelivery(
          address: json['address']! as String,
          point: switch (json['point']) {
            final Map<String, Object?> point => GeoPoint.fromJson(point),
            _ => null,
          },
        ),
        'pickup' => StorePickup(locationId: json['locationId']! as String),
        final type => throw FormatException('Unknown fulfilment "$type"'),
      };

  Map<String, Object?> toJson();
}

/// Delivered by a courier to [address], or to [point] when the customer chose
/// "Folosește locația mea curentă" for this order ([address] is empty then).
final class HomeDelivery extends Fulfilment {
  const HomeDelivery({required this.address, this.point});

  final String address;
  final GeoPoint? point;

  @override
  Map<String, Object?> toJson() => {
    'type': 'delivery',
    'address': address,
    if (point case final point?) 'point': point.toJson(),
  };
}

/// Collected by the customer from a shop.
final class StorePickup extends Fulfilment {
  const StorePickup({required this.locationId});

  /// Id of a StoreLocation.
  final String locationId;

  @override
  Map<String, Object?> toJson() => {'type': 'pickup', 'locationId': locationId};
}

/// One line of an order. It records the unit price at the moment the order
/// was placed, so order history doesn't change when catalog prices do.
@immutable
class OrderItem {
  const OrderItem({
    required this.productId,
    required this.quantity,
    required this.priceBani,
  });

  factory OrderItem.fromJson(Map<String, Object?> json) => OrderItem(
    productId: json['productId']! as String,
    quantity: json['quantity']! as int,
    priceBani: json['priceBani']! as int,
  );

  final String productId;
  final int quantity;

  /// Unit price when the order was placed, in bani.
  final int priceBani;

  int get totalBani => priceBani * quantity;

  Map<String, Object?> toJson() => {
    'productId': productId,
    'quantity': quantity,
    'priceBani': priceBani,
  };
}

/// An order placed from the customer app.
@immutable
class Order {
  const Order({
    required this.id,
    required this.createdAt,
    required this.items,
    required this.totalBani,
    required this.fulfilment,
    required this.payment,
    required this.status,
    this.scheduledFor,
    this.statusChangedAt,
  });

  factory Order.fromJson(Map<String, Object?> json) {
    final scheduledFor = json['scheduledFor'] as String?;
    final statusChangedAt = json['statusChangedAt'] as String?;
    return Order(
      id: json['id']! as String,
      createdAt: DateTime.parse(json['createdAt']! as String),
      items: [
        for (final item in json['items']! as List<Object?>)
          OrderItem.fromJson(item! as Map<String, Object?>),
      ],
      totalBani: json['totalBani']! as int,
      fulfilment: Fulfilment.fromJson(
        json['fulfilment']! as Map<String, Object?>,
      ),
      payment: PaymentMethod.values.byName(json['payment']! as String),
      status: OrderStatus.values.byName(json['status']! as String),
      scheduledFor: scheduledFor == null ? null : DateTime.parse(scheduledFor),
      statusChangedAt: statusChangedAt == null
          ? null
          : DateTime.parse(statusChangedAt),
    );
  }

  static const _deliveryFlow = [
    OrderStatus.placed,
    OrderStatus.accepted,
    OrderStatus.preparing,
    OrderStatus.ready,
    OrderStatus.onTheWay,
    OrderStatus.completed,
  ];

  static const _pickupFlow = [
    OrderStatus.placed,
    OrderStatus.accepted,
    OrderStatus.preparing,
    OrderStatus.ready,
    OrderStatus.completed,
  ];

  /// Order number shown to people, e.g. "DD-1001".
  final String id;
  final DateTime createdAt;
  final List<OrderItem> items;

  /// Sum of the item totals at their recorded prices, in bani.
  final int totalBani;
  final Fulfilment fulfilment;
  final PaymentMethod payment;
  final OrderStatus status;

  /// Requested delivery or pickup time, or null for "as soon as possible".
  final DateTime? scheduledFor;

  /// When the order moved to its current status. Null for orders saved before
  /// the app recorded it.
  final DateTime? statusChangedAt;

  /// Since when the order has had its current status, falling back to when it
  /// was placed for orders saved without [statusChangedAt].
  DateTime get statusSince => statusChangedAt ?? createdAt;

  /// Statuses this order goes through, first to last. Pickup orders have no
  /// courier step.
  List<OrderStatus> get statusFlow => switch (fulfilment) {
    HomeDelivery() => _deliveryFlow,
    StorePickup() => _pickupFlow,
  };

  /// The status after the current one, or null once the order is completed.
  OrderStatus? get nextStatus {
    final flow = statusFlow;
    final index = flow.indexOf(status);
    return index >= 0 && index < flow.length - 1 ? flow[index + 1] : null;
  }

  /// Who takes the next step, or null once the order is completed. The shop
  /// accepts, prepares and readies every order, and hands pickup orders over
  /// itself; a courier takes delivery orders from ready onwards.
  OrderActor? get nextStepBy => switch (status) {
    OrderStatus.placed ||
    OrderStatus.accepted ||
    OrderStatus.preparing => OrderActor.store,
    OrderStatus.ready => switch (fulfilment) {
      HomeDelivery() => OrderActor.courier,
      StorePickup() => OrderActor.store,
    },
    OrderStatus.onTheWay => OrderActor.courier,
    OrderStatus.completed => null,
  };

  Order copyWith({OrderStatus? status, DateTime? statusChangedAt}) => Order(
    id: id,
    createdAt: createdAt,
    items: items,
    totalBani: totalBani,
    fulfilment: fulfilment,
    payment: payment,
    status: status ?? this.status,
    scheduledFor: scheduledFor,
    statusChangedAt: statusChangedAt ?? this.statusChangedAt,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'items': [for (final item in items) item.toJson()],
    'totalBani': totalBani,
    'fulfilment': fulfilment.toJson(),
    'payment': payment.name,
    'status': status.name,
    'scheduledFor': scheduledFor?.toIso8601String(),
    'statusChangedAt': statusChangedAt?.toIso8601String(),
  };
}
