import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/demo_tools/demo_tool_strings.dart';
import 'package:davidan_prototype/features/client/application/catalog_providers.dart';
import 'package:davidan_prototype/features/client/presentation/orders/order_confirmation_screen.dart';
import 'package:davidan_prototype/features/courier/presentation/courier_delivery_screen.dart';
import 'package:davidan_prototype/features/courier/presentation/courier_orders_screen.dart';
import 'package:davidan_prototype/features/kds/presentation/kds_screen.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';

/// Internal demo aid, not part of the app: the customer's order screen, the
/// store panel and the courier app side by side on the same orders, so one
/// window shows an order moving through every role. Only lib/main_demo.dart
/// registers it.
class AllRolesScreen extends ConsumerWidget {
  const AllRolesScreen({super.key, this.orderId});

  static const path = '/demo/roles';

  static String location(String orderId) =>
      Uri(path: path, queryParameters: {'order': orderId}).toString();

  /// The order the customer and courier delivery panels follow, taken from
  /// the URL. The newest order when missing or unknown.
  final String? orderId;

  static const _sideBySideMinWidth = 1100.0;
  static const _phoneColumnWidth = 380.0;
  static const _stackedPanelHeight = 640.0;
  static const _orderChipCount = 6;

  static const _testAddress = 'str. Ismail 88, ap. 12';
  static const _testItems = [('kurtos-scortisoara', 2), ('americano', 1)];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    final tracked =
        orders.where((order) => order.id == orderId).firstOrNull ??
        orders.firstOrNull;

    void placeTestOrder(Fulfilment fulfilment) {
      final products = ref.read(productsByIdProvider);
      final order = ref
          .read(ordersProvider.notifier)
          .place(
            items: [
              for (final (productId, quantity) in _testItems)
                if (products[productId] case final product?)
                  OrderItem(
                    productId: productId,
                    quantity: quantity,
                    priceBani: product.priceBani,
                  ),
            ],
            fulfilment: fulfilment,
            payment: PaymentMethod.cash,
          );
      context.go(location(order.id));
    }

    final customer = _Panel(
      label: DemoToolStrings.customerPanel,
      child: tracked == null
          ? const _NoOrder()
          : OrderConfirmationScreen(orderId: tracked.id),
    );
    const store = _Panel(label: DemoToolStrings.storePanel, child: KdsScreen());
    const courierList = _Panel(
      label: DemoToolStrings.courierListPanel,
      child: CourierOrdersScreen(),
    );
    final courierDelivery = _Panel(
      label: DemoToolStrings.courierDeliveryPanel,
      child: tracked == null
          ? const _NoOrder()
          : CourierDeliveryScreen(orderId: tracked.id),
    );

    return Scaffold(
      backgroundColor: AppColors.desktopBackdrop,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ScreenHeader(title: DemoToolStrings.allRolesTitle),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                0,
                AppSpacing.gutter,
                AppSpacing.md,
              ),
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    DemoToolStrings.trackedOrder,
                    style: AppTextStyles.label,
                  ),
                  for (final order in orders.take(_orderChipCount))
                    AppChip(
                      label: order.id,
                      selected: order.id == tracked?.id,
                      onTap: () => context.go(location(order.id)),
                    ),
                  AppChip(
                    label: DemoToolStrings.testDelivery,
                    icon: Icons.add_rounded,
                    selected: false,
                    onTap: () => placeTestOrder(
                      const HomeDelivery(address: _testAddress),
                    ),
                  ),
                  AppChip(
                    label: DemoToolStrings.testPickup,
                    icon: Icons.add_rounded,
                    selected: false,
                    onTap: () => placeTestOrder(
                      StorePickup(
                        locationId: ref.read(locationsProvider).first.id,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) =>
                    constraints.maxWidth >= _sideBySideMinWidth
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.gutter,
                          0,
                          AppSpacing.gutter,
                          AppSpacing.gutter,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(width: _phoneColumnWidth, child: customer),
                            const SizedBox(width: AppSpacing.lg),
                            const Expanded(child: store),
                            const SizedBox(width: AppSpacing.lg),
                            SizedBox(
                              width: _phoneColumnWidth,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Expanded(child: courierList),
                                  const SizedBox(height: AppSpacing.lg),
                                  Expanded(child: courierDelivery),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.gutter,
                          0,
                          AppSpacing.gutter,
                          AppSpacing.gutter,
                        ),
                        children: [
                          for (final panel in [
                            customer,
                            store,
                            courierList,
                            courierDelivery,
                          ])
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.lg,
                              ),
                              child: SizedBox(
                                height: _stackedPanelHeight,
                                child: panel,
                              ),
                            ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A labelled, rounded frame around one role's screen.
class _Panel extends StatelessWidget {
  const _Panel({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.xs,
            bottom: AppSpacing.xs,
          ),
          child: Text(label, style: AppTextStyles.label),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.lg),
            child: child,
          ),
        ),
      ],
    );
  }
}

class _NoOrder extends StatelessWidget {
  const _NoOrder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.background,
      child: EmptyState(
        icon: Icons.receipt_long_rounded,
        title: DemoToolStrings.noOrderTitle,
        message: DemoToolStrings.noOrderMessage,
      ),
    );
  }
}
