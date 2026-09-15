import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/client/application/catalog_providers.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';

enum FulfilmentType { delivery, pickup }

final fulfilmentChoiceProvider =
    NotifierProvider<FulfilmentChoiceNotifier, Fulfilment?>(
      FulfilmentChoiceNotifier.new,
    );

const _recentAddressCount = 3;

/// Delivery addresses of past orders, newest first and without repeats, so
/// the location screen can offer them the way delivery apps offer saved
/// addresses.
final recentAddressesProvider = Provider<List<String>>((ref) {
  final addresses = {
    for (final order in ref.watch(ordersProvider))
      if (order.fulfilment case HomeDelivery(:final address)) address,
  };
  return addresses.take(_recentAddressCount).toList();
});

/// How the customer wants to get their orders: delivered to an address or
/// picked up from a shop. Chosen on the location screen, shown in the home
/// screen's location bar, and the starting choice at checkout. Null until the
/// first choice, which is how the splash screen recognises a first run. Saved
/// to local storage on every change.
class FulfilmentChoiceNotifier extends Notifier<Fulfilment?> {
  @override
  Fulfilment? build() {
    final saved = ref
        .watch(localStoreProvider)
        .read(StorageKeys.fulfilment, _decode);
    // A saved shop that has since left the mock data counts as no choice.
    if (saved case StorePickup(:final locationId)
        when ref.watch(locationByIdProvider(locationId)) == null) {
      return null;
    }
    return saved;
  }

  void chooseDelivery(String address) {
    assert(address.trim().isNotEmpty, 'A delivery address cannot be blank');
    _save(HomeDelivery(address: address.trim()));
  }

  void choosePickup(String locationId) =>
      _save(StorePickup(locationId: locationId));

  void _save(Fulfilment choice) {
    state = choice;
    ref.read(localStoreProvider).write(StorageKeys.fulfilment, choice.toJson());
  }

  static Fulfilment _decode(Object? json) =>
      Fulfilment.fromJson(json! as Map<String, Object?>);
}
