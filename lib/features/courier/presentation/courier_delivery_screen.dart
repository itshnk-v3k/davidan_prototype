import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_motion.dart';
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
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScreenHeader(
                title: AppStrings.deliveryTitle(orderId),
                onBack: goBack,
              ),
              Expanded(
                child: EmptyState(
                  icon: Icons.receipt_long_rounded,
                  title: AppStrings.deliveryNotFound,
                  actionLabel: AppStrings.backToDeliveries,
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
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: AppStrings.deliveryTitle(order.id),
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
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadii.lg),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: CourierOrderDetails(order: order),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const Text(
                    AppStrings.itemsTitle,
                    style: AppTextStyles.subtitle,
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
    final duration = AppMotion.of(context, AppMotion.medium);

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: AnimatedSize(
            duration: duration,
            curve: AppMotion.standard,
            child: AnimatedSwitcher(
              duration: duration,
              child: KeyedSubtree(
                key: ValueKey(order.status),
                child: switch (order.nextStatus) {
                  final next? when order.nextStepBy == OrderActor.courier =>
                    AppButton(
                      label: AppStrings.advanceTo(next),
                      onPressed: onAdvance,
                    ),
                  null => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: AppSpacing.sm),
                          Text(
                            AppStrings.deliveryCompleted,
                            style: AppTextStyles.bodyStrong,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppButton(
                        label: AppStrings.backToDeliveries,
                        variant: AppButtonVariant.secondary,
                        onPressed: onBack,
                      ),
                    ],
                  ),
                  _ => const Text(
                    AppStrings.courierWaitingForStore,
                    style: AppTextStyles.bodySecondary,
                    textAlign: TextAlign.center,
                  ),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
