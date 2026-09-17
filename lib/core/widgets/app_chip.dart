import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';

/// Pill-shaped choice chip: filled when selected, outlined otherwise. It looks
/// [height] tall and takes taps in [TapTarget.min], the rest a clear margin
/// above and below it.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  /// How tall the pill looks.
  static const double height = 36;

  /// The clear margin above and below the pill.
  static const double tapMargin = (TapTarget.min - height) / 2;

  /// Space between rows of chips that looks like [AppSpacing.sm]: the rows'
  /// clear margins overlap.
  static const double runSpacing = AppSpacing.sm - 2 * tapMargin;

  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? context.colors.onPrimary
        : context.colors.textPrimary;
    final icon = this.icon;

    return Semantics(
      container: true,
      button: true,
      selected: selected,
      // A tap in the clear margin selects too; one on the pill ripples.
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        excludeFromSemantics: true,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: tapMargin),
          child: Material(
            color: selected ? context.colors.primary : context.colors.surface,
            shape: StadiumBorder(
              side: selected
                  ? BorderSide.none
                  : BorderSide(color: context.colors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: SizedBox(
                height: height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 18, color: foreground),
                        const SizedBox(width: AppSpacing.sm - AppSpacing.xxs),
                      ],
                      Flexible(
                        child: Text(
                          label,
                          style: context.textStyles.bodyStrong.copyWith(
                            color: foreground,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
