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

  /// Every `Icons.x` the customer app uses, as "path: name".
  final icons = [
    for (final file in Directory('lib').listSync(recursive: true))
      if (file is File && file.path.endsWith('.dart'))
        for (final match in RegExp(
          r'Icons\.(\w+)',
        ).allMatches(file.readAsStringSync()))
          (path: file.path.replaceAll(r'\', '/'), name: match.group(1)!),
  ].where((icon) => !staffFolders.any(icon.path.startsWith)).toList();

  test('the customer app draws its icons from the rounded set', () {
    expect(
      [
        for (final icon in icons)
          if (!icon.name.endsWith('_rounded')) '${icon.path}: ${icon.name}',
      ],
      [
        // The tab bar's unselected house and receipt: the icon font has no
        // rounded outline of either.
        'lib/features/hub/presentation/client_shell.dart: home_outlined',
        'lib/features/hub/presentation/client_shell.dart: receipt_long_outlined',
      ],
    );
  });
}
