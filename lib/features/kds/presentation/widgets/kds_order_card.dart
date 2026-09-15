import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/client/application/catalog_providers.dart';
import 'package:davidan_prototype/features/kds/presentation/widgets/elapsed_timer.dart';
import 'package:davidan_prototype/features/orders/application/order_lines_provider.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/order_status_pill.dart';

/// A store panel ticket: order number, time since it was placed, delivery or
/// pickup, the items to make, and the shop's next step. A new order has a
/// caramel border and a "NOUĂ" tag until the shop accepts it.
class KdsOrderCard extends ConsumerWidget {
  const KdsOrderCard({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lines = ref.watch(orderLinesProvider(order.id));
    final isNew = order.status == OrderStatus.placed;
    final scheduledFor = order.scheduledFor;
    final time = scheduledFor == null
        ? AppStrings.asSoonAsPossible
        : AppStrings.scheduledAt(formatTime(scheduledFor));
    final (icon, fulfilment) = switch (order.fulfilment) {
      HomeDelivery() => (Icons.delivery_dining_rounded, AppStrings.delivery),
      StorePickup(:final locationId) => (
        Icons.storefront_rounded,
        AppStrings.pickupAt(
          ref.watch(locationByIdProvider(locationId))?.name ?? locationId,
        ),
      ),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: isNew
            ? Border.all(color: context.colors.primary, width: 2)
            : Border.all(color: context.colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(order.id, style: context.textStyles.title),
                ),
                if (isNew) ...[
                  const SizedBox(width: AppSpacing.sm),
                  const _NewTag(),
                ],
                const Spacer(),
                ElapsedTimer(since: order.createdAt),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: OrderStatusPill(status: order.status),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 18, color: context.colors.textSecondary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    '$fulfilment · $time',
                    style: context.textStyles.bodySecondary,
                  ),
                ),
              ],
            ),
            Divider(height: AppSpacing.xl, color: context.colors.border),
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Text(
                  AppStrings.lineItem(line.quantity, line.product.name),
                  style: context.textStyles.bodyStrong,
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            if (order.nextStatus case final next?
                when order.nextStepBy == OrderActor.store)
              AppButton(
                label: AppStrings.advanceTo(next),
                // Accepting a new order is the call to action; later steps
                // are routine.
                variant: isNew
                    ? AppButtonVariant.primary
                    : AppButtonVariant.secondary,
                onPressed: () =>
                    ref.read(ordersProvider.notifier).advance(order.id),
              )
            else if (order.nextStepBy == OrderActor.courier)
              Row(
                children: [
                  Icon(
                    Icons.delivery_dining_rounded,
                    size: 18,
                    color: context.colors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      AppStrings.waitingForCourier,
                      style: context.textStyles.bodySecondary,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _NewTag extends StatelessWidget {
  const _NewTag();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        child: Text(AppStrings.kdsNewTag, style: context.textStyles.badge),
      ),
    );
  }
}
