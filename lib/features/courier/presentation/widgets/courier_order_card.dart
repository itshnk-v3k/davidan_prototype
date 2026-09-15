import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/courier/presentation/widgets/courier_order_details.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/order_status_pill.dart';

/// A delivery in the courier's list. Tapping it opens the delivery.
class CourierOrderCard extends StatelessWidget {
  const CourierOrderCard({super.key, required this.order, required this.onTap});

  final Order order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        side: const BorderSide(color: AppColors.border),
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
                    child: Text(order.id, style: AppTextStyles.subtitle),
                  ),
                  OrderStatusPill(status: order.status),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              CourierOrderDetails(order: order),
            ],
          ),
        ),
      ),
    );
  }
}
