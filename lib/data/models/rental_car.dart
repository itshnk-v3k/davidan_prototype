import 'package:flutter/foundation.dart';

/// A band of rental lengths with its own price per day. davidanrentcar.md's
/// "Tabel de Prețuri pe Zile" shows only each band's first day; its cart
/// charges 1–3 days at the first price, 4–10 at the second, 11–20 at the
/// third and 21 or more at the last, the "Preț normal/zi" its listings show.
enum RentalTier {
  days1to3(1, 3),
  days4to10(4, 10),
  days11to20(11, 20),
  days21plus(21, null);

  const RentalTier(this.fromDays, this.toDays);

  final int fromDays;

  /// Null for the last band, which has no end.
  final int? toDays;

  /// The band a rental of [days] falls in. [days] is at least 1.
  static RentalTier of(int days) =>
      values.lastWhere((tier) => days >= tier.fromDays);
}

/// One line of a car's spec list on davidanrentcar.md, in the site's order.
/// Its label is UI text; its value is the car's.
enum RentalSpec {
  year,
  fuel,
  gearbox,
  consumption,
  passengers,
  engine,
  doors,
  mileage,
}

/// A car of DaviDan Rent Car's fleet, as its page on davidanrentcar.md
/// describes it (docs/sources/davidanrentcar_md.md, section 1).
@immutable
class RentalCar {
  const RentalCar({
    required this.id,
    required this.name,
    required this.tagline,
    required this.image,
    required this.year,
    required this.fuel,
    required this.gearbox,
    required this.consumption,
    required this.passengers,
    required this.engine,
    required this.doors,
    required this.mileage,
    required this.features,
    required this.dayRatesEur,
    required this.insuranceEur,
  });

  /// The car's slug on the site.
  final String id;

  /// The page's title, e.g. "Dacia Logan".
  final String name;

  /// The first line of the page's description, e.g. "Dacia 1.0 Benzină +
  /// GPL 2022 – Economică și Fiabilă!".
  final String tagline;

  /// Bundled photo: the page's featured image.
  final String image;

  final int year;
  final String fuel;
  final String gearbox;

  /// As written, e.g. "10 l/100 km".
  final String consumption;
  final int passengers;

  /// As written, without a unit, e.g. "2.0".
  final String engine;
  final int doors;

  /// As written, e.g. "Nelimitat".
  final String mileage;

  /// The page's ticked "other features".
  final List<String> features;

  /// Price per day in each band, in euros.
  final Map<RentalTier, int> dayRatesEur;

  /// The "Suma de asigurare" the site's cart adds to every rental of this
  /// car, in euros.
  final int insuranceEur;

  /// Price per day for a rental of [days].
  int dayRateFor(int days) => dayRatesEur[RentalTier.of(days)]!;

  /// The lowest price per day, for 21 days or more: what the site's
  /// listings show as the car's price.
  int get lowestDayRateEur => dayRatesEur[RentalTier.days21plus]!;

  /// The spec list with its values, in the site's order.
  List<(RentalSpec, String)> get specs => [
    for (final spec in RentalSpec.values)
      (
        spec,
        switch (spec) {
          RentalSpec.year => '$year',
          RentalSpec.fuel => fuel,
          RentalSpec.gearbox => gearbox,
          RentalSpec.consumption => consumption,
          RentalSpec.passengers => '$passengers',
          RentalSpec.engine => engine,
          RentalSpec.doors => '$doors',
          RentalSpec.mileage => mileage,
        },
      ),
  ];
}
