import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/food/presentation/catalog/widgets/category_chips.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/cart_button.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_grid.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The brand's menu, full screen above the hub: products of one of its
/// categories, under its blurb from the brand's site, with chips to switch
/// category in place.
///
/// The selected category lives in the URL (`?category=`), not in a Notifier:
/// the router is its single source of truth, so links and page reloads open
/// the same category.
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

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: context.l10n.menuTitle,
              onBack: () => context.pop(),
              actions: [CartButton(brand: brand)],
            ),
            CategoryChips(
              categories: categories,
              selectedId: category.id,
              onSelected: (selected) => context.replace(
                Routes.brandMenu(brand, categoryId: selected.id),
              ),
            ),
            // The chips' clear margin makes up the rest of the gap.
            const SizedBox(height: AppSpacing.md - AppChip.tapMargin),
            Expanded(
              child: products.isEmpty
                  ? const _EmptyCategory()
                  : CustomScrollView(
                      // A new key per category starts each list at the top.
                      key: ValueKey(category.id),
                      slivers: [
                        if (description != null)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.gutter,
                                0,
                                AppSpacing.gutter,
                                AppSpacing.md,
                              ),
                              child: Text(
                                description,
                                style: context.textStyles.bodySecondary,
                              ),
                            ),
                          ),
                        ProductGrid(
                          products: products,
                          title: context.l10n.productCount(products.length),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
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
