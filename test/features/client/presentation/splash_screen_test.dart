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

  testWidgets('shows the logo and tagline, then moves on by itself', (
    tester,
  ) async {
    await pumpApp(tester, container, Routes.launcher);
    container.read(appRouterProvider).go(Routes.clientSplash);
    // A new page is built offstage on its first frame and shows from the
    // second. The next screen only starts sliding in over it after that.
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(milliseconds: 16));

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(inScreen<SplashScreen>(find.byType(Image)), findsOneWidget);
    expect(find.text(BrandFacts.tagline), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(SplashScreen), findsNothing);
  });

  testWidgets('first run: the launcher opens location selection, and choosing '
      'continues to home', (tester) async {
    await pumpApp(tester, container, Routes.launcher);
    await tapVisible(tester, find.text(AppStrings.launcherClient));

    expect(find.byType(SplashScreen), findsNothing);
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
    await pumpApp(tester, container, Routes.launcher);
    await tapVisible(tester, find.text(AppStrings.launcherClient));

    expect(find.byType(SplashScreen), findsNothing);
    expect(find.byType(LocationScreen), findsNothing);
    expect(inScreen<HomeScreen>(find.text('str. Ismail 88')), findsOneWidget);
  });
}
