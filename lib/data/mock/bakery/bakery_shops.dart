import 'package:davidan_prototype/data/models/geo_point.dart';
import 'package:davidan_prototype/data/models/store_location.dart';

/// PLACEHOLDER pickup points: plausible Chișinău streets, fictional details.
/// The coordinates are APPROXIMATE, near each street. DaviDan has 74 real
/// locations; swap these in if the client shares them.
const bakeryShops = <StoreLocation>[
  StoreLocation(
    id: 'centru',
    name: 'DaviDan Centru',
    address: 'bd. Ștefan cel Mare și Sfânt 126, Chișinău',
    openingHours: '07:00–22:00',
    position: GeoPoint(47.0243, 28.8330),
  ),
  StoreLocation(
    id: 'botanica',
    name: 'DaviDan Botanica',
    address: 'bd. Dacia 47, Chișinău',
    openingHours: '07:00–21:00',
    position: GeoPoint(46.9880, 28.8575),
  ),
  StoreLocation(
    id: 'buiucani',
    name: 'DaviDan Buiucani',
    address: 'str. Alba Iulia 75, Chișinău',
    openingHours: '07:30–21:00',
    position: GeoPoint(47.0330, 28.7800),
  ),
];
