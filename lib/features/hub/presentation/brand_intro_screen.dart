import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_card.dart';
import 'package:davidan_prototype/core/widgets/brand_header_band.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// A brand without pages of its own (the restaurant), inside Acasă: its photo
/// and the one line its source has about it, under "În curând". Only what the
/// sources say, never an invented menu.
class BrandIntroScreen extends StatelessWidget {
  const BrandIntroScreen({super.key, required this.brand});

  final Brand brand;

  static const _photoHeight = 220.0;

  @override
  Widget build(BuildContext context) {
    final intro = context.content.introOf(brand);
    final image = intro.image;
    final description = intro.description;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: CustomScrollView(
        slivers: [
          // The brand's photo sits across the header's lower edge.
          BrandHeaderBand(
            brand: brand,
            title: intro.name,
            onBack: () => context.pop(),
            overlap: image == null
                ? null
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.gutter,
                    ),
                    child: AppCard(
                      child: Image.asset(image, fit: BoxFit.cover),
                    ),
                  ),
            overlapHeight: _photoHeight,
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              AppSpacing.lg,
              AppSpacing.gutter,
              AppSpacing.xl,
            ),
            sliver: SliverList.list(
              children: [
                Text(
                  context.l10n.comingSoonTitle,
                  style: context.textStyles.headline,
                ),
                if (description != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(description, style: context.textStyles.body),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
