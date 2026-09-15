import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/demo_tool.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_assets.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/link_card.dart';
import 'package:davidan_prototype/features/launcher/application/demo_reset_notifier.dart';

/// Entry point of the prototype: pick which part of the system to show.
class DemoLauncherScreen extends ConsumerWidget {
  const DemoLauncherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roles = [
      (
        icon: Icons.shopping_bag_rounded,
        title: AppStrings.launcherClient,
        hint: AppStrings.launcherClientHint,
        location: Routes.clientSplash,
      ),
      (
        icon: Icons.delivery_dining_rounded,
        title: AppStrings.launcherCourier,
        hint: AppStrings.launcherCourierHint,
        location: Routes.courierOrders,
      ),
      (
        icon: Icons.storefront_rounded,
        title: AppStrings.launcherKds,
        hint: AppStrings.launcherKdsHint,
        location: Routes.kds,
      ),
      // Only when the entry point registers demo tools (main_demo.dart).
      for (final tool in ref.watch(demoToolsProvider))
        (
          icon: tool.icon,
          title: tool.title,
          hint: tool.hint,
          location: tool.route.path,
        ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            const SizedBox(height: AppSpacing.lg),
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(AppAssets.logo, height: 32),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const Text(AppStrings.launcherTitle, style: AppTextStyles.display),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              AppStrings.launcherSubtitle,
              style: AppTextStyles.bodySecondary,
            ),
            const SizedBox(height: AppSpacing.xl),
            for (final role in roles)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: LinkCard(
                  icon: role.icon,
                  title: role.title,
                  hint: role.hint,
                  onTap: () => context.go(role.location),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: AppStrings.resetDemoData,
              icon: Icons.restart_alt_rounded,
              variant: AppButtonVariant.secondary,
              onPressed: () async {
                await ref.read(demoResetProvider.notifier).reset();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppStrings.resetDemoDataDone)),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text(
              AppStrings.launcherFooter,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
