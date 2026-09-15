import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/utils/phone.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/core/widgets/summary_row.dart';
import 'package:davidan_prototype/data/models/customer_account.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/client/application/account_notifier.dart';
import 'package:davidan_prototype/features/client/presentation/account/widgets/nearest_shop_card.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/fulfilment_detail_row.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/order_status_pill.dart';

/// Profile tab. Locked until the customer goes through the demo sign-in;
/// then their name, number, sector and nearest shop, their orders with a
/// live status, and a way to sign out. Saved products have their own tab.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);
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
              child: account == null
                  ? EmptyState(
                      icon: Icons.lock_outline_rounded,
                      title: AppStrings.accountLockedTitle,
                      message: AppStrings.accountLockedMessage,
                      actionLabel: AppStrings.signInTitle,
                      onAction: () => context.push(Routes.signIn),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.gutter,
                        0,
                        AppSpacing.gutter,
                        AppSpacing.xl,
                      ),
                      children: [
                        _AccountCard(account: account),
                        const SizedBox(height: AppSpacing.md),
                        NearestShopCard(account: account),
                        const SizedBox(height: AppSpacing.lg),
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
                              onTap: () =>
                                  context.push(Routes.clientOrder(order.id)),
                            ),
                          ),
                        const SizedBox(height: AppSpacing.xl),
                        AppButton(
                          label: AppStrings.signOut,
                          icon: Icons.logout_rounded,
                          variant: AppButtonVariant.secondary,
                          onPressed: () =>
                              ref.read(accountProvider.notifier).signOut(),
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

/// Initial, name, masked number and sector.
class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.account});

  final CustomerAccount account;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                account.name.characters.first.toUpperCase(),
                style: AppTextStyles.title.copyWith(color: AppColors.onPrimary),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(account.name, style: AppTextStyles.subtitle),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    MoldovanPhone.masked(account.phone),
                    style: AppTextStyles.bodySecondary,
                  ),
                  Text(
                    AppStrings.sectorLabel(account.sector),
                    style: AppTextStyles.caption,
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
