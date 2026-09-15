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
import 'package:davidan_prototype/features/launcher/application/demo_reset_notifier.dart';

/// Entry point of the prototype: pick which part of the system to show.
class DemoLauncherScreen extends ConsumerWidget {
  const DemoLauncherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            _RoleCard(
              icon: Icons.shopping_bag_rounded,
              title: AppStrings.launcherClient,
              hint: AppStrings.launcherClientHint,
              onTap: () => context.go(Routes.clientSplash),
            ),
            _RoleCard(
              icon: Icons.delivery_dining_rounded,
              title: AppStrings.launcherCourier,
              hint: AppStrings.launcherCourierHint,
              onTap: () => context.go(Routes.courierOrders),
            ),
            _RoleCard(
              icon: Icons.storefront_rounded,
              title: AppStrings.launcherKds,
              hint: AppStrings.launcherKdsHint,
              onTap: () => context.go(Routes.kds),
            ),
            // Only when the entry point registers demo tools (main_demo.dart).
            for (final tool in ref.watch(demoToolsProvider))
              _RoleCard(
                icon: tool.icon,
                title: tool.title,
                hint: tool.hint,
                onTap: () => context.go(tool.route.path),
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

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.hint,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          side: const BorderSide(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(AppRadii.md),
                  ),
                  child: Icon(icon, color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.subtitle),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(hint, style: AppTextStyles.bodySecondary),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
