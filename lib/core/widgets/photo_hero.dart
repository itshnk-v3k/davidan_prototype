import 'package:flutter/widgets.dart';

/// A photo that flies between two screens, clipped to [borderRadius]. The two
/// ends usually round their corners differently (a card's top corners, a
/// full-width photo's none), so in flight the corners change along with the
/// size instead of snapping at take-off and landing.
class PhotoHero extends StatelessWidget {
  const PhotoHero({
    super.key,
    required this.tag,
    this.borderRadius = BorderRadius.zero,
    required this.child,
  });

  /// A tag may appear only once per screen.
  final Object tag;
  final BorderRadius borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      flightShuttleBuilder: _shuttle,
      child: _ClippedPhoto(borderRadius: borderRadius, child: child),
    );
  }

  static Widget _shuttle(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    BorderRadius radiusOf(BuildContext heroContext) =>
        switch ((heroContext.widget as Hero).child) {
          _ClippedPhoto(:final borderRadius) => borderRadius,
          _ => BorderRadius.zero,
        };
    final toHero = (toHeroContext.widget as Hero).child;
    // The animation runs from the lower screen (0) to the upper one (1), and
    // backwards on a pop.
    final (lower, upper) = direction == HeroFlightDirection.push
        ? (radiusOf(fromHeroContext), radiusOf(toHeroContext))
        : (radiusOf(toHeroContext), radiusOf(fromHeroContext));

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => ClipRRect(
        borderRadius: BorderRadius.lerp(lower, upper, animation.value)!,
        child: child,
      ),
      child: toHero is _ClippedPhoto ? toHero.child : toHero,
    );
  }
}

class _ClippedPhoto extends StatelessWidget {
  const _ClippedPhoto({required this.borderRadius, required this.child});

  final BorderRadius borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) => borderRadius == BorderRadius.zero
      ? child
      : ClipRRect(borderRadius: borderRadius, child: child);
}
