// Runs in Chrome against real localStorage, the storage the demo uses:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/favorites_notifier.dart';
import 'package:davidan_prototype/features/launcher/application/demo_reset_notifier.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  setUp(() async {
    final app = await startApp();
    await app.read(localStoreProvider).clearDemoData();
    app.dispose();
  });

  List<String> favoriteNames(ProviderContainer app) => [
    for (final product in app.read(favoriteProductsProvider)) product.name,
  ];

  test('saving puts a product first; saving it again removes it', () async {
    final app = await startApp();
    addTearDown(app.dispose);

    final favorites = app.read(favoritesProvider.notifier)
      ..toggle((brand: Brand.bakery, id: 'coca-cola'))
      ..toggle((brand: Brand.bakery, id: 'americano'));
    expect(favoriteNames(app), ['Americano', 'Coca Cola']);
    expect(app.read(favoriteKeysProvider), {
      (brand: Brand.bakery, id: 'americano'),
      (brand: Brand.bakery, id: 'coca-cola'),
    });

    favorites.toggle((brand: Brand.bakery, id: 'coca-cola'));
    expect(favoriteNames(app), ['Americano']);
  });

  test('favourites survive an app restart', () async {
    final session = await startApp();
    session.read(favoritesProvider.notifier)
      ..toggle((brand: Brand.bakery, id: 'sprite'))
      ..toggle((brand: Brand.bakery, id: 'espresso'));
    await flushWrites();
    session.dispose();

    final restarted = await startApp();
    addTearDown(restarted.dispose);
    expect(favoriteNames(restarted), ['Espresso', 'Sprite']);
  });

  test('saved products no longer in the catalog are dropped', () async {
    final session = await startApp();
    session.read(localStoreProvider).write(StorageKeys.favorites, [
      {'brand': 'bakery', 'id': 'retired-product'},
      {'brand': 'bakery', 'id': 'sprite'},
    ]);
    await flushWrites();
    session.dispose();

    final restarted = await startApp();
    addTearDown(restarted.dispose);
    expect(restarted.read(favoritesProvider), [
      (brand: Brand.bakery, id: 'sprite'),
    ]);
  });

  test('demo reset clears favourites now and after a restart', () async {
    final session = await startApp();
    session.read(favoritesProvider.notifier).toggle((
      brand: Brand.bakery,
      id: 'espresso',
    ));
    await flushWrites();

    await session.read(demoResetProvider.notifier).reset();
    expect(session.read(favoritesProvider), isEmpty);
    session.dispose();

    final restarted = await startApp();
    addTearDown(restarted.dispose);
    expect(restarted.read(favoritesProvider), isEmpty);
  });
}
