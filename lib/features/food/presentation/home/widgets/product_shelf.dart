import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_card.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/food/application/product_layout_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/connected_product_card.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_card.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// One row of products: a heading with "Vezi mai mult" (when there is a list
/// to open), the site's blurb when there is one, and the products.
///
/// They follow the saved [ProductLayout]: with cards, side by side and
/// scrolling sideways, narrow enough that the next one peeks in at the edge
/// (which is what tells people the row scrolls), ending in a tile that opens
/// the whole list when there's a [seeAllLabel]; as a list, the first
/// [listPreview] products as wide rows, then that same link. A [featured] row
/// keeps its cards and its sideways scroll whatever the layout, and has no end
/// tile: it is a handful picked out, not a list to walk through.
class ProductShelf extends ConsumerWidget {
  const ProductShelf({
    super.key,
    required this.id,
    required this.title,
    required this.products,
    this.onSeeAll,
    this.description,
    this.seeAllLabel,
    this.showBrand = false,
    this.featured = false,
    this.topPadding = AppSpacing.xl,
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

  /// The popular row: the same cards as every other row (the "Popular Dishes"
  /// of the apps the client picked out), but always as cards.
  final bool featured;

  /// Above the heading: less for a row right under something that belongs to
  /// it, like the switch between cards and rows.
  final double topPadding;

  /// How many products a row shows as a list.
  static const listPreview = 3;

  /// Two cards and a good peek of the third on a 400 px phone, wide enough
  /// for the price beside the stepper.
  static const cardWidth = 152.0;

  /// Below the cards, for their shadows.
  static const _shadowRoom = AppCard.shadowReach;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(productLayoutProvider);
    final description = this.description;
    final seeAllLabel = this.seeAllLabel;
    final onSeeAll = this.onSeeAll;
    final names = [for (final product in products) product.name];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // "Vezi mai mult" takes taps in TapTarget.min. The row is at least that
        // tall, and the padding above and the blurb below give way to it, so
        // the title, the blurb and the cards sit where a 32 px row would put
        // them.
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            topPadding - _titleRowGrowth / 2,
            AppSpacing.sm,
            0,
          ),
          // A long heading (a Russian one at a large text size) wraps to a
          // second line rather than being cut off.
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: TapTarget.min),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: context.textStyles.title,
                    maxLines: 2,
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
        if (!featured && layout == ProductLayout.list)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (index, product)
                    in products.take(listPreview).indexed) ...[
                  if (index > 0) const SizedBox(height: AppSpacing.md),
                  ConnectedProductCard(
                    product: product,
                    heroScope: id,
                    showBrand: showBrand,
                    style: ProductTileStyle.listTile,
                  ),
                ],
                if (seeAllLabel != null && products.length > listPreview)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: TextButton(
                      onPressed: onSeeAll,
                      style: TextButton.styleFrom(
                        foregroundColor: context.colors.primary,
                        textStyle: context.textStyles.bodyStrong,
                        minimumSize: const Size.fromHeight(TapTarget.min),
                      ),
                      child: Text(seeAllLabel),
                    ),
                  ),
              ],
            ),
          )
        else
          SizedBox(
            height:
                ProductCard.heightFor(context, cardWidth, names: names) +
                _shadowRoom,
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
              itemCount:
                  products.length + (seeAllLabel == null || featured ? 0 : 1),
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) => SizedBox(
                width: cardWidth,
                child: index >= products.length
                    ? _SeeAllTile(label: seeAllLabel!, onTap: onSeeAll!)
                    : ConnectedProductCard(
                        product: products[index],
                        heroScope: id,
                        showBrand: showBrand,
                        style: ProductTileStyle.card,
                      ),
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
