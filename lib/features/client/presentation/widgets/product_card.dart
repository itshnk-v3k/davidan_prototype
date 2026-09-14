import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/product_image.dart';

/// Grid card: photo, name, price, and an add button that turns into a
/// quantity stepper once the product is in the cart.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onTap,
    required this.onAdd,
    required this.onRemove,
  });

  final Product product;
  final int quantity;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

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
              child: ProductImage(path: product.image),
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
                          _RoundButton(
                            icon: Icons.add_rounded,
                            filled: true,
                            semanticLabel: AppStrings.addToCart(product.name),
                            onTap: onAdd,
                          )
                        else
                          _QuantityStepper(
                            productName: product.name,
                            quantity: quantity,
                            onAdd: onAdd,
                            onRemove: onRemove,
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

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.productName,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  final String productName;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RoundButton(
            icon: Icons.remove_rounded,
            filled: false,
            semanticLabel: AppStrings.removeOneFromCart(productName),
            onTap: onRemove,
          ),
          SizedBox(
            width: 20,
            child: Text(
              '$quantity',
              style: AppTextStyles.bodyStrong,
              textAlign: TextAlign.center,
            ),
          ),
          _RoundButton(
            icon: Icons.add_rounded,
            filled: true,
            semanticLabel: AppStrings.addToCart(productName),
            onTap: onAdd,
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.filled,
    required this.semanticLabel,
    required this.onTap,
  });

  final IconData icon;
  final bool filled;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: filled ? AppColors.primary : Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox.square(
            dimension: 32,
            child: Icon(
              icon,
              size: 20,
              color: filled ? AppColors.onPrimary : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
