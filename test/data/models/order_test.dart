import 'package:flutter_test/flutter_test.dart';

import 'package:davidan_prototype/data/models/order.dart';

Order orderWith(Fulfilment fulfilment, OrderStatus status) => Order(
  id: 'DD-1001',
  createdAt: DateTime(2026, 9, 15, 10),
  items: const [],
  totalBani: 0,
  fulfilment: fulfilment,
  payment: PaymentMethod.cash,
  status: status,
);

/// Who acts at each status of [fulfilment]'s flow, in flow order.
List<OrderActor?> actorsAlongFlow(Fulfilment fulfilment) => [
  for (final status in orderWith(fulfilment, OrderStatus.placed).statusFlow)
    orderWith(fulfilment, status).nextStepBy,
];

void main() {
  test('the store works a delivery up to ready, then the courier takes it', () {
    expect(actorsAlongFlow(const HomeDelivery(address: 'str. Ismail 88')), [
      OrderActor.store, // placed
      OrderActor.store, // accepted
      OrderActor.store, // preparing
      OrderActor.courier, // ready
      OrderActor.courier, // onTheWay
      null, // completed
    ]);
  });

  test('the store handles a pickup order all the way', () {
    expect(actorsAlongFlow(const StorePickup(locationId: 'centru')), [
      OrderActor.store, // placed
      OrderActor.store, // accepted
      OrderActor.store, // preparing
      OrderActor.store, // ready: handed over in the shop
      null, // completed
    ]);
  });
}
