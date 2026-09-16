# Flutter localization for DaviDan (Romanian + Russian): research notes

Researched 2026-09-16. Project: Flutter 3.47.4 (framework rev 9584c6713b, 2026-09-10) / Dart 3.13.3,
`material_ui` 1.2.0, `cupertino_ui` 1.0.2, `intl` 0.20.3 (all resolved in the project's
`.dart_tool/package_config.json`).

How sure each claim is:
- **[verified-source]**: read in the installed SDK or package source.
- **[verified-probe]**: run in a throwaway probe app at `scratchpad/l10n_probe` (VM and `--platform chrome`).
- **[doc]**: taken from the linked page, with the page's date where it shows one.
- **[unverified]** / **[judgment]**: not checked, or my own opinion.

---

## 1. Is gen-l10n still the official approach? What changed?

**Verdict: yes.** gen-l10n (ARB files + `flutter: generate: true` + `l10n.yaml`) is still the
documented approach. Two changes matter for this project: the synthetic package is gone, and the
generated delegate list does not work with `material_ui` (see section 2).

- The official guide https://docs.flutter.dev/ui/internationalization (updated **2026-09-02**) [doc] still says:
  - `flutter pub add flutter_localizations:"{sdk: flutter}" intl:any`
  - `flutter: generate: true`
  - `l10n.yaml` with `arb-dir: lib/l10n`, `template-arb-file: app_en.arb`, `output-localization-file: app_localizations.dart`
  - import with `import 'l10n/app_localizations.dart';`
  - The guide now also says "Flutter projects will soon be encouraged to use the `material_ui` and `cupertino_ui` packages", and its sample is `localizationsDelegates: [AppLocalizations.delegate, ...GlobalMaterialLocalizations.delegates]`.
  - Its option table still lists `synthetic-package` as "true by default". **That is out of date** (see below).

### The synthetic package (`package:flutter_gen`) is gone
- Breaking-change page: https://docs.flutter.dev/release/breaking-changes/flutter-generate-i10n-source [doc]
  - It landed in 3.28.0-0.0.pre and reached stable in 3.32.0 as a deprecation.
  - Generated files now go into the app's source tree.
  - `generate: true` is now required.
- The actual removal shipped in **Flutter 3.35.0**. The release notes list "Remove support for synthetic package:flutter_gen" (#170602), "Remove generateSyntheticPackages…" (#169893) and "Update … to never use synthetic (flutter_gen) packages": https://docs.flutter.dev/release/release-notes/release-notes-3.35.0 [doc]
- Behaviour in 3.47.4 [verified-source, `flutter_tools/lib/src/localizations/localizations_utils.dart`]:
  - `synthetic-package: true` in l10n.yaml stops the tool with *"Cannot enable "synthetic-package", this feature has been removed. See http://flutter.dev/to/flutter-gen-deprecation"*.
  - `synthetic-package: false` only prints a warning that it "no longer has any effect and should be removed".
  - **Output location:** `output-dir` if you set it. Otherwise the files go into `arb-dir`, whose default is `lib/l10n`.
  - Without `flutter: generate: true` the tool exits with "Attempted to generate localizations code without having the flutter: generate flag turned on" (`gen_l10n.dart`).

### gen-l10n runs automatically [verified-source]
- `flutter pub get` runs `GenerateLocalizationsTarget` whenever `generate: true` is set (`commands/packages.dart`).
- `flutter run` and `flutter build` run the same target when `l10n.yaml` exists. Its `canSkip` returns true when there is no `l10n.yaml`.
- `gen-inputs-and-outputs-list` is described as "used by the Flutter tool's build system to keep track of when to call gen_l10n during hot reload". So editing an ARB file plus hot reload/restart regenerates the code.
- You can still run `flutter gen-l10n` by hand.

### l10n.yaml options in 3.47.4 [verified-source: `commands/generate_localizations.dart`, `localizations_utils.dart`]

| option | default | notes |
|---|---|---|
| `arb-dir` | `lib/l10n` | |
| `output-dir` | same as `arb-dir` | |
| `template-arb-file` | `app_en.arb` | **set to `app_ro.arb`** |
| `output-localization-file` | `app_localizations.dart` | |
| `output-class` | `AppLocalizations` | |
| `untranslated-messages-file` | none (a summary is printed instead) | Writes JSON `{"ru": ["key", …]}`. 3.47.0: "[gen_l10n] Exclude inherited keys from untranslated-messages-file" (#187950) |
| `preferred-supported-locales` | alphabetical | **set to `[ro]`** so `supportedLocales.first` is Romanian, which is the fallback locale |
| `header`, `header-file` | | |
| `use-deferred-loading` | false | web only; not worth it for 2 locales |
| `gen-inputs-and-outputs-list`, `project-dir` | | tooling |
| `required-resource-attributes` | false | forces an `@key` metadata entry for every message |
| `nullable-getter` | **true** | **set to false** so `AppLocalizations.of(context)` is non-null |
| `format` | **true** when read from yaml | runs `dart format` on the output; format options were added in 3.35 (#167029) |
| `use-escaping` | false | treats `'...'` as literal text |
| `suppress-warnings` | false | |
| `relax-syntax` | false | a lone `{` is treated as text. Read from yaml; the CLI parser never passes it through (source quirk) |
| `use-named-parameters` | false | generates methods with named parameters, e.g. `itemsInCart(count: 3)` |
| `synthetic-package` | removed | error if true, warning if false |

### Missing translations [verified-probe]
- If `app_ru.arb` lacks a key, the generated `AppLocalizationsRu` **silently returns the Romanian template text**. For example, `onlyRo` rendered as "Doar în română" in the Russian class.
- The key is listed in `untranslated-messages-file`.
- So a key that is missing from the *template* is a compile error in Dart code, but a missing *translation* is only a warning.

---

## 2. Where the Global*Localizations live with material_ui / cupertino_ui

**Verdict: two different classes are now named `GlobalMaterialLocalizations`.** Use the one from
`package:material_ui/material_ui.dart`, never the one from `flutter_localizations`.
`GlobalWidgetsLocalizations` still lives in the SDK's `flutter_localizations`.

Evidence:
- **material_ui 1.2.0** [verified-source]
  - Its pubspec depends on `cupertino_ui ^1.0.0`, `flutter_localizations: sdk`, and `intl ^0.20.2`.
  - `lib/material_ui.dart` exports `src/global_material_localizations.dart` and `src/l10n/generated_material_localizations.dart`.
  - That file imports `GlobalCupertinoLocalizations` from `package:cupertino_ui` and `GlobalWidgetsLocalizations` from `package:flutter_localizations`.
  - It defines:
    ```dart
    static const List<LocalizationsDelegate<dynamic>> delegates = [
      GlobalCupertinoLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ];
    ```
  - Its CHANGELOG 0.0.2 says: "Copies over Material localizations from flutter/flutter's flutter_localizations package."
  - `material_ui`'s `MaterialLocalizations` is its own `abstract class` in `material_ui/lib/src/material_localizations.dart`, not the framework's.
- **cupertino_ui 1.0.2** exports `src/global_cupertino_localizations.dart` [verified-source].
- **The SDK's `packages/flutter_localizations` still exists in 3.47.4** [verified-source].
  - It still exports the legacy `GlobalMaterialLocalizations` / `GlobalCupertinoLocalizations`, which import `package:flutter/material.dart` and `package:flutter/cupertino.dart`.
  - It also exports `GlobalWidgetsLocalizations`.
- README of material_ui ("Step 2: Migrate localizations"): "simply use the new versions of these classes from `material_ui` and `cupertino_ui` … `localizationsDelegates: GlobalMaterialLocalizations.delegates`" [verified-source; also https://pub.dev/packages/material_ui].
- Breaking-change guide https://docs.flutter.dev/release/breaking-changes/material-ui-and-cupertino-ui (updated **2026-08-28**) [doc]:
  - After migrating, you only need `import 'package:material_ui/material_ui.dart'` and `localizationsDelegates: GlobalMaterialLocalizations.delegates`.
  - It says `flutter_localizations` "is no longer required for design component localizations".
  - It says `package:flutter/material.dart` is set for formal deprecation in an upcoming stable release.
- flutter/flutter#188757 "[decoupling] Using flutter_localizations with material_ui/cupertino_ui" [doc]:
  - Each package looks up localizations by its own exact type.
  - Closed by flutter/packages#12119, merged **2026-07-15**, which moved the Global* classes into the UI packages.
- **Open issue flutter/flutter#191072 "gen-l10n should support Standalone UI packages"** [doc]: P1, team-tool, opened **2026-08-13**, assigned to bkonyi. The generated file still hard-codes the legacy delegates.
  - Confirmed in the 3.47.4 template (`gen_l10n_templates.dart`): it imports `package:flutter_localizations/flutter_localizations.dart`, and `localizationsDelegates` is `[delegate, GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate, GlobalWidgetsLocalizations.delegate]` using the *legacy* types.

### Probe results [verified-probe, VM and chrome]
- `localizationsDelegates: AppLocalizations.localizationsDelegates` with `locale: ru` and material_ui's `MaterialApp`:
  - The debug log says "A MaterialLocalizations delegate that supports the ru locale was not found".
  - Then it throws "**No MaterialLocalizations found.** … (package:material_ui/src/debug.dart)".
- `[AppLocalizations.delegate, ...GlobalMaterialLocalizations.delegates]` works:
  - `MaterialLocalizations.of(context).cancelButtonLabel` gives "Anulați" for ro and "Отмена" for ru.
- Importing both `package:flutter_localizations/flutter_localizations.dart` and `package:material_ui/material_ui.dart` in one file is an `ambiguous_import` error for `GlobalMaterialLocalizations`.

### Exact setup for this project

pubspec.yaml:
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:   # the generated app_localizations.dart imports it
    sdk: flutter
  intl: any                # the generated code imports it; pinned by flutter_localizations (0.20.x)
  material_ui: ^1.2.0
  # …existing deps
flutter:
  generate: true
  uses-material-design: true
```
(`material_ui` already pulls both in transitively. Declaring them directly is still right, because
code in `lib/` imports them. The breaking-change page's "remove flutter_localizations" advice only
applies when you don't use gen-l10n.)

l10n.yaml:
```yaml
arb-dir: lib/l10n
template-arb-file: app_ro.arb
output-localization-file: app_localizations.dart
nullable-getter: false
preferred-supported-locales: [ro]
untranslated-messages-file: build/untranslated_messages.json
required-resource-attributes: false
```

lib/app.dart:
```dart
import 'package:material_ui/material_ui.dart';            // NOT flutter_localizations
import 'package:davidan_prototype/l10n/app_localizations.dart';

MaterialApp.router(
  locale: ref.watch(appLocaleProvider),                   // Locale('ro') / Locale('ru')
  supportedLocales: AppLocalizations.supportedLocales,     // [ro, ru], ro first
  localizationsDelegates: const [
    AppLocalizations.delegate,
    ...GlobalMaterialLocalizations.delegates,              // material_ui's: Cupertino + Material + Widgets
  ],
  // Do NOT use AppLocalizations.localizationsDelegates until flutter/flutter#191072 is fixed.
  ...
);
```
Never write `import 'package:flutter_localizations/flutter_localizations.dart'` in the app's own
code. Only the generated file imports it, and it doesn't re-export it, so there is no ambiguity.

---

## 3. Are ro and ru supported by the built-in Material/Cupertino/Widgets localizations?

**Verdict: yes, both.**
- **SDK** `packages/flutter_localizations/lib/src/l10n/` has `material_ro.arb`, `material_ru.arb`, `cupertino_ro.arb`, `cupertino_ru.arb`, `widgets_ro.arb` and `widgets_ru.arb` [verified-source].
- **material_ui** `lib/src/l10n/` has `material_ro.arb` and `material_ru.arb`. `kMaterialSupportedLanguages` contains `'ro', // Romanian Moldavian Moldovan` and `'ru', // Russian` [verified-source].
- Date symbols for `intl` are loaded by material_ui's delegate through `loadDateIntlDataIfNotLoaded()`, so the date picker and time picker work [verified-source]. Both delegates return a `SynchronousFuture`, so a single `pump` is enough in tests.
- Small inconsistency: Romanian Material strings use the formal register ("Anulați"), while the app's copy uses the informal "tu". This shows in dialogs and pickers. Harmless.

---

## 4. ICU plurals for ro and ru

CLDR cardinal rules (https://www.unicode.org/cldr/charts/latest/supplemental/language_plural_rules.html) [doc]:
- **ro:**
  - one: `i = 1 and v = 0`
  - few: `v != 0 or n = 0 or n != 1 and n % 100 = 1..19`, e.g. 0, 2–16, 101, 1001
  - other: 20–35, 100, 1000
- **ru:**
  - one: `v = 0 and i % 10 = 1 and i % 100 != 11`, e.g. 1, 21, 101
  - few: `i % 10 = 2..4` except 12–14
  - many: `i % 10 = 0`, `i % 10 = 5..9`, or `i % 100 = 11..14`, e.g. 0, 5–19, 100
  - other: decimals

How gen-l10n handles them [verified-source]:
- Plural messages compile to `intl.Intl.pluralLogic(count, locale: localeName, zero:…, one:…, two:…, few:…, many:…, other:…)`.
- intl 0.20.3 `plural_rules.dart` maps `'ro': _mo_rule` and `'ru': _ru_rule`, which match CLDR.
- **Gotcha:** gen-l10n maps `=0`→`zero`, `=1`→`one` and `=2`→`two` (the `pluralCases` map in gen_l10n.dart). `=1{…}` and `one{…}` therefore land in the same slot.
  - `pluralLogic` first returns `zero`/`one`/`two` for the exact numbers 0, 1 and 2, then applies the CLDR rule.
  - So in Russian, `=1{один товар}` would ALSO be used for 21, 31 and 101. Always write the number with `{count}` inside `one{…}`.
  - A `=0{…}` special case is safe, because ro/ru rules never return ZERO.
- Placeholders used for plurals must be `int` or `num`.

ARB examples, verified with probe output:

`lib/l10n/app_ro.arb`
```json
{
  "@@locale": "ro",
  "itemsInCart": "{count, plural, =0{Niciun produs} one{{count} produs} few{{count} produse} other{{count} de produse}}",
  "@itemsInCart": {
    "description": "Count of products in the cart, on the cart button",
    "placeholders": { "count": { "type": "int" } }
  }
}
```

`lib/l10n/app_ru.arb`
```json
{
  "@@locale": "ru",
  "itemsInCart": "{count, plural, =0{Нет товаров} one{{count} товар} few{{count} товара} many{{count} товаров} other{{count} товара}}"
}
```

Probe output (VM and Chrome), without the `=0` case:
- ro: 0 = "0 produse", 1 = "1 produs", 2/5/11/19 = "… produse", 20 = "20 de produse", 21 = "21 de produse", 101 = "101 produse".
- ru: 0 = "0 товаров", 1 = "1 товар", 2 = "2 товара", 5/11/19/20 = "… товаров", 21 = "21 товар", 101 = "101 товар".

Project-specific notes:
- Today's `AppStrings.itemsInCart(int count) => '$count produse în coș'` is already wrong in Romanian for 1 ("1 produse") and for 20 or more (should be "20 de produse").
- Currency: Romanian says "1 leu / 2 lei / 20 de lei". Russian inflects too; 999.md/ru writes "10 леев" and "2 лея" [verified by fetching the page].
- The price label (`formatLei`, "36 lei") should become a message. Either keep an invariant unit ("lei" / "лей", or "MDL"), or use a plural message. [judgment: an invariant unit label is the norm for price tags]

---

## 5. Alternatives compared

Package facts, from the pub.dev API on 2026-09-16 and the package archives:
- **slang 4.19.2** (published 2026-09-12) and **slang_flutter 4.19.0** (2026-08-06). Verified publisher; repository on codeberg.
  - The slang_flutter lib imports only `package:flutter/widgets.dart`, and the generator emits only `package:flutter/widgets.dart` [verified-source]. So it works alongside material_ui: you pass material_ui's `GlobalMaterialLocalizations.delegates` yourself.
  - **Built-in plural resolvers (`plural_resolver_map.dart`): ar, cs, de, en, es, fr, he, it, ja, pl, ru, sv, uk, vi. Romanian is not among them** [verified-source]. With `ro` it logs "Resolver for <lang = ro> not specified!" and falls back to a zero/one/other resolver, which would print "2 de produse". You must call `LocaleSettings.setPluralResolver(language: 'ro', …)`, for example by delegating to `Intl.pluralLogic`.
  - It has no built-in locale persistence, and a global `t` that can be used without a BuildContext.
  - Tooling: `dart run slang analyze` (missing/unused), `migrate arb`, `edit`, `wip` [doc: README].
  - Input can be JSON, YAML, CSV or ARB.
  - For Riverpod, the README suggests `locale_handling: false` plus a provider that holds `AppLocale.x.buildSync()`.
- **easy_localization 3.0.8** (2025-07-24; stable release is 13+ months old; 4.0.0-dev.0 is a pre-release). Uploader not verified.
  - It imports `package:flutter/material.dart`, and its `context.localizationDelegates` returns the legacy `flutter_localizations` delegates [verified-source]. It is therefore **incompatible with material_ui unless you build the delegate list yourself**.
  - Keys are strings at runtime. Codegen only gives key constants, with no type checks on arguments or plurals.
  - **`ignorePluralRules` defaults to `true`**, which means only 0/1/2/other. Russian few/many are ignored unless you set it to false [verified-source].
  - Its own `saveLocale` uses plain shared_preferences, outside this project's `SharedPreferencesWithCache` allowList.
- **intl_utils 2.8.16** (2026-06-11, Localizely). Generates an `S` class from ARB, used with the "Flutter Intl" IDE extension. It is a pre-gen-l10n alternative with no advantage over gen-l10n today beyond Localizely integration [doc]. Whether its generated `S.delegate` needs manual Global delegates, and how `S.current` behaves, was not checked [unverified].
- **Hand-rolled:** `abstract class AppStrings` with `final class AppStringsRo implements AppStrings` and `AppStringsRu`, chosen by a Riverpod provider.

| | gen-l10n (ARB) | slang | easy_localization | hand-rolled Dart |
|---|---|---|---|---|
| Type-safe keys and arguments | yes (generated methods) | yes | keys only (codegen), args untyped | yes |
| Key used in code but missing | compile error | compile error | runtime | compile error |
| Translation missing in ru | **warning; falls back to RO text** | reported at generation or by `analyze`; can fall back (`fallback_strategy`) [doc] | runtime fallback | **compile error** (missing override of an abstract member) |
| CLDR plurals ro + ru | yes (intl) | ru yes, **ro needs a custom resolver** | only with `ignorePluralRules: false` | via `Intl.pluralLogic(locale:)` or hand-written |
| Works with material_ui | yes, **don't use the generated delegate list** (#191072) | yes | needs care (legacy delegates, material.dart import) | yes |
| Codegen step | automatic (pub get, run, hot reload) | `dart run slang` or build_runner | optional | none |
| Translator workflow | ARB is standard in Crowdin, Lokalise, Localizely, POEditor, etc.; VS Code "ARB Editor" (Google, 0.3.0, 2025-01-07); i18n Ally; Flutter Intl | JSON/YAML/CSV/ARB | JSON/CSV/YAML | translators edit Dart (bad) |
| Without BuildContext (notifiers, toasts) | `lookupAppLocalizations(locale)` (generated, synchronous) [verified-probe: "3 товара"] | global `t`, or `AppLocale.ru.buildSync()` | `'key'.tr()` (global; no rebuild) | `ref.read(appStringsProvider)` |
| Testability | override the locale; strings are plain classes | same | needs asset loading in tests | trivial |
| Dependencies / risk | SDK tool; one open P1 bug with a one-line workaround | third-party, very active | stagnant, legacy-material coupled | none |
| Fit: prototype that may go to production | **best** | good | poor | fine for a prototype, weak for production translators |

Using gen-l10n from Riverpod (no BuildContext):
```dart
final appLocaleProvider = NotifierProvider<AppLocaleNotifier, Locale>(AppLocaleNotifier.new);
final l10nProvider = Provider<AppLocalizations>(
  (ref) => lookupAppLocalizations(ref.watch(appLocaleProvider)), // generated, synchronous
);
// in a notifier:  ref.read(toastProvider.notifier).show(ref.read(l10nProvider).addedToCart(q, name));
```
Widgets can use `AppLocalizations.of(context)` or `ref.watch(l10nProvider)`. Both come from the
same locale because `MaterialApp.locale` watches the same provider.

**Recommendation for UI strings: gen-l10n with ARB** [judgment].
- It is the official tool, generated automatically, type-safe, has correct ro/ru plurals out of the box, and works with the translation tools you would use in production.
- Its one weakness is that a missing RU translation silently falls back to RO. Compensate by setting `untranslated-messages-file` and adding a test that asserts the file's `ru` list is empty. Alternatively, have a small script compare the key sets of the two ARB files.
- Migration cost: `AppStrings` currently has about 226 references across about 40 files, most of them `static const`.
  - Screens switch from `AppStrings.x` to `context.l10n.x`, via an extension on BuildContext.
  - Notifiers switch to `ref.read(l10nProvider)`.
  - The enum `switch` helpers (`orderStatus`, `sectorName`, …) become ICU `select` messages, or small Dart extensions that call l10n getters.
- **slang** is a reasonable second choice if you prefer nested JSON/YAML and a global `t`, but you would add a Romanian plural resolver yourself.
- **Hand-rolled** gives the strongest compile-time completeness, but it pushes translators into Dart and needs custom plural code. It is acceptable only if the app stays a demo.

---

## 6. Localizing data (product names, descriptions, category blurbs, legal text)

**Verdict:** data does not belong in ARB. What real apps do:
- **Straus (straus.md, Next.js)** [verified by parsing `__NEXT_DATA__` on /ru]:
  - Locales are `["ro","ru","en"]` with `defaultLocale: "ro"`.
  - The API returns categories already resolved for the requested language (`"name": "Завтрак"`), but the slug stays Romanian and stable (`"slug": "mic-dejun"`).
  - SEO metadata carries sibling fields `title_ro`, `title_ru` and `title_en`.
  - Banners have language-specific images (`VISA_ru_lung500…png`).
- **Andy's Pizza (andys.md, React SPA bundle)** [verified-source of the JS bundle]:
  - The chosen language is persisted in `localStorage.language`.
  - It is sent in the API session-token request, and menu content comes from the API per language.
- **davidan.md itself (Shopify):** hreflang only `en` and `ro`; `/ru` returns 404 [verified]. So **there is no Russian source copy to quote**. Russian product names, descriptions and blurbs will be translations, which the project's "verbatim site copy / never invented" rule should call out explicitly.

Options:
1. **`LocalizedText` value type on models, e.g. `const LocalizedText({required String ro, required String ru})`** in the mock source.
   - Pros: const-friendly; the `required` named parameters make a missing translation a compile error; everything stays in one place; it mirrors APIs that return `{ro, ru}` maps or `name_ro`/`name_ru` columns.
   - Con: every widget needs the locale to resolve the text.
2. **ARB key per product.** Wrong layer: the catalog grows, content comes from the backend, UI translators end up translating the menu, and there are hundreds of keys. Avoid.
3. **Separate per-locale data files (JSON assets, `products.ro.json` / `products.ru.json`).**
   - Pros: close to a real API payload; easy to hand to a translator.
   - Cons: async loading; no compile-time completeness; ids can drift between files.
   - Good for **long legal text**: `assets/legal/terms.ro.md` and `terms.ru.md`, loaded with `rootBundle.loadString` for the current language. Legal text is long, versioned and owned by lawyers, and should not live in Dart or ARB.

**Recommendation for mock data** [judgment]:
- Use option 1 in the raw mock (`mockProducts` with `LocalizedText name/description`).
- **Add one projection layer.** A provider watches `appLocaleProvider` and maps raw records to the existing `Product`/`MenuCategory`/`PromoBanner` models with plain `String` fields.
  - Widgets stay unchanged.
  - Switching language rebuilds the catalog, which is exactly what a production repository calling `GET /products?lang=ru` (or sending `Accept-Language`) would do.
  - Only the repository changes when a backend arrives.
- Keep ids and slugs language-neutral.
- Persist ids only. The project already does this: `OrderItem` stores `productId`, and `deliveryAddressText()` builds the pinned-address text at display time. So saved orders re-render in the new language.
- Legal text goes in per-locale Markdown assets.
- Store names and street addresses [judgment]: keep official Romanian street names in both languages, as many MD services do (unverified). Give the city and sectors Russian exonyms (Кишинёв; Ботаника, Буюканы, Центр, Чеканы, Рышкановка), which fit naturally as l10n `select` messages keyed by the `ChisinauSector` enum.

---

## 7. Switching and persisting the locale with Riverpod; what Moldovan services do

### How Flutter resolves the locale [verified-source: `flutter/lib/src/widgets/localizations.dart`, `LocalizationsResolver`]
- If `MaterialApp.locale` is non-null, the locale is `_resolveLocales([locale], supportedLocales)`.
- If it is null, Flutter uses `PlatformDispatcher.locales` and re-resolves on `didChangeLocales`.
- Resolution order: `localeListResolutionCallback`, then `localeResolutionCallback`, then `basicLocaleListResolution`. The last one falls back to `supportedLocales.first` when nothing matches, hence `preferred-supported-locales: [ro]`.
- Devices report `ro_MD` or `ru_MD`. Matching by language code handles both.

### Pattern, mirroring `ThemeModeNotifier`
```dart
enum AppLanguage { ro, ru }

final appLanguageProvider = NotifierProvider<AppLanguageNotifier, AppLanguage>(AppLanguageNotifier.new);

class AppLanguageNotifier extends Notifier<AppLanguage> {
  @override
  AppLanguage build() =>
      ref.watch(localStoreProvider).read(StorageKeys.language, (j) => AppLanguage.values.byName(j! as String)) ??
      AppLanguage.ro;                      // explicit default, not "follow phone"
  void select(AppLanguage l) {
    state = l;
    ref.read(localStoreProvider).write(StorageKeys.language, l.name);
  }
}
final appLocaleProvider = Provider<Locale>((ref) => Locale(ref.watch(appLanguageProvider).name));
```
- Add `language` to `StorageKeys.settings`, not `demoData`, so a demo reset keeps it, like `themeMode`.
- Label the options with endonyms: "Română" and "Русский".
- Show the switch in Profile and on the demo launcher, and ideally on the first-run or sign-in screen.
- If you also want a "Ca telefonul / Как в телефоне" option:
  - Use `Notifier<AppLanguage?>` and pass `locale: null`.
  - Strings used without a BuildContext then need `basicLocaleListResolution(PlatformDispatcher.instance.locales, supported)`, plus a `WidgetsBindingObserver.didChangeLocales` hook.
  - This adds complexity for little value in MD [judgment].

### What Moldovan services do (checked with curl on 2026-09-16)
- **999.md:** the root redirects to `/ro` (307) **even with `Accept-Language: ru`**. hreflang ro, ru, and `x-default` = ro.
- **maib.md:** the root redirects to `/ro` (301) even with `Accept-Language: ru`. hreflang en, ro, ru.
- **linella.md:** the root redirects to `/ro` (302) even with `Accept-Language: ru`. hreflang ro-MD, ru-MD, en-MD, and `x-default` = ro.
- **straus.md:** Next.js `defaultLocale: "ro"`, locales ro/ru/en. The root is served in Romanian even with an RU `Accept-Language`, and `/ru` holds the Russian version.
- **andys.md:** follows the browser language (ru, ro or en); otherwise `defaultLanguage = "ro-ro"`. The choice is saved in `localStorage`.
- **glovoapp.com:** `/ro/md` and `/ru/md` among about 18 languages, with `x-default` = en. Mobile app behaviour not checked [unverified].
- **Pattern:** Romanian by default, a visible RU switch, and the choice remembered. Only Andy's auto-detects.
- **Recommendation** [judgment]: default to RO with a visible RO/RU switch. Optionally, on the very first launch, preselect RU when the device language is `ru` (the Andy's pattern), then persist whatever the user picks.

### Android per-app language (Android 13+)
- Android: declare `res/xml/locales_config.xml` and `android:localeConfig`, or use AGP 8.1+ `androidResources { generateLocaleConfig = true }` together with `res/resources.properties` (`unqualifiedResLocale=…`). Only apps that declare this appear in Settings › App languages.
  - Source: https://developer.android.com/guide/topics/resources/app-languages (updated 2026-05-11) [doc]
- Flutter has **no built-in support**: flutter/flutter#109842 has been open since 2022-08-19 (P2), and #131762 was closed as a duplicate [doc].
- The engine's `LocalizationPlugin.sendLocalesToFlutter` reads `Configuration.getLocales()` [doc: engine source]. A per-app language set in Android settings should therefore reach `PlatformDispatcher.locales`. That only helps when the app follows the system locale (`locale: null`) [inferred; not tested on device].
- Pushing an in-app choice back to Android needs a plugin, e.g. `devicelocale` 0.9.1 `setLanguagePerApp` [doc].
- **Verdict:** not worth wiring for the prototype. It fights an explicit in-app switch (two sources of truth). Revisit for a production Android release.
- iOS, for later: add `CFBundleLocalizations` (ro, ru) to Info.plist, as the gen-l10n template's doc comment says.

---

## 8. Gotchas

### Fonts: bundled Roboto covers Cyrillic and Romanian diacritics [verified]
Checked with `fc-query` (fontconfig/FreeType) on `assets/fonts/roboto/Roboto-{Regular,Medium,Bold}.ttf`:
- The fontconfig `lang` list includes **ro, mo, ru, uk, be** for all three weights.
- The charset includes `a0-17f` (Latin-1 and Latin Extended-A: ă â î, and cedilla ş ţ).
- It includes **`218-21b`** (Ș ș Ț ț, comma-below).
- It includes **`400-486 488-513`** (the whole basic Cyrillic block, including Ё ё).
- It also includes `2013-2015`, `2017-201e` („ ” – —), `2039-203a`, `2116` (№), and `20bd` (₽).
- A second check with my own pure-Python cmap parser (`scratchpad/measure.py`) found **no missing glyph** among А–я, Ё/ё, Ș/ș/Ț/ț (U+0218–U+021B), Ă/ă, Â/â, Î/î, №, „ ”, « ».
- The project's own strings already use the correct comma-below characters (U+0219/U+021B: 94 ș and 105 ț, and no cedilla forms). Make sure pasted Russian and translated Romanian text doesn't bring in cedilla ş/ţ.
- On web, the engine only downloads Noto fallback fonts for missing glyphs. Since Roboto covers both scripts, RU text causes no extra font fetches. This matters for the `--no-web-resources-cdn` builds. Emoji or other symbols would still need fallback.

### Text width: Russian is not uniformly longer, but Cyrillic glyphs are wider [verified: Roboto Medium advance widths, no kerning]
- Average lowercase advance width: Latin a–z is 0.504 em; Cyrillic а–я is **0.604 em (+20%)**.
- Sample pairs below. The RU translations are mine and only illustrative:

| RO | width | RU | width | RU/RO |
|---|---|---|---|---|
| Acasă | 2.79 em | Главная | 3.91 em | ×1.40 |
| Favorite | 3.63 em | Избранное | 5.14 em | ×1.41 |
| Profil | 2.43 em | Профиль | 4.27 em | ×1.76 |
| Marchează gata | 7.20 em | Отметить как готовый | 10.73 em | ×1.49 |
| Continuă comanda | 8.43 em | Продолжить оформление | 12.26 em | ×1.45 |
| Retrimite codul | 6.81 em | Отправить код повторно | 11.78 em | ×1.73 |
| Adaugă în coș · 36 lei | 9.57 em | Добавить в корзину · 36 лей | 13.37 em | ×1.40 |
| Plasează comanda | 8.49 em | Оформить заказ | 7.83 em | ×0.92 |
| Ridicare din local | 7.67 em | Самовывоз | 5.54 em | ×0.72 |
| Întunecată | 4.76 em | Тёмная | 3.56 em | ×0.75 |

- Budget +50–75% for short labels: nav tabs, chips, `AppButton`, the KDS action buttons, and toasts.
- The W3C/IBM expansion guidance (https://www.w3.org/International/articles/article-text-size) is written for English sources, but its main point applies: short strings grow the most and sit in the tightest spaces.
- Use `Flexible`/`Expanded`, `maxLines` with `overflow: TextOverflow.ellipsis`, and `FittedBox` only as a last resort.

### Testing localized widgets with `flutter test --platform chrome`
- In web tests, `flutter_test` calls `ui_web.TestEnvironment.setUp(const TestEnvironment.flutterTester())`, which sets `forceTestFonts = true` and `disableFontFallbacks = true` [verified-source].
  - All text renders with the **FlutterTest** box font, so glyph coverage and diacritics are *not* exercised.
  - Width is roughly (character count × font size), so overflow tests catch length changes, not real Roboto widths.
  - Real-font checks need a manual run on device or web, or golden tests with real fonts loaded.
- RenderFlex overflow errors fail widget tests. A "ru pass" over key screens (home, cart, checkout, KDS, courier) is cheap and catches the worst cases.
- **Keep RO as the default**, so the existing tests that `find.text('…Romanian…')` keep passing. Russian tests override the language:
  ```dart
  final container = await createTestContainer(overrides: [
    appLanguageProvider.overrideWith(() => FixedLanguage(AppLanguage.ru)), // or write StorageKeys.language first
  ]);
  ```
  Alternatively, save `language: "ru"` to storage before `startApp()`.
- The delegates load synchronously (`SynchronousFuture`), so one `pump` renders localized text [verified-probe on chrome: "All tests passed"].
- Assert strings through the generated class rather than literals, so tests survive copy edits:
  `find.text(lookupAppLocalizations(const Locale('ru')).cartTitle)`.
- A completeness test: run gen-l10n with `untranslated-messages-file`, then assert that the `ru` list in the JSON is empty. Or parse both ARB files and compare their key sets.

### Other gotchas
- `template-arb-file` defaults to `app_en.arb`. Set it to `app_ro.arb`.
- Set `nullable-getter: false`.
- Don't use `AppLocalizations.localizationsDelegates` (#191072), and don't import `flutter_localizations` in app code (ambiguous import).
- Missing RU keys silently show Romanian. Watch the untranslated file.
- `=1{…}` means the same as `one{…}` (see section 4).
- Enum `switch` helpers in AppStrings (`orderStatus`, `advanceTo`, `paymentMethod`, `sectorName`, `locationFailure`) become ICU `select` messages or Dart extensions over l10n getters. `select` takes a String, so pass `status.name`.
- Toasts: `ToastNotifier.show(String)` stores already-resolved text. If the language changes while a toast is visible, it stays in the old language for up to 3 s. Acceptable; otherwise store a key or closure.
- `lookupAppLocalizations` throws a `FlutterError` for an unsupported locale. Always pass a resolved `ro` or `ru` locale.
- `intl` `DateFormat`/`NumberFormat` with `ro`/`ru` need date symbols. material_ui's delegate loads them, but code running before the first frame or outside the widget tree would need `initializeDateFormatting()`. The project hand-formats times (`formatTime`, `formatDateTime`), and those formats are identical in RO and RU, so there is nothing to do today.
- Web: consider updating `<html lang>` when the language changes, for accessibility and screen readers [unverified whether Flutter web does this automatically in 3.47].

---

## Sources
- Flutter i18n guide (2026-09-02): https://docs.flutter.dev/ui/internationalization
- Synthetic package deprecation: https://docs.flutter.dev/release/breaking-changes/flutter-generate-i10n-source
- 3.35.0 release notes (removal): https://docs.flutter.dev/release/release-notes/release-notes-3.35.0
- 3.47.0 release notes: https://docs.flutter.dev/release/release-notes/release-notes-3.47.0
- material_ui/cupertino_ui migration (2026-08-28): https://docs.flutter.dev/release/breaking-changes/material-ui-and-cupertino-ui
- material_ui on pub.dev: https://pub.dev/packages/material_ui
- Issue #188757: https://github.com/flutter/flutter/issues/188757
- flutter/packages PR #12119 (merged 2026-07-15): https://github.com/flutter/packages/pull/12119
- Issue #191072 (gen-l10n and standalone UI packages, open, P1): https://github.com/flutter/flutter/issues/191072
- CLDR plural rules: https://www.unicode.org/cldr/charts/latest/supplemental/language_plural_rules.html
- slang: https://pub.dev/packages/slang · slang_flutter: https://pub.dev/packages/slang_flutter
- easy_localization: https://pub.dev/packages/easy_localization
- intl_utils: https://pub.dev/packages/intl_utils
- ARB Editor for VS Code: https://marketplace.visualstudio.com/items?itemName=Google.arb-editor · Flutter Intl: https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl
- Android per-app languages (2026-05-11): https://developer.android.com/guide/topics/resources/app-languages
- Flutter per-app language issues: https://github.com/flutter/flutter/issues/109842 · https://github.com/flutter/flutter/issues/131762
- Engine LocalizationPlugin: https://github.com/flutter/flutter/blob/master/engine/src/flutter/shell/platform/android/io/flutter/plugin/localization/LocalizationPlugin.java
- devicelocale: https://pub.dev/packages/devicelocale
- W3C text size in translation: https://www.w3.org/International/articles/article-text-size
- Sites checked on 2026-09-16: https://999.md · https://www.maib.md · https://linella.md · https://straus.md · https://andys.md · https://glovoapp.com/ro/md · https://davidan.md
- Local sources: `/opt/homebrew/share/flutter/packages/flutter_tools/lib/src/localizations/*`, `/opt/homebrew/share/flutter/packages/flutter_localizations/`, `~/.pub-cache/hosted/pub.dev/material_ui-1.2.0/`, `~/.pub-cache/hosted/pub.dev/cupertino_ui-1.0.2/`, `~/.pub-cache/hosted/pub.dev/intl-0.20.3/lib/src/plural_rules.dart`
- Probe app: `scratchpad/l10n_probe` (test/probe_test.dart). Width script: `scratchpad/measure.py`
