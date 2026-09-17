import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/info_note.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/data/mock/water/water_catalog.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/cart_button.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_grid.dart';
import 'package:davidan_prototype/features/orders/application/order_lines_provider.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Apa DaviDan, full screen above the hub. Water has two products and no
/// menu, so it is one page: davidan.md's photo of both bottles and its line,
/// the last water order with "Comandă din nou" (water is bought again and
/// again), then the two bottles, which add to the water cart and open their
/// product page like any product card.
class WaterHomeScreen extends ConsumerWidget {
  const WaterHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider(Brand.water));
    final lastOrder = ref.watch(lastOrderOfProvider(Brand.water));

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: context.content.text(WaterPage.title),
              onBack: () => context.pop(),
              actions: const [CartButton(brand: Brand.water)],
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.gutter,
                      0,
                      AppSpacing.gutter,
                      AppSpacing.md,
                    ),
                    sliver: SliverList.list(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadii.lg),
                          // Just taller than wide: the square photo loses
                          // only white above and below the bottles.
                          child: AspectRatio(
                            aspectRatio: 1.1,
                            child: Image.asset(
                              WaterPage.photo,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          context.content.text(WaterPage.line),
                          style: context.textStyles.body,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        if (lastOrder == null)
                          InfoNote(
                            icon: Icons.replay_rounded,
                            text: context.l10n.orderAgainHint,
                          )
                        else
                          _LastOrderCard(
                            order: lastOrder,
                            onOrderAgain: () {
                              ref
                                  .read(cartProvider(Brand.water).notifier)
                                  .repeat(lastOrder);
                              context.push(Routes.brandCart(Brand.water));
                            },
                          ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          context.l10n.itemsTitle,
                          style: context.textStyles.subtitle,
                        ),
                      ],
                    ),
                  ),
                  ProductGrid(products: products),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The last water order: its number and date, what was in it and its total,
/// and the button that puts it back in the cart.
class _LastOrderCard extends ConsumerWidget {
  const _LastOrderCard({required this.order, required this.onOrderAgain});

  final Order order;
  final VoidCallback onOrderAgain;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lines = ref.watch(orderLinesProvider(order.id));

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: context.colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.lastOrderTitle,
                    style: context.textStyles.subtitle,
                  ),
                ),
                Text(
                  context.l10n.formatLei(order.totalBani),
                  style: context.textStyles.price,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              '${context.l10n.orderNumber(order.id)} · '
              '${formatDateTime(order.createdAt)}',
              style: context.textStyles.caption,
            ),
            const SizedBox(height: AppSpacing.md),
            for (final line in lines)
              Text(
                context.l10n.lineItem(line.quantity, line.product.name),
                style: context.textStyles.body,
              ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: context.l10n.orderAgain,
              icon: Icons.replay_rounded,
              onPressed: onOrderAgain,
            ),
          ],
        ),
      ),
    );
  }
}
