import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/core/widgets/bottom_bar_space.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/food/presentation/catalog/widgets/category_chips.dart';
import 'package:davidan_prototype/features/food/presentation/home/menu_feed.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/promo_cards.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_grid.dart';
import 'package:davidan_prototype/features/hub/presentation/brand_shell.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// One of a brand's categories, inside Acasă's shell: the bar and the brand
/// switcher stay above it, so a category reads as the feed narrowed rather
/// than a page of its own. Under them, the brand's categories as chips to
/// move between them in place, the category's offer when it has one, and the
/// whole category below, in the layout the customer chose.
///
/// The open category lives in the URL (`?category=`), not in a Notifier: the
/// router is its single source of truth, so links and page reloads open the
/// same category.
class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key, required this.brand, this.categoryId});

  final Brand brand;
  final String? categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider(brand));
    final category = ref.watch(
      catalogCategoryProvider((brand: brand, categoryId: categoryId)),
    );
    final products = ref.watch(
      productsByCategoryProvider((brand: brand, categoryId: category.id)),
    );
    final description = category.description;
    // This category's demo offer, when it has one (see demo_promos.dart).
    final promos = [
      for (final promo in promosOf(ref, brand))
        if (promo.$1.categoryId == category.id) promo,
    ];

    return CustomScrollView(
      // A new key per category starts each list at the top.
      key: ValueKey(category.id),
      slivers: [
        const SliverBrandShellSpace(),
        SliverToBoxAdapter(
          child: CategoryChips(
            categories: categories,
            selectedId: category.id,
            onSelected: (selected) => context.replace(
              Routes.brandMenu(brand, categoryId: selected.id),
            ),
          ),
        ),
        // The chips' clear margin makes up the rest of the gap.
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.md - AppChip.tapMargin),
        ),
        if (description != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                0,
                AppSpacing.gutter,
                AppSpacing.md,
              ),
              child: Text(description, style: context.textStyles.bodySecondary),
            ),
          ),
        if (products.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: const _EmptyCategory(),
          )
        else ...[
          if (promos.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: PromoCards(
                  promos: promos,
                  // The category is already open, so the card leads on to the
                  // product it puts forward rather than back to this page.
                  onOpen: (product) =>
                      context.push(Routes.brandProduct(product.key)),
                ),
              ),
            ),
          ProductGrid(
            products: products,
            title: context.l10n.productCount(products.length),
          ),
        ],
        const SliverBottomBarSpace(),
      ],
    );
  }
}

class _EmptyCategory extends StatelessWidget {
  const _EmptyCategory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Text(
          context.l10n.categoryEmpty,
          style: context.textStyles.bodySecondary,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
