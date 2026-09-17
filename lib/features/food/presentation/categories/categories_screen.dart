import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/category_grid.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Every category of a brand, inside Acasă: opened from the "Mai multe" tile
/// when the home's single row can't hold them all. A tile opens its category
/// in the menu.
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key, required this.brand});

  final Brand brand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider(brand));

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: context.l10n.allCategoriesTitle,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  AppSpacing.sm,
                  AppSpacing.gutter,
                  // Clear of the floating tab bar.
                  AppSpacing.xl + MediaQuery.paddingOf(context).bottom,
                ),
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
        ),
      ),
    );
  }
}
