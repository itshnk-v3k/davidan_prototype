import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';

/// How product lists show their products: two columns of cards, or one column
/// of wide rows with more beside the photo.
enum ProductLayout { grid, list }

final productLayoutProvider =
    NotifierProvider<ProductLayoutNotifier, ProductLayout>(
      ProductLayoutNotifier.new,
    );

/// The customer's choice of [ProductLayout], the same in every product list
/// and saved to local storage. A preference, like the theme, so resetting the
/// demo keeps it.
class ProductLayoutNotifier extends Notifier<ProductLayout> {
  @override
  ProductLayout build() =>
      ref
          .watch(localStoreProvider)
          .read(
            StorageKeys.productLayout,
            (json) => ProductLayout.values.byName(json! as String),
          ) ??
      ProductLayout.grid;

  void toggle() {
    state = state == ProductLayout.grid
        ? ProductLayout.list
        : ProductLayout.grid;
    ref.read(localStoreProvider).write(StorageKeys.productLayout, state.name);
  }
}
