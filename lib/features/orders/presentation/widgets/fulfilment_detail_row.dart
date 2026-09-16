import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/widgets/detail_row.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/food/application/shop_providers.dart';
import 'package:davidan_prototype/features/orders/presentation/delivery_address.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// How the customer gets an order: "Livrare la / str. Ismail 88", or
/// "Ridicare din / DaviDan Botanica · bd. Dacia 47, Chișinău".
class FulfilmentDetailRow extends ConsumerWidget {
  const FulfilmentDetailRow({super.key, required this.fulfilment});

  final Fulfilment fulfilment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (fulfilment) {
      final HomeDelivery delivery => DetailRow(
        icon: Icons.delivery_dining_rounded,
        label: context.l10n.deliverTo,
        value: context.l10n.deliveryAddressText(delivery),
      ),
      StorePickup(:final locationId) => DetailRow(
        icon: Icons.storefront_rounded,
        label: context.l10n.pickupFrom,
        value: switch (ref.watch(locationByIdProvider(locationId))) {
          final location? => '${location.name} · ${location.address}',
          null => locationId,
        },
      ),
    };
  }
}
