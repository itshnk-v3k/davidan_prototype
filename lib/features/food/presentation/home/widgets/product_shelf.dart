import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_card.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/connected_product_card.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_card.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// One row of products: a heading with "Vezi mai mult" (when there is a list
/// to open), the site's blurb when there is one, and the products side by
/// side, scrolling sideways. Cards are narrow enough that the next one peeks
/// in at the edge, which is what tells people the row scrolls. With
/// [seeAllLabel] the row ends in a tile that opens the whole list too.
class ProductShelf extends StatelessWidget {
  const ProductShelf({
    super.key,
    required this.id,
    required this.title,
    required this.products,
    this.onSeeAll,
    this.description,
    this.seeAllLabel,
    this.showBrand = false,
  }) : assert(
         seeAllLabel == null || onSeeAll != null,
         'The end tile needs onSeeAll',
       );

  /// Tells this row's cards apart from the same product's cards in other rows.
  final String id;
  final String title;
  final List<Product> products;

  /// Null for a row with no whole list behind it, like the hub's mix of
  /// brands: no "Vezi mai mult".
  final VoidCallback? onSeeAll;
  final String? description;
  final String? seeAllLabel;

  /// For a row mixing brands: see [ConnectedProductCard.showBrand].
  final bool showBrand;

  /// Two cards and a peek of the third on a 400 px phone, wide enough for the
  /// price beside the stepper.
  static const cardWidth = 168.0;

  /// Below the cards, for their shadows.
  static const _shadowRoom = AppCard.shadowReach;

  @override
  Widget build(BuildContext context) {
    final description = this.description;
    final seeAllLabel = this.seeAllLabel;
    final onSeeAll = this.onSeeAll;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // "Vezi mai mult" takes taps in TapTarget.min. The row is that tall, and
        // the padding above and the blurb below give way to it, so the title,
        // the blurb and the cards sit where a 32 px row would put them.
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.xl - _titleRowGrowth / 2,
            AppSpacing.sm,
            0,
          ),
          child: SizedBox(
            height: TapTarget.min,
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
                if (onSeeAll != null)
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
            child: Transform.translate(
              offset: const Offset(0, -_titleRowGrowth / 2),
              child: Text(
                description,
                style: context.textStyles.bodySecondary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.md - _titleRowGrowth / 2),
        SizedBox(
          height: ProductCard.heightFor(context, cardWidth) + _shadowRoom,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            // The cards' shadows reach past the row's ends.
            clipBehavior: Clip.none,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              0,
              AppSpacing.gutter,
              _shadowRoom,
            ),
            itemCount: products.length + (seeAllLabel == null ? 0 : 1),
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) => SizedBox(
              width: cardWidth,
              child: index < products.length
                  ? ConnectedProductCard(
                      product: products[index],
                      heroScope: id,
                      showBrand: showBrand,
                    )
                  : _SeeAllTile(label: seeAllLabel!, onTap: onSeeAll!),
            ),
          ),
        ),
      ],
    );
  }
}

/// How much taller the title row is than the 32 px it looks.
const _titleRowGrowth = TapTarget.min - 32;

/// The card-sized tile at the end of a category row.
class _SeeAllTile extends StatelessWidget {
  const _SeeAllTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
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
                PhosphorIconsRegular.arrowRight,
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
    );
  }
}
