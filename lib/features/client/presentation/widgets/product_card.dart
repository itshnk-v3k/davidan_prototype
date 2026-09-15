import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/favorite_toggle.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/product_image.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/quantity_stepper.dart';

/// Grid card: photo with a favourite heart, name, price, and an add button
/// that turns into a quantity stepper once the product is in the cart.
/// Tapping anywhere else on the card opens the product.
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
  });

  final Product product;
  final int quantity;
  final bool favorite;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        side: const BorderSide(color: AppColors.border),
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
                  ProductImage(path: product.image),
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
                      style: AppTextStyles.bodyStrong,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            formatLei(product.priceBani),
                            style: AppTextStyles.price,
                          ),
                        ),
                        if (quantity == 0)
                          RoundIconButton(
                            icon: Icons.add_rounded,
                            semanticLabel: AppStrings.addToCart(product.name),
                            onTap: onAdd,
                          )
                        else
                          QuantityStepper(
                            quantity: quantity,
                            onIncrement: onAdd,
                            onDecrement: onRemove,
                            incrementLabel: AppStrings.addToCart(product.name),
                            decrementLabel: AppStrings.removeOneFromCart(
                              product.name,
                            ),
                          ),
                      ],
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
