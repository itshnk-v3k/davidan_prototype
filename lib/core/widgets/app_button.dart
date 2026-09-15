import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_motion.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/press_scale.dart';

enum AppButtonVariant { primary, secondary }

/// Full-width button styled with the design tokens. It shrinks slightly while
/// pressed, and a changed [label] (a new total, the next order step)
/// crossfades in.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == AppButtonVariant.primary;
    final foreground = isPrimary
        ? context.colors.onPrimary
        : context.colors.textPrimary;

    return PressScale(
      builder: (onHighlightChanged) => Material(
        color: isPrimary ? context.colors.primary : context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          side: isPrimary
              ? BorderSide.none
              : BorderSide(color: context.colors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          onHighlightChanged: onHighlightChanged,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: foreground),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Flexible(
                    child: AnimatedSwitcher(
                      duration: AppMotion.of(context, AppMotion.fast),
                      child: Text(
                        label,
                        key: ValueKey(label),
                        style: context.textStyles.button.copyWith(
                          color: foreground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
