import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';

/// A legal page's text (LegalDocument.text). The format is the least that
/// keeps the site's layout, so no markdown package is needed: paragraphs are
/// separated by a blank line and keep their line breaks; a paragraph starting
/// with "# " is a heading; text between double asterisks is bold, like the
/// site's `<strong>`. Nothing else is markup.
class LegalText extends StatelessWidget {
  const LegalText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final paragraphs = text.trim().split(RegExp(r'\n\s*\n'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, paragraph) in paragraphs.indexed)
          if (paragraph.startsWith('# '))
            Padding(
              padding: EdgeInsets.only(
                top: index == 0 ? 0 : AppSpacing.lg,
                bottom: AppSpacing.sm,
              ),
              child: Text(
                paragraph.substring(2).trim(),
                style: context.textStyles.subtitle,
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Text.rich(
                TextSpan(
                  children: [
                    // Every other piece between the asterisks is bold.
                    for (final (piece, text) in paragraph.split('**').indexed)
                      if (text.isNotEmpty)
                        TextSpan(
                          text: text,
                          style: piece.isOdd
                              ? context.textStyles.bodyStrong
                              : null,
                        ),
                  ],
                ),
                style: context.textStyles.body,
              ),
            ),
      ],
    );
  }
}
