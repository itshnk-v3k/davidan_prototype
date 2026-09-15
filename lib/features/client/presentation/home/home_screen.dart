import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_assets.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/client/application/catalog_providers.dart';
import 'package:davidan_prototype/features/client/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/features/client/presentation/home/widgets/category_strip.dart';
import 'package:davidan_prototype/features/client/presentation/home/widgets/promo_banner_carousel.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/product_grid.dart';

/// Customer home: logo, a location bar pinned at the top, banners,
/// categories and popular products.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banners = ref.watch(bannersProvider);
    final categories = ref.watch(categoriesProvider);
    final popular = ref.watch(popularProductsProvider);
    final location = switch (ref.watch(fulfilmentChoiceProvider)) {
      HomeDelivery(:final address) => (
        icon: Icons.location_on_rounded,
        label: AppStrings.deliverTo,
        value: address,
      ),
      StorePickup(:final locationId) => (
        icon: Icons.storefront_rounded,
        label: AppStrings.pickupFrom,
        value: ref.watch(locationByIdProvider(locationId))?.name ?? locationId,
      ),
      null => (
        icon: Icons.location_on_rounded,
        label: AppStrings.deliverTo,
        value: AppStrings.chooseAddress,
      ),
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _BrandRow(
                onLauncherTap: () => context.go(Routes.launcher),
              ),
            ),
            // Stays at the top while everything below scrolls beneath it, so
            // the address or pickup shop is always one tap away.
            PinnedHeaderSliver(
              child: _LocationBar(
                location: location,
                onTap: () => context.push(Routes.clientLocation),
              ),
            ),
            SliverToBoxAdapter(
              child: PromoBannerCarousel(
                banners: banners,
                onBannerTap: (banner) {
                  final categoryId = banner.categoryId;
                  if (categoryId != null) {
                    context.go(Routes.clientCategory(categoryId));
                  }
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: _SectionTitle(AppStrings.categoriesTitle),
            ),
            SliverToBoxAdapter(
              child: CategoryStrip(
                categories: categories,
                onCategoryTap: (category) =>
                    context.go(Routes.clientCategory(category.id)),
              ),
            ),
            SliverToBoxAdapter(
              child: _SectionTitle(
                AppStrings.popularTitle,
                actionLabel: AppStrings.seeAll,
                onAction: () => context.go(Routes.clientMenu),
              ),
            ),
            ProductGrid(products: popular),
          ],
        ),
      ),
    );
  }
}

class _BrandRow extends StatelessWidget {
  const _BrandRow({required this.onLauncherTap});

  final VoidCallback onLauncherTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.md,
        AppSpacing.gutter,
        0,
      ),
      child: Row(
        children: [
          Image.asset(AppAssets.logo, height: 26),
          const Spacer(),
          AppIconButton(
            icon: Icons.apps_rounded,
            semanticLabel: AppStrings.openLauncher,
            onPressed: onLauncherTap,
          ),
        ],
      ),
    );
  }
}

class _LocationBar extends StatelessWidget {
  const _LocationBar({required this.location, required this.onTap});

  /// What the bar shows: the saved choice, or a prompt to make one.
  final ({IconData icon, String label, String value}) location;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Opaque, so the content scrolling beneath doesn't show through.
    return ColoredBox(
      color: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          AppSpacing.md,
          AppSpacing.gutter,
          AppSpacing.lg,
        ),
        child: Material(
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
            side: const BorderSide(color: AppColors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xxs),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.accentSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      location.icon,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(location.label, style: AppTextStyles.caption),
                        Text(
                          location.value,
                          style: AppTextStyles.bodyStrong,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final actionLabel = this.actionLabel;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.xl,
        AppSpacing.sm,
        AppSpacing.md,
      ),
      child: SizedBox(
        height: 32,
        child: Row(
          children: [
            Expanded(child: Text(title, style: AppTextStyles.title)),
            if (actionLabel != null)
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  textStyle: AppTextStyles.bodyStrong,
                ),
                child: Text(actionLabel),
              ),
          ],
        ),
      ),
    );
  }
}
