import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';

/// Product photo that fills its box, or a branded tile when there is no photo.
class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.path});

  final String? path;

  static const _placeholder = ColoredBox(
    color: AppColors.accentSoft,
    child: Center(
      child: Icon(Icons.restaurant_rounded, size: 32, color: AppColors.accent),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final path = this.path;
    if (path == null) return _placeholder;
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _placeholder,
    );
  }
}
