import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';

/// A dark fade from the top edge of the screen, behind the status bar and the
/// buttons over a photo or a brand's colour, so white icons read on any of
/// them without a chip behind each button. Long and light, darkest at the
/// edge, as Material's scrim guidance has it; the screen under it sets light
/// status bar icons.
class TopScrim extends StatelessWidget {
  const TopScrim({super.key});

  /// Below the status bar, how far the fade reaches: a button row and half
  /// again, so it has faded out before the content.
  static const reach = 96.0;

  /// The fade's height on this phone, status bar included.
  static double heightOf(BuildContext context) =>
      MediaQuery.paddingOf(context).top + reach;

  @override
  Widget build(BuildContext context) {
    final edge = context.colors.edgeScrim;
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              edge,
              edge.withValues(alpha: edge.a * 0.45),
              edge.withValues(alpha: 0),
            ],
            stops: const [0, 0.5, 1],
          ),
        ),
      ),
    );
  }
}
