import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/theme/brand_colors.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/core/widgets/detail_row.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/core/widgets/section_title.dart';
import 'package:davidan_prototype/core/widgets/summary_row.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/account/application/account_notifier.dart';
import 'package:davidan_prototype/features/orders/application/customer_requests_provider.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/fulfilment_detail_row.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/order_status_pill.dart';
import 'package:davidan_prototype/features/rental/application/rental_providers.dart';
import 'package:davidan_prototype/features/rental/presentation/widgets/rental_booking_status_pill.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The Comenzi tab: the customer's orders from every brand and car rental
/// requests, those still under way ("În curs") above the completed ones,
/// newest first, each with its brand and live status. Once there are some
/// from more than one brand, chips filter them by brand. Locked until the
/// demo sign-in, like the profile.
class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key, this.brand});

  /// Shows only this brand's; null, or a brand with nothing sent, shows all.
  /// Lives in the URL (Routes.clientOrdersOf), like the menu's category.
  final Brand? brand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);
    final allRequests = ref.watch(customerRequestsProvider);
    final brands = [
      for (final brand in Brand.values)
        if (allRequests.any((request) => request.brand == brand)) brand,
    ];
    final filter = brands.contains(brand) ? brand : null;
    final requests = [
      for (final request in allRequests)
        if (filter == null || request.brand == filter) request,
    ];
    final sections = [
      (
        title: context.l10n.ordersActiveTitle,
        requests: [
          for (final request in requests)
            if (request.active) request,
        ],
      ),
      (
        title: context.l10n.ordersPastTitle,
        requests: [
          for (final request in requests)
            if (!request.active) request,
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
            ScreenHeader(title: context.l10n.navOrders),
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
              child: switch ((account, requests)) {
                (null, _) => EmptyState(
                  icon: PhosphorIconsRegular.lockSimple,
                  title: context.l10n.accountLockedTitle,
                  message: context.l10n.accountLockedMessage,
                  actionLabel: context.l10n.signInTitle,
                  onAction: () => context.push(Routes.signIn),
                ),
                (_, []) => EmptyState(
                  icon: PhosphorIconsRegular.receipt,
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
                      if (section.requests.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(
                            top: AppSpacing.sm,
                            bottom: AppSpacing.md,
                          ),
                          child: SectionTitle(
                            title: section.title,
                            count: section.requests.length,
                          ),
                        ),
                        for (final request in section.requests)
                          Padding(
                            key: ValueKey(request.id),
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: switch (request) {
                              OrderRequest(:final order) => _RequestCard(
                                brand: order.brand,
                                title: context.l10n.orderNumber(order.id),
                                createdAt: order.createdAt,
                                status: OrderStatusPill(status: order.status),
                                details: FulfilmentDetailRow(
                                  fulfilment: order.fulfilment,
                                ),
                                total: context.l10n.formatLei(order.totalBani),
                                onTap: () =>
                                    context.push(Routes.clientOrder(order.id)),
                              ),
                              BookingRequest(:final booking) => _RequestCard(
                                brand: request.brand,
                                title: context.l10n.rentalBookingNumber(
                                  booking.id,
                                ),
                                createdAt: booking.createdAt,
                                status: RentalBookingStatusPill(
                                  booking: booking,
                                ),
                                details: DetailRow(
                                  icon: PhosphorIconsRegular.car,
                                  label:
                                      ref
                                          .watch(
                                            rentalCarByIdProvider(
                                              booking.carId,
                                            ),
                                          )
                                          ?.name ??
                                      booking.carId,
                                  value:
                                      '${formatDateTime(booking.pickupAt)} – '
                                      '${formatDateTime(booking.returnAt)}',
                                ),
                                totalLabel: context.l10n.rentalPriceTotal,
                                total: context.l10n.formatEuro(
                                  booking.quote.priceEur,
                                ),
                                onTap: () => context.push(
                                  Routes.clientBooking(booking.id),
                                ),
                              ),
                            },
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
                  : context.content.introOf(brand).name,
              selected: brand == selected,
              onTap: () => onSelected(brand),
            ),
          ],
        ],
      ),
    );
  }
}

/// An order or a rental request: its brand, number, when it was sent, live
/// status, what it is for and the total. Tapping it opens it.
class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.brand,
    required this.title,
    required this.createdAt,
    required this.status,
    required this.details,
    required this.total,
    this.totalLabel,
    required this.onTap,
  });

  final Brand brand;
  final String title;
  final DateTime createdAt;
  final Widget status;

  /// How an order is fulfilled; a rental's car and dates.
  final Widget details;

  /// Already formatted, in the brand's currency.
  final String total;

  /// What [total] is; "Total" when null.
  final String? totalLabel;
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
                          context.content.introOf(brand).name,
                          style: context.textStyles.caption.copyWith(
                            color: BrandColors.of(
                              brand,
                              Theme.of(context).brightness,
                            ).primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(title, style: context.textStyles.subtitle),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          formatDateTime(createdAt),
                          style: context.textStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  status,
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              details,
              Divider(height: AppSpacing.xl, color: context.colors.border),
              SummaryRow(label: totalLabel ?? context.l10n.total, value: total),
            ],
          ),
        ),
      ),
    );
  }
}
