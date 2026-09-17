import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_card.dart';
import 'package:davidan_prototype/data/models/menu_category.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// A brand's categories as square photo tiles, each lifted by a soft shadow
/// with its name underneath.
///
/// With [onMore] (a brand's home) they fit one row: every category when there
/// are up to [maxInRow], otherwise the first ones and a "Mai multe" tile that
/// opens them all. Without it (the categories page, the search filter) they
/// wrap, [perRow] to a row. A [selectedId] tile is outlined in the brand's
/// colour.
class CategoryGrid extends StatelessWidget {
  const CategoryGrid({
    super.key,
    required this.categories,
    required this.onCategoryTap,
    this.onMore,
    this.perRow = 4,
    this.selectedId,
  });

  final List<MenuCategory> categories;
  final ValueChanged<MenuCategory> onCategoryTap;
  final VoidCallback? onMore;
  final int perRow;
  final String? selectedId;

  /// The most tiles a brand home's single row holds.
  static const maxInRow = 5;

  static const _gap = AppSpacing.md;

  @override
  Widget build(BuildContext context) {
    final onMore = this.onMore;
    final List<Widget> tiles;
    final int columns;
    if (onMore == null) {
      tiles = [for (final category in categories) _tileFor(category)];
      columns = perRow;
    } else {
      final overflows = categories.length > maxInRow;
      tiles = [
        for (final category in categories.take(
          overflows ? maxInRow - 1 : maxInRow,
        ))
          _tileFor(category),
        if (overflows)
          CategoryTile(
            label: context.l10n.moreCategories,
            icon: PhosphorIconsBold.dotsThree,
            onTap: onMore,
          ),
      ];
      // A short row keeps the tiles the size they'd have four to a row.
      columns = tiles.length < 4 ? 4 : tiles.length;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var start = 0; start < tiles.length; start += columns)
          Padding(
            padding: EdgeInsets.only(top: start == 0 ? 0 : AppSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = start; index < start + columns; index++) ...[
                  if (index > start) const SizedBox(width: _gap),
                  Expanded(
                    child: index < tiles.length
                        ? tiles[index]
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _tileFor(MenuCategory category) => CategoryTile(
    label: category.name,
    image: category.image,
    selected: category.id == selectedId,
    onTap: () => onCategoryTap(category),
  );
}

/// One square tile with its name underneath: a category's photo, or an
/// [icon] on the brand's tint (the "Mai multe" tile).
class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.label,
    required this.onTap,
    this.image,
    this.icon,
    this.selected = false,
  }) : assert((image == null) != (icon == null), 'Pass an image or an icon');

  final String label;
  final VoidCallback onTap;
  final String? image;
  final IconData? icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final image = this.image;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadii.card),
                  border: selected
                      ? Border.all(color: colors.primary, width: 2.5)
                      : null,
                ),
                child: AppCard(
                  onTap: onTap,
                  color: image == null ? colors.accentSoft : null,
                  child: image == null
                      ? Icon(icon, size: 26, color: colors.primary)
                      : Image.asset(image, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: context.textStyles.label.copyWith(
                color: selected ? colors.primary : null,
              ),
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
