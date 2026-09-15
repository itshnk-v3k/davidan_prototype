import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';

/// Title row at the top of a customer app tab, with the button back to the
/// demo launcher.
class TabHeader extends StatelessWidget {
  const TabHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.md,
        AppSpacing.gutter,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppTextStyles.headline)),
          AppIconButton(
            icon: Icons.apps_rounded,
            semanticLabel: AppStrings.openLauncher,
            onPressed: () => context.go(Routes.launcher),
          ),
        ],
      ),
    );
  }
}
