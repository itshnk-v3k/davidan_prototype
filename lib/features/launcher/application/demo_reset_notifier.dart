import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/features/client/application/account_notifier.dart';
import 'package:davidan_prototype/features/client/application/cart_notifier.dart';
import 'package:davidan_prototype/features/client/application/current_location_notifier.dart';
import 'package:davidan_prototype/features/client/application/favorites_notifier.dart';
import 'package:davidan_prototype/features/client/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/features/courier/application/courier_online_notifier.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';

final demoResetProvider = NotifierProvider<DemoResetNotifier, void>(
  DemoResetNotifier.new,
);

/// Wipes saved demo state so a review session can start from scratch.
class DemoResetNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<void> reset() async {
    await ref.read(localStoreProvider).clearAll();
    // Every Notifier that restores saved state must be invalidated here, so
    // it re-runs build() against the now-empty storage.
    ref
      ..invalidate(cartProvider)
      ..invalidate(ordersProvider)
      ..invalidate(fulfilmentChoiceProvider)
      ..invalidate(favoritesProvider)
      ..invalidate(courierOnlineProvider)
      ..invalidate(accountProvider)
      ..invalidate(signInSkippedProvider)
      ..invalidate(currentLocationProvider);
  }
}
