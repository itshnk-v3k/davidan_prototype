import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/data/models/rental_booking.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/features/rental/application/rental_bookings_notifier.dart';

/// Something the customer sent a brand from the app: an order from a brand's
/// cart, or a car rental request. The Comenzi tab and the hub's strip list
/// both.
@immutable
sealed class CustomerRequest {
  const CustomerRequest();

  String get id;
  Brand get brand;
  DateTime get createdAt;

  /// Still under way: an order not yet completed, or a rental request, which
  /// stays sent since the company confirms it by phone.
  bool get active;
}

final class OrderRequest extends CustomerRequest {
  const OrderRequest(this.order);

  final Order order;

  @override
  String get id => order.id;

  @override
  Brand get brand => order.brand;

  @override
  DateTime get createdAt => order.createdAt;

  @override
  bool get active => order.status != OrderStatus.completed;
}

final class BookingRequest extends CustomerRequest {
  const BookingRequest(this.booking);

  final RentalBooking booking;

  @override
  String get id => booking.id;

  @override
  Brand get brand => Brand.carRental;

  @override
  DateTime get createdAt => booking.createdAt;

  @override
  bool get active => true;
}

/// Every order and car rental request, newest first. Those sent in the same
/// instant keep their lists' order, orders first.
final customerRequestsProvider = Provider<List<CustomerRequest>>((ref) {
  final requests = [
    for (final order in ref.watch(ordersProvider)) OrderRequest(order),
    for (final booking in ref.watch(rentalBookingsProvider))
      BookingRequest(booking),
  ];
  final sorted = requests.indexed.toList()
    ..sort((a, b) {
      final byTime = b.$2.createdAt.compareTo(a.$2.createdAt);
      return byTime != 0 ? byTime : a.$1.compareTo(b.$1);
    });
  return [for (final (_, request) in sorted) request];
});

/// The requests still under way, newest first: the hub's strip.
final activeRequestsProvider = Provider<List<CustomerRequest>>(
  (ref) => [
    for (final request in ref.watch(customerRequestsProvider))
      if (request.active) request,
  ],
);
