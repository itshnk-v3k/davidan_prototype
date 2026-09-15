import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/entrance.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/core/widgets/section_title.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/courier/application/courier_online_notifier.dart';
import 'package:davidan_prototype/features/courier/application/courier_providers.dart';
import 'package:davidan_prototype/features/courier/presentation/widgets/courier_order_card.dart';

/// Courier app home: an online/offline switch, then deliveries on the way and
/// deliveries ready to collect from the shop, each group with its count.
/// Offline, only the deliveries already on the way stay listed. Pickup orders
/// never show up here.
class CourierOrdersScreen extends ConsumerWidget {
  const CourierOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (:onTheWay, :ready) = ref.watch(courierDeliveriesProvider);
    final online = ref.watch(courierOnlineProvider);
    void open(Order order) => context.push(Routes.courierDelivery(order.id));

    final Widget list;
    if (onTheWay.isEmpty && (ready.isEmpty || !online)) {
      list = online
          ? const EmptyState(
              icon: Icons.delivery_dining_rounded,
              title: AppStrings.courierEmptyTitle,
              message: AppStrings.courierEmptyMessage,
            )
          : const EmptyState(
              icon: Icons.power_settings_new_rounded,
              title: AppStrings.courierOfflineTitle,
              message: AppStrings.courierOfflineMessage,
            );
    } else {
      list = ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          0,
          AppSpacing.gutter,
          AppSpacing.lg,
        ),
        children: [
          if (onTheWay.isNotEmpty)
            _Group(
              title: AppStrings.courierOnTheWaySection,
              orders: onTheWay,
              onOpen: open,
            ),
          if (!online)
            const _OfflineNote()
          else if (ready.isNotEmpty)
            _Group(
              title: AppStrings.courierReadySection,
              orders: ready,
              onOpen: open,
            ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ScreenHeader(title: AppStrings.courierOrdersTitle),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                0,
                AppSpacing.gutter,
                AppSpacing.lg,
              ),
              child: _OnlineSwitch(
                online: online,
                onChanged: (online) =>
                    ref.read(courierOnlineProvider.notifier).setOnline(online),
              ),
            ),
            Expanded(child: list),
          ],
        ),
      ),
    );
  }
}

class _OnlineSwitch extends StatelessWidget {
  const _OnlineSwitch({required this.online, required this.onChanged});

  final bool online;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        side: BorderSide(color: context.colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onChanged(!online),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.sm,
          ),
          child: MergeSemantics(
            child: Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: online
                        ? context.colors.primary
                        : context.colors.textDisabled,
                    shape: BoxShape.circle,
                  ),
                  child: const SizedBox.square(dimension: 10),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        online
                            ? AppStrings.courierOnline
                            : AppStrings.courierOffline,
                        style: context.textStyles.bodyStrong,
                      ),
                      Text(
                        online
                            ? AppStrings.courierOnlineHint
                            : AppStrings.courierOfflineHint,
                        style: context.textStyles.caption,
                      ),
                    ],
                  ),
                ),
                Switch(value: online, onChanged: onChanged),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A titled list of deliveries. A card fades in when its delivery joins the
/// group (the shop marks it ready, or the courier picks it up).
class _Group extends StatelessWidget {
  const _Group({
    required this.title,
    required this.orders,
    required this.onOpen,
  });

  final String title;
  final List<Order> orders;
  final ValueChanged<Order> onOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionTitle(title: title, count: orders.length),
          for (final order in orders)
            Padding(
              key: ValueKey(order.id),
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Entrance(
                child: CourierOrderCard(
                  order: order,
                  onTap: () => onOpen(order),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OfflineNote extends StatelessWidget {
  const _OfflineNote();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.power_settings_new_rounded,
          size: 20,
          color: context.colors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            AppStrings.courierOfflineMessage,
            style: context.textStyles.bodySecondary,
          ),
        ),
      ],
    );
  }
}
