import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/phone.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/detail_row.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/entrance.dart';
import 'package:davidan_prototype/core/widgets/status_pill.dart';
import 'package:davidan_prototype/features/rental/application/rental_bookings_notifier.dart';
import 'package:davidan_prototype/features/rental/application/rental_providers.dart';
import 'package:davidan_prototype/features/rental/presentation/widgets/rental_quote_card.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// A sent car rental request, shown once it is sent and opened from Comenzi
/// and the hub: its number and status, the site's "Vă vom contacta în
/// curând.", the car, where and when, who to contact, and the price. Nothing
/// more happens to it in the app: DaviDan Rent Car confirms by phone.
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
            icon: Icons.event_busy_rounded,
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
                icon: Icons.close_rounded,
                semanticLabel: l10n.backHome,
                onPressed: goHome,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // The check mark pops in once, as the request is sent.
            Center(
              child: Entrance(
                pop: true,
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: context.colors.accentSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 48,
                    color: context.colors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.rentalRequestSentTitle,
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
            Center(child: StatusPill(label: l10n.rentalBookingStatus)),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.rentalWillContact,
              style: context.textStyles.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(AppRadii.lg),
                border: Border.all(color: context.colors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DetailRow(
                      icon: Icons.directions_car_rounded,
                      label: l10n.rentalCar,
                      value: car?.name ?? booking.carId,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DetailRow(
                      icon: Icons.key_rounded,
                      label: l10n.rentalPickupTitle,
                      value:
                          '${l10n.rentalLocation(booking.pickupLocation)} · '
                          '${formatDateTime(booking.pickupAt)}',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DetailRow(
                      icon: Icons.keyboard_return_rounded,
                      label: l10n.rentalReturnTitle,
                      value:
                          '${l10n.rentalLocation(booking.returnLocation)} · '
                          '${formatDateTime(booking.returnAt)}',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DetailRow(
                      icon: Icons.person_outline_rounded,
                      label: l10n.rentalContact,
                      value:
                          '${booking.name} · '
                          '${MoldovanPhone.format(booking.phone)}',
                    ),
                    if (notes.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      DetailRow(
                        icon: Icons.notes_rounded,
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
