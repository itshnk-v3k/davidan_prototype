import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/legal_text.dart';

/// One of a brand's legal pages in full, as its site words it, pushed from
/// the brand's information page. The router only opens it for a document the
/// brand has.
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
    final document = brandInfos[brand]!.documents.firstWhere(
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
                children: [LegalText(document.text)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
