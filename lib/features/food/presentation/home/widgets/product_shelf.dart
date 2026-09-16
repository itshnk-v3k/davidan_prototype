import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/press_scale.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/connected_product_card.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// One row of the home screen: a heading with "Vezi mai mult", the site's
/// blurb when there is one, and the products side by side, scrolling
/// sideways. Cards are narrow enough that the next one peeks in at the edge,
/// which is what tells people the row scrolls. With [seeAllLabel] the row
/// ends in a tile that opens the whole list too.
class ProductShelf extends StatelessWidget {
  const ProductShelf({
    super.key,
    required this.id,
    required this.title,
    required this.products,
    required this.onSeeAll,
    this.description,
    this.seeAllLabel,
  });

  /// Tells this row's cards apart from the same product's cards in other rows.
  final String id;
  final String title;
  final List<Product> products;
  final VoidCallback onSeeAll;
  final String? description;
  final String? seeAllLabel;

  /// Two cards and a peek of the third on a 400 px phone.
  static const cardWidth = 152.0;
  static const cardHeight = 256.0;

  @override
  Widget build(BuildContext context) {
    final description = this.description;
    final seeAllLabel = this.seeAllLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.xl,
            AppSpacing.sm,
            0,
          ),
          child: SizedBox(
            height: 32,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: context.textStyles.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: onSeeAll,
                  style: TextButton.styleFrom(
                    foregroundColor: context.colors.primary,
                    textStyle: context.textStyles.bodyStrong,
                  ),
                  child: Text(context.l10n.seeAll),
                ),
              ],
            ),
          ),
        ),
        if (description != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              AppSpacing.xxs,
              AppSpacing.gutter,
              0,
            ),
            child: Text(
              description,
              style: context.textStyles.bodySecondary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: cardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
            itemCount: products.length + (seeAllLabel == null ? 0 : 1),
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) => SizedBox(
              width: cardWidth,
              child: index < products.length
                  ? ConnectedProductCard(
                      product: products[index],
                      heroScope: id,
                      compact: true,
                    )
                  : _SeeAllTile(label: seeAllLabel!, onTap: onSeeAll),
            ),
          ),
        ),
      ],
    );
  }
}

/// The card-sized tile at the end of a category row.
class _SeeAllTile extends StatelessWidget {
  const _SeeAllTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressScale(
      builder: (onHighlightChanged) => Material(
        color: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          side: BorderSide(color: context.colors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onHighlightChanged: onHighlightChanged,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.colors.accentSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: context.colors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  label,
                  style: context.textStyles.bodyStrong,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
