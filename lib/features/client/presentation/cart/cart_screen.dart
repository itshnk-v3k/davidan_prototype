import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/features/client/application/cart_notifier.dart';
import 'package:davidan_prototype/features/client/application/product_quantity_notifier.dart';
import 'package:davidan_prototype/features/client/presentation/cart/widgets/cart_line_tile.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/tab_header.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/total_bar.dart';

/// Cart tab: every line with a quantity stepper, the running total and the
/// way on to checkout.
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lines = ref.watch(cartLinesProvider);
    final total = ref.watch(cartTotalProvider);
    CartNotifier cart() => ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TabHeader(title: AppStrings.cartTitle),
            Expanded(
              child: lines.isEmpty
                  ? EmptyState(
                      icon: Icons.shopping_bag_outlined,
                      title: AppStrings.cartEmptyTitle,
                      message: AppStrings.cartEmptyMessage,
                      actionLabel: AppStrings.browseMenu,
                      onAction: () => context.go(Routes.clientMenu),
                    )
                  : ListView.separated(
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
                        final (:product, :quantity) = lines[index];
                        return CartLineTile(
                          product: product,
                          quantity: quantity,
                          onOpen: () =>
                              context.push(Routes.clientProduct(product.id)),
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
          ],
        ),
      ),
      bottomNavigationBar: lines.isEmpty
          ? null
          : TotalBar(
              totalBani: total,
              actionLabel: AppStrings.continueOrder,
              onAction: () => context.push(Routes.clientCheckout),
            ),
    );
  }
}
