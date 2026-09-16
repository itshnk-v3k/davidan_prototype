import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/data/models/order.dart';

/// Whether orders move on by themselves. On in the customer app build
/// (lib/main.dart), where no store panel or courier app is there to move
/// them; the staff build (lib/main_staff.dart) turns it off.
final orderSimulationProvider = Provider<bool>((ref) => true);

/// How long the pretend courier trip takes from the shop to the customer:
/// short enough to watch during a demo. The courier route map moves the
/// courier over this time.
const courierTripDuration = Duration(minutes: 2);

/// How long each step takes when the simulation plays the shop and the
/// courier. A delivery plays out in about five minutes, so a whole order can
/// be followed during a demo.
abstract final class SimulatedTimings {
  /// A new order waits this long for the shop to accept it.
  static const accept = Duration(seconds: 15);

  /// From accepted until the shop starts preparing.
  static const startPreparing = Duration(seconds: 20);

  /// Preparing until packed and ready.
  static const prepare = Duration(minutes: 1);

  /// Ready until a courier collects a delivery.
  static const collect = Duration(seconds: 30);

  /// The courier waits at the door this long after the trip, so the map
  /// shows them arriving before the order is handed over.
  static const handOver = Duration(seconds: 30);

  /// Ready until the customer collects a pickup order.
  static const pickUp = Duration(minutes: 2);
}

/// When the simulated shop or courier moves [order] on to its next status, or
/// null once it is completed. Each step counts from when the order got its
/// current status. A scheduled order waits to start preparing until it would
/// be ready (pickup) or delivered at its time.
DateTime? simulatedNextStepAt(Order order) {
  final since = order.statusSince;
  final delivery = order.fulfilment is HomeDelivery;
  return switch (order.status) {
    OrderStatus.placed => since.add(SimulatedTimings.accept),
    OrderStatus.accepted => _later(
      since.add(SimulatedTimings.startPreparing),
      order.scheduledFor?.subtract(
        delivery
            ? SimulatedTimings.prepare +
                  SimulatedTimings.collect +
                  courierTripDuration +
                  SimulatedTimings.handOver
            : SimulatedTimings.prepare,
      ),
    ),
    OrderStatus.preparing => since.add(SimulatedTimings.prepare),
    OrderStatus.ready => since.add(
      delivery ? SimulatedTimings.collect : SimulatedTimings.pickUp,
    ),
    OrderStatus.onTheWay => since.add(
      courierTripDuration + SimulatedTimings.handOver,
    ),
    OrderStatus.completed => null,
  };
}

DateTime _later(DateTime a, DateTime? b) => b != null && b.isAfter(a) ? b : a;
