import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/courier/presentation/widgets/courier_order_details.dart';
import 'package:davidan_prototype/features/orders/application/order_lines_provider.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/courier_route_map.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/order_status_pill.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/order_summary_card.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// One delivery: where to go (with the route map once it's on the way), what
/// to collect, the items, and the courier's next step. Pickup orders and
/// unknown ids show "not found".
class CourierDeliveryScreen extends ConsumerWidget {
  const CourierDeliveryScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderByIdProvider(orderId));

    // go_router builds the list underneath even when this screen is opened
    // from a URL, so back normally pops to it.
    void goBack() =>
        context.canPop() ? context.pop() : context.go(Routes.courierOrders);

    if (order == null || order.fulfilment is! HomeDelivery) {
      return Scaffold(
        backgroundColor: context.colors.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScreenHeader(
                title: context.l10n.deliveryTitle(orderId),
                onBack: goBack,
              ),
              Expanded(
                child: EmptyState(
                  icon: Icons.receipt_long_rounded,
                  title: context.l10n.deliveryNotFound,
                  actionLabel: context.l10n.backToDeliveries,
                  onAction: goBack,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final lines = ref.watch(orderLinesProvider(order.id));

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: context.l10n.deliveryTitle(order.id),
              onBack: goBack,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  0,
                  AppSpacing.gutter,
                  AppSpacing.xl,
                ),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OrderStatusPill(status: order.status),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (order.status == OrderStatus.onTheWay) ...[
                    CourierRouteMap(since: order.statusSince),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(AppRadii.lg),
                      border: Border.all(color: context.colors.border),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: CourierOrderDetails(order: order),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    context.l10n.itemsTitle,
                    style: context.textStyles.subtitle,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  OrderSummaryCard(lines: lines, totalBani: order.totalBani),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _ActionBar(
        order: order,
        onAdvance: () => ref.read(ordersProvider.notifier).advance(order.id),
        onBack: goBack,
      ),
    );
  }
}

/// The courier's next step, a "delivered" note once done, or a note that the
/// shop is still on it. Each step crossfades in, and the bar grows or shrinks
/// to fit instead of jumping.
class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.order,
    required this.onAdvance,
    required this.onBack,
  });

  final Order order;
  final VoidCallback onAdvance;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: KeyedSubtree(
            key: ValueKey(order.status),
            child: switch (order.nextStatus) {
              final next? when order.nextStepBy == OrderActor.courier =>
                AppButton(
                  label: context.l10n.advanceTo(next),
                  onPressed: onAdvance,
                ),
              null => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 20,
                        color: context.colors.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        context.l10n.deliveryCompleted,
                        style: context.textStyles.bodyStrong,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: context.l10n.backToDeliveries,
                    variant: AppButtonVariant.secondary,
                    onPressed: onBack,
                  ),
                ],
              ),
              _ => Text(
                context.l10n.courierWaitingForStore,
                style: context.textStyles.bodySecondary,
                textAlign: TextAlign.center,
              ),
            },
          ),
        ),
      ),
    );
  }
}
