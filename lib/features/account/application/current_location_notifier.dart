import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/location/location_result.dart';
import 'package:davidan_prototype/core/location/location_service.dart';
import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/data/models/geo_point.dart';
import 'package:davidan_prototype/data/models/pinned_location.dart';

@immutable
class CurrentLocationState {
  const CurrentLocationState({this.pinned, this.locating = false});

  /// The delivery point for the next order, if the customer chose one.
  final PinnedLocation? pinned;

  /// A location lookup is running.
  final bool locating;
}

final currentLocationProvider =
    NotifierProvider<CurrentLocationNotifier, CurrentLocationState>(
      CurrentLocationNotifier.new,
    );

/// "Folosește locația mea curentă": a delivery point for the next order only.
/// The saved address or shop (FulfilmentChoiceNotifier) stays as it is.
/// Placing the order, or dismissing the point, clears it. Saved, so it
/// survives a restart mid-demo; cleared by demo reset.
class CurrentLocationNotifier extends Notifier<CurrentLocationState> {
  @override
  CurrentLocationState build() => CurrentLocationState(
    pinned: ref
        .watch(localStoreProvider)
        .read(
          StorageKeys.currentLocation,
          (json) => PinnedLocation.fromJson(json! as Map<String, Object?>),
        ),
  );

  /// Looks up the phone's location and pins it. Returns why that failed
  /// instead, so the screen can offer the map picker.
  Future<LocationFailure?> locate() async {
    state = CurrentLocationState(pinned: state.pinned, locating: true);
    final result = await ref.read(locationServiceProvider).currentLocation();
    switch (result) {
      case LocationFound(:final point):
        _pin(PinnedLocation(point: point, source: PinSource.gps));
        return null;
      case LocationNotFound(:final failure):
        state = CurrentLocationState(pinned: state.pinned);
        return failure;
    }
  }

  /// Pins a point chosen by hand on the map picker.
  void pinOnMap(GeoPoint point) =>
      _pin(PinnedLocation(point: point, source: PinSource.map));

  void clear() {
    state = const CurrentLocationState();
    ref.read(localStoreProvider).remove(StorageKeys.currentLocation);
  }

  void _pin(PinnedLocation pinned) {
    state = CurrentLocationState(pinned: pinned);
    ref
        .read(localStoreProvider)
        .write(StorageKeys.currentLocation, pinned.toJson());
  }
}
