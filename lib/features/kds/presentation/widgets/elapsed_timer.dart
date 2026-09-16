import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/core/widgets/clock_ticker.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Time since [since] as "mm:ss", redrawn every second. Each redraw works it
/// out again from the saved timestamp, so reopening the panel or reloading the
/// page shows the real wait instead of starting from zero. Turns amber once an
/// order has waited [warnAfter] and red once it has waited [overdueAfter].
class ElapsedTimer extends StatelessWidget {
  const ElapsedTimer({super.key, required this.since});

  static const warnAfter = Duration(minutes: 10);
  static const overdueAfter = Duration(minutes: 15);

  final DateTime since;

  @override
  Widget build(BuildContext context) {
    return ClockTicker(
      builder: (context, now) {
        final elapsed = now.difference(since);
        final text = formatElapsed(elapsed);
        final color = elapsed >= overdueAfter
            ? context.colors.error
            : elapsed >= warnAfter
            ? context.colors.warning
            : context.colors.textSecondary;

        return Semantics(
          label: context.l10n.timeSincePlaced(text),
          excludeSemantics: true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.timer_outlined, size: 18, color: color),
              const SizedBox(width: AppSpacing.xs),
              Text(
                text,
                style: context.textStyles.bodyStrong.copyWith(
                  color: color,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
