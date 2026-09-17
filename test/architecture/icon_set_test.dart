// Reads source files, so it runs on the VM and `--platform chrome` skips it:
//   flutter test test/architecture
@TestOn('vm')
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  // The staff apps (phase 2) aren't part of the customer app's look.
  const staffFolders = [
    'lib/staff/',
    'lib/features/courier/',
    'lib/features/kds/',
  ];

  /// Every customer app source file, as (path, contents).
  final sources = [
    for (final file in Directory('lib').listSync(recursive: true))
      if (file is File && file.path.endsWith('.dart'))
        (path: file.path.replaceAll(r'\', '/'), text: file.readAsStringSync()),
  ].where((source) => !staffFolders.any(source.path.startsWith)).toList();

  test('the customer app draws no Material Icons glyphs', () {
    expect([
      for (final source in sources)
        for (final match in RegExp(
          r'(?<![A-Za-z_])Icons\.(\w+)',
        ).allMatches(source.text))
          '${source.path}: ${match.group(1)}',
    ], isEmpty);
  });

  test('its icons are Phosphor in the styles the app uses: Regular by '
      'default, Fill for a selected or active state, Bold for small action '
      'glyphs', () {
    const styles = {
      'PhosphorIconsRegular',
      'PhosphorIconsFill',
      'PhosphorIconsBold',
    };
    expect([
      for (final source in sources)
        for (final match in RegExp(
          r'\b(Phosphor\w*)\.\w+',
        ).allMatches(source.text))
          if (!styles.contains(match.group(1)))
            '${source.path}: ${match.group(0)}',
    ], isEmpty);
  });
}
