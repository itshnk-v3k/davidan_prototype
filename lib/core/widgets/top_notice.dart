import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_motion.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';

/// A short message in a caramel pill that floats at the top of the screen:
/// the store panel's new-order notice and the phone apps' confirmations.
/// Screen readers announce it when it appears.
class TopNotice extends StatelessWidget {
  const TopNotice({super.key, required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      // Keeps text styles clean when shown above a screen's Scaffold.
      child: Material(
        type: MaterialType.transparency,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadii.pill),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: AppColors.onPrimary),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    message,
                    style: AppTextStyles.bodyStrong.copyWith(
                      color: AppColors.onPrimary,
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

/// Drops [notice] in from the top edge, and lifts it away when it becomes
/// null or is replaced by a notice with a different key.
class TopNoticeSwitcher extends StatelessWidget {
  const TopNoticeSwitcher({super.key, required this.notice});

  final TopNotice? notice;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppMotion.of(context, AppMotion.medium),
      switchInCurve: AppMotion.standard,
      switchOutCurve: AppMotion.standard,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, -0.5),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: notice ?? const SizedBox.shrink(),
    );
  }
}
