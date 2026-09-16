import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/data/models/pinned_location.dart';
import 'package:davidan_prototype/features/account/application/current_location_notifier.dart';
import 'package:davidan_prototype/features/account/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/application/shop_providers.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';

/// What the customer has filled in on the checkout screen so far.
@immutable
class CheckoutDraft {
  const CheckoutDraft({
    required this.type,
    required this.address,
    required this.locationId,
    required this.payment,
    required this.scheduledFor,
    required this.showErrors,
    this.pinned,
    this.placedOrder,
  });

  final FulfilmentType type;

  /// Typed delivery address. Kept when switching to pickup and back.
  final String address;

  /// A one-off delivery point from "Folosește locația mea curentă". While
  /// set, a delivery goes there instead of to [address].
  final PinnedLocation? pinned;

  /// Selected pickup shop. Empty for a brand with nowhere to pick up.
  final String locationId;
  final PaymentMethod payment;

  /// Chosen time slot, or null for "as soon as possible".
  final DateTime? scheduledFor;

  /// Set by a failed attempt to place the order, so errors only appear after
  /// the customer tried to submit.
  final bool showErrors;

  /// The order this checkout placed. The cart is empty from then on, but the
  /// screen stays visible while the confirmation slides in, so it keeps
  /// showing this order instead of an empty cart.
  final Order? placedOrder;

  bool get addressMissing =>
      type == FulfilmentType.delivery &&
      pinned == null &&
      address.trim().isEmpty;

  CheckoutDraft copyWith({
    FulfilmentType? type,
    String? address,
    ValueGetter<PinnedLocation?>? pinned,
    String? locationId,
    PaymentMethod? payment,
    ValueGetter<DateTime?>? scheduledFor,
    bool? showErrors,
    Order? placedOrder,
  }) => CheckoutDraft(
    type: type ?? this.type,
    address: address ?? this.address,
    pinned: pinned != null ? pinned() : this.pinned,
    locationId: locationId ?? this.locationId,
    payment: payment ?? this.payment,
    scheduledFor: scheduledFor != null ? scheduledFor() : this.scheduledFor,
    showErrors: showErrors ?? this.showErrors,
    placedOrder: placedOrder ?? this.placedOrder,
  );
}

/// One brand's checkout. Auto-disposed when the checkout screen closes, so
/// every checkout starts fresh. The cart itself stays in CartNotifier.
final checkoutProvider = NotifierProvider.autoDispose
    .family<CheckoutNotifier, CheckoutDraft, Brand>(CheckoutNotifier.new);

/// Time slots offered at checkout, computed once when the screen opens.
final checkoutTimeSlotsProvider = Provider.autoDispose<List<DateTime>>(
  (ref) => timeSlotsAfter(ref.watch(clockProvider)()),
);

/// Scheduled times stay within this window of the current day.
const _slotsFromHour = 8;
const _slotsUntilHour = 20;

/// Up to six half-hour slots today between 08:00 and 20:00, the first at least
/// 30 minutes after [now]: 10:07 → 11:00 … 13:30, 06:10 → 08:00 … 10:30,
/// 18:20 → 19:00, 19:30, 20:00. From 19:31 there are none, and the customer
/// can only order "as soon as possible".
List<DateTime> timeSlotsAfter(DateTime now) {
  final opens = DateTime(now.year, now.month, now.day, _slotsFromHour);
  final closes = DateTime(now.year, now.month, now.day, _slotsUntilHour);
  final earliest = now.add(const Duration(minutes: 30));
  final halfHour = DateTime(
    earliest.year,
    earliest.month,
    earliest.day,
    earliest.hour,
    earliest.minute - earliest.minute % 30,
  );
  var slot = halfHour.isBefore(earliest)
      ? halfHour.add(const Duration(minutes: 30))
      : halfHour;
  if (slot.isBefore(opens)) slot = opens;

  final slots = <DateTime>[];
  while (slots.length < 6 && !slot.isAfter(closes)) {
    slots.add(slot);
    slot = slot.add(const Duration(minutes: 30));
  }
  return slots;
}

class CheckoutNotifier extends Notifier<CheckoutDraft> {
  CheckoutNotifier(this.brand);

  final Brand brand;

  /// Starts from a pinned current location if there is one, otherwise from
  /// the delivery address or pickup shop saved on the location screen. A
  /// brand with nowhere to pick up starts from delivery.
  @override
  CheckoutDraft build() {
    final choice = ref.watch(fulfilmentChoiceProvider);
    final shops = ref.watch(pickupShopsProvider(brand));
    // Read, not watched: placing the order clears the pinned point, and a
    // rebuild then would drop the placed order this screen still shows.
    final pinned = ref.read(currentLocationProvider).pinned;
    final pickupShop = choice is StorePickup
        ? shops.where((shop) => shop.id == choice.locationId).firstOrNull
        : null;
    return CheckoutDraft(
      type: pinned == null && pickupShop != null
          ? FulfilmentType.pickup
          : FulfilmentType.delivery,
      address: choice is HomeDelivery ? choice.address : '',
      pinned: pinned,
      locationId: (pickupShop ?? shops.firstOrNull)?.id ?? '',
      payment: PaymentMethod.cash,
      scheduledFor: null,
      showErrors: false,
    );
  }

  /// Pickup is ignored for a brand with nowhere to pick up.
  void setType(FulfilmentType type) {
    if (type == FulfilmentType.pickup &&
        ref.read(pickupShopsProvider(brand)).isEmpty) {
      return;
    }
    state = state.copyWith(type: type);
  }

  void setAddress(String address) => state = state.copyWith(address: address);

  /// Stops delivering to the pinned current location, for this order and the
  /// next ones, and goes back to the typed address.
  void dropPinnedLocation() {
    state = state.copyWith(pinned: () => null);
    ref.read(currentLocationProvider.notifier).clear();
  }

  void setLocation(String locationId) =>
      state = state.copyWith(locationId: locationId);

  void setPayment(PaymentMethod payment) =>
      state = state.copyWith(payment: payment);

  void setTime(DateTime? scheduledFor) =>
      state = state.copyWith(scheduledFor: () => scheduledFor);

  /// Places the order from the brand's cart and empties that cart. A pinned current
  /// location is used up by it. Returns null, and shows the form errors, when
  /// something required is missing.
  Order? placeOrder() {
    final lines = ref.read(cartLinesProvider(brand));
    if (lines.isEmpty) return null;
    if (state.addressMissing) {
      state = state.copyWith(showErrors: true);
      return null;
    }

    final pinned = state.pinned;
    final order = ref
        .read(ordersProvider.notifier)
        .place(
          brand: brand,
          items: [
            for (final line in lines)
              OrderItem(
                productId: line.product.id,
                quantity: line.quantity,
                priceBani: line.priceBani,
              ),
          ],
          fulfilment: switch (state.type) {
            FulfilmentType.delivery when pinned != null => HomeDelivery(
              address: '',
              point: pinned.point,
            ),
            FulfilmentType.delivery => HomeDelivery(
              address: state.address.trim(),
            ),
            FulfilmentType.pickup => StorePickup(locationId: state.locationId),
          },
          payment: state.payment,
          scheduledFor: state.scheduledFor,
        );
    state = state.copyWith(placedOrder: order);
    ref.read(cartProvider(brand).notifier).clear();
    if (state.type == FulfilmentType.delivery && pinned != null) {
      ref.read(currentLocationProvider.notifier).clear();
    }
    return order;
  }
}
