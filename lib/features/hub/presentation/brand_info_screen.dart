import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/detail_row.dart';
import 'package:davidan_prototype/core/widgets/link_card.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/brand_info.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// A brand's information page, opened from its home in Acasă or from Profil:
/// its contacts as its site gives them, and its legal pages, each opening in
/// full. The router only opens it for a brand in brandInfos.
class BrandInfoScreen extends StatelessWidget {
  const BrandInfoScreen({super.key, required this.brand, required this.tab});

  final Brand brand;

  /// The tab it's open in (Routes.clientHome or Routes.clientProfile), where
  /// its legal pages open too.
  final String tab;

  static IconData _iconOf(BrandInfoKind kind) => switch (kind) {
    BrandInfoKind.deliveryArea => Icons.delivery_dining_rounded,
    BrandInfoKind.address => Icons.location_on_rounded,
    BrandInfoKind.hours => Icons.schedule_rounded,
    BrandInfoKind.phone => Icons.phone_rounded,
    BrandInfoKind.email => Icons.mail_outline_rounded,
    BrandInfoKind.instagram => Icons.photo_camera_rounded,
    BrandInfoKind.company => Icons.business_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final info = context.content.infoOf(brand)!;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(title: info.name, onBack: () => context.pop()),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  0,
                  AppSpacing.gutter,
                  AppSpacing.xl,
                ),
                children: [
                  Text(
                    context.l10n.brandContactsTitle,
                    style: context.textStyles.subtitle,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(AppRadii.lg),
                      border: Border.all(color: context.colors.border),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final (index, line) in info.lines.indexed)
                            Padding(
                              padding: EdgeInsets.only(
                                top: index == 0 ? 0 : AppSpacing.lg,
                              ),
                              child: DetailRow(
                                icon: _iconOf(line.kind),
                                label: context.l10n.brandInfoLabel(line.kind),
                                value: line.value,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (info.documents.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      context.l10n.legalDocumentsTitle,
                      style: context.textStyles.subtitle,
                    ),
                    for (final document in info.documents)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.md),
                        child: LinkCard(
                          icon: Icons.description_rounded,
                          title: document.title,
                          hint: context.l10n.legalDocumentHint(info.website),
                          onTap: () => context.push(
                            Routes.brandLegal(brand, document.id, tab: tab),
                          ),
                        ),
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
