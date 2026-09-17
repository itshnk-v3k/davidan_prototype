import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_motion.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/scale_pop.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The way into [brand]'s cart, at the top right of the brand's pages: a
/// shopping bag with the number of items in the cart. The receipt icon is the
/// Comenzi tab's, so the two never look alike. The cart opens over the
/// screen it was opened from, so back returns there.
class CartButton extends ConsumerWidget {
  const CartButton({super.key, required this.brand});

  final Brand brand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(cartCountProvider(brand));

    return _BagButton(
      count: count,
      semanticLabel: context.l10n.openCart(count),
      onPressed: () => context.push(Routes.brandCart(brand)),
    );
  }
}

/// The way into every brand's cart from the hub's tabs, where no one brand is
/// open: the same shopping bag, counting the items in all the carts, opening
/// the list of carts that have something in them.
class OpenCartsButton extends ConsumerWidget {
  const OpenCartsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(
      openCartsProvider.select(
        (carts) => carts.fold(0, (sum, cart) => sum + cart.count),
      ),
    );

    return _BagButton(
      count: count,
      semanticLabel: context.l10n.openCarts(count),
      onPressed: () => context.push(Routes.openCarts),
    );
  }
}

class _BagButton extends StatelessWidget {
  const _BagButton({
    required this.count,
    required this.semanticLabel,
    required this.onPressed,
  });

  final int count;
  final String semanticLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AppIconButton(
          icon: Icons.shopping_bag_rounded,
          semanticLabel: semanticLabel,
          onPressed: onPressed,
        ),
        // The badge grows in with the first item, bumps each time the count
        // goes up, and shrinks away when the cart empties. This is the
        // "added" feedback from anywhere in the app.
        Positioned(
          top: -AppSpacing.xs,
          right: -AppSpacing.xs,
          child: IgnorePointer(
            child: ExcludeSemantics(
              child: AnimatedSwitcher(
                duration: AppMotion.of(context, AppMotion.medium),
                switchInCurve: AppMotion.emphasized,
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: count > 0
                    ? ScalePop<int>(
                        key: const ValueKey('badge'),
                        value: count,
                        shouldPop: (previous, current) => current > previous,
                        scale: 1.25,
                        child: _Badge(count: count),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      constraints: const BoxConstraints(minWidth: 18),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: context.colors.background, width: 1.5),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: context.textStyles.badge,
      ),
    );
  }
}
