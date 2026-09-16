import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/info_note.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// A brand without pages of its own, full screen above the hub: its photo and
/// the one line its source has about it, under "În curând". Only what the
/// sources say, never an invented menu.
///
/// [inProgress] marks a brand whose pages the prototype just hasn't built yet
/// (water and car rental, until hub round steps 6 and 7): "În lucru", with
/// a note saying so, rather than suggesting the brand has nothing to offer.
class BrandIntroScreen extends StatelessWidget {
  const BrandIntroScreen({
    super.key,
    required this.brand,
    this.inProgress = false,
  });

  final Brand brand;
  final bool inProgress;

  @override
  Widget build(BuildContext context) {
    final intro = brandIntros[brand]!;
    final image = intro.image;
    final description = intro.description;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: intro.name,
              onBack: () => context.canPop()
                  ? context.pop()
                  : context.go(Routes.clientHome),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  0,
                  AppSpacing.gutter,
                  AppSpacing.xl,
                ),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: image == null
                          ? ColoredBox(
                              color: context.colors.accentSoft,
                              child: Icon(
                                Icons.directions_car_rounded,
                                size: 72,
                                color: context.colors.primary,
                              ),
                            )
                          : Image.asset(image, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    inProgress
                        ? context.l10n.inProgressTitle
                        : context.l10n.comingSoonTitle,
                    style: context.textStyles.headline,
                  ),
                  if (description != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(description, style: context.textStyles.body),
                  ],
                  if (inProgress) ...[
                    const SizedBox(height: AppSpacing.lg),
                    InfoNote(
                      icon: Icons.construction_rounded,
                      text: context.l10n.inProgressMessage,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
