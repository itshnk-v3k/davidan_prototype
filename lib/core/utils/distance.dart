import 'package:davidan_prototype/data/models/geo_point.dart';

/// "650 m" under a kilometre, otherwise "1,4 km" with a decimal comma, the
/// Romanian way.
String formatDistance(double meters) {
  final roundedMeters = (meters / 10).round() * 10;
  if (roundedMeters < 1000) return '$roundedMeters m';
  return '${(meters / 1000).toStringAsFixed(1).replaceAll('.', ',')} km';
}

/// "46.98500, 28.85800": five decimals, about a metre, for a courier to paste
/// into a maps app.
String formatCoordinates(GeoPoint point) =>
    '${point.latitude.toStringAsFixed(5)}, '
    '${point.longitude.toStringAsFixed(5)}';
