import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_image.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/quantity_stepper.dart';

/// Cart line: photo, name, line total, a quantity stepper and a remove
/// button. Tapping the rest of the card opens the product.
class CartLineTile extends StatelessWidget {
  const CartLineTile({
    super.key,
    required this.product,
    required this.quantity,
    required this.onOpen,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final Product product;
  final int quantity;
  final VoidCallback onOpen;

  /// Null disables the plus button.
  final VoidCallback? onIncrement;

  /// Null disables the minus button. Removing the line is [onRemove]'s job.
  final VoidCallback? onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        side: BorderSide(color: context.colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.md),
                child: SizedBox.square(
                  dimension: 72,
                  child: ProductImage(
                    path: product.image,
                    heroTag: ProductImage.heroTagFor(product.key),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: context.textStyles.bodyStrong,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      formatLei(product.priceBani * quantity),
                      style: context.textStyles.price,
                    ),
                    if (quantity > 1)
                      Text(
                        AppStrings.unitPrice(formatLei(product.priceBani)),
                        style: context.textStyles.caption,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _RemoveButton(
                    semanticLabel: AppStrings.removeFromCart(product.name),
                    onTap: onRemove,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  QuantityStepper(
                    quantity: quantity,
                    onIncrement: onIncrement,
                    onDecrement: onDecrement,
                    incrementLabel: AppStrings.addToCart(product.name),
                    decrementLabel: AppStrings.removeOneFromCart(product.name),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.semanticLabel, required this.onTap});

  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox.square(
            dimension: 32,
            child: Icon(
              Icons.delete_outline_rounded,
              size: 20,
              color: context.colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
