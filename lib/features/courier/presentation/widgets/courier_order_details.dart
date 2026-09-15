import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/core/widgets/detail_row.dart';
import 'package:davidan_prototype/data/models/order.dart';

/// What a courier needs at a glance: where to go, when, and how much to
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
        if (order.fulfilment case HomeDelivery(:final address)) ...[
          DetailRow(
            icon: Icons.location_on_rounded,
            label: AppStrings.deliverTo,
            value: address,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        DetailRow(
          icon: Icons.schedule_rounded,
          label: AppStrings.orderTime,
          value: scheduledFor == null
              ? AppStrings.asSoonAsPossible
              : formatTime(scheduledFor),
        ),
        const SizedBox(height: AppSpacing.md),
        DetailRow(
          icon: Icons.payments_rounded,
          label: AppStrings.toCollect,
          value: AppStrings.amountToCollect(
            formatLei(order.totalBani),
            AppStrings.paymentMethod(order.payment),
          ),
        ),
      ],
    );
  }
}
