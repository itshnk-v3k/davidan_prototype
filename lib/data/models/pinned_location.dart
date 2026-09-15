import 'package:flutter/foundation.dart';

import 'package:davidan_prototype/data/models/geo_point.dart';

/// Where a pinned point came from.
enum PinSource {
  /// The phone's location.
  gps,

  /// Chosen by hand on the map picker, when the location wasn't available.
  map,
}

/// A delivery point from "Folosește locația mea curentă". It replaces the
/// saved address for the next order only.
@immutable
class PinnedLocation {
  const PinnedLocation({required this.point, required this.source});

  factory PinnedLocation.fromJson(Map<String, Object?> json) => PinnedLocation(
    point: GeoPoint.fromJson(json['point']! as Map<String, Object?>),
    source: PinSource.values.byName(json['source']! as String),
  );

  final GeoPoint point;
  final PinSource source;

  Map<String, Object?> toJson() => {
    'point': point.toJson(),
    'source': source.name,
  };
}
