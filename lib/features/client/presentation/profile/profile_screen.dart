import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/theme/theme_mode_notifier.dart';
import 'package:davidan_prototype/core/toast/toast_notifier.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/utils/phone.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/core/widgets/summary_row.dart';
import 'package:davidan_prototype/core/widgets/theme_mode_selector.dart';
import 'package:davidan_prototype/data/models/customer_account.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/client/application/account_notifier.dart';
import 'package:davidan_prototype/features/client/presentation/account/widgets/nearest_shop_card.dart';
import 'package:davidan_prototype/features/launcher/application/demo_reset_notifier.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/fulfilment_detail_row.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/order_status_pill.dart';

/// Profile tab. Locked until the customer goes through the demo sign-in;
/// then their name, number, sector and nearest shop, their orders with a
/// live status, and a way to sign out. Saved products have their own tab.
/// The theme switch and the demo reset are there either way: the customer app
/// build has no launcher to hold them.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

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
            const ScreenHeader(title: AppStrings.profileTitle),
            Expanded(
              child: account == null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: EmptyState(
                            icon: Icons.lock_outline_rounded,
                            title: AppStrings.accountLockedTitle,
                            message: AppStrings.accountLockedMessage,
                            actionLabel: AppStrings.signInTitle,
                            onAction: () => context.push(Routes.signIn),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(
                            AppSpacing.gutter,
                            0,
                            AppSpacing.gutter,
                            AppSpacing.xl,
                          ),
                          child: _DemoSettings(),
                        ),
                      ],
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
                        const SizedBox(height: AppSpacing.xl),
                        const _DemoSettings(),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          AppStrings.demoProfileNote,
                          style: context.textStyles.caption,
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

/// The theme switch and the demo reset. Resetting starts the demo over from
/// the splash, the way a first launch would.
class _DemoSettings extends ConsumerWidget {
  const _DemoSettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ThemeModeSelector(
          selected: ref.watch(themeModeProvider),
          onSelected: ref.read(themeModeProvider.notifier).select,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          label: AppStrings.resetDemoData,
          icon: Icons.restart_alt_rounded,
          variant: AppButtonVariant.secondary,
          onPressed: () async {
            await ref.read(demoResetProvider.notifier).reset();
            if (!context.mounted) return;
            context.go(Routes.clientSplash);
            ref.read(toastProvider.notifier).show(AppStrings.resetDemoDataDone);
          },
        ),
      ],
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
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: context.colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.colors.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                account.name.characters.first.toUpperCase(),
                style: context.textStyles.title.copyWith(
                  color: context.colors.onPrimary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(account.name, style: context.textStyles.subtitle),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    MoldovanPhone.masked(account.phone),
                    style: context.textStyles.bodySecondary,
                  ),
                  Text(
                    AppStrings.sectorLabel(account.sector),
                    style: context.textStyles.caption,
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
      child: Text(title, style: context.textStyles.subtitle),
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
                          AppStrings.orderNumber(order.id),
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
