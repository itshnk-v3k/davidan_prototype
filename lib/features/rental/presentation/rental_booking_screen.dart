import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/phone.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/confirm_dialog.dart';
import 'package:davidan_prototype/core/widgets/detail_row.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/info_note.dart';
import 'package:davidan_prototype/features/rental/application/rental_bookings_notifier.dart';
import 'package:davidan_prototype/features/rental/application/rental_providers.dart';
import 'package:davidan_prototype/features/rental/presentation/widgets/rental_booking_status_pill.dart';
import 'package:davidan_prototype/features/rental/presentation/widgets/rental_quote_card.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// A sent car rental request, shown once it is sent and opened from Comenzi
/// and the hub: its number and status, the site's "Vă vom contacta în
/// curând.", what the request does and doesn't mean yet, the car, where and
/// when, who to contact, and the price. DaviDan Rent Car confirms by phone, so
/// the only thing the customer can still do here is cancel it.
class RentalBookingScreen extends ConsumerWidget {
  const RentalBookingScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(rentalBookingByIdProvider(bookingId));
    void goHome() => context.go(Routes.clientHome);
    final l10n = context.l10n;

    if (booking == null) {
      return Scaffold(
        backgroundColor: context.colors.background,
        body: SafeArea(
          child: EmptyState(
            icon: PhosphorIconsRegular.calendarX,
            title: l10n.rentalBookingNotFound,
            actionLabel: l10n.backHome,
            onAction: goHome,
          ),
        ),
      );
    }

    final car = ref.watch(rentalCarByIdProvider(booking.carId));
    final notes = booking.notes;

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
                icon: PhosphorIconsRegular.x,
                semanticLabel: l10n.backHome,
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
                  booking.cancelled
                      ? PhosphorIconsRegular.calendarX
                      : PhosphorIconsBold.check,
                  size: 48,
                  color: context.colors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              booking.cancelled
                  ? l10n.rentalRequestCancelledTitle
                  : l10n.rentalRequestSentTitle,
              style: context.textStyles.headline,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.rentalBookingNumber(booking.id),
              style: context.textStyles.bodySecondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Center(child: RentalBookingStatusPill(booking: booking)),
            if (!booking.cancelled) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.rentalWillContact,
                style: context.textStyles.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              InfoNote(
                icon: PhosphorIconsRegular.info,
                text: l10n.rentalRequestNotReserved,
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(AppRadii.card),
                border: Border.all(color: context.colors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DetailRow(
                      icon: PhosphorIconsRegular.car,
                      label: l10n.rentalCar,
                      value: car?.name ?? booking.carId,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DetailRow(
                      icon: PhosphorIconsRegular.key,
                      label: l10n.rentalPickupTitle,
                      value:
                          '${l10n.rentalLocation(booking.pickupLocation)} · '
                          '${formatDateTime(booking.pickupAt)}',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DetailRow(
                      icon: PhosphorIconsRegular.arrowUDownLeft,
                      label: l10n.rentalReturnTitle,
                      value:
                          '${l10n.rentalLocation(booking.returnLocation)} · '
                          '${formatDateTime(booking.returnAt)}',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DetailRow(
                      icon: PhosphorIconsRegular.user,
                      label: l10n.rentalContact,
                      value:
                          '${booking.name} · '
                          '${MoldovanPhone.format(booking.phone)}',
                    ),
                    if (notes.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      DetailRow(
                        icon: PhosphorIconsRegular.notepad,
                        label: l10n.rentalNotesLabel,
                        value: notes,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            RentalQuoteCard(quote: booking.quote),
            if (!booking.cancelled) ...[
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: l10n.rentalCancelRequest,
                variant: AppButtonVariant.secondary,
                onPressed: () async {
                  final confirmed = await showConfirmDialog(
                    context,
                    title: l10n.rentalCancelRequestTitle,
                    message: l10n.rentalCancelRequestMessage,
                    confirmLabel: l10n.rentalCancelRequest,
                    cancelLabel: l10n.back,
                  );
                  if (confirmed) {
                    ref
                        .read(rentalBookingsProvider.notifier)
                        .cancel(booking.id);
                  }
                },
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: AppButton(label: l10n.backHome, onPressed: goHome),
        ),
      ),
    );
  }
}
