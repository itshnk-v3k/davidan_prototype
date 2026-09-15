import 'package:flutter/foundation.dart';

import 'package:davidan_prototype/data/models/cart_item.dart';

/// Where an order is in its lifecycle. The customer app creates orders as
/// [placed]; the store panel and courier app move them forward. Saved by
/// name, so renaming a value needs a LocalStore.schemaVersion bump.
enum OrderStatus { placed, preparing, ready, onTheWay, completed }

/// Paid when the order is received. DaviDan takes no online payments.
enum PaymentMethod { cash, card }

/// How the customer gets the order.
@immutable
sealed class Fulfilment {
  const Fulfilment();

  factory Fulfilment.fromJson(Map<String, Object?> json) =>
      switch (json['type']) {
        'delivery' => HomeDelivery(address: json['address']! as String),
        'pickup' => StorePickup(locationId: json['locationId']! as String),
        final type => throw FormatException('Unknown fulfilment "$type"'),
      };

  Map<String, Object?> toJson();
}

/// Delivered by a courier to [address].
final class HomeDelivery extends Fulfilment {
  const HomeDelivery({required this.address});

  final String address;

  @override
  Map<String, Object?> toJson() => {'type': 'delivery', 'address': address};
}

/// Collected by the customer from a shop.
final class StorePickup extends Fulfilment {
  const StorePickup({required this.locationId});

  /// Id of a StoreLocation.
  final String locationId;

  @override
  Map<String, Object?> toJson() => {'type': 'pickup', 'locationId': locationId};
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
  });

  factory Order.fromJson(Map<String, Object?> json) {
    final scheduledFor = json['scheduledFor'] as String?;
    return Order(
      id: json['id']! as String,
      createdAt: DateTime.parse(json['createdAt']! as String),
      items: [
        for (final item in json['items']! as List<Object?>)
          CartItem.fromJson(item! as Map<String, Object?>),
      ],
      totalBani: json['totalBani']! as int,
      fulfilment: Fulfilment.fromJson(
        json['fulfilment']! as Map<String, Object?>,
      ),
      payment: PaymentMethod.values.byName(json['payment']! as String),
      status: OrderStatus.values.byName(json['status']! as String),
      scheduledFor: scheduledFor == null ? null : DateTime.parse(scheduledFor),
    );
  }

  /// Order number shown to people, e.g. "DD-1001".
  final String id;
  final DateTime createdAt;
  final List<CartItem> items;

  /// Total when the order was placed, in bani. Later price changes in the
  /// catalog don't change what the customer agreed to pay.
  final int totalBani;
  final Fulfilment fulfilment;
  final PaymentMethod payment;
  final OrderStatus status;

  /// Requested delivery or pickup time, or null for "as soon as possible".
  final DateTime? scheduledFor;

  Map<String, Object?> toJson() => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'items': [for (final item in items) item.toJson()],
    'totalBani': totalBani,
    'fulfilment': fulfilment.toJson(),
    'payment': payment.name,
    'status': status.name,
    'scheduledFor': scheduledFor?.toIso8601String(),
  };
}
