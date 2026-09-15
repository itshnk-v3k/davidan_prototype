// Splash screen (/client/splash) in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/app_router.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_assets.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/features/client/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/features/client/presentation/home/home_screen.dart';
import 'package:davidan_prototype/features/client/presentation/location/location_screen.dart';
import 'package:davidan_prototype/features/client/presentation/splash/splash_screen.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  /// Opens the customer app from the launcher and waits out the splash.
  Future<void> enterCustomerApp(WidgetTester tester) async {
    await pumpApp(tester, container, Routes.launcher);
    await tapVisible(tester, find.text(AppStrings.launcherClient));
    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(SplashScreen.holdDuration);
    await tester.pumpAndSettle();
    expect(find.byType(SplashScreen), findsNothing);
  }

  testWidgets(
    'shows the logo and tagline over the pastry photo for the whole hold, '
    'then moves on',
    (tester) async {
      await pumpApp(tester, container, Routes.launcher);
      container.read(appRouterProvider).go(Routes.clientSplash);
      // Builds the splash, which starts its hold.
      await tester.pump();

      await tester.pump(
        SplashScreen.holdDuration - const Duration(milliseconds: 1),
      );
      expect(find.byType(SplashScreen), findsOneWidget);
      expect(
        inScreen<SplashScreen>(
          find.image(const AssetImage(AppAssets.splashBackground)),
        ),
        findsOneWidget,
      );
      expect(
        inScreen<SplashScreen>(find.image(const AssetImage(AppAssets.logo))),
        findsOneWidget,
      );
      expect(find.text(BrandFacts.tagline), findsOneWidget);
      expect(find.byType(LocationScreen), findsNothing);

      await tester.pump(const Duration(milliseconds: 1));
      await tester.pumpAndSettle();
      expect(find.byType(SplashScreen), findsNothing);
      expect(find.byType(LocationScreen), findsOneWidget);
    },
  );

  testWidgets('the splash fits a 360 x 640 phone', (tester) async {
    await pumpApp(
      tester,
      container,
      Routes.launcher,
      size: const Size(360, 640),
    );
    container.read(appRouterProvider).go(Routes.clientSplash);
    // The first frame builds the new page offstage; the next one shows it.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text(BrandFacts.tagline), findsOneWidget);

    await tester.pump(SplashScreen.holdDuration);
    await tester.pumpAndSettle();
  });

  testWidgets('first run: the launcher opens location selection, and choosing '
      'continues to home', (tester) async {
    await enterCustomerApp(tester);

    expect(find.byType(LocationScreen), findsOneWidget);
    // Replaced the splash, so there is no back button.
    expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);

    await tapVisible(tester, find.text(AppStrings.pickup));
    await tapVisible(tester, find.text('DaviDan Centru'));

    expect(find.byType(LocationScreen), findsNothing);
    expect(inScreen<HomeScreen>(find.text('DaviDan Centru')), findsOneWidget);
  });

  testWidgets('with a saved choice it goes straight to home', (tester) async {
    container
        .read(fulfilmentChoiceProvider.notifier)
        .chooseDelivery('str. Ismail 88');
    await enterCustomerApp(tester);

    expect(find.byType(LocationScreen), findsNothing);
    expect(inScreen<HomeScreen>(find.text('str. Ismail 88')), findsOneWidget);
  });
}
