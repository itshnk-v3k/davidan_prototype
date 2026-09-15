// The demo account, the mock sign-in and a pinned current location, against
// real localStorage in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/location/location_result.dart';
import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/data/mock/mock_sectors.dart';
import 'package:davidan_prototype/data/models/chisinau_sector.dart';
import 'package:davidan_prototype/data/models/customer_account.dart';
import 'package:davidan_prototype/data/models/geo_point.dart';
import 'package:davidan_prototype/data/models/pinned_location.dart';
import 'package:davidan_prototype/features/client/application/account_notifier.dart';
import 'package:davidan_prototype/features/client/application/current_location_notifier.dart';
import 'package:davidan_prototype/features/client/application/sign_in_draft_notifier.dart';
import 'package:davidan_prototype/features/launcher/application/demo_reset_notifier.dart';

import '../../../helpers/fake_location_service.dart';
import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  setUp(() async {
    final app = await startApp();
    await app.read(localStoreProvider).clearAll();
    app.dispose();
  });

  const nearBuiucani = GeoPoint(47.0360, 28.7800);
  const ana = CustomerAccount(
    phone: '69123456',
    name: 'Ana',
    sector: ChisinauSector.botanica,
    nearestLocationId: 'botanica',
    matchedBy: ShopMatch.sector,
  );

  /// The draft is auto-disposed without a listener, as when its screens
  /// close, so keep one while the test uses it.
  SignInDraftNotifier draftOf(ProviderContainer container) {
    container.listen(signInDraftProvider, (_, _) {});
    return container.read(signInDraftProvider.notifier);
  }

  test('the mock sign-in wants a Moldovan mobile number, then accepts any '
      'complete code', () async {
    final container = await createTestContainer();
    final draft = draftOf(container)..setPhone('22 123 456');
    expect(draft.submitPhone(), isFalse);

    draft.setPhone('69 123 456');
    expect(draft.submitPhone(), isTrue);
    expect(container.read(signInDraftProvider).phone, '69123456');

    draft.setCode('12');
    expect(draft.submitCode(), isFalse);
    for (final code in ['0000', '4821', '9999']) {
      draft.setCode(code);
      expect(draft.submitCode(), isTrue, reason: code);
    }
  });

  test('a missing name or sector blocks the account', () async {
    final container = await createTestContainer();
    final draft = draftOf(container)..setName('  ');
    expect(draft.finish(), isNull);
    draft.setName('Ana');
    expect(draft.finish(), isNull);
    expect(container.read(signInDraftProvider).showDetailsErrors, isTrue);
    expect(container.read(accountProvider), isNull);
  });

  test('without a location the nearest shop comes from the sector', () async {
    final location = FakeLocationService.at(nearBuiucani);
    final container = await createTestContainer(locationService: location);
    final account =
        (draftOf(container)
              ..setPhone('69123456')
              ..setName(' Ana ')
              ..setSector(ChisinauSector.riscani))
            .finish()!;

    expect(account.name, 'Ana');
    expect(account.nearestLocationId, 'centru');
    expect(account.matchedBy, ShopMatch.sector);
    expect(account.distanceMeters, isNull);
    expect(container.read(accountProvider)?.name, 'Ana');
    // Nobody asked for the location.
    expect(location.lookups, 0);
  });

  test('with a location found the shop is matched by distance and the '
      'sector picked; a failed lookup falls back to the sector', () async {
    final found = await createTestContainer(
      locationService: FakeLocationService.at(nearBuiucani),
    );
    final draft = draftOf(found)..setName('Ion');
    await draft.locate();
    expect(found.read(signInDraftProvider).sector, ChisinauSector.buiucani);

    final byLocation = draft.finish()!;
    expect(byLocation.nearestLocationId, 'buiucani');
    expect(byLocation.matchedBy, ShopMatch.location);
    expect(byLocation.distanceMeters, 334);

    final failed = await createTestContainer(
      locationService: FakeLocationService.failing(LocationFailure.timeout),
    );
    final fallback = draftOf(failed)..setName('Ion');
    await fallback.locate();
    expect(failed.read(signInDraftProvider).sector, isNull);
    fallback.setSector(ChisinauSector.botanica);

    final bySector = fallback.finish()!;
    expect(bySector.nearestLocationId, 'botanica');
    expect(bySector.matchedBy, ShopMatch.sector);
  });

  test('the account and a skipped sign-in survive a restart; signing out '
      'removes only the account', () async {
    final session = await startApp();
    session.read(accountProvider.notifier).register(ana);
    session.read(signInSkippedProvider.notifier).skip();
    await flushWrites();
    session.dispose();

    final restarted = await startApp();
    expect(restarted.read(accountProvider)?.name, 'Ana');
    expect(restarted.read(signInSkippedProvider), isTrue);
    restarted.read(accountProvider.notifier).signOut();
    await flushWrites();
    restarted.dispose();

    final again = await startApp();
    addTearDown(again.dispose);
    expect(again.read(accountProvider), isNull);
    expect(again.read(signInSkippedProvider), isTrue);
  });

  test('locating pins the phone\'s location; a failed lookup pins nothing '
      'and says why', () async {
    final found = await createTestContainer(
      locationService: FakeLocationService.at(nearBuiucani),
    );
    expect(await found.read(currentLocationProvider.notifier).locate(), isNull);
    expect(
      found.read(currentLocationProvider).pinned,
      isA<PinnedLocation>()
          .having((p) => p.point, 'point', nearBuiucani)
          .having((p) => p.source, 'source', PinSource.gps),
    );

    final denied = await createTestContainer(
      locationService: FakeLocationService.failing(LocationFailure.denied),
    );
    expect(
      await denied.read(currentLocationProvider.notifier).locate(),
      LocationFailure.denied,
    );
    expect(denied.read(currentLocationProvider).pinned, isNull);
    expect(denied.read(currentLocationProvider).locating, isFalse);
  });

  test('a pinned location survives a restart until it is cleared', () async {
    final session = await startApp();
    session
        .read(currentLocationProvider.notifier)
        .pinOnMap(sectorCentres[ChisinauSector.ciocana]!);
    await flushWrites();
    session.dispose();

    final restarted = await startApp();
    expect(
      restarted.read(currentLocationProvider).pinned?.source,
      PinSource.map,
    );
    restarted.read(currentLocationProvider.notifier).clear();
    await flushWrites();
    restarted.dispose();

    final again = await startApp();
    addTearDown(again.dispose);
    expect(again.read(currentLocationProvider).pinned, isNull);
  });

  test('demo reset clears the account, the skipped sign-in and a pinned '
      'location, now and after a restart', () async {
    final session = await startApp();
    session.read(accountProvider.notifier).register(ana);
    session.read(signInSkippedProvider.notifier).skip();
    session
        .read(currentLocationProvider.notifier)
        .pinOnMap(const GeoPoint(47.0, 28.85));
    await flushWrites();

    await session.read(demoResetProvider.notifier).reset();
    expect(session.read(accountProvider), isNull);
    expect(session.read(signInSkippedProvider), isFalse);
    expect(session.read(currentLocationProvider).pinned, isNull);
    session.dispose();

    final restarted = await startApp();
    addTearDown(restarted.dispose);
    expect(restarted.read(accountProvider), isNull);
    expect(restarted.read(signInSkippedProvider), isFalse);
    expect(restarted.read(currentLocationProvider).pinned, isNull);
  });
}
