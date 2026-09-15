import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/option_tile.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/client/application/catalog_providers.dart';
import 'package:davidan_prototype/features/client/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/features/client/application/location_draft_notifier.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/fulfilment_fields.dart';

/// Delivery address or pickup shop for the customer's orders. As in delivery
/// apps' address pickers, a ready option (a recent address, a shop) is chosen
/// with one tap, and a typed address is confirmed with a button. Opened by
/// the splash screen on first run, and from the home location bar after.
class LocationScreen extends ConsumerWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(locationDraftProvider);
    final choice = ref.watch(fulfilmentChoiceProvider);
    LocationDraftNotifier location() =>
        ref.read(locationDraftProvider.notifier);
    FulfilmentChoiceNotifier save() =>
        ref.read(fulfilmentChoiceProvider.notifier);

    // Pushed from home, this route pops back there. On first run the splash
    // opened it with go(), so there is nothing to pop: continue to home.
    void close() =>
        context.canPop() ? context.pop() : context.go(Routes.clientHome);

    void confirmAddress() {
      if (location().confirmAddress()) close();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: AppStrings.locationTitle,
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
                  const Text(
                    AppStrings.locationPrompt,
                    style: AppTextStyles.bodySecondary,
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
                      label: AppStrings.confirmAddress,
                      onPressed: confirmAddress,
                    ),
                    _RecentAddresses(
                      addresses: ref.watch(recentAddressesProvider),
                      selected: choice is HomeDelivery ? choice.address : null,
                      onSelected: (address) {
                        save().chooseDelivery(address);
                        close();
                      },
                    ),
                  ] else
                    PickupShopList(
                      locations: ref.watch(locationsProvider),
                      selectedId: choice is StorePickup
                          ? choice.locationId
                          : null,
                      onSelected: (locationId) {
                        save().choosePickup(locationId);
                        close();
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
          const Text(
            AppStrings.recentAddressesTitle,
            style: AppTextStyles.subtitle,
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
