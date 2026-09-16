// The dark and light themes and the switch between them, in the real app, in
// Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_assets.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/theme_mode_notifier.dart';
import 'package:davidan_prototype/core/widgets/brand_logo.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/account/presentation/profile/profile_screen.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/launcher/application/demo_reset_notifier.dart';
import 'package:davidan_prototype/features/launcher/presentation/demo_launcher_screen.dart';
import 'package:davidan_prototype/staff/staff_build.dart';

import '../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  Brightness brightnessOf(WidgetTester tester, Finder finder) =>
      Theme.of(tester.element(finder)).brightness;

  String logoAsset(WidgetTester tester) =>
      (tester
                  .widget<Image>(
                    find.descendant(
                      of: find.byType(BrandLogo),
                      matching: find.byType(Image),
                    ),
                  )
                  .image
              as AssetImage)
          .assetName;

  testWidgets('the prototype opens in the dark theme, with the cream logo', (
    tester,
  ) async {
    await pumpApp(tester, container, Routes.clientHome);

    expect(container.read(themeModeProvider), ThemeMode.dark);
    expect(brightnessOf(tester, find.byType(BrandLogo)), Brightness.dark);
    expect(tester.element(find.byType(BrandLogo)).colors, AppColors.dark);
    expect(logoAsset(tester), AppAssets.logoOnDark);
  });

  testWidgets(
    'choosing the light theme in the profile applies at once, even without '
    'an account',
    (tester) async {
      await pumpApp(tester, container, Routes.clientProfile);

      await tapVisible(tester, find.text(ro.themeLight));

      expect(container.read(themeModeProvider), ThemeMode.light);
      expect(
        brightnessOf(tester, find.byType(ProfileScreen)),
        Brightness.light,
      );
      expect(
        tester.element(find.byType(ProfileScreen)).colors,
        AppColors.light,
      );
    },
  );

  test('the chosen theme is still chosen after a restart', () async {
    container.read(themeModeProvider.notifier).select(ThemeMode.light);
    await flushWrites();

    final restarted = await startApp();
    addTearDown(restarted.dispose);
    expect(restarted.read(themeModeProvider), ThemeMode.light);
  });

  testWidgets('the staff build\'s demo launcher has the same switch', (
    tester,
  ) async {
    final container = await createTestContainer(overrides: staffBuildOverrides);
    container.read(themeModeProvider.notifier).select(ThemeMode.light);
    await pumpApp(tester, container, Routes.launcher);
    expect(logoAsset(tester), AppAssets.logo);

    await tapVisible(tester, find.text(ro.themeDark));

    expect(
      brightnessOf(tester, find.byType(DemoLauncherScreen)),
      Brightness.dark,
    );
    // Back up to the logo, which the list stopped building while scrolled.
    await tester.drag(find.byType(ListView), const Offset(0, 1000));
    await tester.pumpAndSettle();
    expect(logoAsset(tester), AppAssets.logoOnDark);
  });

  test('resetting the demo data keeps the chosen theme', () async {
    container.read(themeModeProvider.notifier).select(ThemeMode.light);
    container.read(cartProvider(Brand.bakery).notifier).add('americano');

    await container.read(demoResetProvider.notifier).reset();

    expect(container.read(cartCountProvider(Brand.bakery)), 0);
    expect(container.read(themeModeProvider), ThemeMode.light);
    final restarted = await startApp();
    addTearDown(restarted.dispose);
    expect(restarted.read(themeModeProvider), ThemeMode.light);
    expect(restarted.read(cartCountProvider(Brand.bakery)), 0);
  });

  testWidgets('"Ca telefonul" follows the phone\'s light or dark setting', (
    tester,
  ) async {
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    container.read(themeModeProvider.notifier).select(ThemeMode.system);
    await pumpApp(tester, container, Routes.clientProfile);
    expect(brightnessOf(tester, find.byType(ProfileScreen)), Brightness.light);

    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();
    expect(brightnessOf(tester, find.byType(ProfileScreen)), Brightness.dark);
  });

  for (final mode in [ThemeMode.dark, ThemeMode.light]) {
    testWidgets('every role\'s main screens open in the ${mode.name} theme', (
      tester,
    ) async {
      // The staff build, which has every role.
      final container = await createTestContainer(
        overrides: staffBuildOverrides,
      );
      container.read(themeModeProvider.notifier).select(mode);
      final brightness = mode == ThemeMode.dark
          ? Brightness.dark
          : Brightness.light;

      for (final (route, size) in [
        (Routes.launcher, const Size(400, 900)),
        (Routes.clientHome, const Size(400, 900)),
        (Routes.clientOrders, const Size(400, 900)),
        (Routes.brandHome(Brand.bakery), const Size(400, 900)),
        (Routes.brandMenu(Brand.bakery), const Size(400, 900)),
        (Routes.brandHome(Brand.restaurant), const Size(400, 900)),
        (Routes.brandCart(Brand.bakery), const Size(400, 900)),
        (Routes.clientFavorites, const Size(400, 900)),
        (Routes.clientProfile, const Size(400, 900)),
        (Routes.signIn, const Size(400, 900)),
        (Routes.clientLocation, const Size(400, 900)),
        (Routes.courierOrders, const Size(400, 900)),
        (Routes.kds, const Size(1280, 800)),
      ]) {
        await pumpApp(tester, container, route, size: size);
        expect(
          brightnessOf(tester, find.byType(Scaffold).last),
          brightness,
          reason: route,
        );
      }
    });
  }
}
