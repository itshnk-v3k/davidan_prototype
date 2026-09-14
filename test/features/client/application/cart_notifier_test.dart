// Runs in Chrome against real localStorage, the storage the demo uses:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/features/client/application/cart_notifier.dart';
import 'package:davidan_prototype/features/launcher/application/demo_reset_notifier.dart';

/// Boots providers the way main() does. Each call reads storage from scratch,
/// like reloading the page.
Future<ProviderContainer> startApp() async {
  final prefs = await LocalStore.openPreferences();
  return ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
}

/// Lets fire-and-forget storage writes finish.
Future<void> flushWrites() => Future<void>.delayed(Duration.zero);

void main() {
  // `flutter test` doesn't run the web plugin registrant that `flutter run`
  // generates, so register the localStorage implementation by hand.
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  setUp(() async {
    final app = await startApp();
    await app.read(localStoreProvider).clearAll();
    app.dispose();
  });

  test('cart survives an app restart', () async {
    final session = await startApp();
    session.read(cartProvider.notifier)
      ..add('croissant-ciocolata')
      ..add('croissant-ciocolata')
      ..add('americano');
    await flushWrites();
    session.dispose();

    final restarted = await startApp();
    addTearDown(restarted.dispose);
    expect(restarted.read(cartCountProvider), 3);
    expect(restarted.read(cartQuantitiesProvider), {
      'croissant-ciocolata': 2,
      'americano': 1,
    });
  });

  test('add with a quantity adds that many units', () async {
    final app = await startApp();
    addTearDown(app.dispose);
    app.read(cartProvider.notifier)
      ..add('espresso', quantity: 3)
      ..add('espresso', quantity: 2);
    expect(app.read(cartQuantitiesProvider), {'espresso': 5});
  });

  test('removeOne decrements and drops the line at zero', () async {
    final app = await startApp();
    addTearDown(app.dispose);
    final cart = app.read(cartProvider.notifier)
      ..add('fanta')
      ..add('fanta')
      ..removeOne('fanta');
    expect(app.read(cartQuantitiesProvider), {'fanta': 1});

    cart.removeOne('fanta');
    expect(app.read(cartProvider), isEmpty);
  });

  test(
    'saved lines for products no longer in the catalog are dropped',
    () async {
      final session = await startApp();
      session.read(localStoreProvider).write(StorageKeys.cart, [
        {'productId': 'retired-product', 'quantity': 2},
        {'productId': 'sprite', 'quantity': 1},
      ]);
      await flushWrites();
      session.dispose();

      final restarted = await startApp();
      addTearDown(restarted.dispose);
      expect(restarted.read(cartQuantitiesProvider), {'sprite': 1});
    },
  );

  test('unreadable saved data falls back to an empty cart', () async {
    final prefs = await LocalStore.openPreferences();
    await prefs.setString(
      'davidan.v${LocalStore.schemaVersion}.${StorageKeys.cart}',
      '{oops',
    );

    final app = await startApp();
    addTearDown(app.dispose);
    expect(app.read(cartProvider), isEmpty);
  });

  test('demo reset empties the cart now and after a restart', () async {
    final session = await startApp();
    session.read(cartProvider.notifier).add('espresso');
    await flushWrites();

    await session.read(demoResetProvider.notifier).reset();
    expect(session.read(cartCountProvider), 0);
    session.dispose();

    final restarted = await startApp();
    addTearDown(restarted.dispose);
    expect(restarted.read(cartCountProvider), 0);
  });
}
