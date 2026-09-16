import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_motion.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/application/product_quantity_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/cart/widgets/cart_line_tile.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/total_bar.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// One brand's cart, opened over the tabs by their cart button: every line
/// with a quantity stepper, the running total and the way on to checkout.
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key, required this.brand});

  final Brand brand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lines = ref.watch(cartLinesProvider(brand));
    final total = ref.watch(cartTotalProvider(brand));
    CartNotifier cart() => ref.read(cartProvider(brand).notifier);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: context.l10n.cartTitle,
              // Opened straight from a link, there's nothing to go back to.
              onBack: () => context.canPop()
                  ? context.pop()
                  : context.go(Routes.clientHome),
            ),
            Expanded(
              // Removing the last line crossfades to the empty state.
              child: AnimatedSwitcher(
                duration: AppMotion.of(context, AppMotion.medium),
                child: lines.isEmpty
                    ? EmptyState(
                        key: const ValueKey('empty'),
                        icon: Icons.shopping_bag_outlined,
                        title: context.l10n.cartEmptyTitle,
                        message: context.l10n.cartEmptyMessage,
                        actionLabel: context.l10n.browseMenu,
                        onAction: () => context.go(Routes.clientMenu),
                      )
                    : ListView.separated(
                        key: const ValueKey('lines'),
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.gutter,
                          0,
                          AppSpacing.gutter,
                          AppSpacing.lg,
                        ),
                        itemCount: lines.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final (:product, :quantity, priceBani: _) =
                              lines[index];
                          return CartLineTile(
                            product: product,
                            quantity: quantity,
                            onOpen: () =>
                                context.push(Routes.brandProduct(product.key)),
                            onIncrement: quantity < ProductQuantityNotifier.max
                                ? () => cart().add(product.id)
                                : null,
                            onDecrement: quantity > 1
                                ? () => cart().removeOne(product.id)
                                : null,
                            onRemove: () => cart().remove(product.id),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: lines.isEmpty
          ? null
          : TotalBar(
              totalBani: total,
              actionLabel: context.l10n.continueOrder,
              onAction: () => context.push(Routes.brandCheckout(brand)),
            ),
    );
  }
}
