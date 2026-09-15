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
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/core/widgets/summary_row.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/fulfilment_detail_row.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/order_status_pill.dart';

/// Profile tab. The prototype has no accounts, so there is no sign-in or
/// settings: the customer's orders with their live status. Saved products
/// have their own tab.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ScreenHeader(title: AppStrings.profileTitle),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  0,
                  AppSpacing.gutter,
                  AppSpacing.xl,
                ),
                children: [
                  const _SectionTitle(AppStrings.myOrdersTitle),
                  if (orders.isEmpty)
                    EmptyState(
                      icon: Icons.receipt_long_rounded,
                      title: AppStrings.ordersEmptyTitle,
                      message: AppStrings.ordersEmptyMessage,
                      actionLabel: AppStrings.browseMenu,
                      onAction: () => context.go(Routes.clientMenu),
                    ),
                  for (final (index, order) in orders.indexed)
                    Padding(
                      key: ValueKey(order.id),
                      padding: EdgeInsets.only(
                        top: index == 0 ? 0 : AppSpacing.md,
                      ),
                      child: _OrderHistoryCard(
                        order: order,
                        onTap: () => context.push(Routes.clientOrder(order.id)),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.lg),
                  const Text(
                    AppStrings.demoProfileNote,
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.md),
      child: Text(title, style: AppTextStyles.subtitle),
    );
  }
}

/// A past order: number, when it was placed, live status, how it is
/// fulfilled and the total. Tapping it opens the order.
class _OrderHistoryCard extends StatelessWidget {
  const _OrderHistoryCard({required this.order, required this.onTap});

  final Order order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.orderNumber(order.id),
                          style: AppTextStyles.subtitle,
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          formatDateTime(order.createdAt),
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  OrderStatusPill(status: order.status),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              FulfilmentDetailRow(fulfilment: order.fulfilment),
              const Divider(height: AppSpacing.xl, color: AppColors.border),
              SummaryRow(
                label: AppStrings.total,
                value: formatLei(order.totalBani),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
