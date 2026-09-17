import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/location/location_result.dart';
import 'package:davidan_prototype/core/location/location_service.dart';
import 'package:davidan_prototype/core/utils/phone.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/data/mock/mock_sectors.dart';
import 'package:davidan_prototype/data/models/chisinau_sector.dart';
import 'package:davidan_prototype/data/models/customer_account.dart';
import 'package:davidan_prototype/features/account/application/account_notifier.dart';
import 'package:davidan_prototype/features/account/application/nearby.dart';
import 'package:davidan_prototype/features/food/application/shop_providers.dart';

/// What the customer has filled in on the sign-in screens so far.
@immutable
class SignInDraft {
  const SignInDraft({
    this.phone = '',
    this.code = '',
    this.name = '',
    this.sector,
    this.locating = false,
    this.located,
    this.showPhoneError = false,
    this.showCodeError = false,
    this.showDetailsErrors = false,
    this.codeSentAt,
  });

  static const codeLength = 4;

  /// How long after a code is sent it can be sent again.
  static const resendDelay = Duration(seconds: 60);

  /// Digits typed after +373.
  final String phone;
  final String code;
  final String name;
  final ChisinauSector? sector;

  /// A location lookup is running.
  final bool locating;

  /// The last location lookup, if the customer asked for one.
  final LocationResult? located;

  // Set by a failed attempt to continue, so errors only appear after trying.
  final bool showPhoneError;
  final bool showCodeError;
  final bool showDetailsErrors;

  /// When the (pretend) code was last sent; null if the code screen was
  /// opened without sending one, e.g. after a page refresh.
  final DateTime? codeSentAt;

  /// Time left until the code can be sent again at [now]; zero when it can.
  Duration resendWaitAt(DateTime now) {
    final sentAt = codeSentAt;
    if (sentAt == null) return Duration.zero;
    final left = resendDelay - now.difference(sentAt);
    return left.isNegative ? Duration.zero : left;
  }

  bool get phoneValid => MoldovanPhone.isValid(phone);
  bool get codeComplete => code.length == codeLength;
  bool get nameMissing => name.trim().isEmpty;

  SignInDraft copyWith({
    String? phone,
    String? code,
    String? name,
    ChisinauSector? sector,
    bool? locating,
    LocationResult? located,
    bool? showPhoneError,
    bool? showCodeError,
    bool? showDetailsErrors,
    DateTime? codeSentAt,
  }) => SignInDraft(
    phone: phone ?? this.phone,
    code: code ?? this.code,
    name: name ?? this.name,
    sector: sector ?? this.sector,
    locating: locating ?? this.locating,
    located: located ?? this.located,
    showPhoneError: showPhoneError ?? this.showPhoneError,
    showCodeError: showCodeError ?? this.showCodeError,
    showDetailsErrors: showDetailsErrors ?? this.showDetailsErrors,
    codeSentAt: codeSentAt ?? this.codeSentAt,
  );
}

/// Lives while the sign-in screens are open. Each step is pushed on top of the
/// previous one, so going back keeps what was typed.
final signInDraftProvider =
    NotifierProvider.autoDispose<SignInDraftNotifier, SignInDraft>(
      SignInDraftNotifier.new,
    );

/// The mock sign-in: phone number, code, then name and sector.
///
/// DEMO ONLY, NO REAL VERIFICATION: no SMS is sent, and any 4-digit code is
/// accepted without being checked against anything. The prototype has no
/// backend; this only shows what the flow would look like.
class SignInDraftNotifier extends Notifier<SignInDraft> {
  @override
  SignInDraft build() => const SignInDraft();

  void setPhone(String value) =>
      state = state.copyWith(phone: MoldovanPhone.digitsOf(value));

  /// Whether the number looks like a Moldovan mobile, and if so "sends" the
  /// code. Shows the error if not.
  bool submitPhone() {
    if (!state.phoneValid) {
      state = state.copyWith(showPhoneError: true);
      return false;
    }
    state = state.copyWith(codeSentAt: ref.read(clockProvider)());
    return true;
  }

  /// "Sends" the code again, which starts the wait over. Nothing is sent (see
  /// the class comment).
  void resendCode() =>
      state = state.copyWith(codeSentAt: ref.read(clockProvider)());

  void setCode(String value) => state = state.copyWith(
    code: _digits(value, SignInDraft.codeLength),
    showCodeError: false,
  );

  /// Accepts any complete code: nothing is verified (see the class comment).
  bool submitCode() {
    if (state.codeComplete) return true;
    state = state.copyWith(showCodeError: true);
    return false;
  }

  void setName(String name) => state = state.copyWith(name: name);

  void setSector(ChisinauSector sector) =>
      state = state.copyWith(sector: sector);

  /// Looks up the phone's location, to match the nearest shop by distance.
  /// Found inside Chișinău, its sector is picked too; the customer can still
  /// change it.
  Future<void> locate() async {
    state = state.copyWith(locating: true);
    final result = await ref.read(locationServiceProvider).currentLocation();
    if (!ref.mounted) return;
    state = state.copyWith(
      locating: false,
      located: result,
      sector: switch (result) {
        LocationFound(:final point) => sectorAt(point),
        LocationNotFound() => null,
      },
    );
  }

  /// Creates the account. The nearest shop comes from the phone's location
  /// when it was found, otherwise from the sector. Returns null, and shows the
  /// errors, when the name or sector is missing.
  CustomerAccount? finish() {
    final sector = state.sector;
    if (state.nameMissing || sector == null) {
      state = state.copyWith(showDetailsErrors: true);
      return null;
    }

    final locations = ref.read(locationsProvider);
    final CustomerAccount account;
    if (state.located case LocationFound(:final point)) {
      final nearest = nearestLocation(point, locations);
      account = CustomerAccount(
        phone: state.phone,
        name: state.name.trim(),
        sector: sector,
        nearestLocationId: nearest.location.id,
        matchedBy: ShopMatch.location,
        distanceMeters: nearest.meters.round(),
      );
    } else {
      account = CustomerAccount(
        phone: state.phone,
        name: state.name.trim(),
        sector: sector,
        nearestLocationId: nearestLocationToSector(sector, locations).id,
        matchedBy: ShopMatch.sector,
      );
    }
    ref.read(accountProvider.notifier).register(account);
    return account;
  }

  static String _digits(String value, int maxLength) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    return digits.length > maxLength ? digits.substring(0, maxLength) : digits;
  }
}
