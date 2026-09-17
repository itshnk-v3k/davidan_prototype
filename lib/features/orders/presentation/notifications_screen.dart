import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/theme/brand_colors.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/core/widgets/app_card.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/features/orders/application/customer_requests_provider.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/order_status_pill.dart';
import 'package:davidan_prototype/features/rental/presentation/widgets/rental_booking_status_pill.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The bell's page, inside Acasă: the latest news of every order and rental
/// request, most recent first. Each says what happened last (its status) and
/// when, and opens its order or request. Built only from what the app knows;
/// there are no offers or messages from the brands to show.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updates = [
      for (final request in ref.watch(customerRequestsProvider))
        (request: request, at: _updatedAt(request)),
    ]..sort((a, b) => b.at.compareTo(a.at));

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: context.l10n.notificationsTitle,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: updates.isEmpty
                  ? EmptyState(
                      icon: PhosphorIconsRegular.bell,
                      title: context.l10n.notificationsEmptyTitle,
                      message: context.l10n.notificationsEmptyMessage,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.gutter,
                        AppSpacing.xs,
                        AppSpacing.gutter,
                        AppSpacing.xl,
                      ),
                      itemCount: updates.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final (:request, :at) = updates[index];
                        return _UpdateCard(
                          key: ValueKey(request.id),
                          request: request,
                          at: at,
                          onTap: () => context.push(switch (request) {
                            OrderRequest(:final order) => Routes.clientOrder(
                              order.id,
                            ),
                            BookingRequest(:final booking) =>
                              Routes.clientBooking(booking.id),
                          }),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// When the request last changed: an order's current status, a request's
  /// cancellation or its sending.
  static DateTime _updatedAt(CustomerRequest request) => switch (request) {
    OrderRequest(:final order) => order.statusSince,
    BookingRequest(:final booking) => booking.cancelledAt ?? booking.createdAt,
  };
}

class _UpdateCard extends StatelessWidget {
  const _UpdateCard({
    super.key,
    required this.request,
    required this.at,
    required this.onTap,
  });

  final CustomerRequest request;
  final DateTime at;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final intro = context.content.introOf(request.brand);
    final image = intro.image;

    return AppCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: colors.accentSoft,
                shape: BoxShape.circle,
              ),
              child: image == null
                  ? Icon(PhosphorIconsRegular.car, color: colors.primary)
                  : Image.asset(image, fit: BoxFit.cover),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    intro.name,
                    style: context.textStyles.caption.copyWith(
                      color: BrandColors.of(
                        request.brand,
                        Theme.of(context).brightness,
                      ).primary,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    switch (request) {
                      OrderRequest(:final order) => l10n.orderNumber(order.id),
                      BookingRequest(:final booking) =>
                        l10n.rentalBookingNumber(booking.id),
                    },
                    style: context.textStyles.bodyStrong,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    formatDayMonthTime(at),
                    style: context.textStyles.caption,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            switch (request) {
              OrderRequest(:final order) => OrderStatusPill(
                status: order.status,
              ),
              BookingRequest(:final booking) => RentalBookingStatusPill(
                booking: booking,
              ),
            },
          ],
        ),
      ),
    );
  }
}
