import 'package:flutter/widgets.dart';

import 'package:davidan_prototype/core/location/location_result.dart';
import 'package:davidan_prototype/data/models/brand_info.dart';
import 'package:davidan_prototype/data/models/chisinau_sector.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/l10n/app_localizations.dart';

export 'package:davidan_prototype/l10n/app_localizations.dart';

// All UI text lives in lib/l10n/app_ro.arb (Romanian, the source) and
// app_ru.arb; the build generates AppLocalizations from them (l10n.yaml).
// Product, category and banner names are content and live with the mock data
// in lib/data/mock/.

extension AppLocalizationsOfContext on BuildContext {
  /// UI text in the app's language. Notifiers and toasts read stringsProvider
  /// instead, which follows the same language without a BuildContext.
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Text for enum values, and for messages that take one, e.g.
/// `l10n.orderStatus(status)`. The switches are exhaustive, so a new enum value
/// doesn't compile until it has its text.
extension AppLocalizationsOfEnums on AppLocalizations {
  String sectorName(ChisinauSector sector) => switch (sector) {
    ChisinauSector.botanica => sectorBotanica,
    ChisinauSector.buiucani => sectorBuiucani,
    ChisinauSector.centru => sectorCentru,
    ChisinauSector.ciocana => sectorCiocana,
    ChisinauSector.riscani => sectorRiscani,
  };

  /// "Sectorul Botanica".
  String sectorLabel(ChisinauSector sector) => sectorOf(sectorName(sector));

  /// "Zona Botanica", or "În afara Chișinăului" for no sector.
  String areaName(ChisinauSector? sector) =>
      sector == null ? outsideChisinau : areaOf(sectorName(sector));

  String matchedBySector(ChisinauSector sector) =>
      matchedBySectorOf(sectorName(sector));

  String locationFailure(LocationFailure failure) => switch (failure) {
    LocationFailure.denied => locationFailureDenied,
    LocationFailure.deniedForever => locationFailureDeniedForever,
    LocationFailure.serviceOff => locationFailureServiceOff,
    LocationFailure.timeout => locationFailureTimeout,
    LocationFailure.unavailable => locationFailureUnavailable,
  };

  String locationFailedUseSector(LocationFailure failure) =>
      findShopBySectorAfter(locationFailure(failure));

  String brandInfoLabel(BrandInfoKind kind) => switch (kind) {
    BrandInfoKind.deliveryArea => brandInfoDeliveryArea,
    BrandInfoKind.address => brandInfoAddress,
    BrandInfoKind.phone => brandInfoPhone,
    BrandInfoKind.email => brandInfoEmail,
    BrandInfoKind.instagram => brandInfoInstagram,
    BrandInfoKind.company => brandInfoCompany,
  };

  String paymentMethod(PaymentMethod method) => switch (method) {
    PaymentMethod.cash => paymentCash,
    PaymentMethod.card => paymentCard,
  };

  String orderStatus(OrderStatus status) => switch (status) {
    OrderStatus.placed => orderStatusPlaced,
    OrderStatus.accepted => orderStatusAccepted,
    OrderStatus.preparing => orderStatusPreparing,
    OrderStatus.ready => orderStatusReady,
    OrderStatus.onTheWay => orderStatusOnTheWay,
    OrderStatus.completed => orderStatusCompleted,
  };

  /// Order actions on the store panel and in the courier app, named after the
  /// status they move the order to.
  String advanceTo(OrderStatus next) => switch (next) {
    OrderStatus.placed => placeOrder,
    OrderStatus.accepted => advanceToAccepted,
    OrderStatus.preparing => advanceToPreparing,
    OrderStatus.ready => advanceToReady,
    OrderStatus.onTheWay => advanceToOnTheWay,
    OrderStatus.completed => advanceToCompleted,
  };
}
