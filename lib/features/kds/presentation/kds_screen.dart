import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_motion.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/entrance.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/core/widgets/section_title.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/kds/application/kds_providers.dart';
import 'package:davidan_prototype/features/kds/presentation/widgets/kds_order_card.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';

/// Store panel: every order the shop still has work on, in three columns
/// (new, in the kitchen, ready). A tablet or desktop shows the columns side
/// by side; a phone stacks them. An order placed while the panel is open is
/// announced by a short notice at the top. A card fades in wherever it lands:
/// a new order, or an order moving to the next column.
class KdsScreen extends ConsumerStatefulWidget {
  const KdsScreen({super.key});

  /// How long a new-order notice stays up.
  static const noticeDuration = Duration(seconds: 4);

  static const _sideBySideMinWidth = 840.0;

  @override
  ConsumerState<KdsScreen> createState() => _KdsScreenState();
}

class _KdsScreenState extends ConsumerState<KdsScreen> {
  /// The most recently placed order, while its notice is up.
  String? _announcedOrderId;
  Timer? _noticeTimer;

  @override
  void dispose() {
    _noticeTimer?.cancel();
    super.dispose();
  }

  /// Shows the notice for [orderId], replacing any notice still up.
  void _announce(String orderId) {
    _noticeTimer?.cancel();
    setState(() => _announcedOrderId = orderId);
    _noticeTimer = Timer(KdsScreen.noticeDuration, () {
      if (mounted) setState(() => _announcedOrderId = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final columns = {
      for (final column in KdsColumn.values)
        column: ref.watch(kdsColumnProvider(column)),
    };

    // Only orders that didn't exist before are news: not the ones already
    // there when the panel opened, nor orders moving between columns.
    ref.listen(ordersProvider, (previous, next) {
      final known = {for (final order in previous ?? const <Order>[]) order.id};
      for (final order in next) {
        if (!known.contains(order.id) && order.status == OrderStatus.placed) {
          _announce(order.id);
        }
      }
    });

    final announcedOrderId = _announcedOrderId;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ScreenHeader(title: AppStrings.kdsTitle),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: columns.values.every((orders) => orders.isEmpty)
                        ? const EmptyState(
                            icon: Icons.receipt_long_rounded,
                            title: AppStrings.kdsEmptyTitle,
                            message: AppStrings.kdsEmptyMessage,
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) =>
                                constraints.maxWidth >=
                                    KdsScreen._sideBySideMinWidth
                                ? _SideBySide(columns: columns)
                                : _Stacked(columns: columns),
                          ),
                  ),
                  // Floats over the columns but lets taps through, so it never
                  // covers an Accept button while it's up.
                  Positioned(
                    top: AppSpacing.xs,
                    left: AppSpacing.gutter,
                    right: AppSpacing.gutter,
                    child: IgnorePointer(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: AnimatedSwitcher(
                          duration: AppMotion.of(context, AppMotion.medium),
                          switchInCurve: AppMotion.standard,
                          switchOutCurve: AppMotion.standard,
                          // Drops in from the top edge and rises away.
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween(
                                    begin: const Offset(0, -0.5),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              ),
                          child: announcedOrderId == null
                              ? const SizedBox.shrink()
                              : _NewOrderNotice(
                                  key: ValueKey(announcedOrderId),
                                  orderId: announcedOrderId,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewOrderNotice extends StatelessWidget {
  const _NewOrderNotice({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadii.pill),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.notifications_active_rounded,
                size: 18,
                color: AppColors.onPrimary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  AppStrings.newOrderArrived(orderId),
                  style: AppTextStyles.bodyStrong.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideBySide extends StatelessWidget {
  const _SideBySide({required this.columns});

  final Map<KdsColumn, List<Order>> columns;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        0,
        AppSpacing.gutter,
        AppSpacing.gutter,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, MapEntry(key: column, value: orders))
              in columns.entries.indexed)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: index == 0 ? 0 : AppSpacing.lg),
                child: DecoratedBox(
                  key: ValueKey(column),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ColumnTitle(column: column, count: orders.length),
                        const SizedBox(height: AppSpacing.md),
                        Expanded(
                          child: orders.isEmpty
                              ? const Center(
                                  child: Text(
                                    AppStrings.kdsColumnEmpty,
                                    style: AppTextStyles.bodySecondary,
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: orders.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(height: AppSpacing.md),
                                  itemBuilder: (_, index) => Entrance(
                                    key: ValueKey(orders[index].id),
                                    child: KdsOrderCard(order: orders[index]),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Stacked extends StatelessWidget {
  const _Stacked({required this.columns});

  final Map<KdsColumn, List<Order>> columns;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        0,
        AppSpacing.gutter,
        AppSpacing.xl,
      ),
      children: [
        for (final (index, MapEntry(key: column, value: orders))
            in columns.entries.indexed)
          Padding(
            key: ValueKey(column),
            padding: EdgeInsets.only(top: index == 0 ? 0 : AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ColumnTitle(column: column, count: orders.length),
                const SizedBox(height: AppSpacing.md),
                if (orders.isEmpty)
                  const Text(
                    AppStrings.kdsColumnEmpty,
                    style: AppTextStyles.bodySecondary,
                  )
                else
                  for (final (index, order) in orders.indexed)
                    Padding(
                      key: ValueKey(order.id),
                      padding: EdgeInsets.only(
                        top: index == 0 ? 0 : AppSpacing.md,
                      ),
                      child: Entrance(child: KdsOrderCard(order: order)),
                    ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ColumnTitle extends StatelessWidget {
  const _ColumnTitle({required this.column, required this.count});

  final KdsColumn column;
  final int count;

  @override
  Widget build(BuildContext context) {
    return SectionTitle(
      title: switch (column) {
        KdsColumn.incoming => AppStrings.kdsIncoming,
        KdsColumn.inKitchen => AppStrings.kdsInKitchen,
        KdsColumn.ready => AppStrings.kdsReady,
      },
      count: count,
    );
  }
}
