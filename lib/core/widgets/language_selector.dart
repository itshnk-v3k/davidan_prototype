import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/widgets/setting_selector.dart';
import 'package:davidan_prototype/l10n/app_language.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// "Limba aplicației" with a three-way switch: Română, Русский, or following
/// the phone.
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final AppLanguage selected;
  final ValueChanged<AppLanguage> onSelected;

  /// Each language is named in itself, as language pickers do, so a person
  /// can find theirs whatever language the app is in. These names are the
  /// same in every language, so they aren't in the ARB files.
  static const romanian = 'Română';
  static const russian = 'Русский';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SettingSelector(
      title: l10n.languageTitle,
      options: [
        (value: AppLanguage.ro, icon: const Text('RO'), label: romanian),
        (value: AppLanguage.ru, icon: const Text('RU'), label: russian),
        (
          value: AppLanguage.system,
          icon: const Icon(Icons.smartphone_rounded),
          label: l10n.languageSystem,
        ),
      ],
      selected: selected,
      onSelected: onSelected,
    );
  }
}
