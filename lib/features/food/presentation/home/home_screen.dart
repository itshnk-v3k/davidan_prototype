import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/extra_app.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/brand_logo.dart';
import 'package:davidan_prototype/data/mock/mock_sectors.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/account/application/current_location_notifier.dart';
import 'package:davidan_prototype/features/account/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/food/application/shop_providers.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/category_strip.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/product_shelf.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/promo_banner_carousel.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/cart_button.dart';

/// A brand's home: logo, a location bar pinned at the top, banners and
/// category tiles, then a row of the brand's popular products and one row per
/// category, each scrolling sideways with a link to the whole category. The
/// layout of a shop page in Glovo or Yandex Eda: the menu can be browsed
/// without leaving home, and the Meniu tab still holds every product.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, required this.brand});

  final Brand brand;

  static const _popularRowId = 'popular';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banners = ref.watch(bannersProvider(brand));
    final categories = ref.watch(categoriesProvider(brand));
    final popular = ref.watch(popularProductsProvider(brand));
    final categoryRows = [
      for (final category in categories)
        (
          category: category,
          products: ref.watch(
            productsByCategoryProvider((brand: brand, categoryId: category.id)),
          ),
        ),
    ];
    final pinned = ref.watch(
      currentLocationProvider.select((state) => state.pinned),
    );
    // A location pinned for the next order comes first; the saved choice is
    // back once that order is placed or the pin is dropped.
    final location = pinned != null
        ? (
            icon: Icons.my_location_rounded,
            label: AppStrings.deliverToCurrentLocation,
            value: AppStrings.currentLocationValue(
              AppStrings.areaName(sectorAt(pinned.point)),
            ),
          )
        : switch (ref.watch(fulfilmentChoiceProvider)) {
            HomeDelivery(:final address) => (
              icon: Icons.location_on_rounded,
              label: AppStrings.deliverTo,
              value: address,
            ),
            StorePickup(:final locationId) => (
              icon: Icons.storefront_rounded,
              label: AppStrings.pickupFrom,
              value:
                  ref.watch(locationByIdProvider(locationId))?.name ??
                  locationId,
            ),
            null => (
              icon: Icons.location_on_rounded,
              label: AppStrings.deliverTo,
              value: AppStrings.chooseAddress,
            ),
          };

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _BrandRow(
                brand: brand,
                // Only the staff build has a launcher to go back to.
                onLauncherTap: ref.watch(extraAppsProvider).isEmpty
                    ? null
                    : () => context.go(Routes.launcher),
              ),
            ),
            // Stays at the top while everything below scrolls beneath it, so
            // the address or pickup shop is always one tap away.
            PinnedHeaderSliver(
              child: _LocationBar(
                location: location,
                onTap: () => context.push(Routes.clientLocation),
                onClear: pinned == null
                    ? null
                    : () => ref.read(currentLocationProvider.notifier).clear(),
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
              child: ProductShelf(
                id: _popularRowId,
                title: AppStrings.popularTitle,
                products: popular,
                onSeeAll: () => context.go(Routes.clientMenu),
              ),
            ),
            // Built as they scroll into view.
            SliverList.builder(
              itemCount: categoryRows.length,
              itemBuilder: (context, index) {
                final (:category, :products) = categoryRows[index];
                void openCategory() =>
                    context.go(Routes.clientCategory(category.id));
                return ProductShelf(
                  id: category.id,
                  title: category.name,
                  description: category.description,
                  products: products,
                  onSeeAll: openCategory,
                  seeAllLabel: AppStrings.seeAllProducts(products.length),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          ],
        ),
      ),
    );
  }
}

class _BrandRow extends StatelessWidget {
  const _BrandRow({required this.brand, required this.onLauncherTap});

  final Brand brand;

  /// Null hides the launcher button.
  final VoidCallback? onLauncherTap;

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
          const BrandLogo(height: 26),
          const Spacer(),
          if (onLauncherTap case final onLauncherTap?) ...[
            AppIconButton(
              icon: Icons.apps_rounded,
              semanticLabel: AppStrings.openLauncher,
              onPressed: onLauncherTap,
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          CartButton(brand: brand),
        ],
      ),
    );
  }
}

class _LocationBar extends StatelessWidget {
  const _LocationBar({
    required this.location,
    required this.onTap,
    required this.onClear,
  });

  /// What the bar shows: a pinned current location, the saved choice, or a
  /// prompt to make one.
  final ({IconData icon, String label, String value}) location;
  final VoidCallback onTap;

  /// Drops a pinned current location. Null when none is pinned.
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final onClear = this.onClear;

    // Opaque, so the content scrolling beneath doesn't show through.
    return ColoredBox(
      color: context.colors.background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          AppSpacing.md,
          AppSpacing.gutter,
          AppSpacing.lg,
        ),
        child: Material(
          color: context.colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
            side: BorderSide(color: context.colors.border),
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
                    decoration: BoxDecoration(
                      color: context.colors.accentSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      location.icon,
                      size: 20,
                      color: context.colors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(location.label, style: context.textStyles.caption),
                        Text(
                          location.value,
                          style: context.textStyles.bodyStrong,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (onClear != null)
                    AppIconButton(
                      icon: Icons.close_rounded,
                      semanticLabel: AppStrings.dropCurrentLocation,
                      size: 32,
                      onPressed: onClear,
                    )
                  else
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: context.colors.textSecondary,
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
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.xl,
        AppSpacing.gutter,
        AppSpacing.md,
      ),
      child: SizedBox(
        height: 32,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(title, style: context.textStyles.title),
        ),
      ),
    );
  }
}
