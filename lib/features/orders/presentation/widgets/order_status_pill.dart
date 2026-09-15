import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_motion.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/data/models/order.dart';

/// The order's status as a pill with a dot. The customer, shop and courier
/// screens all use it, so a status reads the same everywhere. A new status
/// crossfades in while the pill resizes to fit it.
class OrderStatusPill extends StatelessWidget {
  const OrderStatusPill({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.of(context, AppMotion.medium);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs + AppSpacing.xxs,
        ),
        child: AnimatedSize(
          duration: duration,
          curve: AppMotion.standard,
          alignment: AlignmentDirectional.centerStart,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: SizedBox.square(dimension: 8),
              ),
              const SizedBox(width: AppSpacing.sm),
              AnimatedSwitcher(
                duration: duration,
                layoutBuilder: (current, previous) => Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: [...previous, ?current],
                ),
                child: Text(
                  AppStrings.orderStatus(status),
                  key: ValueKey(status),
                  style: AppTextStyles.label,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
