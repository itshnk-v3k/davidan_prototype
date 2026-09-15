// Runs in Chrome against real localStorage, the storage the demo uses:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/features/courier/application/courier_online_notifier.dart';
import 'package:davidan_prototype/features/launcher/application/demo_reset_notifier.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  setUp(() async {
    final app = await startApp();
    await app.read(localStoreProvider).clearAll();
    app.dispose();
  });

  test('the courier starts online; going offline survives a restart', () async {
    final session = await startApp();
    expect(session.read(courierOnlineProvider), isTrue);

    session.read(courierOnlineProvider.notifier).setOnline(false);
    await flushWrites();
    session.dispose();

    final restarted = await startApp();
    addTearDown(restarted.dispose);
    expect(restarted.read(courierOnlineProvider), isFalse);
  });

  test(
    'demo reset puts the courier back online, also after a restart',
    () async {
      final session = await startApp();
      session.read(courierOnlineProvider.notifier).setOnline(false);
      await flushWrites();

      await session.read(demoResetProvider.notifier).reset();
      expect(session.read(courierOnlineProvider), isTrue);
      session.dispose();

      final restarted = await startApp();
      addTearDown(restarted.dispose);
      expect(restarted.read(courierOnlineProvider), isTrue);
    },
  );
}
