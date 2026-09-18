import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/data/mock/demo_promos.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/category_grid.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/product_shelf.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/promo_banner_carousel.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/promo_cards.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_grid.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// A brand with a menu (the patisserie, the sushi), inside Acasă's shell: the
/// site's banners, the demo offers, the category tiles, the brand's popular
/// products as big cards, and then one row per category, each with a link to
/// the whole category, under the switch between cards and rows that they
/// follow. The layout of a shop page in Glovo or Yandex Eda: the menu can be
/// browsed without leaving home, and a category page holds all of it.
///
/// Search is not in the page: the magnifier in the shell's bar above is the
/// one way in, and it is on screen wherever the customer is in the brand,
/// where a field under the banners would scroll away. The filter that stood
/// beside that field is on the search screen itself.
class MenuFeed extends ConsumerWidget {
  const MenuFeed({super.key, required this.brand});

  final Brand brand;

  static const popularRowId = 'popular';

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
    final promos = promosOf(ref, brand);

    return SliverMainAxisGroup(
      slivers: [
        if (banners.isNotEmpty)
          SliverToBoxAdapter(
            child: PromoBannerCarousel(
              banners: banners,
              onBannerTap: (banner) {
                final categoryId = banner.categoryId;
                if (categoryId != null) {
                  context.push(Routes.brandMenu(brand, categoryId: categoryId));
                }
              },
            ),
          ),
        // The offers ride with the banners above the menu itself, so the ads
        // are one block rather than two apart.
        if (promos.isNotEmpty) ...[
          SliverToBoxAdapter(child: SectionTitle(context.l10n.offersTitle)),
          SliverToBoxAdapter(
            child: PromoCards(
              promos: promos,
              onOpen: (product) =>
                  context.push(Routes.brandProduct(product.key)),
            ),
          ),
        ],
        SliverToBoxAdapter(child: SectionTitle(context.l10n.categoriesTitle)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
            child: CategoryGrid(
              categories: categories,
              onCategoryTap: (category) => context.push(
                Routes.brandMenu(brand, categoryId: category.id),
              ),
              onMore: () => context.push(Routes.brandCategories(brand)),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: ProductShelf(
            id: popularRowId,
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
            final shelf = ProductShelf(
              id: category.id,
              title: category.name,
              description: category.description,
              products: products,
              onSeeAll: () => context.push(
                Routes.brandMenu(brand, categoryId: category.id),
              ),
              seeAllLabel: context.l10n.seeAllProducts(products.length),
              // Close under the switch above the first row.
              topPadding: index == 0 ? AppSpacing.sm : AppSpacing.xl,
            );
            if (index > 0) return shelf;
            // Once, above the category rows: cards or wide rows, for these
            // rows and every product list in the app. The popular row above
            // always keeps its big cards.
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    AppSpacing.xl,
                    AppSpacing.gutter,
                    0,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ProductLayoutSwitch(),
                  ),
                ),
                shelf,
              ],
            );
          },
        ),
      ],
    );
  }
}

/// [brand]'s demo promos (see demo_promos.dart), each with the product it puts
/// forward, and only for a product the brand still sells.
List<(DemoPromo, Product)> promosOf(WidgetRef ref, Brand brand) {
  final byId = ref.watch(productsByIdProvider(brand));
  return [
    for (final promo in demoPromos[brand] ?? const <DemoPromo>[])
      if (byId[promo.productId] case final product?) (promo, product),
  ];
}

/// A heading above one of a feed's blocks.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key});

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
