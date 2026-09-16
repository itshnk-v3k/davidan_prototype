import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/data/mock/bakery/bakery_shops.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/store_location.dart';

// The only place the app reads mock shop data.

/// The bakery's shops, where an order can be picked up. Sign-up also suggests
/// the nearest one.
final locationsProvider = Provider<List<StoreLocation>>((ref) => bakeryShops);

/// Where [brand]'s orders can be picked up. Empty for a brand whose orders are
/// only delivered: no sushi or water source names a place to pick one up, and
/// the bakery's shops don't sell sushi.
final pickupShopsProvider = Provider.family<List<StoreLocation>, Brand>(
  (ref, brand) => switch (brand) {
    Brand.bakery => ref.watch(locationsProvider),
    Brand.restaurant ||
    Brand.sushi ||
    Brand.water ||
    Brand.carRental => const [],
  },
);

/// Null when no shop has this id.
final locationByIdProvider = Provider.family<StoreLocation?, String>(
  (ref, locationId) => ref
      .watch(locationsProvider)
      .where((location) => location.id == locationId)
      .firstOrNull,
);
