import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_assets.dart';
import 'package:davidan_prototype/data/models/brand.dart';

/// The wordmark in the version that reads on the theme's background: the
/// DaviDan logo, or [brand]'s own when it has one (DaviDan Sushi). The
/// wordmark is charcoal in the light theme and near-white in the dark one.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, required this.height, this.brand});

  final double height;

  /// Null for DaviDan's own logo, as a brand without a logo of its own shows.
  final Brand? brand;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Image.asset(switch (brand) {
      Brand.sushi => dark ? AppAssets.sushiLogoOnDark : AppAssets.sushiLogo,
      _ => dark ? AppAssets.logoOnDark : AppAssets.logo,
    }, height: height);
  }
}
