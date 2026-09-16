// The app's language and the switch between Română, Русский and the phone's
// language, in the real app, in Chrome:
//   flutter test --platform chrome
//
// These tests check which language is chosen and that the choice reaches
// Material's labels and the toasts; test/features/russian_test.dart checks the
// app's Russian itself.
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/toast/toast_notifier.dart';
import 'package:davidan_prototype/core/widgets/language_selector.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/account/presentation/profile/profile_screen.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/launcher/application/demo_reset_notifier.dart';
import 'package:davidan_prototype/features/launcher/presentation/demo_launcher_screen.dart';
import 'package:davidan_prototype/l10n/app_language.dart';
import 'package:davidan_prototype/l10n/l10n.dart';
import 'package:davidan_prototype/staff/staff_build.dart';

import '../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  const romanian = Locale('ro');
  const russian = Locale('ru');

  Locale localeOf(WidgetTester tester, Finder finder) =>
      Localizations.localeOf(tester.element(finder));

  testWidgets('the prototype opens in Romanian', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);

    expect(container.read(appLanguageProvider), AppLanguage.ro);
    expect(localeOf(tester, find.text(ro.navHome)), romanian);
    expect(container.read(stringsProvider).localeName, 'ro');
  });

  testWidgets(
    'choosing Русский in the profile applies at once, even without an '
    'account, to the widgets, Material\'s own labels and the toasts\' text',
    (tester) async {
      await pumpApp(tester, container, Routes.clientProfile);
      final profile = find.byType(ProfileScreen);
      expect(
        MaterialLocalizations.of(tester.element(profile)).cancelButtonLabel,
        'Anulați',
      );

      await tapVisible(tester, find.text(LanguageSelector.russian));

      expect(container.read(appLanguageProvider), AppLanguage.ru);
      expect(localeOf(tester, profile), russian);
      expect(tester.element(profile).l10n.localeName, 'ru');
      // material_ui's delegates are the ones registered (flutter#191072).
      expect(
        MaterialLocalizations.of(tester.element(profile)).cancelButtonLabel,
        'Отмена',
      );
      expect(container.read(stringsProvider).localeName, 'ru');
    },
  );

  test('the chosen language is still chosen after a restart', () async {
    container.read(appLanguageProvider.notifier).select(AppLanguage.ru);
    await flushWrites();

    final restarted = await startApp();
    addTearDown(restarted.dispose);
    expect(restarted.read(appLanguageProvider), AppLanguage.ru);
    expect(restarted.read(appLocaleProvider), russian);
  });

  testWidgets('the staff build\'s demo launcher has the same switch', (
    tester,
  ) async {
    final container = await createTestContainer(overrides: staffBuildOverrides);
    await pumpApp(tester, container, Routes.launcher);
    // Below the role cards, which the list only builds once scrolled to.
    await tester.scrollUntilVisible(find.text(LanguageSelector.russian), 200);

    await tapVisible(tester, find.text(LanguageSelector.russian));

    expect(container.read(appLanguageProvider), AppLanguage.ru);
    expect(localeOf(tester, find.byType(DemoLauncherScreen)), russian);
  });

  test('resetting the demo data keeps the chosen language', () async {
    container.read(appLanguageProvider.notifier).select(AppLanguage.ru);
    container.read(cartProvider(Brand.bakery).notifier).add('americano');

    await container.read(demoResetProvider.notifier).reset();

    expect(container.read(cartCountProvider(Brand.bakery)), 0);
    expect(container.read(appLanguageProvider), AppLanguage.ru);
    final restarted = await startApp();
    addTearDown(restarted.dispose);
    expect(restarted.read(appLanguageProvider), AppLanguage.ru);
    expect(restarted.read(cartCountProvider(Brand.bakery)), 0);
  });

  testWidgets('the demo reset\'s toast is in the chosen language', (
    tester,
  ) async {
    container.read(appLanguageProvider.notifier).select(AppLanguage.ru);
    await pumpApp(tester, container, Routes.clientProfile);

    await tapVisible(
      tester,
      find.text(lookupAppLocalizations(russian).resetDemoData),
    );

    // Read before the 3 s toast timer ends it.
    expect(
      container.read(toastProvider)?.message,
      lookupAppLocalizations(russian).resetDemoDataDone,
    );
    await tester.pump(ToastNotifier.duration);
    await tester.pumpAndSettle();
  });

  testWidgets(
    '"Ca telefonul" follows the phone\'s language as it changes, and is '
    'Romanian when the phone has neither Romanian nor Russian',
    (tester) async {
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      tester.platformDispatcher.localesTestValue = const [Locale('ru', 'MD')];
      container.read(appLanguageProvider.notifier).select(AppLanguage.system);
      await pumpApp(tester, container, Routes.clientProfile);
      final profile = find.byType(ProfileScreen);
      expect(localeOf(tester, profile), russian);
      expect(container.read(stringsProvider).localeName, 'ru');

      for (final (phone, expected) in [
        (const [Locale('en', 'US')], romanian),
        (const [Locale('ro', 'MD')], romanian),
        (const [Locale('en', 'US'), Locale('ru', 'RU')], russian),
        (const [Locale('uk', 'UA'), Locale('ro', 'RO')], romanian),
      ]) {
        tester.platformDispatcher.localesTestValue = phone;
        await tester.pumpAndSettle();
        expect(localeOf(tester, profile), expected, reason: '$phone');
        expect(
          container.read(stringsProvider).localeName,
          expected.languageCode,
          reason: '$phone',
        );
      }
    },
  );

  testWidgets('choosing a language again leaves "Ca telefonul"', (
    tester,
  ) async {
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    tester.platformDispatcher.localesTestValue = const [Locale('ru', 'MD')];
    container.read(appLanguageProvider.notifier).select(AppLanguage.system);
    await pumpApp(tester, container, Routes.clientProfile);

    await tapVisible(tester, find.text(LanguageSelector.romanian));

    expect(container.read(appLanguageProvider), AppLanguage.ro);
    expect(localeOf(tester, find.byType(ProfileScreen)), romanian);
  });

  testWidgets('every role\'s main screens open in Russian', (tester) async {
    // The staff build, which has every role. A missing Material delegate
    // throws "No MaterialLocalizations found" here (flutter#191072).
    final container = await createTestContainer(overrides: staffBuildOverrides);
    container.read(appLanguageProvider.notifier).select(AppLanguage.ru);

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
        localeOf(tester, find.byType(Scaffold).last),
        russian,
        reason: route,
      );
    }
  });
}
