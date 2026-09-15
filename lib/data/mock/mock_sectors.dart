import 'package:davidan_prototype/data/models/chisinau_sector.dart';
import 'package:davidan_prototype/data/models/geo_point.dart';

/// APPROXIMATE centre of each sector, good to a few hundred metres: enough to
/// match a sector to its nearest shop and to name the area around a point.
const sectorCentres = <ChisinauSector, GeoPoint>{
  ChisinauSector.botanica: GeoPoint(46.985, 28.858),
  ChisinauSector.buiucani: GeoPoint(47.031, 28.790),
  ChisinauSector.centru: GeoPoint(47.024, 28.832),
  ChisinauSector.ciocana: GeoPoint(47.040, 28.893),
  ChisinauSector.riscani: GeoPoint(47.052, 28.856),
};

/// Farther than this from every sector centre counts as outside Chișinău.
const chisinauRadiusMeters = 7000.0;

/// The sector whose centre is nearest [point], or null outside Chișinău.
ChisinauSector? sectorAt(GeoPoint point) {
  ChisinauSector? nearest;
  var nearestMeters = chisinauRadiusMeters;
  for (final MapEntry(key: sector, value: centre) in sectorCentres.entries) {
    final meters = point.distanceTo(centre);
    if (meters <= nearestMeters) {
      nearest = sector;
      nearestMeters = meters;
    }
  }
  return nearest;
}
