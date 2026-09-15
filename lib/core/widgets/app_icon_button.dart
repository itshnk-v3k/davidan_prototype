import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_motion.dart';
import 'package:davidan_prototype/core/widgets/scale_pop.dart';

/// Round icon button on a white surface, used in screen headers and over
/// photos. A new [icon] crossfades in.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.iconColor = AppColors.textPrimary,
    this.size = 40,
    this.emphasized = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String semanticLabel;
  final Color iconColor;
  final double size;

  /// Pops the icon once each time this turns true, e.g. a heart being saved.
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: AppColors.surface,
        shape: const CircleBorder(side: BorderSide(color: AppColors.border)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox.square(
            dimension: size,
            child: ScalePop<bool>(
              value: emphasized,
              shouldPop: (_, now) => now,
              child: AnimatedSwitcher(
                duration: AppMotion.of(context, AppMotion.fast),
                child: Icon(
                  icon,
                  key: ValueKey(icon),
                  size: size * 0.55,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
