import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/core/widgets/summary_row.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/account/application/account_notifier.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/fulfilment_detail_row.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/order_status_pill.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The Comenzi tab: the customer's orders from every brand, newest first, each
/// with its live status. Locked until the demo sign-in, like the profile.
class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);
    final orders = ref.watch(ordersProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(title: context.l10n.myOrdersTitle),
            Expanded(
              child: switch ((account, orders)) {
                (null, _) => EmptyState(
                  icon: Icons.lock_outline_rounded,
                  title: context.l10n.accountLockedTitle,
                  message: context.l10n.accountLockedMessage,
                  actionLabel: context.l10n.signInTitle,
                  onAction: () => context.push(Routes.signIn),
                ),
                (_, []) => EmptyState(
                  icon: Icons.receipt_long_rounded,
                  title: context.l10n.ordersEmptyTitle,
                  message: context.l10n.ordersEmptyMessage,
                  actionLabel: context.l10n.backHome,
                  onAction: () => context.go(Routes.clientHome),
                ),
                _ => ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    0,
                    AppSpacing.gutter,
                    AppSpacing.xl,
                  ),
                  itemCount: orders.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _OrderCard(
                      key: ValueKey(order.id),
                      order: order,
                      onTap: () => context.push(Routes.clientOrder(order.id)),
                    );
                  },
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// An order: number, when it was placed, live status, how it is fulfilled and
/// the total. Tapping it opens the order.
class _OrderCard extends StatelessWidget {
  const _OrderCard({super.key, required this.order, required this.onTap});

  final Order order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        side: BorderSide(color: context.colors.border),
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
                          context.l10n.orderNumber(order.id),
                          style: context.textStyles.subtitle,
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          formatDateTime(order.createdAt),
                          style: context.textStyles.caption,
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
              Divider(height: AppSpacing.xl, color: context.colors.border),
              SummaryRow(
                label: context.l10n.total,
                value: context.l10n.formatLei(order.totalBani),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
