import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';

/// A raised card: the surface colour lifted off the background by a soft
/// shadow in the light theme, and set apart by its lighter tone and an outline
/// in the dark one, where a shadow wouldn't show (Material 3 does the same).
/// With [onTap] the whole card is one button. Its content is clipped to its
/// corners.
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

  /// A wide, faint shadow a little below the card and a tight one along its
  /// edge, together under 20% dark: the card lifts off the page without a
  /// visible outline.
  static List<BoxShadow> shadowsOf(AppColors colors) => [
    BoxShadow(
      color: colors.cardShadowContact,
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
    BoxShadow(
      color: colors.cardShadow,
      blurRadius: 16,
      spreadRadius: -2,
      offset: const Offset(0, 6),
    ),
  ];

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
