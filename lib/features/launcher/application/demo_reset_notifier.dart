import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/features/client/application/cart_notifier.dart';

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
    ref.invalidate(cartProvider);
  }
}
