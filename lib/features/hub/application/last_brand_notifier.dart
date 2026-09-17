import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/data/models/brand.dart';

final lastBrandProvider = NotifierProvider<LastBrandNotifier, Brand>(
  LastBrandNotifier.new,
);

/// The brand the customer was last shopping in, saved to local storage: where
/// Acasă opens. The patisserie until they pick another, since it is the brand
/// with the fullest menu.
///
/// It is only read when Acasă has to choose a brand for itself (the redirect
/// on Routes.clientHome). What is on screen is the URL's brand, never this:
/// the router stays the single source of truth, as it is for the open
/// category (see CatalogScreen).
class LastBrandNotifier extends Notifier<Brand> {
  static const fallback = Brand.bakery;

  @override
  Brand build() =>
      ref
          .watch(localStoreProvider)
          .read(
            StorageKeys.lastBrand,
            (json) => Brand.values.byName(json! as String),
          ) ??
      fallback;

  /// Remembers [brand] as the one to open Acasă on. Called as a brand's feed
  /// is built, so it also covers a brand opened straight from a link.
  void remember(Brand brand) {
    if (state == brand) return;
    state = brand;
    ref.read(localStoreProvider).write(StorageKeys.lastBrand, brand.name);
  }
}
