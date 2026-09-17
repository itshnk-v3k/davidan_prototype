import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/extra_app.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Title row at the top of a screen.
///
/// Without [onBack] it heads a top-level screen (a customer tab, the courier
/// list, the store panel): a large title, the button back to the demo
/// launcher (staff build only) and any [actions]. With [onBack] it leads with
/// a back button instead.
class ScreenHeader extends ConsumerWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.onBack,
    this.actions = const [],
  });

  final String title;
  final VoidCallback? onBack;

  /// Buttons at the far right, such as a brand's cart button. On a top-level
  /// header they follow the launcher button. They are [AppIconButton]s (or
  /// built on one), lined up by their circles, not their clear margins.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onBack = this.onBack;
    // Only the staff build has a launcher to go back to.
    final hasLauncher = ref.watch(extraAppsProvider).isNotEmpty;

    // Buttons take taps in TapTarget.min, beyond their 40 px circles. Their
    // clear margins take the place of the padding and gaps around them, so the
    // circles and the title sit where they would without them.
    const margin = TapTarget.iconButtonMargin;
    final leadsWithButton = onBack != null;
    final endsWithButton = hasLauncher || actions.isNotEmpty;
    final vertical = leadsWithButton || endsWithButton
        ? AppSpacing.md - margin
        : AppSpacing.md;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        leadsWithButton ? AppSpacing.gutter - margin : AppSpacing.gutter,
        vertical,
        endsWithButton ? AppSpacing.gutter - margin : AppSpacing.gutter,
        vertical,
      ),
      child: Row(
        children: onBack == null
            ? [
                Expanded(
                  child: Text(title, style: context.textStyles.headline),
                ),
                if (hasLauncher)
                  AppIconButton(
                    icon: Icons.apps_rounded,
                    semanticLabel: context.l10n.openLauncher,
                    onPressed: () => context.go(Routes.launcher),
                  ),
                for (final (index, action) in actions.indexed) ...[
                  if (hasLauncher || index > 0)
                    const SizedBox(width: AppSpacing.sm - 2 * margin),
                  action,
                ],
              ]
            : [
                AppIconButton(
                  icon: Icons.arrow_back_rounded,
                  semanticLabel: context.l10n.back,
                  onPressed: onBack,
                ),
                const SizedBox(width: AppSpacing.md - margin),
                Expanded(child: Text(title, style: context.textStyles.title)),
                for (final (index, action) in actions.indexed) ...[
                  SizedBox(
                    width: index == 0
                        ? AppSpacing.sm - margin
                        : AppSpacing.sm - 2 * margin,
                  ),
                  action,
                ],
              ],
      ),
    );
  }
}
