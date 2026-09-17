import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/brand_header_band.dart';
import 'package:davidan_prototype/core/widgets/search_bar_button.dart';
import 'package:davidan_prototype/data/mock/demo_promos.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/category_grid.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/product_shelf.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/promo_banner_carousel.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/promo_cards.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/cart_button.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_grid.dart';
import 'package:davidan_prototype/features/search/presentation/widgets/category_filter_sheet.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// A brand's home, inside Acasă: a header pinned at the top with the way back
/// to the hub and the brand's cart, then the banners, the search field and
/// the category tiles, then a row of the brand's popular
/// products and one row per category, each scrolling sideways with a link to
/// the whole category. The layout of a shop page in Glovo or Yandex Eda: the
/// menu can be browsed without leaving home, and the menu page holds every
/// product.
class BrandHomeScreen extends ConsumerWidget {
  const BrandHomeScreen({super.key, required this.brand});

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

    final info = brandInfos[brand];
    // Demo promos (see demo_promos.dart), each with its category.
    final promos = [
      for (final promo in demoPromos[brand] ?? const <DemoPromo>[])
        if (categories.where((each) => each.id == promo.categoryId).firstOrNull
            case final category?)
          (promo, category),
    ];

    return Scaffold(
      backgroundColor: context.colors.background,
      body: CustomScrollView(
        slivers: [
          // Pinned at the top while everything below scrolls beneath it, so
          // the way back to the hub is always in the same place.
          BrandHeaderBand(
            brand: brand,
            onBack: () => context.pop(),
            actions: [
              if (info != null)
                AppIconButton(
                  icon: PhosphorIconsRegular.info,
                  semanticLabel: context.l10n.openBrandInfo(info.name),
                  onPressed: () => context.push(Routes.brandInfo(brand)),
                ),
              CartButton(brand: brand),
            ],
          ),
          if (banners.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: PromoBannerCarousel(
                  banners: banners,
                  onBannerTap: (banner) {
                    final categoryId = banner.categoryId;
                    if (categoryId != null) {
                      context.push(
                        Routes.brandMenu(brand, categoryId: categoryId),
                      );
                    }
                  },
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.lg,
                AppSpacing.gutter,
                0,
              ),
              child: SearchBarButton(
                hint: context.l10n.searchMenuHint,
                onTap: () => context.push(Routes.brandSearch(brand)),
                filterLabel: context.l10n.filterByCategory,
                onFilter: () async {
                  final choice = await showCategoryFilterSheet(
                    context,
                    brands: [brand],
                  );
                  if (choice == null || !context.mounted) return;
                  unawaited(
                    context.push(
                      Routes.brandSearch(
                        brand,
                        categoryId: choice.category?.categoryId,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // The button beside "Categorii" switches every product row below,
          // and every product list in the app, between cards and wide rows.
          SliverToBoxAdapter(
            child: _SectionTitle(
              context.l10n.categoriesTitle,
              trailing: const ProductLayoutToggle(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.gutter,
              ),
              child: CategoryGrid(
                categories: categories,
                onCategoryTap: (category) => context.push(
                  Routes.brandMenu(brand, categoryId: category.id),
                ),
                onMore: () => context.push(Routes.brandCategories(brand)),
              ),
            ),
          ),
          if (promos.isNotEmpty) ...[
            SliverToBoxAdapter(child: _SectionTitle(context.l10n.offersTitle)),
            SliverToBoxAdapter(
              child: PromoCards(
                promos: promos,
                onOpen: (category) => context.push(
                  Routes.brandMenu(brand, categoryId: category.id),
                ),
              ),
            ),
          ],
          SliverToBoxAdapter(
            child: ProductShelf(
              id: _popularRowId,
              title: context.l10n.popularTitle,
              products: popular,
              onSeeAll: () => context.push(Routes.brandMenu(brand)),
              featured: true,
            ),
          ),
          // Built as they scroll into view.
          SliverList.builder(
            itemCount: categoryRows.length,
            itemBuilder: (context, index) {
              final (:category, :products) = categoryRows[index];
              void openCategory() => context.push(
                Routes.brandMenu(brand, categoryId: category.id),
              );
              return ProductShelf(
                id: category.id,
                title: category.name,
                description: category.description,
                products: products,
                onSeeAll: openCategory,
                seeAllLabel: context.l10n.seeAllProducts(products.length),
              );
            },
          ),
          // Clear of the floating tab bar.
          SliverToBoxAdapter(
            child: SizedBox(
              height: AppSpacing.xl + MediaQuery.paddingOf(context).bottom,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.trailing});

  final String title;

  /// A button at the far right, lined up by its circle.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final trailing = this.trailing;
    // A trailing button takes taps in TapTarget.min. The row grows to that,
    // and the padding gives way, so the title sits where a 32 px row would put
    // it and the button's circle lines up with the content's right edge.
    final growth = trailing == null ? 0.0 : (TapTarget.min - 32) / 2;
    final margin = TapTarget.marginFor(ProductLayoutToggle.size);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.xl - growth,
        trailing == null ? AppSpacing.gutter : AppSpacing.gutter - margin,
        AppSpacing.md - growth,
      ),
      child: SizedBox(
        height: 32 + 2 * growth,
        child: Row(
          children: [
            Expanded(child: Text(title, style: context.textStyles.title)),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
