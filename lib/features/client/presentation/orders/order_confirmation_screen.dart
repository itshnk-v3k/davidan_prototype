import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/client/application/catalog_providers.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/summary_row.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';

/// Shown after checkout: the order number, its status and what was chosen.
/// A stand-in for the live order tracking screen.
class OrderConfirmationScreen extends ConsumerWidget {
  const OrderConfirmationScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderByIdProvider(orderId));
    void goHome() => context.go(Routes.clientHome);

    if (order == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: EmptyState(
            icon: Icons.receipt_long_rounded,
            title: AppStrings.orderNotFound,
            actionLabel: AppStrings.backHome,
            onAction: goHome,
          ),
        ),
      );
    }

    final fulfilment = switch (order.fulfilment) {
      HomeDelivery(:final address) => (
        icon: Icons.delivery_dining_rounded,
        label: AppStrings.deliverTo,
        value: address,
      ),
      StorePickup(:final locationId) => (
        icon: Icons.storefront_rounded,
        label: AppStrings.pickupFrom,
        value: switch (ref.watch(locationByIdProvider(locationId))) {
          final location? => '${location.name} · ${location.address}',
          null => locationId,
        },
      ),
    };
    final scheduledFor = order.scheduledFor;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AppIconButton(
                icon: Icons.close_rounded,
                semanticLabel: AppStrings.backHome,
                onPressed: goHome,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: AppColors.accentSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              AppStrings.orderPlacedTitle,
              style: AppTextStyles.headline,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              AppStrings.orderNumber(order.id),
              style: AppTextStyles.bodySecondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Center(
              child: _StatusPill(label: AppStrings.orderStatus(order.status)),
            ),
            const SizedBox(height: AppSpacing.xl),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadii.lg),
                border: Border.all(color: AppColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _DetailRow(
                      icon: fulfilment.icon,
                      label: fulfilment.label,
                      value: fulfilment.value,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _DetailRow(
                      icon: Icons.schedule_rounded,
                      label: AppStrings.orderTime,
                      value: scheduledFor == null
                          ? AppStrings.asSoonAsPossible
                          : formatTime(scheduledFor),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _DetailRow(
                      icon: Icons.payments_rounded,
                      label: AppStrings.paymentTitle,
                      value: AppStrings.paymentMethod(order.payment),
                    ),
                    const Divider(
                      height: AppSpacing.xl,
                      color: AppColors.border,
                    ),
                    SummaryRow(
                      label: AppStrings.total,
                      value: formatLei(order.totalBani),
                      emphasized: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              AppStrings.trackingComingSoon,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: AppButton(label: AppStrings.backHome, onPressed: goHome),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs + AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: SizedBox.square(dimension: 8),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(label, style: AppTextStyles.label),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.xxs),
              Text(value, style: AppTextStyles.bodyStrong),
            ],
          ),
        ),
      ],
    );
  }
}
