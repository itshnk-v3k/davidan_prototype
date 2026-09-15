import 'package:davidan_prototype/data/models/geo_point.dart';

/// Why the phone's location isn't available.
enum LocationFailure {
  /// The customer declined the permission prompt.
  denied,

  /// Declined for good, or blocked in settings: Android won't ask again.
  deniedForever,

  /// Location is switched off on the device.
  serviceOff,

  /// No fix in time, e.g. indoors without mobile data.
  timeout,

  /// No location on this device or browser, e.g. a web page not on HTTPS.
  unavailable,
}

/// The outcome of asking for the phone's location.
sealed class LocationResult {
  const LocationResult();
}

final class LocationFound extends LocationResult {
  const LocationFound(this.point);

  final GeoPoint point;
}

final class LocationNotFound extends LocationResult {
  const LocationNotFound(this.failure);

  final LocationFailure failure;
}
