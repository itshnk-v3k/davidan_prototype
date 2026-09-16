import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/theme/brand_colors.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/core/widgets/section_title.dart';
import 'package:davidan_prototype/core/widgets/summary_row.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/account/application/account_notifier.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/fulfilment_detail_row.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/order_status_pill.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The Comenzi tab: the customer's orders from every brand, those still on
/// their way ("În curs") above the completed ones, newest first, each with its
/// brand and live status. Once there are orders from more than one brand,
/// chips filter them by brand. Locked until the demo sign-in, like the
/// profile.
class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key, this.brand});

  /// Shows only this brand's orders; null, or a brand with no orders, shows
  /// all. Lives in the URL (Routes.clientOrdersOf), like the menu's category.
  final Brand? brand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);
    final allOrders = ref.watch(ordersProvider);
    final brands = [
      for (final brand in Brand.values)
        if (allOrders.any((order) => order.brand == brand)) brand,
    ];
    final filter = brands.contains(brand) ? brand : null;
    final orders = [
      for (final order in allOrders)
        if (filter == null || order.brand == filter) order,
    ];
    final sections = [
      (
        title: context.l10n.ordersActiveTitle,
        orders: [
          for (final order in orders)
            if (order.status != OrderStatus.completed) order,
        ],
      ),
      (
        title: context.l10n.ordersPastTitle,
        orders: [
          for (final order in orders)
            if (order.status == OrderStatus.completed) order,
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(title: context.l10n.myOrdersTitle),
            if (account != null && brands.length > 1) ...[
              _BrandChips(
                brands: brands,
                selected: filter,
                onSelected: (brand) => context.go(
                  brand == null
                      ? Routes.clientOrders
                      : Routes.clientOrdersOf(brand),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
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
                _ => ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    0,
                    AppSpacing.gutter,
                    AppSpacing.xl,
                  ),
                  children: [
                    for (final section in sections)
                      if (section.orders.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(
                            top: AppSpacing.sm,
                            bottom: AppSpacing.md,
                          ),
                          child: SectionTitle(
                            title: section.title,
                            count: section.orders.length,
                          ),
                        ),
                        for (final order in section.orders)
                          Padding(
                            key: ValueKey(order.id),
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: _OrderCard(
                              order: order,
                              onTap: () =>
                                  context.push(Routes.clientOrder(order.id)),
                            ),
                          ),
                      ],
                  ],
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// "Toate" and a chip per brand that has orders.
class _BrandChips extends StatelessWidget {
  const _BrandChips({
    required this.brands,
    required this.selected,
    required this.onSelected,
  });

  final List<Brand> brands;

  /// Null when every brand is shown.
  final Brand? selected;
  final ValueChanged<Brand?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
      child: Row(
        children: [
          for (final (index, brand) in [null, ...brands].indexed) ...[
            if (index > 0) const SizedBox(width: AppSpacing.sm),
            AppChip(
              label: brand == null
                  ? context.l10n.allBrands
                  : brandIntros[brand]!.name,
              selected: brand == selected,
              onTap: () => onSelected(brand),
            ),
          ],
        ],
      ),
    );
  }
}

/// An order: its brand, number, when it was placed, live status, how it is
/// fulfilled and the total. Tapping it opens the order.
class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.onTap});

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
                          brandIntros[order.brand]!.name,
                          style: context.textStyles.caption.copyWith(
                            color: BrandColors.of(
                              order.brand,
                              Theme.of(context).brightness,
                            ).primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
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
