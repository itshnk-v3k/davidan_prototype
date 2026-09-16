import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/theme/brand_colors.dart';
import 'package:davidan_prototype/core/widgets/status_pill.dart';
import 'package:davidan_prototype/features/orders/application/customer_requests_provider.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/order_status_pill.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The orders still on their way and the car rental requests, from every
/// brand, as a row of cards under the hub's location bar, each with its live
/// status. Nothing at all when there are none. With more than one, the next
/// card peeks in at the edge.
class ActiveOrdersStrip extends ConsumerWidget {
  const ActiveOrdersStrip({super.key, required this.onOpen});

  final ValueChanged<CustomerRequest> onOpen;

  static const _height = 72.0;
  static const _peek = 40.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(activeRequestsProvider);
    if (requests.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: SizedBox(
        height: _height,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width =
                constraints.maxWidth -
                2 * AppSpacing.gutter -
                (requests.length > 1 ? _peek : 0);
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.gutter,
              ),
              itemCount: requests.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) => SizedBox(
                key: ValueKey(requests[index].id),
                width: width,
                child: _ActiveRequestCard(
                  request: requests[index],
                  onTap: () => onOpen(requests[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// The brand's photo and name, the order's or request's number and its
/// status.
class _ActiveRequestCard extends StatelessWidget {
  const _ActiveRequestCard({required this.request, required this.onTap});

  final CustomerRequest request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final intro = context.content.introOf(request.brand);
    final image = intro.image;

    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        side: BorderSide(color: colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
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
                    ? Icon(Icons.directions_car_rounded, color: colors.primary)
                    : Image.asset(image, fit: BoxFit.cover),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        OrderRequest(:final order) => context.l10n.orderNumber(
                          order.id,
                        ),
                        BookingRequest(:final booking) =>
                          context.l10n.rentalBookingNumber(booking.id),
                      },
                      style: context.textStyles.bodyStrong,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              switch (request) {
                OrderRequest(:final order) => OrderStatusPill(
                  status: order.status,
                ),
                BookingRequest() => StatusPill(
                  label: context.l10n.rentalBookingStatus,
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
