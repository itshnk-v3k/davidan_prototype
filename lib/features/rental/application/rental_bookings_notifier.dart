import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/data/models/rental_booking.dart';
import 'package:davidan_prototype/data/models/rental_car.dart';
import 'package:davidan_prototype/features/rental/application/rental_providers.dart';

final rentalBookingsProvider =
    NotifierProvider<RentalBookingsNotifier, List<RentalBooking>>(
      RentalBookingsNotifier.new,
    );

/// Null when no request has this id (e.g. a hand-edited link).
final rentalBookingByIdProvider = Provider.family<RentalBooking?, String>(
  (ref, bookingId) => ref
      .watch(rentalBookingsProvider)
      .where((booking) => booking.id == bookingId)
      .firstOrNull,
);

/// Every car rental request sent from the app, newest first, saved to local
/// storage on every change.
class RentalBookingsNotifier extends Notifier<List<RentalBooking>> {
  static const _firstNumber = 1001;

  @override
  List<RentalBooking> build() =>
      ref.watch(localStoreProvider).read(StorageKeys.rentalBookings, _decode) ??
      const [];

  /// Sends a request to rent [car] and returns it, priced at today's prices.
  RentalBooking request({
    required RentalCar car,
    required RentalLocation pickupLocation,
    required RentalLocation returnLocation,
    required DateTime pickupAt,
    required DateTime returnAt,
    required Set<RentalExtra> extras,
    required String name,
    required String phone,
    required String notes,
  }) {
    final booking = RentalBooking(
      // Requests are never deleted (only a demo reset clears them all), so
      // the count gives the next free number.
      id: 'RC-${_firstNumber + state.length}',
      carId: car.id,
      createdAt: ref.read(clockProvider)(),
      pickupLocation: pickupLocation,
      returnLocation: returnLocation,
      pickupAt: pickupAt,
      returnAt: returnAt,
      name: name,
      phone: phone,
      notes: notes,
      quote: quoteRental(
        car,
        days: rentalDays(pickupAt, returnAt),
        extras: extras,
      ),
    );
    state = [booking, ...state];
    ref.read(localStoreProvider).write(StorageKeys.rentalBookings, [
      for (final booking in state) booking.toJson(),
    ]);
    return booking;
  }

  static List<RentalBooking> _decode(Object? json) => [
    for (final entry in json! as List<Object?>)
      RentalBooking.fromJson(entry! as Map<String, Object?>),
  ];
}
