import 'package:flutter/foundation.dart';

/// A DaviDan shop where customers can pick up an order.
@immutable
class StoreLocation {
  const StoreLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.openingHours,
  });

  final String id;
  final String name;
  final String address;
  final String openingHours;
}
