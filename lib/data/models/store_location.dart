import 'package:flutter/foundation.dart';

import 'package:davidan_prototype/data/models/geo_point.dart';

/// A DaviDan shop where customers can pick up an order.
@immutable
class StoreLocation {
  const StoreLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.openingHours,
    required this.position,
  });

  final String id;
  final String name;
  final String address;
  final String openingHours;

  /// Where the shop is, for finding the one nearest a customer.
  final GeoPoint position;
}
