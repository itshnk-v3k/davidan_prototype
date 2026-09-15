import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/data/models/cart_item.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/client/application/cart_notifier.dart';
import 'package:davidan_prototype/features/client/application/catalog_providers.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';

enum FulfilmentType { delivery, pickup }

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
    this.placedOrder,
  });

  final FulfilmentType type;

  /// Typed delivery address. Kept when switching to pickup and back.
  final String address;

  /// Selected pickup shop.
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
      type == FulfilmentType.delivery && address.trim().isEmpty;

  CheckoutDraft copyWith({
    FulfilmentType? type,
    String? address,
    String? locationId,
    PaymentMethod? payment,
    ValueGetter<DateTime?>? scheduledFor,
    bool? showErrors,
    Order? placedOrder,
  }) => CheckoutDraft(
    type: type ?? this.type,
    address: address ?? this.address,
    locationId: locationId ?? this.locationId,
    payment: payment ?? this.payment,
    scheduledFor: scheduledFor != null ? scheduledFor() : this.scheduledFor,
    showErrors: showErrors ?? this.showErrors,
    placedOrder: placedOrder ?? this.placedOrder,
  );
}

/// An order's items with their products looked up in the catalog. Items whose
/// product has since left the catalog are skipped.
final orderLinesProvider = Provider.family<List<CartLine>, String>((
  ref,
  orderId,
) {
  final items = ref.watch(orderByIdProvider(orderId))?.items ?? const [];
  final products = ref.watch(productsByIdProvider);
  return [
    for (final item in items)
      if (products[item.productId] case final product?)
        (product: product, quantity: item.quantity),
  ];
});

/// Auto-disposed when the checkout screen closes, so every checkout starts
/// fresh. The cart itself stays in CartNotifier.
final checkoutProvider =
    NotifierProvider.autoDispose<CheckoutNotifier, CheckoutDraft>(
      CheckoutNotifier.new,
    );

/// Time slots offered at checkout, computed once when the screen opens.
final checkoutTimeSlotsProvider = Provider.autoDispose<List<DateTime>>(
  (ref) => timeSlotsAfter(ref.watch(clockProvider)()),
);

/// Six half-hour slots, the first at least 30 minutes after [now]:
/// 10:07 → 11:00, 11:30 … 13:30. Opening hours are ignored in the prototype.
List<DateTime> timeSlotsAfter(DateTime now) {
  final earliest = now.add(const Duration(minutes: 30));
  final halfHour = DateTime(
    earliest.year,
    earliest.month,
    earliest.day,
    earliest.hour,
    earliest.minute - earliest.minute % 30,
  );
  final first = halfHour.isBefore(earliest)
      ? halfHour.add(const Duration(minutes: 30))
      : halfHour;
  return [for (var i = 0; i < 6; i++) first.add(Duration(minutes: 30 * i))];
}

class CheckoutNotifier extends Notifier<CheckoutDraft> {
  @override
  CheckoutDraft build() => CheckoutDraft(
    type: FulfilmentType.delivery,
    address: '',
    locationId: ref.watch(locationsProvider).first.id,
    payment: PaymentMethod.cash,
    scheduledFor: null,
    showErrors: false,
  );

  void setType(FulfilmentType type) => state = state.copyWith(type: type);

  void setAddress(String address) => state = state.copyWith(address: address);

  void setLocation(String locationId) =>
      state = state.copyWith(locationId: locationId);

  void setPayment(PaymentMethod payment) =>
      state = state.copyWith(payment: payment);

  void setTime(DateTime? scheduledFor) =>
      state = state.copyWith(scheduledFor: () => scheduledFor);

  /// Places the order from the cart and empties the cart. Returns null, and
  /// shows the form errors, when something required is missing.
  Order? placeOrder() {
    final items = ref.read(cartProvider);
    if (items.isEmpty) return null;
    if (state.addressMissing) {
      state = state.copyWith(showErrors: true);
      return null;
    }

    final order = ref
        .read(ordersProvider.notifier)
        .place(
          items: items,
          totalBani: ref.read(cartTotalProvider),
          fulfilment: switch (state.type) {
            FulfilmentType.delivery => HomeDelivery(
              address: state.address.trim(),
            ),
            FulfilmentType.pickup => StorePickup(locationId: state.locationId),
          },
          payment: state.payment,
          scheduledFor: state.scheduledFor,
        );
    state = state.copyWith(placedOrder: order);
    ref.read(cartProvider.notifier).clear();
    return order;
  }
}
