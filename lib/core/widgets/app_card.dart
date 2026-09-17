import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';

/// A raised card, soft rather than sharp: the surface colour lifted off the
/// background by a wide, faint shadow. In the dark theme the card's lighter
/// tone does most of the work, with a deeper shadow and a faint hairline
/// softening its edge. With [onTap] the whole card is one button. Its content
/// is clipped to its corners.
///
/// A scroll view holding cards side by side keeps `clipBehavior: Clip.none`,
/// or it cuts the shadows off under the cards.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.radius = AppRadii.lg,
    this.color,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double radius;

  /// The theme's surface when null.
  final Color? color;

  /// A wide shadow well below the card, pulled in at the sides so it only
  /// shows underneath, and a faint one along its edge.
  static List<BoxShadow> shadowsOf(AppColors colors) => [
    BoxShadow(
      color: colors.cardShadowContact,
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
    BoxShadow(
      color: colors.cardShadow,
      blurRadius: 24,
      spreadRadius: -6,
      offset: const Offset(0, 8),
    ),
  ];

  /// How far below a card its shadow reaches, for rows that leave room.
  static const shadowReach = 18.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final corners = BorderRadius.circular(radius);
    final onTap = this.onTap;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: corners,
        boxShadow: shadowsOf(colors),
      ),
      child: Material(
        color: color ?? colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: corners,
          side: colors.cardOutline.a == 0
              ? BorderSide.none
              : BorderSide(color: colors.cardOutline),
        ),
        clipBehavior: Clip.antiAlias,
        child: onTap == null ? child : InkWell(onTap: onTap, child: child),
      ),
    );
  }
}
