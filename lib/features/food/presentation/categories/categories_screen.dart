import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/food/presentation/home/menu_feed.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/category_grid.dart';
import 'package:davidan_prototype/features/hub/presentation/brand_shell.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Every category of a brand, inside Acasă's shell: opened from the "Mai
/// multe" tile when the feed's two rows can't hold them all. A tile opens its
/// category.
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key, required this.brand});

  final Brand brand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider(brand));

    return CustomScrollView(
      slivers: [
        const SliverBrandShellSpace(),
        SliverToBoxAdapter(
          child: SectionTitle(context.l10n.allCategoriesTitle),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            0,
            AppSpacing.gutter,
            // Clear of the floating tab bar.
            AppSpacing.xl + MediaQuery.paddingOf(context).bottom,
          ),
          sliver: SliverToBoxAdapter(
            child: CategoryGrid(
              categories: categories,
              perRow: 3,
              onCategoryTap: (category) => context.push(
                Routes.brandMenu(brand, categoryId: category.id),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
