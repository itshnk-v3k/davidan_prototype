import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/location/geolocator_location_service.dart';
import 'package:davidan_prototype/core/location/location_result.dart';

/// The device's current position. Screens never talk to GPS directly, so tests
/// can swap in a fake and a failed fix never breaks the demo.
abstract interface class LocationService {
  /// Asks for the permission when needed. Never throws: every problem comes
  /// back as a [LocationNotFound].
  Future<LocationResult> currentLocation();
}

final locationServiceProvider = Provider<LocationService>(
  (ref) => const GeolocatorLocationService(),
);
