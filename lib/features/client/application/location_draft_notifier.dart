import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/client/application/fulfilment_choice_notifier.dart';

/// What the customer has filled in on the location screen so far.
@immutable
class LocationDraft {
  const LocationDraft({
    required this.type,
    required this.address,
    required this.showErrors,
  });

  /// The mode on screen. Switching it saves nothing.
  final FulfilmentType type;

  /// Typed delivery address, starting from the saved one.
  final String address;

  /// Set by confirming a blank address, so the error only appears after the
  /// customer tried.
  final bool showErrors;

  bool get addressMissing => address.trim().isEmpty;

  LocationDraft copyWith({
    FulfilmentType? type,
    String? address,
    bool? showErrors,
  }) => LocationDraft(
    type: type ?? this.type,
    address: address ?? this.address,
    showErrors: showErrors ?? this.showErrors,
  );
}

/// Auto-disposed when the location screen closes, so it always opens on the
/// saved choice.
final locationDraftProvider =
    NotifierProvider.autoDispose<LocationDraftNotifier, LocationDraft>(
      LocationDraftNotifier.new,
    );

class LocationDraftNotifier extends Notifier<LocationDraft> {
  @override
  LocationDraft build() {
    final choice = ref.watch(fulfilmentChoiceProvider);
    return LocationDraft(
      type: choice is StorePickup
          ? FulfilmentType.pickup
          : FulfilmentType.delivery,
      address: choice is HomeDelivery ? choice.address : '',
      showErrors: false,
    );
  }

  void setType(FulfilmentType type) => state = state.copyWith(type: type);

  void setAddress(String address) => state = state.copyWith(address: address);

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
}
