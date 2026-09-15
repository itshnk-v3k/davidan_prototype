import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';

/// Pill-shaped choice chip: filled when selected, outlined otherwise.
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

  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? context.colors.onPrimary
        : context.colors.textPrimary;
    final icon = this.icon;

    return Semantics(
      button: true,
      selected: selected,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
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
    );
  }
}
