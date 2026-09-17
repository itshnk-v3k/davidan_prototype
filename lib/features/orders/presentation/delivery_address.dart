import 'package:davidan_prototype/core/utils/distance.dart';
import 'package:davidan_prototype/data/mock/mock_sectors.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

extension DeliveryAddressText on AppLocalizations {
  /// A delivery's address as people see it: the typed address, or for a
  /// delivery to the customer's current location, its area and coordinates.
  String deliveryAddressText(HomeDelivery delivery) => switch (delivery.point) {
    final point? => pinnedAddress(
      areaName(sectorAt(point)),
      formatCoordinates(point),
    ),
    null => delivery.address,
  };

  /// The same address as the customer sees it on their own order: "your
  /// location" and its area, without the coordinates the courier needs.
  String customerDeliveryAddressText(HomeDelivery delivery) =>
      switch (delivery.point) {
        final point? => pinnedAddressCustomer(areaName(sectorAt(point))),
        null => delivery.address,
      };
}
