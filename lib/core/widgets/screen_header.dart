import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';

/// Title row at the top of a screen.
///
/// Without [onBack] it heads a top-level screen (a customer tab, the courier
/// list, the store panel): a large title, the button back to the demo
/// launcher and any [actions]. With [onBack] it leads with a back button
/// instead.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.onBack,
    this.actions = const [],
  });

  final String title;
  final VoidCallback? onBack;

  /// Buttons at the far right of a top-level header, after the launcher
  /// button, such as the customer tabs' cart button.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final onBack = this.onBack;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.md,
        AppSpacing.gutter,
        AppSpacing.md,
      ),
      child: Row(
        children: onBack == null
            ? [
                Expanded(
                  child: Text(title, style: context.textStyles.headline),
                ),
                AppIconButton(
                  icon: Icons.apps_rounded,
                  semanticLabel: AppStrings.openLauncher,
                  onPressed: () => context.go(Routes.launcher),
                ),
                for (final action in actions) ...[
                  const SizedBox(width: AppSpacing.sm),
                  action,
                ],
              ]
            : [
                AppIconButton(
                  icon: Icons.arrow_back_rounded,
                  semanticLabel: AppStrings.back,
                  onPressed: onBack,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: Text(title, style: context.textStyles.title)),
              ],
      ),
    );
  }
}
