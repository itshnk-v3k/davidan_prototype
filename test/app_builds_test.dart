// What each entry point contains, in the real app, in Chrome:
//   flutter test --platform chrome
// lib/main.dart is the customer app shown to the client, without the staff
// apps; lib/main_staff.dart adds them for phase 2.
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/app_router.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/demo_tools/demo_tool_strings.dart';
import 'package:davidan_prototype/features/courier/presentation/courier_orders_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/home_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/splash/splash_screen.dart';
import 'package:davidan_prototype/features/kds/presentation/kds_screen.dart';
import 'package:davidan_prototype/features/launcher/presentation/demo_launcher_screen.dart';
import 'package:davidan_prototype/staff/staff_build.dart';

import 'helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  Finder launcherButton() => find.byIcon(Icons.apps_rounded);

  group('the customer app build (lib/main.dart)', () {
    setUp(() async => container = await createTestContainer());

    testWidgets('opens on the splash: there is no launcher', (tester) async {
      await pumpApp(tester, container, Routes.launcher);

      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.byType(DemoLauncherScreen), findsNothing);
    });

    testWidgets('home and the tab headers have no button to a launcher', (
      tester,
    ) async {
      for (final route in [
        Routes.clientHome,
        Routes.clientMenu,
        Routes.clientFavorites,
        Routes.clientProfile,
      ]) {
        await pumpApp(tester, container, route);
        expect(launcherButton(), findsNothing, reason: route);
      }
    });

    testWidgets('the courier app and the store panel are not found', (
      tester,
    ) async {
      await pumpApp(tester, container, Routes.courierOrders);
      expect(find.byType(CourierOrdersScreen), findsNothing);

      container.read(appRouterProvider).go(Routes.kds);
      await tester.pumpAndSettle();
      expect(find.byType(KdsScreen), findsNothing);
    });
  });

  group('the staff build (lib/main_staff.dart)', () {
    setUp(
      () async =>
          container = await createTestContainer(overrides: staffBuildOverrides),
    );

    testWidgets(
      'opens on the launcher, which lists the customer app, the staff apps '
      'and the board',
      (tester) async {
        await pumpApp(tester, container, Routes.launcher);

        expect(find.byType(DemoLauncherScreen), findsOneWidget);
        for (final title in [
          ro.launcherClient,
          ro.launcherCourier,
          ro.launcherKds,
          DemoToolStrings.allRolesTitle,
        ]) {
          expect(find.text(title), findsOneWidget, reason: title);
        }
      },
    );

    testWidgets('home has the button back to the launcher', (tester) async {
      await pumpApp(tester, container, Routes.clientHome);

      await tester.tap(inScreen<HomeScreen>(launcherButton()));
      await tester.pumpAndSettle();

      expect(find.byType(DemoLauncherScreen), findsOneWidget);
    });
  });
}
