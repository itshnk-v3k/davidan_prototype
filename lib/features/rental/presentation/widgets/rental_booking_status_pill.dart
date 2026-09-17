import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/widgets/status_pill.dart';
import 'package:davidan_prototype/data/models/rental_booking.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// A rental request's status: waiting for the company to call, or cancelled.
class RentalBookingStatusPill extends StatelessWidget {
  const RentalBookingStatusPill({super.key, required this.booking});

  final RentalBooking booking;

  @override
  Widget build(BuildContext context) => StatusPill(
    label: booking.cancelled
        ? context.l10n.rentalBookingCancelled
        : context.l10n.rentalBookingStatus,
  );
}
