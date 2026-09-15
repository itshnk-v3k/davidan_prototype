import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/kds/application/kds_providers.dart';
import 'package:davidan_prototype/features/kds/presentation/widgets/kds_order_card.dart';

/// Store panel: every order the shop still has work on, in three columns
/// (new, in the kitchen, ready). A tablet or desktop shows the columns side
/// by side; a phone stacks them.
class KdsScreen extends ConsumerWidget {
  const KdsScreen({super.key});

  static const _sideBySideMinWidth = 840.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final columns = {
      for (final column in KdsColumn.values)
        column: ref.watch(kdsColumnProvider(column)),
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ScreenHeader(title: AppStrings.kdsTitle),
            Expanded(
              child: columns.values.every((orders) => orders.isEmpty)
                  ? const EmptyState(
                      icon: Icons.receipt_long_rounded,
                      title: AppStrings.kdsEmptyTitle,
                      message: AppStrings.kdsEmptyMessage,
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) =>
                          constraints.maxWidth >= _sideBySideMinWidth
                          ? _SideBySide(columns: columns)
                          : _Stacked(columns: columns),
                    ),
            ),
          ],
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
                                  itemBuilder: (_, index) => KdsOrderCard(
                                    key: ValueKey(orders[index].id),
                                    order: orders[index],
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
                      child: KdsOrderCard(order: order),
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
    return Row(
      children: [
        Text(switch (column) {
          KdsColumn.incoming => AppStrings.kdsIncoming,
          KdsColumn.inKitchen => AppStrings.kdsInKitchen,
          KdsColumn.ready => AppStrings.kdsReady,
        }, style: AppTextStyles.subtitle),
        const SizedBox(width: AppSpacing.sm),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.accentSoft,
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            child: Text('$count', style: AppTextStyles.label),
          ),
        ),
      ],
    );
  }
}
