import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_motion.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/theme/brand_colors.dart';
import 'package:davidan_prototype/core/widgets/glass_surface.dart';
import 'package:davidan_prototype/data/models/brand.dart';

/// A short message on frosted glass that floats at the top of the screen: the
/// store panel's new-order notice and the phone apps' confirmations, with the
/// icon on a tint of [brand]'s colour (DaviDan's caramel without one). Screen
/// readers announce it when it appears.
class TopNotice extends StatelessWidget {
  const TopNotice({
    super.key,
    required this.icon,
    required this.message,
    this.brand,
  });

  final IconData icon;
  final String message;
  final Brand? brand;

  /// Rounder than a card's corners, far from a pill.
  static const radius = 18.0;

  @override
  Widget build(BuildContext context) {
    final brand = this.brand;
    if (brand != null) {
      return BrandTheme(
        brand: brand,
        child: TopNotice(icon: icon, message: message),
      );
    }
    final colors = context.colors;
    return Semantics(
      liveRegion: true,
      // Keeps text styles clean when shown above a screen's Scaffold.
      child: Material(
        type: MaterialType.transparency,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          // Frosted glass, like the tab bar, with more of the surface behind
          // the text.
          child: GlassSurface(
            borderRadius: BorderRadius.circular(radius),
            tintOpacity: 0.78,
            shadow: true,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colors.accentSoft,
                      borderRadius: BorderRadius.circular(AppRadii.sm + 2),
                    ),
                    child: Icon(icon, size: 20, color: colors.primary),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Flexible(
                    child: Text(message, style: context.textStyles.bodyStrong),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Drops [notice] in from the top edge, and lifts it away when it becomes
/// null or is replaced by a notice with a different key. With [onDismiss], a
/// swipe up takes it away at once: it follows the finger up, and springs back
/// if let go too early.
class TopNoticeSwitcher extends StatelessWidget {
  const TopNoticeSwitcher({super.key, required this.notice, this.onDismiss});

  final TopNotice? notice;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final notice = this.notice;
    final onDismiss = this.onDismiss;
    return AnimatedSwitcher(
      duration: AppMotion.of(context, AppMotion.medium),
      switchInCurve: AppMotion.standard,
      switchOutCurve: AppMotion.standard,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, -0.5),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: notice == null
          ? const SizedBox.shrink()
          : onDismiss == null
          ? notice
          : _SwipeUpToDismiss(
              key: notice.key,
              onDismiss: onDismiss,
              child: notice,
            ),
    );
  }
}

class _SwipeUpToDismiss extends StatefulWidget {
  const _SwipeUpToDismiss({
    super.key,
    required this.onDismiss,
    required this.child,
  });

  final VoidCallback onDismiss;
  final Widget child;

  @override
  State<_SwipeUpToDismiss> createState() => _SwipeUpToDismissState();
}

class _SwipeUpToDismissState extends State<_SwipeUpToDismiss> {
  /// How far the notice has been dragged up, as a negative offset.
  double _dragged = 0;

  /// Dragged this far, or flung up this fast, it goes.
  static const _distance = 24.0;
  static const _speed = 300.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: (details) => setState(
        // Up only: a pull down doesn't move it.
        () => _dragged = (_dragged + details.delta.dy).clamp(
          double.negativeInfinity,
          0,
        ),
      ),
      onVerticalDragEnd: (details) {
        final flungUp = (details.primaryVelocity ?? 0) < -_speed;
        if (flungUp || _dragged < -_distance) {
          widget.onDismiss();
        } else {
          setState(() => _dragged = 0);
        }
      },
      onVerticalDragCancel: () => setState(() => _dragged = 0),
      child: Transform.translate(
        offset: Offset(0, _dragged),
        child: widget.child,
      ),
    );
  }
}
