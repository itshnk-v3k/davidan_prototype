import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/option_tile.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/data/models/store_location.dart';
import 'package:davidan_prototype/features/client/application/cart_notifier.dart';
import 'package:davidan_prototype/features/client/application/catalog_providers.dart';
import 'package:davidan_prototype/features/client/application/checkout_notifier.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/order_summary_card.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/total_bar.dart';

/// Delivery address or pickup shop, time, payment on receipt and the order
/// summary. Placing the order empties the cart and opens its confirmation.
class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(checkoutProvider);
    final placedOrder = draft.placedOrder;
    final lines = placedOrder == null
        ? ref.watch(cartLinesProvider)
        : ref.watch(orderLinesProvider(placedOrder.id));

    // Opened from the cart, this route was pushed and pops back. Opened
    // straight from a URL there is nothing to pop, so go to the cart tab.
    void goBack() =>
        context.canPop() ? context.pop() : context.go(Routes.clientCart);

    if (lines.isEmpty) {
      return _EmptyCheckout(
        onBack: goBack,
        onBrowseMenu: () => context.go(Routes.clientMenu),
      );
    }

    final slots = ref.watch(checkoutTimeSlotsProvider);
    final locations = ref.watch(locationsProvider);
    // Not `placedOrder?.totalBani ?? ref.watch(...)`: the `??` context would
    // infer watch<int?> and make the total nullable.
    final total = placedOrder == null
        ? ref.watch(cartTotalProvider)
        : placedOrder.totalBani;
    CheckoutNotifier checkout() => ref.read(checkoutProvider.notifier);
    final delivery = draft.type == FulfilmentType.delivery;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(onBack: goBack),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  0,
                  AppSpacing.gutter,
                  AppSpacing.xl,
                ),
                children: [
                  _FulfilmentSection(
                    draft: draft,
                    locations: locations,
                    onTypeChanged: (type) => checkout().setType(type),
                    onAddressChanged: (address) =>
                        checkout().setAddress(address),
                    onLocationSelected: (id) => checkout().setLocation(id),
                  ),
                  _Section(
                    title: delivery
                        ? AppStrings.deliveryTimeTitle
                        : AppStrings.pickupTimeTitle,
                    children: [
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          AppChip(
                            label: AppStrings.asSoonAsPossible,
                            icon: Icons.bolt_rounded,
                            selected: draft.scheduledFor == null,
                            onTap: () => checkout().setTime(null),
                          ),
                          for (final slot in slots)
                            AppChip(
                              label: formatTime(slot),
                              selected: slot == draft.scheduledFor,
                              onTap: () => checkout().setTime(slot),
                            ),
                        ],
                      ),
                    ],
                  ),
                  _Section(
                    title: AppStrings.paymentTitle,
                    children: [
                      Text(
                        delivery
                            ? AppStrings.paymentOnDelivery
                            : AppStrings.paymentOnPickup,
                        style: AppTextStyles.bodySecondary,
                      ),
                      for (final method in PaymentMethod.values)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.sm),
                          child: OptionTile(
                            title: AppStrings.paymentMethod(method),
                            icon: switch (method) {
                              PaymentMethod.cash => Icons.payments_rounded,
                              PaymentMethod.card => Icons.credit_card_rounded,
                            },
                            selected: method == draft.payment,
                            onTap: () => checkout().setPayment(method),
                          ),
                        ),
                    ],
                  ),
                  _Section(
                    title: AppStrings.orderSummaryTitle,
                    children: [
                      OrderSummaryCard(lines: lines, totalBani: total),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: TotalBar(
        totalBani: total,
        actionLabel: AppStrings.placeOrder,
        onAction: () {
          final order = checkout().placeOrder();
          if (order != null) context.go(Routes.clientOrder(order.id));
        },
      ),
    );
  }
}

class _FulfilmentSection extends StatelessWidget {
  const _FulfilmentSection({
    required this.draft,
    required this.locations,
    required this.onTypeChanged,
    required this.onAddressChanged,
    required this.onLocationSelected,
  });

  final CheckoutDraft draft;
  final List<StoreLocation> locations;
  final ValueChanged<FulfilmentType> onTypeChanged;
  final ValueChanged<String> onAddressChanged;
  final ValueChanged<String> onLocationSelected;

  @override
  Widget build(BuildContext context) {
    final delivery = draft.type == FulfilmentType.delivery;

    return _Section(
      title: AppStrings.fulfilmentTitle,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            AppChip(
              label: AppStrings.delivery,
              icon: Icons.delivery_dining_rounded,
              selected: delivery,
              onTap: () => onTypeChanged(FulfilmentType.delivery),
            ),
            AppChip(
              label: AppStrings.pickup,
              icon: Icons.storefront_rounded,
              selected: !delivery,
              onTap: () => onTypeChanged(FulfilmentType.pickup),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (delivery)
          TextFormField(
            // The draft owns the text: switching to pickup and back recreates
            // the field with what was typed before.
            initialValue: draft.address,
            onChanged: onAddressChanged,
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.done,
            style: AppTextStyles.body,
            decoration: InputDecoration(
              labelText: AppStrings.deliveryAddress,
              hintText: AppStrings.deliveryAddressHint,
              prefixIcon: const Icon(Icons.location_on_outlined),
              errorText: draft.showErrors && draft.addressMissing
                  ? AppStrings.deliveryAddressMissing
                  : null,
            ),
          )
        else
          for (final (index, location) in locations.indexed)
            Padding(
              padding: EdgeInsets.only(top: index == 0 ? 0 : AppSpacing.sm),
              child: OptionTile(
                title: location.name,
                subtitle: '${location.address} · ${location.openingHours}',
                icon: Icons.storefront_rounded,
                selected: location.id == draft.locationId,
                onTap: () => onLocationSelected(location.id),
              ),
            ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: AppTextStyles.subtitle),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.md,
        AppSpacing.gutter,
        0,
      ),
      child: Row(
        children: [
          AppIconButton(
            icon: Icons.arrow_back_rounded,
            semanticLabel: AppStrings.back,
            onPressed: onBack,
          ),
          const SizedBox(width: AppSpacing.md),
          const Expanded(
            child: Text(AppStrings.checkoutTitle, style: AppTextStyles.title),
          ),
        ],
      ),
    );
  }
}

class _EmptyCheckout extends StatelessWidget {
  const _EmptyCheckout({required this.onBack, required this.onBrowseMenu});

  final VoidCallback onBack;
  final VoidCallback onBrowseMenu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(onBack: onBack),
            Expanded(
              child: EmptyState(
                icon: Icons.shopping_bag_outlined,
                title: AppStrings.cartEmptyTitle,
                message: AppStrings.cartEmptyMessage,
                actionLabel: AppStrings.browseMenu,
                onAction: onBrowseMenu,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
