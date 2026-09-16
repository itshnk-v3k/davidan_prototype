import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/features/orders/application/order_simulation.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';

/// Plays the shop and the courier while the app is open: once a second it
/// moves on every order whose simulated next step is due (see
/// simulatedNextStepAt). DaviDanApp wraps the whole app in it when
/// orderSimulationProvider is on, so orders keep moving on any screen. The
/// time comes from clockProvider, so tests control it.
class OrderSimulator extends ConsumerStatefulWidget {
  const OrderSimulator({super.key, required this.child});

  final Widget child;

  static const interval = Duration(seconds: 1);

  @override
  ConsumerState<OrderSimulator> createState() => _OrderSimulatorState();
}

class _OrderSimulatorState extends ConsumerState<OrderSimulator> {
  late final Timer _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(
      OrderSimulator.interval,
      (_) => ref
          .read(ordersProvider.notifier)
          .advanceDue(ref.read(clockProvider)(), simulatedNextStepAt),
    );
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
