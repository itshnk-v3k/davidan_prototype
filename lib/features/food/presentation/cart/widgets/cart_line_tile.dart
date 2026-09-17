import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_image.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/quantity_stepper.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

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
        borderRadius: BorderRadius.circular(AppRadii.card),
        side: BorderSide(color: context.colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        // The bin and the stepper take taps beyond what they show, so the
        // card's padding gives way to their clear margins, and the rest of the
        // card sits where it would without them.
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md - _binMargin,
            AppSpacing.md - _binMargin,
            AppSpacing.md - _stepperOutset,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: _binMargin),
                child: SizedBox.square(
                  dimension: 72,
                  child: ProductImage(
                    path: product.image,
                    heroTag: ProductImage.heroTagFor(product.key),
                    borderRadius: BorderRadius.circular(AppRadii.sm),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: _binMargin),
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
                        context.l10n.formatLei(product.priceBani * quantity),
                        style: context.textStyles.price,
                      ),
                      if (quantity > 1)
                        Text(
                          context.l10n.unitPrice(
                            context.l10n.formatLei(product.priceBani),
                          ),
                          style: context.textStyles.caption,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm - _stepperOutset),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _RemoveButton(
                    semanticLabel: context.l10n.removeFromCart(product.name),
                    onTap: onRemove,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: _binMargin - _stepperOutset,
                    ),
                    child: QuantityStepper(
                      quantity: quantity,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                      incrementLabel: context.l10n.addToCart(product.name),
                      decrementLabel: context.l10n.removeOneFromCart(
                        product.name,
                      ),
                    ),
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

/// The bin's look, 32 dp, inside its [TapTarget.min] tap area.
const _binSize = 32.0;
const _binMargin = (TapTarget.min - _binSize) / 2;

/// How far the stepper's tap area reaches past its pill.
const _stepperOutset = (TapTarget.min - 32) / 2 - QuantityStepper.inset;

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
        type: MaterialType.transparency,
        child: InkResponse(
          onTap: onTap,
          radius: _binSize / 2,
          child: SizedBox.square(
            dimension: TapTarget.min,
            child: Icon(
              PhosphorIconsRegular.trash,
              size: 20,
              color: context.colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
