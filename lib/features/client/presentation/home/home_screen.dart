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
import 'package:davidan_prototype/features/client/application/cart_notifier.dart';
import 'package:davidan_prototype/features/client/application/catalog_providers.dart';
import 'package:davidan_prototype/features/client/presentation/home/widgets/category_strip.dart';
import 'package:davidan_prototype/features/client/presentation/home/widgets/promo_banner_carousel.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/product_grid.dart';

/// Customer home: location bar, banners, categories and popular products.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banners = ref.watch(bannersProvider);
    final categories = ref.watch(categoriesProvider);
    final popular = ref.watch(popularProductsProvider);
    final quantities = ref.watch(cartQuantitiesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _Header(
                onLocationTap: () => context.push(Routes.clientLocation),
                onLauncherTap: () => context.go(Routes.launcher),
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
            ProductGrid(
              products: popular,
              quantities: quantities,
              onOpen: (product) =>
                  context.push(Routes.clientProduct(product.id)),
              onAdd: (product) =>
                  ref.read(cartProvider.notifier).add(product.id),
              onRemove: (product) =>
                  ref.read(cartProvider.notifier).removeOne(product.id),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onLocationTap, required this.onLauncherTap});

  final VoidCallback onLocationTap;
  final VoidCallback onLauncherTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.md,
        AppSpacing.gutter,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
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
          const SizedBox(height: AppSpacing.md),
          Material(
            color: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.md),
              side: const BorderSide(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onLocationTap,
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
                      child: const Icon(
                        Icons.location_on_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.deliverTo,
                            style: AppTextStyles.caption,
                          ),
                          Text(
                            AppStrings.chooseAddress,
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
        ],
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
