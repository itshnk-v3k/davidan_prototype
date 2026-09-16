// Runs in Chrome against real localStorage, the storage the demo uses:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/launcher/application/demo_reset_notifier.dart';

import '../../../helpers/test_app.dart';

void main() {
  // `flutter test` doesn't run the web plugin registrant that `flutter run`
  // generates, so register the localStorage implementation by hand.
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  setUp(() async {
    final app = await startApp();
    await app.read(localStoreProvider).clearDemoData();
    app.dispose();
  });

  test('cart survives an app restart', () async {
    final session = await startApp();
    session.read(cartProvider(Brand.bakery).notifier)
      ..add('croissant-ciocolata')
      ..add('croissant-ciocolata')
      ..add('americano');
    await flushWrites();
    session.dispose();

    final restarted = await startApp();
    addTearDown(restarted.dispose);
    expect(restarted.read(cartCountProvider(Brand.bakery)), 3);
    expect(restarted.read(cartQuantitiesProvider(Brand.bakery)), {
      'croissant-ciocolata': 2,
      'americano': 1,
    });
  });

  test('add with a quantity adds that many units', () async {
    final app = await startApp();
    addTearDown(app.dispose);
    app.read(cartProvider(Brand.bakery).notifier)
      ..add('espresso', quantity: 3)
      ..add('espresso', quantity: 2);
    expect(app.read(cartQuantitiesProvider(Brand.bakery)), {'espresso': 5});
  });

  test('removeOne decrements and drops the line at zero', () async {
    final app = await startApp();
    addTearDown(app.dispose);
    final cart = app.read(cartProvider(Brand.bakery).notifier)
      ..add('fanta')
      ..add('fanta')
      ..removeOne('fanta');
    expect(app.read(cartQuantitiesProvider(Brand.bakery)), {'fanta': 1});

    cart.removeOne('fanta');
    expect(app.read(cartProvider(Brand.bakery)), isEmpty);
  });

  test(
    'saved lines for products no longer in the catalog are dropped',
    () async {
      final session = await startApp();
      session.read(localStoreProvider).write(StorageKeys.cartOf(Brand.bakery), [
        {'productId': 'retired-product', 'quantity': 2},
        {'productId': 'sprite', 'quantity': 1},
      ]);
      await flushWrites();
      session.dispose();

      final restarted = await startApp();
      addTearDown(restarted.dispose);
      expect(restarted.read(cartQuantitiesProvider(Brand.bakery)), {
        'sprite': 1,
      });
    },
  );

  test('unreadable saved data falls back to an empty cart', () async {
    final prefs = await LocalStore.openPreferences();
    await prefs.setString(
      'davidan.v${LocalStore.schemaVersion}.${StorageKeys.cartOf(Brand.bakery)}',
      '{oops',
    );

    final app = await startApp();
    addTearDown(app.dispose);
    expect(app.read(cartProvider(Brand.bakery)), isEmpty);
  });

  test('demo reset empties the cart now and after a restart', () async {
    final session = await startApp();
    session.read(cartProvider(Brand.bakery).notifier).add('espresso');
    await flushWrites();

    await session.read(demoResetProvider.notifier).reset();
    expect(session.read(cartCountProvider(Brand.bakery)), 0);
    session.dispose();

    final restarted = await startApp();
    addTearDown(restarted.dispose);
    expect(restarted.read(cartCountProvider(Brand.bakery)), 0);
  });
}
