import 'package:davidan_prototype/data/models/store_location.dart';

/// PLACEHOLDER pickup points: plausible Chișinău streets, fictional details.
/// DaviDan has 74 real locations; swap these in if the client shares them.
const mockLocations = <StoreLocation>[
  StoreLocation(
    id: 'centru',
    name: 'DaviDan Centru',
    address: 'bd. Ștefan cel Mare și Sfânt 126, Chișinău',
    openingHours: '07:00–22:00',
  ),
  StoreLocation(
    id: 'botanica',
    name: 'DaviDan Botanica',
    address: 'bd. Dacia 47, Chișinău',
    openingHours: '07:00–21:00',
  ),
  StoreLocation(
    id: 'buiucani',
    name: 'DaviDan Buiucani',
    address: 'str. Alba Iulia 75, Chișinău',
    openingHours: '07:30–21:00',
  ),
];
