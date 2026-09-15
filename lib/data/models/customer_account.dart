import 'package:flutter/foundation.dart';

import 'package:davidan_prototype/data/models/chisinau_sector.dart';

/// How the nearest shop was found at sign-up.
enum ShopMatch {
  /// From the centre of the sector the customer picked.
  sector,

  /// From the phone's location.
  location,
}

/// The customer's DEMO account. Nothing in it was verified: the prototype
/// sends no SMS and has no backend.
@immutable
class CustomerAccount {
  const CustomerAccount({
    required this.phone,
    required this.name,
    required this.sector,
    required this.nearestLocationId,
    required this.matchedBy,
    this.distanceMeters,
  });

  factory CustomerAccount.fromJson(Map<String, Object?> json) =>
      CustomerAccount(
        phone: json['phone']! as String,
        name: json['name']! as String,
        sector: ChisinauSector.values.byName(json['sector']! as String),
        nearestLocationId: json['nearestLocationId']! as String,
        matchedBy: ShopMatch.values.byName(json['matchedBy']! as String),
        distanceMeters: json['distanceMeters'] as int?,
      );

  /// Moldovan mobile number without +373: 8 digits, e.g. "69123456".
  final String phone;
  final String name;
  final ChisinauSector sector;

  /// Id of the StoreLocation nearest the customer.
  final String nearestLocationId;
  final ShopMatch matchedBy;

  /// Distance to that shop, when [matchedBy] is [ShopMatch.location].
  final int? distanceMeters;

  Map<String, Object?> toJson() => {
    'phone': phone,
    'name': name,
    'sector': sector.name,
    'nearestLocationId': nearestLocationId,
    'matchedBy': matchedBy.name,
    'distanceMeters': distanceMeters,
  };
}
