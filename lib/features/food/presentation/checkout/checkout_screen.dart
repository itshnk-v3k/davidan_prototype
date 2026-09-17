import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/distance.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/core/widgets/detail_row.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/option_tile.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/data/mock/mock_sectors.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/data/models/pinned_location.dart';
import 'package:davidan_prototype/data/models/store_location.dart';
import 'package:davidan_prototype/features/account/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/features/account/presentation/widgets/fulfilment_fields.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/application/shop_providers.dart';
import 'package:davidan_prototype/features/food/application/checkout_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/total_bar.dart';
import 'package:davidan_prototype/features/orders/application/order_lines_provider.dart';
import 'package:davidan_prototype/features/orders/presentation/widgets/order_summary_card.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Checkout of one brand's cart: delivery address (or a pinned current
/// location) or, for a brand with shops to pick up from, a pickup shop, then
/// time, payment on receipt and the order summary.
/// Placing the order empties that cart and opens its confirmation.
class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key, required this.brand});

  final Brand brand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(checkoutProvider(brand));
    final placedOrder = draft.placedOrder;
    final lines = placedOrder == null
        ? ref.watch(cartLinesProvider(brand))
        : ref.watch(orderLinesProvider(placedOrder.id));

    // Opened from the cart, this route was pushed and pops back. Opened
    // straight from a URL there is nothing to pop, so go to the cart.
    void goBack() =>
        context.canPop() ? context.pop() : context.go(Routes.brandCart(brand));

    if (lines.isEmpty) {
      return _EmptyCheckout(
        onBack: goBack,
        // The menu is inside Acasă, so go() rather than push (see Routes).
        onBrowseMenu: () => context.go(Routes.brandMenu(brand)),
      );
    }

    final slots = ref.watch(checkoutTimeSlotsProvider);
    final locations = ref.watch(pickupShopsProvider(brand));
    // Not `placedOrder?.totalBani ?? ref.watch(...)`: the `??` context would
    // infer watch<int?> and make the total nullable.
    final total = placedOrder == null
        ? ref.watch(cartTotalProvider(brand))
        : placedOrder.totalBani;
    CheckoutNotifier checkout() => ref.read(checkoutProvider(brand).notifier);
    final delivery = draft.type == FulfilmentType.delivery;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(title: context.l10n.checkoutTitle, onBack: goBack),
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
                        ? context.l10n.deliveryTimeTitle
                        : context.l10n.pickupTimeTitle,
                    children: [
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          AppChip(
                            label: context.l10n.asSoonAsPossible,
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
                    title: context.l10n.paymentTitle,
                    children: [
                      Text(
                        delivery
                            ? context.l10n.paymentOnDelivery
                            : context.l10n.paymentOnPickup,
                        style: context.textStyles.bodySecondary,
                      ),
                      for (final method in PaymentMethod.values)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.sm),
                          child: OptionTile(
                            title: context.l10n.paymentMethod(method),
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
                    title: context.l10n.orderSummaryTitle,
                    children: [
                      OrderSummaryCard(
                        lines: lines,
                        totalBani: total,
                        // The bottom bar shows it, next to the button.
                        showTotal: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: TotalBar(
        total: context.l10n.formatLei(total),
        actionLabel: context.l10n.placeOrder,
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

  /// Where the brand's orders can be picked up. Empty for a brand that only
  /// delivers: no choice between delivery and pickup is shown.
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
      title: context.l10n.fulfilmentTitle,
      children: [
        if (locations.isNotEmpty) ...[
          FulfilmentTypeChips(selected: draft.type, onChanged: onTypeChanged),
          const SizedBox(height: AppSpacing.md),
        ],
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
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: context.colors.primary, width: 2),
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
              label: context.l10n.deliverToCurrentLocation,
              value: context.l10n.areaName(sectorAt(pinned.point)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, top: AppSpacing.xxs),
              child: Text(
                formatCoordinates(pinned.point),
                style: context.textStyles.caption,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onDrop,
                style: TextButton.styleFrom(
                  foregroundColor: context.colors.primary,
                  textStyle: context.textStyles.bodyStrong,
                ),
                child: Text(context.l10n.typeAddressInstead),
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
          Text(title, style: context.textStyles.subtitle),
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
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(title: context.l10n.checkoutTitle, onBack: onBack),
            Expanded(
              child: EmptyState(
                icon: Icons.shopping_bag_outlined,
                title: context.l10n.cartEmptyTitle,
                message: context.l10n.cartEmptyMessage,
                actionLabel: context.l10n.browseMenu,
                onAction: onBrowseMenu,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
