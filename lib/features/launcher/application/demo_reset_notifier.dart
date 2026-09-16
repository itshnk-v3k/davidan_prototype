import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/router/extra_app.dart';
import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/features/account/application/account_notifier.dart';
import 'package:davidan_prototype/features/account/application/current_location_notifier.dart';
import 'package:davidan_prototype/features/account/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/application/favorites_notifier.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/features/rental/application/rental_bookings_notifier.dart';

final demoResetProvider = NotifierProvider<DemoResetNotifier, void>(
  DemoResetNotifier.new,
);

/// Wipes saved demo state so a review session can start from scratch.
class DemoResetNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<void> reset() async {
    await ref.read(localStoreProvider).clearDemoData();
    // Every Notifier that restores saved state must be invalidated here, so
    // it re-runs build() against the now-empty storage. Registered extra apps
    // (the staff build's courier app) list their own.
    ref
      ..invalidate(cartProvider)
      ..invalidate(ordersProvider)
      ..invalidate(rentalBookingsProvider)
      ..invalidate(fulfilmentChoiceProvider)
      ..invalidate(favoritesProvider)
      ..invalidate(accountProvider)
      ..invalidate(signInSkippedProvider)
      ..invalidate(currentLocationProvider);
    for (final app in ref.read(extraAppsProvider)) {
      app.savedState.forEach(ref.invalidate);
    }
  }
}
