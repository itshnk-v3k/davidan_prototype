import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/data/models/customer_account.dart';

final accountProvider = NotifierProvider<AccountNotifier, CustomerAccount?>(
  AccountNotifier.new,
);

/// The customer's DEMO account, or null when signed out. Created by the mock
/// sign-in (SignInDraftNotifier), where nothing is verified. Saved to local
/// storage and cleared by demo reset.
class AccountNotifier extends Notifier<CustomerAccount?> {
  @override
  CustomerAccount? build() => ref
      .watch(localStoreProvider)
      .read(
        StorageKeys.account,
        (json) => CustomerAccount.fromJson(json! as Map<String, Object?>),
      );

  void register(CustomerAccount account) {
    state = account;
    ref.read(localStoreProvider).write(StorageKeys.account, account.toJson());
  }

  void signOut() {
    state = null;
    ref.read(localStoreProvider).remove(StorageKeys.account);
  }
}

final signInSkippedProvider = NotifierProvider<SignInSkippedNotifier, bool>(
  SignInSkippedNotifier.new,
);

/// Whether the customer tapped "Mai târziu" on the sign-in screen, so the
/// splash stops offering it. Saved; cleared by demo reset.
class SignInSkippedNotifier extends Notifier<bool> {
  @override
  bool build() =>
      ref
          .watch(localStoreProvider)
          .read(StorageKeys.signInSkipped, (json) => json! as bool) ??
      false;

  void skip() {
    state = true;
    ref.read(localStoreProvider).write(StorageKeys.signInSkipped, true);
  }
}
