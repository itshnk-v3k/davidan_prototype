import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_motion.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';

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

  static const _options = <({ThemeMode mode, IconData icon, String label})>[
    (
      mode: ThemeMode.dark,
      icon: Icons.dark_mode_rounded,
      label: AppStrings.themeDark,
    ),
    (
      mode: ThemeMode.light,
      icon: Icons.light_mode_rounded,
      label: AppStrings.themeLight,
    ),
    (
      mode: ThemeMode.system,
      icon: Icons.smartphone_rounded,
      label: AppStrings.themeSystem,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(AppStrings.themeTitle, style: context.textStyles.subtitle),
        const SizedBox(height: AppSpacing.md),
        Material(
          color: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
            side: BorderSide(color: colors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: Row(
              children: [
                for (final option in _options)
                  Expanded(
                    child: _Segment(
                      icon: option.icon,
                      label: option.label,
                      selected: option.mode == selected,
                      onTap: () => onSelected(option.mode),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = selected ? colors.onPrimary : colors.textPrimary;
    final radius = BorderRadius.circular(AppRadii.sm);

    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: AnimatedContainer(
        duration: AppMotion.of(context, AppMotion.fast),
        curve: AppMotion.standard,
        decoration: BoxDecoration(
          color: selected ? colors.primary : colors.surface,
          borderRadius: radius,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Column(
              children: [
                Icon(icon, size: 20, color: foreground),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  label,
                  style: context.textStyles.label.copyWith(color: foreground),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
