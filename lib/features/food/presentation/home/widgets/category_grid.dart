import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_card.dart';
import 'package:davidan_prototype/data/models/menu_category.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// A brand's categories as square photo tiles, three to a row, each with its
/// name on the photo over a dark fade at the bottom, the way delivery apps
/// show them: the photo and the name share the whole tile, so both read at a
/// glance and a two-line name has room.
///
/// With [onMore] (a brand's home) they fill at most two rows: every category
/// when there are up to [maxOnHome], otherwise the first ones and a "Mai
/// multe" tile that opens them all. Without it (the categories page, the
/// search filter) they all wrap, [perRow] to a row. A [selectedId] tile is
/// outlined in the brand's colour.
class CategoryGrid extends StatelessWidget {
  const CategoryGrid({
    super.key,
    required this.categories,
    required this.onCategoryTap,
    this.onMore,
    this.perRow = 3,
    this.selectedId,
  });

  final List<MenuCategory> categories;
  final ValueChanged<MenuCategory> onCategoryTap;
  final VoidCallback? onMore;
  final int perRow;
  final String? selectedId;

  /// The most tiles a brand home's two rows hold.
  static const maxOnHome = 6;

  static const _gap = AppSpacing.md;

  @override
  Widget build(BuildContext context) {
    final onMore = this.onMore;
    final overflows = onMore != null && categories.length > maxOnHome;
    final tiles = [
      for (final category
          in overflows ? categories.take(maxOnHome - 1) : categories)
        _tileFor(category),
      if (overflows)
        CategoryTile(
          label: context.l10n.moreCategories,
          icon: PhosphorIconsBold.dotsThree,
          onTap: onMore,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var start = 0; start < tiles.length; start += perRow)
          Padding(
            padding: EdgeInsets.only(top: start == 0 ? 0 : _gap),
            child: Row(
              children: [
                for (var index = start; index < start + perRow; index++) ...[
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

/// One square tile with its name in its lower left corner: a category's
/// photo under a dark fade, or an [icon] on the brand's tint (the "Mai multe"
/// tile).
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
    final onPhoto = image != null;
    final scrim = colors.scrim;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: AspectRatio(
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
            color: onPhoto ? null : colors.accentSoft,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (onPhoto) ...[
                  Image.asset(image, fit: BoxFit.cover),
                  // Dark under the name, clear over the upper half.
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          scrim.withValues(alpha: scrim.a * 1.25),
                          scrim.withValues(alpha: scrim.a * 0.6),
                          scrim.withValues(alpha: 0),
                        ],
                        stops: const [0, 0.35, 0.7],
                      ),
                    ),
                  ),
                ] else
                  Align(
                    alignment: const Alignment(0, -0.3),
                    child: Icon(icon, size: 28, color: colors.primary),
                  ),
                Positioned(
                  left: AppSpacing.sm + AppSpacing.xxs,
                  right: AppSpacing.sm,
                  bottom: AppSpacing.sm,
                  child: Text(
                    label,
                    style: context.textStyles.bodyStrong.copyWith(
                      fontSize: 13,
                      height: 1.2,
                      color: onPhoto ? colors.onImage : colors.primary,
                    ),
                    // Three at a large text size on a small phone.
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
