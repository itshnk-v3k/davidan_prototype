import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/widgets/setting_selector.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// "Tema aplicației" with a three-way switch: dark, light, or following the
/// phone.
class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final ThemeMode selected;
  final ValueChanged<ThemeMode> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SettingSelector(
      title: l10n.themeTitle,
      options: [
        (
          value: ThemeMode.dark,
          icon: const Icon(PhosphorIconsRegular.moon),
          label: l10n.themeDark,
        ),
        (
          value: ThemeMode.light,
          icon: const Icon(PhosphorIconsRegular.sun),
          label: l10n.themeLight,
        ),
        (
          value: ThemeMode.system,
          icon: const Icon(PhosphorIconsRegular.deviceMobile),
          label: l10n.themeSystem,
        ),
      ],
      selected: selected,
      onSelected: onSelected,
    );
  }
}
