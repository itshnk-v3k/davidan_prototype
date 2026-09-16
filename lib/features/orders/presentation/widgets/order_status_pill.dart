import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/widgets/status_pill.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The order's status as a [StatusPill]. The customer, shop and courier
/// screens all use it, so a status reads the same everywhere.
class OrderStatusPill extends StatelessWidget {
  const OrderStatusPill({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) =>
      StatusPill(label: context.l10n.orderStatus(status));
}
