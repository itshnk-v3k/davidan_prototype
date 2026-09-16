import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/legal_text.dart';
import 'package:davidan_prototype/core/widgets/info_note.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// One of a brand's legal pages in full, as its site words it, pushed from
/// the brand's information page. The sites have them only in Romanian, so in
/// any other language a note says so above the text. The router only opens it
/// for a document the brand has.
class LegalDocumentScreen extends StatelessWidget {
  const LegalDocumentScreen({
    super.key,
    required this.brand,
    required this.documentId,
  });

  final Brand brand;

  /// The page's slug on the brand's site (LegalDocument.id).
  final String documentId;

  @override
  Widget build(BuildContext context) {
    final info = context.content.infoOf(brand)!;
    final document = info.documents.firstWhere(
      (document) => document.id == documentId,
    );

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: document.title,
              // Opened straight from a link, there's nothing to go back to.
              onBack: () => context.canPop()
                  ? context.pop()
                  : context.go(Routes.brandInfo(brand)),
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
                  // The sites' legal pages exist only in Romanian.
                  if (context.l10n.localeName != 'ro') ...[
                    InfoNote(
                      icon: Icons.translate_rounded,
                      text: context.l10n.legalDocumentRomanianOnly(
                        info.website,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  LegalText(document.text),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
