import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_card.dart';
import 'package:davidan_prototype/data/models/menu_category.dart';

/// A brand's categories as square photo tiles, [perRow] to a row, each lifted
/// by a soft shadow with its name underneath. Every category shows at once,
/// with nothing hidden off to the side.
class CategoryGrid extends StatelessWidget {
  const CategoryGrid({
    super.key,
    required this.categories,
    required this.onCategoryTap,
  });

  final List<MenuCategory> categories;
  final ValueChanged<MenuCategory> onCategoryTap;

  static const perRow = 4;
  static const _gap = AppSpacing.md;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var start = 0; start < categories.length; start += perRow)
            Padding(
              padding: EdgeInsets.only(top: start == 0 ? 0 : AppSpacing.lg),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var index = start; index < start + perRow; index++) ...[
                    if (index > start) const SizedBox(width: _gap),
                    Expanded(
                      child: index < categories.length
                          ? _CategoryTile(
                              category: categories[index],
                              onTap: () => onCategoryTap(categories[index]),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ),
        ],
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
    return Semantics(
      button: true,
      label: category.name,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: AppCard(
                onTap: onTap,
                child: Image.asset(category.image, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
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
