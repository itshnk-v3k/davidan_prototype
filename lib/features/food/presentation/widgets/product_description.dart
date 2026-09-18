import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';

/// A product's description as its brand's site writes it, set out as a list
/// rather than one block of running text: each labelled part ("Ingrediente:",
/// "Conține:", "Componența setului:", and their Russian counterparts) becomes
/// a small heading with its items under it, one to a line; a part with no
/// label ("Poate conține urme de …") stays a line of its own.
///
/// The site's wording is never rewritten, only broken where the text already
/// divides itself: at a full stop before a capital, and at the commas between
/// items. A comma inside brackets (the E-numbers listed inside one
/// ingredient) or between digits ("gr. 3,5%") belongs to the item, so neither
/// breaks a line.
class ProductDescription extends StatelessWidget {
  const ProductDescription(this.text, {super.key});

  final String text;

  /// The longest a part's label may be. A colon further in belongs to the
  /// text ("aromă: vanilină"), not to a heading.
  static const _maxLabelLength = 30;

  /// A part of a description: its items under [label], or one paragraph
  /// ([label] null, one item).
  static List<({String? label, List<String> items})> partsOf(String text) => [
    for (final sentence in _sentences(text))
      if (_labelEnd(sentence) case final colon?)
        (
          label: sentence.substring(0, colon).trim(),
          items: _items(sentence.substring(colon + 1)),
        )
      else
        (label: null, items: [sentence]),
  ];

  /// Where a sentence's label ends, or null when it has none: the first colon,
  /// as long as it comes early and nothing in front of it has been listed
  /// already.
  static int? _labelEnd(String sentence) {
    final colon = sentence.indexOf(':');
    if (colon <= 0 || colon > _maxLabelLength) return null;
    if (sentence.substring(0, colon).contains(',')) return null;
    return colon;
  }

  /// The text's sentences: it is cut at a full stop followed by a capital, so
  /// an abbreviation inside one ("cu gr. 3,5%") keeps its sentence whole.
  static List<String> _sentences(String text) {
    final sentences = <String>[];
    var start = 0;
    for (var at = 0; at < text.length - 1; at++) {
      if (text[at] != '.' || !_isSpace(text[at + 1])) continue;
      var next = at + 1;
      while (next < text.length && _isSpace(text[next])) {
        next++;
      }
      if (next >= text.length || !_isCapital(text[next])) continue;
      sentences.add(text.substring(start, at + 1).trim());
      start = next;
      at = next - 1;
    }
    final last = text.substring(start).trim();
    if (last.isNotEmpty) sentences.add(last);
    return sentences;
  }

  /// One sentence's items: what its commas separate, outside any brackets,
  /// each without the full stop that ends the sentence.
  static List<String> _items(String list) {
    final items = <String>[];
    final item = StringBuffer();
    var depth = 0;
    for (var at = 0; at < list.length; at++) {
      final character = list[at];
      if (character == '(' || character == '[') depth++;
      if (character == ')' || character == ']') depth--;
      final breaks =
          character == ',' &&
          depth == 0 &&
          at + 1 < list.length &&
          _isSpace(list[at + 1]);
      if (breaks) {
        items.add(item.toString());
        item.clear();
      } else {
        item.write(character);
      }
    }
    items.add(item.toString());
    return [
      for (var item in items)
        if (_trimItem(item) case final item when item.isNotEmpty) item,
    ];
  }

  static String _trimItem(String item) {
    final trimmed = item.trim();
    return trimmed.endsWith('.')
        ? trimmed.substring(0, trimmed.length - 1).trim()
        : trimmed;
  }

  static bool _isSpace(String character) => character.trim().isEmpty;

  /// Latin and Cyrillic alike: a letter that has a lower case of its own.
  static bool _isCapital(String character) =>
      character.toLowerCase() != character &&
      character.toUpperCase() == character;

  @override
  Widget build(BuildContext context) {
    final parts = partsOf(text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (index, part) in parts.indexed)
          Padding(
            padding: EdgeInsets.only(top: index == 0 ? 0 : AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (part.label case final label?) ...[
                  Text(label, style: context.textStyles.bodyStrong),
                  const SizedBox(height: AppSpacing.xs),
                  for (final item in part.items) _Item(item),
                ] else
                  for (final item in part.items)
                    Text(item, style: context.textStyles.bodySecondary),
              ],
            ),
          ),
      ],
    );
  }
}

/// One line of a list, behind a small dot on the first line of its text.
class _Item extends StatelessWidget {
  const _Item(this.text);

  final String text;

  /// The dot's own size, and the column it sits in, so every item's text
  /// starts on the same line whatever its dot.
  static const _dotSize = 3.0;
  static const _dotColumn = AppSpacing.md;

  @override
  Widget build(BuildContext context) {
    final style = context.textStyles.bodySecondary;
    // On the middle of the first line, whatever the phone's text size.
    final lineHeight =
        MediaQuery.textScalerOf(context).scale(style.fontSize!) * style.height!;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _dotColumn,
            height: lineHeight,
            child: Center(
              child: Container(
                width: _dotSize,
                height: _dotSize,
                decoration: BoxDecoration(
                  color: context.colors.textSecondary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Expanded(child: Text(text, style: style)),
        ],
      ),
    );
  }
}
