import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/time.dart';

/// Time since [since] as "mm:ss", redrawn every second. Each redraw works it
/// out again from the saved timestamp, so reopening the panel or reloading the
/// page shows the real wait instead of starting from zero. Turns red once an
/// order has waited [overdueAfter].
class ElapsedTimer extends ConsumerStatefulWidget {
  const ElapsedTimer({super.key, required this.since});

  static const overdueAfter = Duration(minutes: 15);

  final DateTime since;

  @override
  ConsumerState<ElapsedTimer> createState() => _ElapsedTimerState();
}

class _ElapsedTimerState extends ConsumerState<ElapsedTimer> {
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
  Widget build(BuildContext context) {
    final elapsed = ref.watch(clockProvider)().difference(widget.since);
    final text = formatElapsed(elapsed);
    final color = elapsed >= ElapsedTimer.overdueAfter
        ? AppColors.error
        : AppColors.textSecondary;

    return Semantics(
      label: AppStrings.timeSincePlaced(text),
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 18, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(
            text,
            style: AppTextStyles.bodyStrong.copyWith(
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
