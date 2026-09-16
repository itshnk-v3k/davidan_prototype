import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/account/application/account_notifier.dart';
import 'package:davidan_prototype/features/account/application/fulfilment_choice_notifier.dart';

/// What the customer has filled in on the location screen so far.
@immutable
class LocationDraft {
  const LocationDraft({
    required this.type,
    required this.address,
    required this.showErrors,
    this.pickupSelection,
  });

  /// The mode on screen. Switching it saves nothing.
  final FulfilmentType type;

  /// Typed delivery address, starting from the saved one.
  final String address;

  /// Set by confirming a blank address, so the error only appears after the
  /// customer tried.
  final bool showErrors;

  /// Right after sign-up: the shop selected on screen, starting with the
  /// nearest one, until the customer confirms it. Null otherwise.
  final String? pickupSelection;

  bool get addressMissing => address.trim().isEmpty;

  LocationDraft copyWith({
    FulfilmentType? type,
    String? address,
    bool? showErrors,
    String? pickupSelection,
  }) => LocationDraft(
    type: type ?? this.type,
    address: address ?? this.address,
    showErrors: showErrors ?? this.showErrors,
    pickupSelection: pickupSelection ?? this.pickupSelection,
  );
}

/// Auto-disposed when the location screen closes, so it always opens on the
/// saved choice. The argument is `suggestNearest`: right after sign-up the
/// screen opens on pickup with the account's nearest shop selected, and
/// nothing is saved until the customer confirms.
final locationDraftProvider = NotifierProvider.autoDispose
    .family<LocationDraftNotifier, LocationDraft, bool>(
      LocationDraftNotifier.new,
    );

class LocationDraftNotifier extends Notifier<LocationDraft> {
  LocationDraftNotifier(this._suggestNearest);

  final bool _suggestNearest;

  @override
  LocationDraft build() {
    final choice = ref.watch(fulfilmentChoiceProvider);
    final nearest = _suggestNearest
        ? ref.watch(accountProvider)?.nearestLocationId
        : null;
    return LocationDraft(
      type: nearest != null || choice is StorePickup
          ? FulfilmentType.pickup
          : FulfilmentType.delivery,
      address: choice is HomeDelivery ? choice.address : '',
      showErrors: false,
      pickupSelection: nearest,
    );
  }

  void setType(FulfilmentType type) => state = state.copyWith(type: type);

  void setAddress(String address) => state = state.copyWith(address: address);

  void selectPickup(String locationId) =>
      state = state.copyWith(pickupSelection: locationId);

  /// Saves the typed address as the customer's choice. Returns false, and
  /// shows the error, when it is blank.
  bool confirmAddress() {
    if (state.addressMissing) {
      state = state.copyWith(showErrors: true);
      return false;
    }
    ref.read(fulfilmentChoiceProvider.notifier).chooseDelivery(state.address);
    return true;
  }

  /// Saves the selected shop. Returns false when none is selected.
  bool confirmPickup() {
    final locationId = state.pickupSelection;
    if (locationId == null) return false;
    ref.read(fulfilmentChoiceProvider.notifier).choosePickup(locationId);
    return true;
  }
}
