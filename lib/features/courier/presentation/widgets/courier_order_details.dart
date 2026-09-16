import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/core/widgets/detail_row.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/orders/presentation/delivery_address.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// What a courier needs at a glance: where to go (an address, or the area
/// and coordinates of a customer's current location), when, and how much to
/// collect in which way (cash, or card on the POS terminal they carry).
class CourierOrderDetails extends StatelessWidget {
  const CourierOrderDetails({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final scheduledFor = order.scheduledFor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (order.fulfilment case final HomeDelivery delivery) ...[
          DetailRow(
            icon: Icons.location_on_rounded,
            label: context.l10n.deliverTo,
            value: context.l10n.deliveryAddressText(delivery),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        DetailRow(
          icon: Icons.schedule_rounded,
          label: context.l10n.orderTime,
          value: scheduledFor == null
              ? context.l10n.asSoonAsPossible
              : formatTime(scheduledFor),
        ),
        const SizedBox(height: AppSpacing.md),
        DetailRow(
          icon: Icons.payments_rounded,
          label: context.l10n.toCollect,
          value: context.l10n.amountToCollect(
            context.l10n.formatLei(order.totalBani),
            context.l10n.paymentMethod(order.payment),
          ),
        ),
      ],
    );
  }
}
