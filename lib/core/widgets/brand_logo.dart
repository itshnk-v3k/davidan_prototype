import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_assets.dart';

/// The DaviDan wordmark in the version that reads on the theme's background:
/// charcoal in the light theme, cream in the dark one.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Image.asset(
      dark ? AppAssets.logoOnDark : AppAssets.logo,
      height: height,
    );
  }
}
