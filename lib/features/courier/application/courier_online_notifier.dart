import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';

final courierOnlineProvider = NotifierProvider<CourierOnlineNotifier, bool>(
  CourierOnlineNotifier.new,
);

/// Whether the courier is taking new deliveries. Cosmetic: nothing is sent
/// anywhere. Offline, the list keeps the deliveries already on the way, so
/// they can be finished, and hides those waiting at the shop. Online by
/// default; saved to local storage.
class CourierOnlineNotifier extends Notifier<bool> {
  @override
  bool build() =>
      ref
          .watch(localStoreProvider)
          .read(StorageKeys.courierOnline, (json) => json! as bool) ??
      true;

  void setOnline(bool online) {
    state = online;
    ref.read(localStoreProvider).write(StorageKeys.courierOnline, online);
  }
}
