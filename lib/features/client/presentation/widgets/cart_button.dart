import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_motion.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/scale_pop.dart';
import 'package:davidan_prototype/features/client/application/cart_notifier.dart';

/// The way into the cart, at the top right of the customer tabs: a receipt
/// icon with the number of items in the cart. The cart opens over the tabs,
/// so back returns to the tab it was opened from.
class CartButton extends ConsumerWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(cartCountProvider);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AppIconButton(
          icon: Icons.receipt_long_rounded,
          semanticLabel: AppStrings.openCart(count),
          onPressed: () => context.push(Routes.clientCart),
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
