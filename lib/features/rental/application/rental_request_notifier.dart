import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/utils/phone.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/data/models/rental_booking.dart';
import 'package:davidan_prototype/features/account/application/account_notifier.dart';
import 'package:davidan_prototype/features/rental/application/rental_bookings_notifier.dart';
import 'package:davidan_prototype/features/rental/application/rental_providers.dart';

/// What the customer has filled in on a car's request form so far.
@immutable
class RentalRequestDraft {
  const RentalRequestDraft({
    required this.pickupLocation,
    required this.returnLocation,
    required this.pickupAt,
    required this.returnAt,
    required this.extras,
    required this.name,
    required this.phone,
    required this.notes,
    required this.openedAt,
    required this.showErrors,
  });

  final RentalLocation pickupLocation;
  final RentalLocation returnLocation;
  final DateTime pickupAt;
  final DateTime returnAt;
  final Set<RentalExtra> extras;
  final String name;

  /// Digits typed after +373.
  final String phone;
  final String notes;

  /// When the form opened: no pickup can be earlier.
  final DateTime openedAt;

  /// Set by a failed attempt to send, so the contact errors only appear after
  /// the customer tried. Errors in the dates show at once, since the price
  /// depends on them.
  final bool showErrors;

  bool get pickupPassed => pickupAt.isBefore(openedAt);
  bool get returnNotAfterPickup => !returnAt.isAfter(pickupAt);
  bool get datesValid => !pickupPassed && !returnNotAfterPickup;
  int get days => rentalDays(pickupAt, returnAt);
  bool get nameMissing => name.trim().isEmpty;
  bool get phoneValid => MoldovanPhone.isValid(phone);

  RentalRequestDraft copyWith({
    RentalLocation? pickupLocation,
    RentalLocation? returnLocation,
    DateTime? pickupAt,
    DateTime? returnAt,
    Set<RentalExtra>? extras,
    String? name,
    String? phone,
    String? notes,
    bool? showErrors,
  }) => RentalRequestDraft(
    pickupLocation: pickupLocation ?? this.pickupLocation,
    returnLocation: returnLocation ?? this.returnLocation,
    pickupAt: pickupAt ?? this.pickupAt,
    returnAt: returnAt ?? this.returnAt,
    extras: extras ?? this.extras,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    notes: notes ?? this.notes,
    openedAt: openedAt,
    showErrors: showErrors ?? this.showErrors,
  );
}

/// One car's request form, by car id. Auto-disposed when the form closes, so
/// every request starts fresh.
final rentalRequestProvider = NotifierProvider.autoDispose
    .family<RentalRequestNotifier, RentalRequestDraft, String>(
      RentalRequestNotifier.new,
    );

class RentalRequestNotifier extends Notifier<RentalRequestDraft> {
  RentalRequestNotifier(this.carId);

  final String carId;

  /// The hour davidanrentcar.md's booking form starts its times at.
  static const defaultHour = 9;

  /// How many days the form's first dates span.
  static const defaultDays = 3;

  /// Starts with tomorrow at 09:00 until three days later, both in Chișinău,
  /// and the signed-in customer's name and phone.
  @override
  RentalRequestDraft build() {
    final now = ref.watch(clockProvider)();
    // Read, not watched: signing out elsewhere shouldn't wipe the form.
    final account = ref.read(accountProvider);
    return RentalRequestDraft(
      pickupLocation: RentalLocation.chisinau,
      returnLocation: RentalLocation.chisinau,
      pickupAt: DateTime(now.year, now.month, now.day + 1, defaultHour),
      returnAt: DateTime(
        now.year,
        now.month,
        now.day + 1 + defaultDays,
        defaultHour,
      ),
      extras: const {},
      name: account?.name ?? '',
      phone: account?.phone ?? '',
      notes: '',
      openedAt: now,
      showErrors: false,
    );
  }

  void setPickupLocation(RentalLocation location) =>
      state = state.copyWith(pickupLocation: location);

  void setReturnLocation(RentalLocation location) =>
      state = state.copyWith(returnLocation: location);

  /// Moves the pickup. A return that is no longer after it moves to the same
  /// time a day later.
  void setPickupAt(DateTime pickupAt) => state = state.copyWith(
    pickupAt: pickupAt,
    returnAt: state.returnAt.isAfter(pickupAt)
        ? null
        : DateTime(
            pickupAt.year,
            pickupAt.month,
            pickupAt.day + 1,
            pickupAt.hour,
            pickupAt.minute,
          ),
  );

  void setReturnAt(DateTime returnAt) =>
      state = state.copyWith(returnAt: returnAt);

  void toggleExtra(RentalExtra extra) => state = state.copyWith(
    extras: state.extras.contains(extra)
        ? {...state.extras}.difference({extra})
        : {...state.extras, extra},
  );

  void setName(String name) => state = state.copyWith(name: name);

  void setPhone(String phone) => state = state.copyWith(phone: phone);

  void setNotes(String notes) => state = state.copyWith(notes: notes);

  /// Sends the request. Returns null, and shows the form's errors, when the
  /// dates or the contact details aren't right.
  RentalBooking? send() {
    final car = ref.read(rentalCarByIdProvider(carId));
    if (car == null) return null;
    if (!state.datesValid || state.nameMissing || !state.phoneValid) {
      state = state.copyWith(showErrors: true);
      return null;
    }
    return ref
        .read(rentalBookingsProvider.notifier)
        .request(
          car: car,
          pickupLocation: state.pickupLocation,
          returnLocation: state.returnLocation,
          pickupAt: state.pickupAt,
          returnAt: state.returnAt,
          extras: state.extras,
          name: state.name.trim(),
          phone: state.phone,
          notes: state.notes.trim(),
        );
  }
}
