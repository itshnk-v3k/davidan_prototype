import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The brand's cart as a bar across the foot of its browse screens, the way
/// the delivery apps the client picked out carry one: the bag with how many
/// items are in it and the running total, tapped to open the cart. It is
/// there as long as the brand's cart holds something, while the feed and its
/// categories scroll under it, and gone the moment the cart is emptied.
///
/// It does the job the bag in the header used to do, which is why the header
/// of a brand that sells no longer carries one ([BrandShell]). Every brand
/// has its own cart, so the bar shows the open brand's.
///
/// It reads [cartCountProvider] and [cartTotalProvider], the same two the cart
/// screen and the badges read, and keeps no count of its own: there is one
/// cart, and this is a view of it.
///
/// It floats above the tab bar rather than replacing it: the tabs are how the
/// customer leaves the brand, so they stay reachable. [space] is the room a
/// screen under it leaves at the end of its content; [BrandShell] adds that to
/// the bottom padding its pages already leave for the tab bar.
class CartBar extends ConsumerWidget {
  const CartBar({super.key, required this.brand});

  final Brand brand;

  /// The bar itself, as tall as the buttons at the foot of the task screens.
  static const height = 52.0;

  /// The bar and the gap under it, between it and the tab bar.
  static const space = height + AppSpacing.sm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(cartCountProvider(brand));
    final total = ref.watch(cartTotalProvider(brand));
    if (count == 0) return const SizedBox.shrink();
    final colors = context.colors;
    final radius = BorderRadius.circular(AppRadii.md);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
      child: Semantics(
        button: true,
        label: context.l10n.openCart(count),
        excludeSemantics: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: colors.primary,
            borderRadius: radius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.push(Routes.brandCart(brand)),
              child: SizedBox(
                height: height,
                child: Stack(
                  children: [
                    // Centred on the bar, not after the bag, so the total sits
                    // where the buttons on the screens below carry theirs.
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xxl + AppSpacing.md,
                        ),
                        child: Text(
                          context.l10n.cartBarTotal(
                            context.l10n.formatLei(total),
                          ),
                          style: context.textStyles.button.copyWith(
                            color: colors.onPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Positioned(
                      left: AppSpacing.lg,
                      top: 0,
                      bottom: 0,
                      child: Center(child: _Bag(count: count)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The shopping bag with how many items are in the cart on its corner: the
/// header's bag and its badge, in the colours of the bar it sits on.
class _Bag extends StatelessWidget {
  const _Bag({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(PhosphorIconsRegular.handbag, size: 24, color: colors.onPrimary),
        Positioned(
          top: -AppSpacing.sm,
          left: AppSpacing.md,
          child: Container(
            height: 18,
            constraints: const BoxConstraints(minWidth: 18),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.onPrimary,
              borderRadius: BorderRadius.circular(AppRadii.pill),
            ),
            child: Text(
              count > 99 ? '99+' : '$count',
              style: context.textStyles.badge.copyWith(color: colors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
