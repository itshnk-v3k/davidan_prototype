import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/data/mock/bakery/bakery_shops.dart';
import 'package:davidan_prototype/data/models/store_location.dart';

// The only place the app reads mock shop data.

/// The bakery's shops, where an order can be picked up. Sign-up also suggests
/// the nearest one.
final locationsProvider = Provider<List<StoreLocation>>((ref) => bakeryShops);

/// Null when no shop has this id.
final locationByIdProvider = Provider.family<StoreLocation?, String>(
  (ref, locationId) => ref
      .watch(locationsProvider)
      .where((location) => location.id == locationId)
      .firstOrNull,
);
