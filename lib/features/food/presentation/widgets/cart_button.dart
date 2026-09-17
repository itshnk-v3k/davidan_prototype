import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/count_badge.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The way into every brand's cart from the hub's tabs, where no one brand is
/// open, and from a brand that sells nothing (Rent Car, the restaurant),
/// which has no cart bar of its own: a shopping bag counting the items in all
/// the carts, opening the list of carts that have something in them. The
/// receipt icon is the Comenzi tab's, so the two never look alike.
///
/// Inside a brand that sells, the cart is the [CartBar] at the foot of the
/// page instead, and the header carries no bag.
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
          icon: PhosphorIconsRegular.handbag,
          semanticLabel: semanticLabel,
          onPressed: onPressed,
        ),
        // On the circle's corner, inside the button's clear margin.
        if (count > 0)
          Positioned(
            top: TapTarget.iconButtonMargin - AppSpacing.xs,
            right: TapTarget.iconButtonMargin - AppSpacing.xs,
            child: IgnorePointer(
              child: ExcludeSemantics(child: CountBadge(count: count)),
            ),
          ),
      ],
    );
  }
}
