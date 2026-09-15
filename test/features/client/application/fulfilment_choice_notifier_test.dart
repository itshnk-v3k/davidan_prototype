// Runs in Chrome against real localStorage, the storage the demo uses:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/client/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/features/launcher/application/demo_reset_notifier.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  setUp(() async {
    final app = await startApp();
    await app.read(localStoreProvider).clearDemoData();
    app.dispose();
  });

  test('nothing is chosen on first run', () async {
    final app = await startApp();
    addTearDown(app.dispose);
    expect(app.read(fulfilmentChoiceProvider), isNull);
  });

  test('a delivery address survives an app restart, trimmed', () async {
    final session = await startApp();
    session
        .read(fulfilmentChoiceProvider.notifier)
        .chooseDelivery('  str. Ismail 88 ');
    await flushWrites();
    session.dispose();

    final restarted = await startApp();
    addTearDown(restarted.dispose);
    expect(
      restarted.read(fulfilmentChoiceProvider),
      isA<HomeDelivery>().having((c) => c.address, 'address', 'str. Ismail 88'),
    );
  });

  test('choosing a shop replaces the address, also after a restart', () async {
    final session = await startApp();
    session.read(fulfilmentChoiceProvider.notifier)
      ..chooseDelivery('str. Ismail 88')
      ..choosePickup('botanica');
    await flushWrites();
    session.dispose();

    final restarted = await startApp();
    addTearDown(restarted.dispose);
    expect(
      restarted.read(fulfilmentChoiceProvider),
      isA<StorePickup>().having((c) => c.locationId, 'locationId', 'botanica'),
    );
  });

  test(
    'a saved shop that is no longer in the mock data counts as no choice',
    () async {
      final session = await startApp();
      session
          .read(localStoreProvider)
          .write(
            StorageKeys.fulfilment,
            const StorePickup(locationId: 'closed-shop').toJson(),
          );
      await flushWrites();
      session.dispose();

      final restarted = await startApp();
      addTearDown(restarted.dispose);
      expect(restarted.read(fulfilmentChoiceProvider), isNull);
    },
  );

  test('demo reset clears the choice now and after a restart', () async {
    final session = await startApp();
    session.read(fulfilmentChoiceProvider.notifier).choosePickup('centru');
    await flushWrites();

    await session.read(demoResetProvider.notifier).reset();
    expect(session.read(fulfilmentChoiceProvider), isNull);
    session.dispose();

    final restarted = await startApp();
    addTearDown(restarted.dispose);
    expect(restarted.read(fulfilmentChoiceProvider), isNull);
  });

  test('recent addresses: past deliveries only, newest first, no repeats, '
      'at most three', () async {
    final app = await createTestContainer();
    for (final address in ['str. A 1', 'str. B 2', 'str. A 1', 'str. C 3']) {
      placeTestOrder(app, fulfilment: HomeDelivery(address: address));
    }
    placeTestOrder(app, fulfilment: const StorePickup(locationId: 'centru'));
    placeTestOrder(app, fulfilment: const HomeDelivery(address: 'str. D 4'));

    expect(app.read(recentAddressesProvider), [
      'str. D 4',
      'str. C 3',
      'str. A 1',
    ]);
  });
}
