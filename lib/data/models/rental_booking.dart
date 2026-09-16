import 'package:flutter/foundation.dart';

/// Where a car is picked up or returned: the two places davidanrentcar.md's
/// forms offer. Saved by name.
enum RentalLocation { airport, chisinau }

/// The extra services davidanrentcar.md's request form offers. Saved by name.
enum RentalExtra { childSeat, unlimitedKm }

/// What a rental costs, line by line, the way davidanrentcar.md's cart adds
/// it up: the days at the price per day for that length, the chosen extras,
/// the location fee and the car's insurance amount. Amounts are in euros.
@immutable
class RentalQuote {
  const RentalQuote({
    required this.days,
    required this.dayRateEur,
    required this.extrasEur,
    required this.locationFeeEur,
    required this.insuranceEur,
  });

  factory RentalQuote.fromJson(Map<String, Object?> json) => RentalQuote(
    days: json['days']! as int,
    dayRateEur: json['dayRateEur']! as int,
    extrasEur: {
      for (final MapEntry(:key, :value)
          in (json['extrasEur']! as Map<String, Object?>).entries)
        RentalExtra.values.byName(key): value! as int,
    },
    locationFeeEur: json['locationFeeEur']! as int,
    insuranceEur: json['insuranceEur']! as int,
  );

  /// Days charged: every started 24 hours counts as a day.
  final int days;
  final int dayRateEur;

  /// Each chosen extra with what it adds, in [RentalExtra] order.
  final Map<RentalExtra, int> extrasEur;
  final int locationFeeEur;
  final int insuranceEur;

  int get rentalEur => days * dayRateEur;

  int get totalEur =>
      rentalEur +
      extrasEur.values.fold<int>(0, (sum, amount) => sum + amount) +
      locationFeeEur +
      insuranceEur;

  Map<String, Object?> toJson() => {
    'days': days,
    'dayRateEur': dayRateEur,
    'extrasEur': {
      for (final MapEntry(:key, :value) in extrasEur.entries) key.name: value,
    },
    'locationFeeEur': locationFeeEur,
    'insuranceEur': insuranceEur,
  };
}

/// A request to rent a car, sent from the app. DaviDan Rent Car confirms a
/// booking by contacting the customer, and the prototype has no one to do
/// that, so a request stays sent. Nothing is paid in the app.
@immutable
class RentalBooking {
  const RentalBooking({
    required this.id,
    required this.carId,
    required this.createdAt,
    required this.pickupLocation,
    required this.returnLocation,
    required this.pickupAt,
    required this.returnAt,
    required this.name,
    required this.phone,
    required this.notes,
    required this.quote,
  });

  factory RentalBooking.fromJson(Map<String, Object?> json) => RentalBooking(
    id: json['id']! as String,
    carId: json['carId']! as String,
    createdAt: DateTime.parse(json['createdAt']! as String),
    pickupLocation: RentalLocation.values.byName(
      json['pickupLocation']! as String,
    ),
    returnLocation: RentalLocation.values.byName(
      json['returnLocation']! as String,
    ),
    pickupAt: DateTime.parse(json['pickupAt']! as String),
    returnAt: DateTime.parse(json['returnAt']! as String),
    name: json['name']! as String,
    phone: json['phone']! as String,
    notes: json['notes']! as String,
    quote: RentalQuote.fromJson(json['quote']! as Map<String, Object?>),
  );

  /// Request number shown to people, e.g. "RC-1001".
  final String id;

  /// Id of the RentalCar.
  final String carId;
  final DateTime createdAt;
  final RentalLocation pickupLocation;
  final RentalLocation returnLocation;
  final DateTime pickupAt;
  final DateTime returnAt;

  /// Who to contact: a name and a Moldovan mobile number without +373.
  final String name;
  final String phone;

  /// "Informații suplimentare", possibly empty.
  final String notes;

  /// The price when the request was sent.
  final RentalQuote quote;

  Map<String, Object?> toJson() => {
    'id': id,
    'carId': carId,
    'createdAt': createdAt.toIso8601String(),
    'pickupLocation': pickupLocation.name,
    'returnLocation': returnLocation.name,
    'pickupAt': pickupAt.toIso8601String(),
    'returnAt': returnAt.toIso8601String(),
    'name': name,
    'phone': phone,
    'notes': notes,
    'quote': quote.toJson(),
  };
}
