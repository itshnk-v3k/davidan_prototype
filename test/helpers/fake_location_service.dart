import 'package:davidan_prototype/core/location/location_result.dart';
import 'package:davidan_prototype/core/location/location_service.dart';
import 'package:davidan_prototype/data/models/geo_point.dart';

/// Stands in for the phone's GPS: answers every lookup with [result] and
/// counts them. Chrome widget tests can't grant real geolocation, and must
/// never wait on it.
class FakeLocationService implements LocationService {
  FakeLocationService(this.result);

  FakeLocationService.at(GeoPoint point) : this(LocationFound(point));

  FakeLocationService.failing(LocationFailure failure)
    : this(LocationNotFound(failure));

  LocationResult result;
  int lookups = 0;

  @override
  Future<LocationResult> currentLocation() async {
    lookups++;
    return result;
  }
}
