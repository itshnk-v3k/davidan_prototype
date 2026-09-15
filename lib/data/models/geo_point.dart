import 'dart:math' as math;

import 'package:flutter/foundation.dart';

/// A position on Earth, in degrees.
@immutable
class GeoPoint {
  const GeoPoint(this.latitude, this.longitude);

  factory GeoPoint.fromJson(Map<String, Object?> json) => GeoPoint(
    (json['lat']! as num).toDouble(),
    (json['lng']! as num).toDouble(),
  );

  final double latitude;
  final double longitude;

  static const _earthRadiusMeters = 6371000.0;

  /// Straight-line ("as the crow flies") distance in metres, by the haversine
  /// formula.
  double distanceTo(GeoPoint other) {
    double radians(double degrees) => degrees * math.pi / 180;
    final dLat = radians(other.latitude - latitude);
    final dLng = radians(other.longitude - longitude);
    final a =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(radians(latitude)) *
            math.cos(radians(other.latitude)) *
            math.pow(math.sin(dLng / 2), 2);
    return 2 * _earthRadiusMeters * math.asin(math.sqrt(a));
  }

  Map<String, Object?> toJson() => {'lat': latitude, 'lng': longitude};

  @override
  bool operator ==(Object other) =>
      other is GeoPoint &&
      other.latitude == latitude &&
      other.longitude == longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  String toString() => 'GeoPoint($latitude, $longitude)';
}
