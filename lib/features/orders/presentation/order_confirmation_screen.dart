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
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/detail_row.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/summary_row.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/courier_route_map.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/fulfilment_detail_row.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/order_status_pill.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Shown after checkout: the order number, its live status, a map with the
/// courier while a delivery is on the way, and what was chosen. A stand-in
/// for the full order tracking screen.
class OrderConfirmationScreen extends ConsumerWidget {
  const OrderConfirmationScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderByIdProvider(orderId));
    void goHome() => context.go(Routes.clientHome);

    if (order == null) {
      return Scaffold(
        backgroundColor: context.colors.background,
        body: SafeArea(
          child: EmptyState(
            icon: Icons.receipt_long_rounded,
            title: context.l10n.orderNotFound,
            actionLabel: context.l10n.backHome,
            onAction: goHome,
          ),
        ),
      );
    }

    final scheduledFor = order.scheduledFor;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AppIconButton(
                icon: Icons.close_rounded,
                semanticLabel: context.l10n.backHome,
                onPressed: goHome,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: context.colors.accentSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 48,
                  color: context.colors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              context.l10n.orderPlacedTitle,
              style: context.textStyles.headline,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              context.l10n.orderNumber(order.id),
              style: context.textStyles.bodySecondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Center(child: OrderStatusPill(status: order.status)),
            // Pickup orders never get here: they have no courier step.
            if (order.status == OrderStatus.onTheWay) ...[
              const SizedBox(height: AppSpacing.xl),
              CourierRouteMap(since: order.statusSince),
            ],
            const SizedBox(height: AppSpacing.xl),
            DecoratedBox(
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
                    FulfilmentDetailRow(fulfilment: order.fulfilment),
                    const SizedBox(height: AppSpacing.md),
                    DetailRow(
                      icon: Icons.schedule_rounded,
                      label: context.l10n.orderTime,
                      value: scheduledFor == null
                          ? context.l10n.asSoonAsPossible
                          : formatTime(scheduledFor),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DetailRow(
                      icon: Icons.payments_rounded,
                      label: context.l10n.paymentTitle,
                      value: context.l10n.paymentMethod(order.payment),
                    ),
                    Divider(
                      height: AppSpacing.xl,
                      color: context.colors.border,
                    ),
                    SummaryRow(
                      label: context.l10n.total,
                      value: context.l10n.formatLei(order.totalBani),
                      emphasized: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              context.l10n.trackingComingSoon,
              style: context.textStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: AppButton(label: context.l10n.backHome, onPressed: goHome),
        ),
      ),
    );
  }
}
