import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_motion.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/theme/brand_colors.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/widgets/press_scale.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/favorite_toggle.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_image.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/quantity_stepper.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Product card: photo with a favourite heart, name, price, and an add button
/// that turns into a quantity stepper once the product is in the cart.
/// Tapping anywhere else on the card opens the product; the photo flies to
/// the product page. Shown outside its brand (the hub, favourites), the card
/// names its brand on the photo, since "+" adds to that brand's cart.
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
    this.compact = false,
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

  /// For the narrow cards of home's rows: the price gets its own line, with
  /// the add button or stepper under it, instead of sharing one.
  final bool compact;

  /// The brand's name, on the photo; null inside the brand's own pages.
  final String? brandName;

  @override
  Widget build(BuildContext context) {
    final price = Text(
      context.l10n.formatLei(product.priceBani),
      style: context.textStyles.price,
    );
    final cartControl = AnimatedSwitcher(
      duration: AppMotion.of(context, AppMotion.medium),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween(
            begin: 0.8,
            end: 1.0,
          ).chain(CurveTween(curve: AppMotion.emphasized)).animate(animation),
          alignment: Alignment.centerRight,
          child: child,
        ),
      ),
      // Both sit at the right edge, so the stepper grows out of the add button.
      layoutBuilder: (current, previous) => Stack(
        alignment: Alignment.centerRight,
        children: [...previous, ?current],
      ),
      child: quantity == 0
          ? Padding(
              key: const ValueKey('add'),
              padding: const EdgeInsets.all(QuantityStepper.inset),
              child: RoundIconButton(
                icon: Icons.add_rounded,
                semanticLabel: context.l10n.addToCart(product.name),
                onTap: onAdd,
              ),
            )
          : QuantityStepper(
              key: const ValueKey('stepper'),
              quantity: quantity,
              onIncrement: onAdd,
              onDecrement: onRemove,
              incrementLabel: context.l10n.addToCart(product.name),
              decrementLabel: context.l10n.removeOneFromCart(product.name),
            ),
    );

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
                    ),
                    if (brandName case final brandName?)
                      Positioned(
                        top: AppSpacing.sm,
                        left: AppSpacing.sm,
                        // Leaves room for the heart.
                        right: AppSpacing.sm + 32 + AppSpacing.xs,
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
                      top: AppSpacing.sm,
                      right: AppSpacing.sm,
                      child: FavoriteToggle(
                        productName: product.name,
                        favorite: favorite,
                        onToggle: onToggleFavorite,
                        size: 32,
                      ),
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
                      if (compact) ...[
                        price,
                        const SizedBox(height: AppSpacing.xs),
                        Align(
                          alignment: Alignment.centerRight,
                          child: cartControl,
                        ),
                      ] else
                        Row(
                          children: [
                            Expanded(child: price),
                            cartControl,
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
