import 'package:flutter_test/flutter_test.dart';

import 'package:davidan_prototype/core/utils/distance.dart';
import 'package:davidan_prototype/core/utils/phone.dart';
import 'package:davidan_prototype/data/mock/bakery/bakery_shops.dart';
import 'package:davidan_prototype/data/mock/mock_sectors.dart';
import 'package:davidan_prototype/data/models/chisinau_sector.dart';
import 'package:davidan_prototype/data/models/customer_account.dart';
import 'package:davidan_prototype/data/models/geo_point.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/data/models/pinned_location.dart';
import 'package:davidan_prototype/data/models/store_location.dart';
import 'package:davidan_prototype/features/account/application/nearby.dart';

void main() {
  StoreLocation shop(String id) =>
      bakeryShops.firstWhere((location) => location.id == id);

  test('distances are straight-line metres', () {
    // About 4.4 km from the Centru shop to the Botanica shop.
    expect(
      shop('centru').position.distanceTo(shop('botanica').position),
      closeTo(4443, 30),
    );
    // 0.003° of latitude is about 334 m anywhere.
    expect(
      const GeoPoint(
        47.0330,
        28.7800,
      ).distanceTo(const GeoPoint(47.0360, 28.78)),
      closeTo(334, 2),
    );
  });

  test('each sector is matched to the shop nearest its centre', () {
    expect(
      {
        for (final sector in ChisinauSector.values)
          sector: nearestLocationToSector(sector, bakeryShops).id,
      },
      {
        ChisinauSector.botanica: 'botanica',
        ChisinauSector.buiucani: 'buiucani',
        ChisinauSector.centru: 'centru',
        ChisinauSector.ciocana: 'centru',
        ChisinauSector.riscani: 'centru',
      },
    );
  });

  test('the nearest shop to a point, with its distance', () {
    final nearest = nearestLocation(
      const GeoPoint(47.0360, 28.7800),
      bakeryShops,
    );
    expect(nearest.location.id, 'buiucani');
    expect(formatDistance(nearest.meters), '330 m');
  });

  test(
    'a point is named after the nearest sector, or none outside the city',
    () {
      for (final MapEntry(key: sector, value: centre)
          in sectorCentres.entries) {
        expect(sectorAt(centre), sector);
      }
      expect(
        sectorAt(const GeoPoint(46.9915, 28.8575)),
        ChisinauSector.botanica,
      );
      // Orhei, about 45 km north.
      expect(sectorAt(const GeoPoint(47.385, 28.824)), isNull);
    },
  );

  test('distances read the Romanian way', () {
    expect(formatDistance(4), '0 m');
    expect(formatDistance(334), '330 m');
    expect(formatDistance(994), '990 m');
    expect(formatDistance(996), '1,0 km');
    expect(formatDistance(4871), '4,9 km');
    expect(
      formatCoordinates(const GeoPoint(46.985, 28.858)),
      '46.98500, 28.85800',
    );
  });

  test(
    'Moldovan mobile numbers: 8 digits after +373, starting with 6 or 7',
    () {
      expect(MoldovanPhone.isValid('69123456'), isTrue);
      expect(MoldovanPhone.isValid('78123456'), isTrue);
      expect(MoldovanPhone.isValid('22123456'), isFalse);
      expect(MoldovanPhone.isValid('6912345'), isFalse);
      expect(MoldovanPhone.format('69123456'), '+373 69 123 456');
      expect(MoldovanPhone.masked('69123456'), '+373 69 *** 456');
    },
  );

  test('saved shapes survive JSON: deliveries with and without a point, '
      'accounts and pinned locations', () {
    const typed = HomeDelivery(address: 'str. Ismail 88');
    final typedBack = Fulfilment.fromJson(typed.toJson()) as HomeDelivery;
    expect(typedBack.address, 'str. Ismail 88');
    expect(typedBack.point, isNull);
    expect(typed.toJson().containsKey('point'), isFalse);

    const pinned = HomeDelivery(address: '', point: GeoPoint(46.985, 28.858));
    final pinnedBack = Fulfilment.fromJson(pinned.toJson()) as HomeDelivery;
    expect(pinnedBack.point, const GeoPoint(46.985, 28.858));

    const account = CustomerAccount(
      phone: '69123456',
      name: 'Ion',
      sector: ChisinauSector.buiucani,
      nearestLocationId: 'buiucani',
      matchedBy: ShopMatch.location,
      distanceMeters: 334,
    );
    final accountBack = CustomerAccount.fromJson(account.toJson());
    expect(accountBack.sector, ChisinauSector.buiucani);
    expect(accountBack.matchedBy, ShopMatch.location);
    expect(accountBack.distanceMeters, 334);

    const location = PinnedLocation(
      point: GeoPoint(47.04, 28.893),
      source: PinSource.map,
    );
    final locationBack = PinnedLocation.fromJson(location.toJson());
    expect(locationBack.point, const GeoPoint(47.04, 28.893));
    expect(locationBack.source, PinSource.map);
  });
}
