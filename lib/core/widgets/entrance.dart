import 'package:flutter/widgets.dart';

import 'package:davidan_prototype/core/theme/app_motion.dart';

/// Brings [child] in once, when it first appears: it fades in while lifting
/// into place, or with [pop] grows in with a slight overshoot. Rebuilds don't
/// replay it; a new element does (an order card moving to another column).
class Entrance extends StatelessWidget {
  const Entrance({super.key, this.pop = false, required this.child});

  /// Grow in instead of lifting, for one element that should be noticed: an
  /// empty state's icon, the order-placed check mark.
  final bool pop;
  final Widget child;

  static const _lift = 12.0;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppMotion.of(context, AppMotion.slow),
      curve: pop ? AppMotion.emphasized : AppMotion.standard,
      builder: (context, progress, child) => Opacity(
        // The overshoot curve runs past 1.
        opacity: progress.clamp(0.0, 1.0),
        child: pop
            ? Transform.scale(scale: 0.6 + 0.4 * progress, child: child)
            : Transform.translate(
                offset: Offset(0, (1 - progress) * _lift),
                child: child,
              ),
      ),
      child: child,
    );
  }
}
