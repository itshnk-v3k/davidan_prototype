import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/core/utils/time.dart';

/// Rebuilds [builder] once a second with the current time from clockProvider,
/// for anything that shows time passing: a wait timer, a courier on the way.
/// Every tick reads the clock again, so nothing drifts and tests can move
/// time by overriding clockProvider.
class ClockTicker extends ConsumerStatefulWidget {
  const ClockTicker({super.key, required this.builder});

  final Widget Function(BuildContext context, DateTime now) builder;

  @override
  ConsumerState<ClockTicker> createState() => _ClockTickerState();
}

class _ClockTickerState extends ConsumerState<ClockTicker> {
  late final Timer _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, ref.watch(clockProvider)());
}
