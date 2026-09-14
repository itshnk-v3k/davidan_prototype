import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';

/// A link from a placeholder screen to the next step of the flow.
class PlaceholderLink {
  const PlaceholderLink(this.label, this.location, {this.push = false});

  final String label;
  final String location;

  /// Push onto the stack (back returns here) instead of replacing the location.
  final bool push;
}

/// Stand-in for a screen that isn't built yet. It links to the next step, so
/// the whole prototype stays clickable from day one.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.location,
    this.links = const [],
  });

  final String title;

  /// Current route, shown small for orientation during review.
  final String location;
  final List<PlaceholderLink> links;

  @override
  Widget build(BuildContext context) {
    final canPop = context.canPop();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  AppIconButton(
                    icon: canPop
                        ? Icons.arrow_back_rounded
                        : Icons.apps_rounded,
                    semanticLabel: canPop
                        ? AppStrings.back
                        : AppStrings.openLauncher,
                    onPressed: canPop
                        ? context.pop
                        : () => context.go(Routes.launcher),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Text(title, style: AppTextStyles.title)),
                ],
              ),
              const Spacer(),
              const Icon(
                Icons.construction_rounded,
                size: 48,
                color: AppColors.accent,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title,
                style: AppTextStyles.subtitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                AppStrings.placeholderBody,
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                location,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              for (final link in links)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: AppButton(
                    label: link.label,
                    onPressed: () => link.push
                        ? context.push(link.location)
                        : context.go(link.location),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
