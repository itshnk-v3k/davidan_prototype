import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/data/mock/rental/rental_cars.dart';
import 'package:davidan_prototype/data/models/rental_booking.dart';
import 'package:davidan_prototype/data/models/rental_car.dart';
import 'package:davidan_prototype/l10n/app_language.dart';

// The only place the app reads the mock fleet, as catalog_providers is for
// menus, and how a rental is priced.

/// The fleet in the app's language.
final rentalCarsProvider = Provider<List<RentalCar>>((ref) {
  final content = ref.watch(contentProvider);
  return [for (final car in rentalCars) content.car(car)];
});

/// Null when no car has this id (e.g. a hand-edited link).
final rentalCarByIdProvider = Provider.family<RentalCar?, String>(
  (ref, carId) =>
      ref.watch(rentalCarsProvider).where((car) => car.id == carId).firstOrNull,
);

/// Days charged for a rental from [pickupAt] to [returnAt], counted the way
/// davidanrentcar.md's cart counts them: every started day, so 1 day and 4
/// hours are 2 days. Counted on the calendar, so a rental over the change to
/// or from summer time doesn't gain a day. At least 1.
int rentalDays(DateTime pickupAt, DateTime returnAt) {
  final calendarDays = DateTime.utc(returnAt.year, returnAt.month, returnAt.day)
      .difference(DateTime.utc(pickupAt.year, pickupAt.month, pickupAt.day))
      .inDays;
  final laterInTheDay =
      returnAt.hour * 60 + returnAt.minute >
      pickupAt.hour * 60 + pickupAt.minute;
  return math.max(1, calendarDays + (laterInTheDay ? 1 : 0));
}

/// What renting [car] for [days] with [extras] costs, added up like
/// davidanrentcar.md's cart: the price per day for that many days, the
/// extras, the location fee and the car's insurance amount.
RentalQuote quoteRental(
  RentalCar car, {
  required int days,
  required Set<RentalExtra> extras,
}) => RentalQuote(
  days: days,
  dayRateEur: car.dayRateFor(days),
  extrasEur: {
    for (final extra in RentalExtra.values)
      if (extras.contains(extra))
        extra: switch (extra) {
          RentalExtra.childSeat => RentalTerms.childSeatEur,
          RentalExtra.unlimitedKm => RentalTerms.unlimitedKmPerDayEur * days,
        },
  },
  locationFeeEur: RentalTerms.locationFeeEur,
  insuranceEur: car.insuranceEur,
);
