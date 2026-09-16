import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/l10n/app_localizations.dart';
import 'package:davidan_prototype/l10n/content.dart';

/// The language setting: Romanian, Russian, or the phone's language.
enum AppLanguage {
  ro(Locale('ro')),
  ru(Locale('ru')),
  system(null);

  const AppLanguage(this.locale);

  /// Null for [system], which depends on the phone.
  final Locale? locale;
}

final appLanguageProvider = NotifierProvider<AppLanguageNotifier, AppLanguage>(
  AppLanguageNotifier.new,
);

/// Română by default, as Moldovan services open in Romanian whatever the
/// phone's language; saved to local storage. Like the theme, a presenter's
/// preference rather than demo data, so resetting the demo keeps it.
class AppLanguageNotifier extends Notifier<AppLanguage> {
  @override
  AppLanguage build() =>
      ref
          .watch(localStoreProvider)
          .read(
            StorageKeys.language,
            (json) => AppLanguage.values.byName(json! as String),
          ) ??
      AppLanguage.ro;

  void select(AppLanguage language) {
    state = language;
    ref.read(localStoreProvider).write(StorageKeys.language, language.name);
  }
}

final deviceLocalesProvider =
    NotifierProvider<DeviceLocalesNotifier, List<Locale>>(
      DeviceLocalesNotifier.new,
    );

/// The phone's languages, most preferred first, kept up to date when they
/// change while the app runs.
class DeviceLocalesNotifier extends Notifier<List<Locale>>
    with WidgetsBindingObserver {
  @override
  List<Locale> build() {
    final binding = WidgetsBinding.instance;
    binding.addObserver(this);
    ref.onDispose(() => binding.removeObserver(this));
    return binding.platformDispatcher.locales;
  }

  @override
  void didChangeLocales(List<Locale>? locales) => state = locales ?? const [];
}

/// The locale the app is shown in: always Romanian or Russian. "Ca telefonul"
/// picks the phone's first language the app has, and Romanian when it has
/// none of them (supportedLocales lists ro first).
final appLocaleProvider = Provider<Locale>((ref) {
  final language = ref.watch(appLanguageProvider);
  return language.locale ??
      basicLocaleListResolution(
        ref.watch(deviceLocalesProvider),
        AppLocalizations.supportedLocales,
      );
});

/// UI text for code without a BuildContext: notifiers and toasts. Widgets read
/// context.l10n; both follow [appLocaleProvider].
final stringsProvider = Provider<AppLocalizations>(
  (ref) => lookupAppLocalizations(ref.watch(appLocaleProvider)),
);

/// The brands' content in the app's language, for providers. Widgets use
/// context.content; both follow [appLocaleProvider].
final contentProvider = Provider<ContentTranslator>(
  (ref) => ContentTranslator.of(ref.watch(appLocaleProvider)),
);
