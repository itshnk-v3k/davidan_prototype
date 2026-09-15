import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/features/courier/application/courier_providers.dart';
import 'package:davidan_prototype/features/courier/presentation/widgets/courier_order_card.dart';

/// Courier app home: deliveries on the way, then ones ready to collect from
/// the shop. Pickup orders never show up here.
class CourierOrdersScreen extends ConsumerWidget {
  const CourierOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(courierOrdersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ScreenHeader(title: AppStrings.courierOrdersTitle),
            Expanded(
              child: orders.isEmpty
                  ? const EmptyState(
                      icon: Icons.delivery_dining_rounded,
                      title: AppStrings.courierEmptyTitle,
                      message: AppStrings.courierEmptyMessage,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.gutter,
                        0,
                        AppSpacing.gutter,
                        AppSpacing.lg,
                      ),
                      itemCount: orders.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return CourierOrderCard(
                          key: ValueKey(order.id),
                          order: order,
                          onTap: () =>
                              context.push(Routes.courierDelivery(order.id)),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
