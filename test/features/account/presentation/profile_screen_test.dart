// Profile screen (/client/profile) in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/toast/toast_notifier.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/chisinau_sector.dart';
import 'package:davidan_prototype/features/account/application/account_notifier.dart';
import 'package:davidan_prototype/features/account/presentation/profile/profile_screen.dart';
import 'package:davidan_prototype/features/account/presentation/sign_in/sign_in_phone_screen.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/hub/presentation/brand_info_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/splash/splash_screen.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  Finder inProfile(Finder finder) => inScreen<ProfileScreen>(finder);

  testWidgets('the Profil tab opens it, and it lists no orders: Comenzi does', (
    tester,
  ) async {
    signInTestAccount(container);
    placeTestOrder(container);
    await pumpApp(tester, container, Routes.clientHome);
    await tester.tap(find.text(ro.navProfile));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(inProfile(find.text(ro.navOrders)), findsNothing);
    expect(inProfile(find.text('138 L')), findsNothing);
  });

  testWidgets(
    'signed out it is locked, and "Intră în cont" opens the sign-in',
    (tester) async {
      await pumpApp(tester, container, Routes.clientProfile);

      expect(inProfile(find.text(ro.accountLockedTitle)), findsOneWidget);

      await tapVisible(tester, find.text(ro.signInTitle));
      expect(find.byType(SignInPhoneScreen), findsOneWidget);
    },
  );

  testWidgets(
    'signed in: name, masked number, sector and nearest shop; signing out '
    'locks it',
    (tester) async {
      signInTestAccount(
        container,
        name: 'Ana Popescu',
        sector: ChisinauSector.buiucani,
      );
      await pumpApp(tester, container, Routes.clientProfile);

      expect(inProfile(find.text('Ana Popescu')), findsOneWidget);
      expect(inProfile(find.text('+373 69 *** 456')), findsOneWidget);
      expect(
        inProfile(find.text(ro.sectorLabel(ChisinauSector.buiucani))),
        findsOneWidget,
      );
      expect(inProfile(find.text(ro.nearestShopTitle)), findsOneWidget);
      expect(inProfile(find.text('DaviDan Buiucani')), findsOneWidget);

      // Signing out is last in Profil, below the settings.
      await tester.scrollUntilVisible(
        inProfile(find.text(ro.signOut)),
        300,
        scrollable: inProfile(find.byType(Scrollable)).first,
      );
      await tapVisible(tester, inProfile(find.text(ro.signOut)));
      // Signing out asks first.
      expect(find.text(ro.signOutConfirmTitle), findsOneWidget);
      await tester.tap(find.text(ro.signOut).last);
      await tester.pumpAndSettle();

      expect(inProfile(find.text(ro.accountLockedTitle)), findsOneWidget);
      expect(container.read(accountProvider), isNull);
    },
  );

  testWidgets(
    'resetting the demo data, signed in or not, starts the demo over from '
    'the splash',
    (tester) async {
      for (final signedIn in [true, false]) {
        if (signedIn) signInTestAccount(container);
        placeTestOrder(container);
        container.read(cartProvider(Brand.bakery).notifier).add('americano');
        await pumpApp(tester, container, Routes.clientProfile);

        await tapVisible(tester, find.text(ro.resetDemoData));

        expect(find.byType(SplashScreen), findsOneWidget, reason: '$signedIn');
        expect(container.read(accountProvider), isNull);
        expect(container.read(ordersProvider), isEmpty);
        expect(container.read(cartCountProvider(Brand.bakery)), 0);
        // Lets the confirmation toast time out.
        await tester.pump(ToastNotifier.duration);
        await tester.pumpAndSettle();
      }
    },
  );

  testWidgets('the "Despre DaviDan" facts are gone', (tester) async {
    signInTestAccount(container);
    await pumpApp(tester, container, Routes.clientProfile);

    expect(inProfile(find.text('Despre DaviDan')), findsNothing);
    expect(inProfile(find.text('Angajați')), findsNothing);
    expect(inProfile(find.text('720')), findsNothing);
    expect(inProfile(find.text('74')), findsNothing);
    expect(inProfile(find.text('2.000.000+')), findsNothing);
  });

  testWidgets(
    'signed out on a 360 x 640 phone, "Intră în cont" shows in full and the '
    'settings scroll into view below it',
    (tester) async {
      await pumpApp(
        tester,
        container,
        Routes.clientProfile,
        size: const Size(360, 640),
      );

      final signIn = find.widgetWithText(AppButton, ro.signInTitle);
      final lockMessage = tester.getRect(find.byType(EmptyState));
      expect(
        lockMessage.contains(tester.getRect(signIn).topLeft) &&
            lockMessage.contains(tester.getRect(signIn).bottomRight),
        isTrue,
        reason: 'the button is cut off by the settings under it',
      );

      await tester.scrollUntilVisible(
        find.text(ro.resetDemoData),
        200,
        scrollable: inProfile(find.byType(Scrollable)).first,
      );
      expect(find.text(ro.languageTitle), findsOneWidget);
      await tapVisible(tester, signIn);
      expect(find.byType(SignInPhoneScreen), findsOneWidget);
    },
  );

  testWidgets('fits a 360 x 640 phone with a long name', (tester) async {
    signInTestAccount(container, name: 'Alexandru-Constantin Popescu');
    await pumpApp(
      tester,
      container,
      Routes.clientProfile,
      size: const Size(360, 640),
    );

    expect(find.byType(ProfileScreen), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(ro.demoProfileNote),
      200,
      scrollable: find
          .descendant(
            of: find.byType(ProfileScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text(ro.demoProfileNote), findsOneWidget);
  });

  testWidgets(
    'the brands\' contacts open from Profil; the settings and the demo reset '
    'come before signing out, which is last and can be backed out of',
    (tester) async {
      signInTestAccount(container);
      await pumpApp(
        tester,
        container,
        Routes.clientProfile,
        size: const Size(400, 1600),
      );

      double topOf(String text) =>
          tester.getTopLeft(inProfile(find.text(text))).dy;
      final order = [
        ro.nearestShopTitle,
        ro.profileBrandsTitle,
        ro.themeTitle,
        ro.languageTitle,
        ro.profileDemoTitle,
        ro.signOut,
      ];
      for (var i = 1; i < order.length; i++) {
        expect(
          topOf(order[i]),
          greaterThan(topOf(order[i - 1])),
          reason: order[i],
        );
      }

      await tapVisible(tester, find.text(ro.signOut));
      await tester.tap(find.text(ro.back));
      await tester.pumpAndSettle();
      expect(container.read(accountProvider), isNotNull);

      await tapVisible(tester, inProfile(find.text('Rent Car')));
      expect(find.byType(BrandInfoScreen), findsOneWidget);
      expect(find.text('DAVIDAN RENT CAR SRL'), findsOneWidget);
    },
  );
}
