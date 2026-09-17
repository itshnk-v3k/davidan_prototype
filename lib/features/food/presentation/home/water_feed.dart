import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/app_card.dart';
import 'package:davidan_prototype/core/widgets/info_note.dart';
import 'package:davidan_prototype/data/mock/water/water_catalog.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_grid.dart';
import 'package:davidan_prototype/features/orders/application/order_lines_provider.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Apa DaviDan, inside Acasă's shell. Water has two products and no menu, so
/// it is one block: davidan.md's photo of both bottles and its line, the last
/// water order with "Comandă din nou" (water is bought again and again), then
/// the two bottles, which add to the water cart and open their product page
/// like any product card.
class WaterFeed extends ConsumerWidget {
  const WaterFeed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider(Brand.water));
    final lastOrder = ref.watch(lastOrderOfProvider(Brand.water));

    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.sm,
            AppSpacing.gutter,
            AppSpacing.md,
          ),
          sliver: SliverList.list(
            children: [
              const _BottlesPhoto(),
              const SizedBox(height: AppSpacing.lg),
              Text(
                context.content.text(WaterPage.line),
                style: context.textStyles.body,
              ),
              const SizedBox(height: AppSpacing.xl),
              if (lastOrder == null)
                InfoNote(
                  icon: PhosphorIconsRegular.arrowCounterClockwise,
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
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
        ProductGrid(products: products, title: context.l10n.itemsTitle),
      ],
    );
  }
}

/// davidan.md's photo of both bottles, whole: they stand on white, so the
/// card is white too and the photo fits inside it without cropping a cap.
class _BottlesPhoto extends StatelessWidget {
  const _BottlesPhoto();

  static const height = 240.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: AppCard(
        color: Colors.white,
        child: Image.asset(WaterPage.photo, fit: BoxFit.contain),
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

    return AppCard(
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
              icon: PhosphorIconsRegular.arrowCounterClockwise,
              onPressed: onOrderAgain,
            ),
          ],
        ),
      ),
    );
  }
}
