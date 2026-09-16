import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/link_card.dart';
import 'package:davidan_prototype/core/widgets/option_tile.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/account/application/account_notifier.dart';
import 'package:davidan_prototype/features/account/application/current_location_notifier.dart';
import 'package:davidan_prototype/features/account/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/features/account/application/location_draft_notifier.dart';
import 'package:davidan_prototype/features/account/presentation/widgets/fulfilment_fields.dart';
import 'package:davidan_prototype/features/food/application/shop_providers.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Delivery address or pickup shop for the customer's orders. As in delivery
/// apps' address pickers, a ready option (a recent address, a shop) is chosen
/// with one tap, and a typed address is confirmed with a button. At the top,
/// "Folosește locația mea curentă" sets a delivery point for the next order
/// only, falling back to the map picker when the location isn't available.
///
/// Opened by the splash on first run, from the home location bar after, and
/// right after sign-up with [suggestNearest]: pickup, with the nearest shop
/// selected until the customer confirms it.
class LocationScreen extends ConsumerWidget {
  const LocationScreen({super.key, this.suggestNearest = false});

  final bool suggestNearest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(locationDraftProvider(suggestNearest));
    final choice = ref.watch(fulfilmentChoiceProvider);
    final locating = ref.watch(
      currentLocationProvider.select((state) => state.locating),
    );
    final nearestId = ref.watch(accountProvider)?.nearestLocationId;
    LocationDraftNotifier location() =>
        ref.read(locationDraftProvider(suggestNearest).notifier);
    FulfilmentChoiceNotifier save() =>
        ref.read(fulfilmentChoiceProvider.notifier);

    // Pushed from home, this route pops back there. On first run and after
    // sign-up it was opened with go(), so there is nothing to pop: continue
    // to home.
    void close() =>
        context.canPop() ? context.pop() : context.go(Routes.clientHome);

    // Choosing an address or shop here also drops a location pinned for the
    // next order: the customer just said where they want it.
    void saved() {
      ref.read(currentLocationProvider.notifier).clear();
      close();
    }

    void confirmAddress() {
      if (location().confirmAddress()) saved();
    }

    Future<void> useCurrentLocation() async {
      final failure = await ref.read(currentLocationProvider.notifier).locate();
      if (!context.mounted) return;
      if (failure == null) {
        close();
      } else {
        context.push(Routes.clientLocationMap(failure));
      }
    }

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: context.l10n.locationTitle,
              onBack: context.canPop() ? () => context.pop() : null,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  0,
                  AppSpacing.gutter,
                  AppSpacing.xl,
                ),
                children: [
                  Text(
                    context.l10n.locationPrompt,
                    style: context.textStyles.bodySecondary,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  LinkCard(
                    icon: Icons.my_location_rounded,
                    title: context.l10n.useCurrentLocation,
                    hint: locating
                        ? context.l10n.locating
                        : context.l10n.useCurrentLocationHint,
                    onTap: locating ? () {} : useCurrentLocation,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FulfilmentTypeChips(
                    selected: draft.type,
                    onChanged: (type) => location().setType(type),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (draft.type == FulfilmentType.delivery) ...[
                    DeliveryAddressField(
                      initialValue: draft.address,
                      onChanged: (address) => location().setAddress(address),
                      showMissingError:
                          draft.showErrors && draft.addressMissing,
                      onSubmitted: (_) => confirmAddress(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: context.l10n.confirmAddress,
                      onPressed: confirmAddress,
                    ),
                    _RecentAddresses(
                      addresses: ref.watch(recentAddressesProvider),
                      selected: choice is HomeDelivery ? choice.address : null,
                      onSelected: (address) {
                        save().chooseDelivery(address);
                        saved();
                      },
                    ),
                  ] else if (draft.pickupSelection case final selection?) ...[
                    Text(
                      context.l10n.nearestSuggestion,
                      style: context.textStyles.bodySecondary,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PickupShopList(
                      locations: ref.watch(locationsProvider),
                      selectedId: selection,
                      nearestId: nearestId,
                      onSelected: (locationId) =>
                          location().selectPickup(locationId),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: context.l10n.confirmShop,
                      onPressed: () {
                        if (location().confirmPickup()) saved();
                      },
                    ),
                  ] else
                    PickupShopList(
                      locations: ref.watch(locationsProvider),
                      selectedId: choice is StorePickup
                          ? choice.locationId
                          : null,
                      nearestId: nearestId,
                      onSelected: (locationId) {
                        save().choosePickup(locationId);
                        saved();
                      },
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

/// Addresses of past deliveries, one tap each. Nothing when there are none.
class _RecentAddresses extends StatelessWidget {
  const _RecentAddresses({
    required this.addresses,
    required this.selected,
    required this.onSelected,
  });

  final List<String> addresses;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    if (addresses.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.recentAddressesTitle,
            style: context.textStyles.subtitle,
          ),
          for (final address in addresses)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: OptionTile(
                title: address,
                icon: Icons.history_rounded,
                selected: address == selected,
                onTap: () => onSelected(address),
              ),
            ),
        ],
      ),
    );
  }
}
