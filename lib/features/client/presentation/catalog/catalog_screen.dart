import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/features/client/application/catalog_providers.dart';
import 'package:davidan_prototype/features/client/presentation/catalog/widgets/category_chips.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/cart_button.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/product_grid.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';

/// Products of one category, under its davidan.md blurb, with chips to switch
/// category in place.
///
/// The selected category lives in the URL (`?category=`), not in a Notifier:
/// the router is its single source of truth, so links and page reloads open
/// the same category.
class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key, this.categoryId});

  final String? categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final category = ref.watch(catalogCategoryProvider(categoryId));
    final products = ref.watch(productsByCategoryProvider(category.id));
    final description = category.description;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ScreenHeader(
              title: AppStrings.menuTitle,
              actions: [CartButton()],
            ),
            CategoryChips(
              categories: categories,
              selectedId: category.id,
              onSelected: (selected) =>
                  context.go(Routes.clientCategory(selected.id)),
            ),
            const SizedBox(height: AppSpacing.md),
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
                        ProductGrid(products: products),
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
          AppStrings.categoryEmpty,
          style: context.textStyles.bodySecondary,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
