import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/core/widgets/option_tile.dart';
import 'package:davidan_prototype/data/models/store_location.dart';
import 'package:davidan_prototype/features/account/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

// Delivery-or-pickup controls shared by the location screen and checkout.

/// "Livrare" and "Ridicare din local" chips.
class FulfilmentTypeChips extends StatelessWidget {
  const FulfilmentTypeChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final FulfilmentType selected;
  final ValueChanged<FulfilmentType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        AppChip(
          label: context.l10n.delivery,
          icon: Icons.delivery_dining_rounded,
          selected: selected == FulfilmentType.delivery,
          onTap: () => onChanged(FulfilmentType.delivery),
        ),
        AppChip(
          label: context.l10n.pickup,
          icon: Icons.storefront_rounded,
          selected: selected == FulfilmentType.pickup,
          onTap: () => onChanged(FulfilmentType.pickup),
        ),
      ],
    );
  }
}

/// Delivery address input. [initialValue] is only read when the field is
/// created, so the screen's draft owns the text.
class DeliveryAddressField extends StatelessWidget {
  const DeliveryAddressField({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.showMissingError = false,
    this.onSubmitted,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;
  final bool showMissingError;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      keyboardType: TextInputType.streetAddress,
      textInputAction: TextInputAction.done,
      style: context.textStyles.body,
      decoration: InputDecoration(
        labelText: context.l10n.deliveryAddress,
        hintText: context.l10n.deliveryAddressHint,
        prefixIcon: const Icon(Icons.location_on_outlined),
        errorText: showMissingError
            ? context.l10n.deliveryAddressMissing
            : null,
      ),
    );
  }
}

/// A card per pickup shop, with its address and opening hours. The shop
/// nearest a signed-in customer ([nearestId]) says so.
class PickupShopList extends StatelessWidget {
  const PickupShopList({
    super.key,
    required this.locations,
    required this.selectedId,
    required this.onSelected,
    this.nearestId,
  });

  final List<StoreLocation> locations;

  /// Null when no shop is chosen.
  final String? selectedId;
  final ValueChanged<String> onSelected;
  final String? nearestId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, location) in locations.indexed)
          Padding(
            padding: EdgeInsets.only(top: index == 0 ? 0 : AppSpacing.sm),
            child: OptionTile(
              title: location.name,
              subtitle: [
                if (location.id == nearestId) context.l10n.nearestToYou,
                location.address,
                location.openingHours,
              ].join(' · '),
              icon: Icons.storefront_rounded,
              selected: location.id == selectedId,
              onTap: () => onSelected(location.id),
            ),
          ),
      ],
    );
  }
}
