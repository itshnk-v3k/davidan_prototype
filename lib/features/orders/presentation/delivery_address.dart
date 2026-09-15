import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/utils/distance.dart';
import 'package:davidan_prototype/data/mock/mock_sectors.dart';
import 'package:davidan_prototype/data/models/order.dart';

/// A delivery's address as people see it: the typed address, or for a
/// delivery to the customer's current location, its area and coordinates.
String deliveryAddressText(HomeDelivery delivery) => switch (delivery.point) {
  final point? => AppStrings.pinnedAddress(
    AppStrings.areaName(sectorAt(point)),
    formatCoordinates(point),
  ),
  null => delivery.address,
};
