// Demo sign-in (phone, any code, name and sector), the nearest shop, and the
// locked profile, in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/location/location_result.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/core/widgets/option_tile.dart';
import 'package:davidan_prototype/data/models/chisinau_sector.dart';
import 'package:davidan_prototype/data/models/customer_account.dart';
import 'package:davidan_prototype/data/models/geo_point.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/account/application/account_notifier.dart';
import 'package:davidan_prototype/features/account/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/features/account/presentation/location/location_screen.dart';
import 'package:davidan_prototype/features/account/presentation/profile/profile_screen.dart';
import 'package:davidan_prototype/features/account/presentation/sign_in/sign_in_code_screen.dart';
import 'package:davidan_prototype/features/account/presentation/sign_in/sign_in_details_screen.dart';
import 'package:davidan_prototype/features/account/presentation/sign_in/sign_in_phone_screen.dart';
import 'package:davidan_prototype/features/account/presentation/sign_in/welcome_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/hub_home_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/splash/splash_screen.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

import '../../../helpers/fake_location_service.dart';
import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  /// 334 m north of the Buiucani shop.
  const nearBuiucani = GeoPoint(47.0360, 28.7800);

  Finder chip(String label) => find.widgetWithText(AppChip, label);

  /// Types a valid number and any code, ending on the details step.
  Future<void> enterPhoneAndCode(WidgetTester tester) async {
    await tester.enterText(
      inScreen<SignInPhoneScreen>(find.byType(TextField)),
      '69123456',
    );
    await tapVisible(tester, find.text(ro.sendCode));
    expect(find.byType(SignInCodeScreen), findsOneWidget);

    await tester.enterText(
      inScreen<SignInCodeScreen>(find.byType(TextField)),
      '4821',
    );
    await tester.pumpAndSettle();
    expect(find.byType(SignInDetailsScreen), findsOneWidget);
  }

  testWidgets(
    'first launch offers sign-in; "Mai târziu" goes on to location selection '
    'and the profile stays locked',
    (tester) async {
      final container = await createTestContainer();
      // "/" opens the splash in the customer app build.
      await pumpApp(tester, container, Routes.launcher);
      await tester.pump(SplashScreen.holdDuration);
      await tester.pumpAndSettle();

      expect(find.byType(SignInPhoneScreen), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);

      await tapVisible(tester, find.text(ro.signInLater));

      expect(find.byType(LocationScreen), findsOneWidget);
      expect(container.read(signInSkippedProvider), isTrue);
      expect(container.read(accountProvider), isNull);

      await tapVisible(tester, find.text(ro.pickup));
      await tapVisible(tester, find.text('DaviDan Centru'));
      await tester.tap(find.text(ro.navProfile));
      await tester.pumpAndSettle();

      expect(
        inScreen<ProfileScreen>(find.text(ro.accountLockedTitle)),
        findsOneWidget,
      );
      expect(
        inScreen<ProfileScreen>(find.text(ro.myOrdersTitle)),
        findsNothing,
      );
    },
  );

  testWidgets(
    'from the locked profile: phone, any 4-digit code, name and sector create '
    'the account; the shop nearest the sector is suggested, not chosen, until '
    'confirmed; signing out locks the profile again',
    (tester) async {
      final location = FakeLocationService.failing(LocationFailure.denied);
      final container = await createTestContainer(locationService: location);
      await pumpApp(tester, container, Routes.clientProfile);

      await tapVisible(tester, find.text(ro.signInTitle));
      expect(find.byType(SignInPhoneScreen), findsOneWidget);
      // Opened from the profile: back, and no "Mai târziu".
      expect(find.text(ro.signInLater), findsNothing);

      await tester.enterText(find.byType(TextField), '22123');
      await tapVisible(tester, find.text(ro.sendCode));
      expect(find.text(ro.phoneInvalid), findsOneWidget);
      expect(find.byType(SignInCodeScreen), findsNothing);

      await tester.enterText(find.byType(TextField), '69123456');
      await tapVisible(tester, find.text(ro.sendCode));
      expect(find.text(ro.codeSentTo('+373 69 123 456')), findsOneWidget);
      expect(find.text(ro.demoCodeNote), findsOneWidget);

      final codeField = inScreen<SignInCodeScreen>(find.byType(TextField));
      await tester.enterText(codeField, '482');
      await tapVisible(tester, find.text(ro.confirmCode));
      expect(find.text(ro.codeIncomplete), findsOneWidget);
      await tester.enterText(codeField, '4821');
      await tester.pumpAndSettle();
      expect(find.byType(SignInDetailsScreen), findsOneWidget);

      await tapVisible(tester, find.text(ro.createAccount));
      expect(find.text(ro.nameMissing), findsOneWidget);
      expect(find.text(ro.sectorMissing), findsOneWidget);

      await tester.enterText(
        inScreen<SignInDetailsScreen>(find.byType(TextField)),
        'Ana',
      );
      await tapVisible(tester, chip('Ciocana'));
      await tapVisible(tester, find.text(ro.createAccount));

      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.text(ro.welcomeTitle('Ana')), findsOneWidget);
      expect(find.text('DaviDan Centru'), findsOneWidget);
      expect(
        find.text(ro.matchedBySector(ChisinauSector.ciocana)),
        findsOneWidget,
      );
      expect(location.lookups, 0);

      await tester.tap(find.text(ro.chooseHowToReceive));
      await tester.pumpAndSettle();

      expect(find.byType(LocationScreen), findsOneWidget);
      final suggested = tester.widget<OptionTile>(
        find.widgetWithText(OptionTile, 'DaviDan Centru'),
      );
      expect(suggested.selected, isTrue);
      expect(suggested.subtitle, startsWith(ro.nearestToYou));
      // Suggested, not saved.
      expect(container.read(fulfilmentChoiceProvider), isNull);

      await tapVisible(tester, find.text(ro.confirmShop));

      expect(
        inScreen<HubHomeScreen>(find.text('DaviDan Centru')),
        findsOneWidget,
      );
      expect(
        container.read(fulfilmentChoiceProvider),
        isA<StorePickup>().having((c) => c.locationId, 'locationId', 'centru'),
      );

      await tester.tap(find.text(ro.navProfile));
      await tester.pumpAndSettle();
      Finder inProfile(Finder finder) => inScreen<ProfileScreen>(finder);
      expect(inProfile(find.text('Ana')), findsOneWidget);
      expect(inProfile(find.text('+373 69 *** 456')), findsOneWidget);
      expect(
        inProfile(find.text(ro.sectorLabel(ChisinauSector.ciocana))),
        findsOneWidget,
      );
      expect(inProfile(find.text('DaviDan Centru')), findsOneWidget);

      await tapVisible(tester, find.text(ro.signOut));
      expect(inProfile(find.text(ro.accountLockedTitle)), findsOneWidget);
      expect(container.read(accountProvider), isNull);
    },
  );

  testWidgets('another shop can be picked instead of the suggested one', (
    tester,
  ) async {
    final container = await createTestContainer();
    signInTestAccount(container, sector: ChisinauSector.botanica);
    await pumpApp(tester, container, Routes.clientLocationAfterSignUp);

    OptionTile tile(String name) =>
        tester.widget<OptionTile>(find.widgetWithText(OptionTile, name));
    expect(tile('DaviDan Botanica').selected, isTrue);

    await tapVisible(
      tester,
      find.widgetWithText(OptionTile, 'DaviDan Buiucani'),
    );
    expect(tile('DaviDan Buiucani').selected, isTrue);
    expect(tile('DaviDan Botanica').selected, isFalse);
    expect(container.read(fulfilmentChoiceProvider), isNull);

    await tapVisible(tester, find.text(ro.confirmShop));
    expect(
      container.read(fulfilmentChoiceProvider),
      isA<StorePickup>().having((c) => c.locationId, 'locationId', 'buiucani'),
    );
  });

  testWidgets(
    'with the phone\'s location, the nearest shop is matched by distance and '
    'the sector is picked',
    (tester) async {
      final location = FakeLocationService.at(nearBuiucani);
      final container = await createTestContainer(locationService: location);
      await pumpApp(tester, container, Routes.signIn);
      await enterPhoneAndCode(tester);

      await tester.enterText(
        inScreen<SignInDetailsScreen>(find.byType(TextField)),
        'Ion',
      );
      await tapVisible(tester, find.text(ro.useMyLocationForShop));

      expect(location.lookups, 1);
      expect(
        find.text(ro.locationFoundNearest('330 m', 'DaviDan Buiucani')),
        findsOneWidget,
      );
      expect(tester.widget<AppChip>(chip('Buiucani')).selected, isTrue);

      await tapVisible(tester, find.text(ro.createAccount));

      expect(find.text('DaviDan Buiucani'), findsOneWidget);
      expect(find.text(ro.matchedByLocation('330 m')), findsOneWidget);
      expect(
        container.read(accountProvider),
        isA<CustomerAccount>()
            .having((a) => a.matchedBy, 'matchedBy', ShopMatch.location)
            .having((a) => a.distanceMeters, 'distanceMeters', 334),
      );
    },
  );

  testWidgets('when the location lookup fails, the sector decides', (
    tester,
  ) async {
    final container = await createTestContainer(
      locationService: FakeLocationService.failing(LocationFailure.denied),
    );
    await pumpApp(tester, container, Routes.signIn);
    await enterPhoneAndCode(tester);

    await tester.enterText(
      inScreen<SignInDetailsScreen>(find.byType(TextField)),
      'Ion',
    );
    await tapVisible(tester, find.text(ro.useMyLocationForShop));
    expect(
      find.text(ro.locationFailedUseSector(LocationFailure.denied)),
      findsOneWidget,
    );

    await tapVisible(tester, chip('Botanica'));
    await tapVisible(tester, find.text(ro.createAccount));

    expect(find.text('DaviDan Botanica'), findsOneWidget);
    expect(
      find.text(ro.matchedBySector(ChisinauSector.botanica)),
      findsOneWidget,
    );
  });

  testWidgets('the sign-in steps fit a 360 x 640 phone', (tester) async {
    final container = await createTestContainer();
    await pumpApp(tester, container, Routes.signIn, size: const Size(360, 640));
    expect(find.byType(SignInPhoneScreen), findsOneWidget);

    await enterPhoneAndCode(tester);
    await tester.enterText(
      inScreen<SignInDetailsScreen>(find.byType(TextField)),
      'Alexandru-Constantin Popescu',
    );
    await tapVisible(tester, chip('Rîșcani'));
    await tapVisible(tester, find.text(ro.createAccount));
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });
}
