import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/distance.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/core/widgets/detail_row.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/option_tile.dart';
import 'package:davidan_prototype/data/mock/mock_sectors.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/data/models/pinned_location.dart';
import 'package:davidan_prototype/data/models/store_location.dart';
import 'package:davidan_prototype/features/client/application/cart_notifier.dart';
import 'package:davidan_prototype/features/client/application/catalog_providers.dart';
import 'package:davidan_prototype/features/client/application/checkout_notifier.dart';
import 'package:davidan_prototype/features/client/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/fulfilment_fields.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/total_bar.dart';
import 'package:davidan_prototype/features/orders/application/order_lines_provider.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/order_summary_card.dart';

/// Delivery address (or a pinned current location) or pickup shop, time,
/// payment on receipt and the order summary. Placing the order empties the
/// cart and opens its confirmation.
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
            ScreenHeader(title: AppStrings.checkoutTitle, onBack: goBack),
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
                    onDropPinned: () => checkout().dropPinnedLocation(),
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
    required this.onDropPinned,
    required this.onLocationSelected,
  });

  final CheckoutDraft draft;
  final List<StoreLocation> locations;
  final ValueChanged<FulfilmentType> onTypeChanged;
  final ValueChanged<String> onAddressChanged;
  final VoidCallback onDropPinned;
  final ValueChanged<String> onLocationSelected;

  @override
  Widget build(BuildContext context) {
    final delivery = draft.type == FulfilmentType.delivery;
    final pinned = draft.pinned;

    return _Section(
      title: AppStrings.fulfilmentTitle,
      children: [
        FulfilmentTypeChips(selected: draft.type, onChanged: onTypeChanged),
        const SizedBox(height: AppSpacing.md),
        if (delivery && pinned != null)
          _PinnedLocationCard(pinned: pinned, onDrop: onDropPinned)
        else if (delivery)
          // The draft owns the text: switching to pickup and back recreates
          // the field with what was typed before.
          DeliveryAddressField(
            initialValue: draft.address,
            onChanged: onAddressChanged,
            showMissingError: draft.showErrors && draft.addressMissing,
          )
        else
          PickupShopList(
            locations: locations,
            selectedId: draft.locationId,
            onSelected: onLocationSelected,
          ),
      ],
    );
  }
}

/// Delivery to the location pinned for this order, with a way back to typing
/// an address.
class _PinnedLocationCard extends StatelessWidget {
  const _PinnedLocationCard({required this.pinned, required this.onDrop});

  final PinnedLocation pinned;
  final VoidCallback onDrop;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DetailRow(
              icon: Icons.my_location_rounded,
              label: AppStrings.deliverToCurrentLocation,
              value: AppStrings.areaName(sectorAt(pinned.point)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, top: AppSpacing.xxs),
              child: Text(
                formatCoordinates(pinned.point),
                style: AppTextStyles.caption,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onDrop,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  textStyle: AppTextStyles.bodyStrong,
                ),
                child: const Text(AppStrings.typeAddressInstead),
              ),
            ),
          ],
        ),
      ),
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
            ScreenHeader(title: AppStrings.checkoutTitle, onBack: onBack),
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
