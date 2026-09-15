import 'package:davidan_prototype/data/mock/mock_sectors.dart';
import 'package:davidan_prototype/data/models/chisinau_sector.dart';
import 'package:davidan_prototype/data/models/geo_point.dart';
import 'package:davidan_prototype/data/models/store_location.dart';

// One distance rule for every "nearest shop": from the phone's location, or
// from the centre of the sector the customer picked. Adding DaviDan's real
// shops only needs their coordinates.

/// The shop nearest [point] and how far it is, in metres. [locations] must
/// not be empty.
({StoreLocation location, double meters}) nearestLocation(
  GeoPoint point,
  List<StoreLocation> locations,
) {
  assert(locations.isNotEmpty, 'No shops to choose from');
  var nearest = locations.first;
  var nearestMeters = point.distanceTo(nearest.position);
  for (final location in locations.skip(1)) {
    final meters = point.distanceTo(location.position);
    if (meters < nearestMeters) {
      nearest = location;
      nearestMeters = meters;
    }
  }
  return (location: nearest, meters: nearestMeters);
}

/// The shop nearest the centre of [sector].
StoreLocation nearestLocationToSector(
  ChisinauSector sector,
  List<StoreLocation> locations,
) => nearestLocation(sectorCentres[sector]!, locations).location;
