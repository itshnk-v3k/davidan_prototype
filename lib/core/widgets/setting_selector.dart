import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_motion.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';

/// One choice of a [SettingSelector]: its [icon] sits above its [label].
typedef SettingOption<T> = ({T value, Widget icon, String label});

/// A titled row of segments with one of them selected, for the app settings
/// (theme, language) in the profile and on the demo launcher.
class SettingSelector<T> extends StatelessWidget {
  const SettingSelector({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final List<SettingOption<T>> options;
  final T selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: context.textStyles.subtitle),
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
                for (final option in options)
                  Expanded(
                    child: _Segment(
                      icon: option.icon,
                      label: option.label,
                      selected: option.value == selected,
                      onTap: () => onSelected(option.value),
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

  final Widget icon;
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
                SizedBox(
                  height: 20,
                  child: IconTheme.merge(
                    data: IconThemeData(size: 20, color: foreground),
                    child: DefaultTextStyle.merge(
                      style: context.textStyles.label.copyWith(
                        color: foreground,
                        fontWeight: FontWeight.w700,
                      ),
                      child: Center(child: icon),
                    ),
                  ),
                ),
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
