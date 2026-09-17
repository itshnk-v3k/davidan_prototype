import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/brand_header_band.dart';
import 'package:davidan_prototype/core/widgets/search_bar_button.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/category_strip.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/product_shelf.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/promo_banner_carousel.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/cart_button.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// A brand's home, inside Acasă: a header pinned at the top with the way back
/// to the hub and the brand's cart, the banners across its lower edge, the
/// search field and category tiles, then a row of the brand's popular
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

    return Scaffold(
      backgroundColor: context.colors.background,
      body: CustomScrollView(
        slivers: [
          // Pinned at the top while everything below scrolls beneath it, so
          // the way back to the hub is always in the same place. The banners
          // sit across its lower edge.
          BrandHeaderBand(
            brand: brand,
            onBack: () => context.pop(),
            actions: [
              if (info != null)
                AppIconButton(
                  icon: Icons.info_rounded,
                  semanticLabel: context.l10n.openBrandInfo(info.name),
                  onPressed: () => context.push(Routes.brandInfo(brand)),
                ),
              CartButton(brand: brand),
            ],
            overlap: banners.isEmpty
                ? null
                : PromoBannerCarousel(
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
            overlapHeight: PromoBannerCarousel.height,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.md,
                AppSpacing.gutter,
                0,
              ),
              child: SearchBarButton(
                hint: context.l10n.searchMenuHint,
                onTap: () => context.push(Routes.brandSearch(brand)),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _SectionTitle(context.l10n.categoriesTitle),
          ),
          SliverToBoxAdapter(
            child: CategoryStrip(
              categories: categories,
              onCategoryTap: (category) => context.push(
                Routes.brandMenu(brand, categoryId: category.id),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ProductShelf(
              id: _popularRowId,
              // "Produse DaviDan" is davidan.md's own heading; the sushi
              // site has none, so its row gets a plain one.
              title: brand == Brand.bakery
                  ? context.l10n.popularTitle
                  : context.l10n.popularTitlePlain,
              products: popular,
              onSeeAll: () => context.push(Routes.brandMenu(brand)),
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
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
        ],
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
