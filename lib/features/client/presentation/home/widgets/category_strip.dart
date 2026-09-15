import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/data/models/menu_category.dart';

/// Horizontally scrolling row of category tiles.
class CategoryStrip extends StatelessWidget {
  const CategoryStrip({
    super.key,
    required this.categories,
    required this.onCategoryTap,
  });

  final List<MenuCategory> categories;
  final ValueChanged<MenuCategory> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 116,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) => _CategoryTile(
          category: categories[index],
          onTap: () => onCategoryTap(categories[index]),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});

  final MenuCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.lg),
              child: SizedBox.square(
                dimension: 72,
                child: Image.asset(category.image, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: AppSpacing.xs + AppSpacing.xxs),
            Text(
              category.name,
              style: context.textStyles.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
