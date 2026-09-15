import 'dart:async';

import 'package:geolocator/geolocator.dart';

import 'package:davidan_prototype/core/location/location_result.dart';
import 'package:davidan_prototype/core/location/location_service.dart';
import 'package:davidan_prototype/data/models/geo_point.dart';

/// The real device location through the geolocator package: Android's
/// permission prompt and a GPS or network fix, or the browser's geolocation on
/// web (HTTPS or localhost only). The only file that imports geolocator.
///
/// Chrome widget tests can't grant geolocation, so they use a fake instead;
/// check this one on a phone or an emulator with a simulated location.
class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService({
    this.timeLimit = const Duration(seconds: 15),
  });

  /// How long to wait for a fresh fix.
  final Duration timeLimit;

  @override
  Future<LocationResult> currentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const LocationNotFound(LocationFailure.serviceOff);
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        return const LocationNotFound(LocationFailure.denied);
      }
      if (permission == LocationPermission.deniedForever) {
        return const LocationNotFound(LocationFailure.deniedForever);
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: timeLimit,
        ),
      );
      return LocationFound(GeoPoint(position.latitude, position.longitude));
    } on TimeoutException {
      // Indoors a fresh fix can take long. A recent position is close enough
      // to find the nearest shop or a delivery area.
      return await _lastKnown() ??
          const LocationNotFound(LocationFailure.timeout);
    } on LocationServiceDisabledException {
      return const LocationNotFound(LocationFailure.serviceOff);
    } on PermissionDeniedException {
      return const LocationNotFound(LocationFailure.denied);
    } catch (_) {
      return const LocationNotFound(LocationFailure.unavailable);
    }
  }

  static Future<LocationFound?> _lastKnown() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      return position == null
          ? null
          : LocationFound(GeoPoint(position.latitude, position.longitude));
    } catch (_) {
      // Not supported on web.
      return null;
    }
  }
}
