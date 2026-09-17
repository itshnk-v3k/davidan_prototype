import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/theme/brand_colors.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/favorite_toggle.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_image.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/quantity_stepper.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Product card: photo with a favourite heart and, in its lower corner, an add
/// button that turns into a quantity stepper once the product is in the cart;
/// then the name and the price. Over the photo, the stepper never has to share
/// the narrow card's width with the price. Tapping anywhere else on the card
/// opens the product; the photo flies to the product page. Shown outside its
/// brand (the hub, favourites), the card names its brand on the photo, since
/// "+" adds to that brand's cart.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.favorite,
    required this.onTap,
    required this.onAdd,
    required this.onRemove,
    required this.onToggleFavorite,
    this.heroScope,
    this.brandName,
  });

  final Product product;
  final int quantity;
  final bool favorite;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onToggleFavorite;

  /// See [ProductImage.heroTagFor].
  final String? heroScope;

  /// The brand's name, on the photo; null inside the brand's own pages.
  final String? brandName;

  @override
  Widget build(BuildContext context) {
    // Both sit at the right edge, so the stepper's plus is exactly where the
    // add button was.
    final cartControl = quantity == 0
        ? RoundIconButton(
            icon: Icons.add_rounded,
            semanticLabel: context.l10n.addToCart(product.name),
            onTap: onAdd,
          )
        : QuantityStepper(
            quantity: quantity,
            onIncrement: onAdd,
            onDecrement: onRemove,
            incrementLabel: context.l10n.addToCart(product.name),
            decrementLabel: context.l10n.removeOneFromCart(product.name),
            raised: true,
          );
    // The heart and the add button look this far from the photo's edges; their
    // clear tap margins reach to the edges.
    const photoInset = AppSpacing.sm;
    const controlSize = 32.0;
    const controlOffset = photoInset - (TapTarget.min - controlSize) / 2;

    return Material(
      color: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        side: BorderSide(color: context.colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1.15,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ProductImage(
                    path: product.image,
                    heroTag: ProductImage.heroTagFor(
                      product.key,
                      scope: heroScope,
                    ),
                    // The card's own top corners.
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadii.lg),
                    ),
                  ),
                  if (brandName case final brandName?)
                    Positioned(
                      top: AppSpacing.sm,
                      left: AppSpacing.sm,
                      // Leaves room for the heart.
                      right: photoInset + controlSize + AppSpacing.xs,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: _BrandTag(
                          name: brandName,
                          color: BrandColors.of(
                            product.key.brand,
                            Theme.of(context).brightness,
                          ).primary,
                        ),
                      ),
                    ),
                  Positioned(
                    top: controlOffset,
                    right: controlOffset,
                    child: FavoriteToggle(
                      productName: product.name,
                      favorite: favorite,
                      onToggle: onToggleFavorite,
                      size: controlSize,
                    ),
                  ),
                  Positioned(
                    right: controlOffset,
                    bottom: controlOffset,
                    child: cartControl,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.sm,
                  AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: context.textStyles.bodyStrong,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      context.l10n.formatLei(product.priceBani),
                      style: context.textStyles.price,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A brand's name in its colour, on a pill that stays readable over any photo.
class _BrandTag extends StatelessWidget {
  const _BrandTag({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          name,
          style: context.textStyles.label.copyWith(color: color),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
