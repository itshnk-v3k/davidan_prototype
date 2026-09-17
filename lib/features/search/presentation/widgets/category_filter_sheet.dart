import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/theme/brand_colors.dart';
import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/core/widgets/confirm_dialog.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/category_grid.dart';
import 'package:davidan_prototype/features/search/application/search_providers.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Asks which category to search in, on a sheet over the tabs: the same photo
/// tiles as a brand's home, one group per brand of [brands] that has a menu,
/// and "Toate categoriile". Resolves to the choice, as a record whose
/// `category` is null for "Toate categoriile", or null when the sheet is
/// closed without choosing.
Future<({CategoryFilter? category})?> showCategoryFilterSheet(
  BuildContext context, {
  required List<Brand> brands,
  CategoryFilter? selected,
}) {
  final theme = Theme.of(context);
  return showModalBottomSheet<({CategoryFilter? category})>(
    // Over the tab bar too; see phoneNavigatorOf.
    context: phoneNavigatorOf(context).context,
    useRootNavigator: false,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: theme.extension<AppColors>()!.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
    ),
    builder: (_) => Theme(
      data: theme,
      child: _FilterSheet(brands: brands, selected: selected),
    ),
  );
}

class _FilterSheet extends ConsumerWidget {
  const _FilterSheet({required this.brands, required this.selected});

  final List<Brand> brands;
  final CategoryFilter? selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = [
      for (final brand in brands)
        if (ref.watch(categoriesProvider(brand)) case final categories
            when categories.isNotEmpty)
          (brand: brand, categories: categories),
    ];

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.8,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          0,
          AppSpacing.gutter,
          AppSpacing.xl + MediaQuery.viewPaddingOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.filterByCategory,
              style: context.textStyles.title,
            ),
            const SizedBox(height: AppSpacing.md),
            AppChip(
              label: context.l10n.allCategoriesTitle,
              selected: selected == null,
              onTap: () => Navigator.of(context).pop((category: null)),
            ),
            for (final (:brand, :categories) in groups) ...[
              const SizedBox(height: AppSpacing.lg),
              if (groups.length > 1) ...[
                Text(
                  context.content.introOf(brand).name,
                  style: context.textStyles.subtitle.copyWith(
                    color: BrandColors.of(
                      brand,
                      Theme.of(context).brightness,
                    ).primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              BrandTheme(
                brand: brand,
                child: CategoryGrid(
                  categories: categories,
                  selectedId: selected?.brand == brand
                      ? selected?.categoryId
                      : null,
                  onCategoryTap: (category) => Navigator.of(context)
                      .pop((category: (brand: brand, categoryId: category.id))),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
