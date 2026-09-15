import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';

/// Round icon button on a white surface, used in screen headers and over
/// photos.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.iconColor = AppColors.textPrimary,
    this.size = 40,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String semanticLabel;
  final Color iconColor;
  final double size;

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
            child: Icon(icon, size: size * 0.55, color: iconColor),
          ),
        ),
      ),
    );
  }
}
