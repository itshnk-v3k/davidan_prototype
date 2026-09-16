// Reads source files, so it runs on the VM and `--platform chrome` skips it:
//   flutter test test/architecture
@TestOn('vm')
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const package = 'package:davidan_prototype/';

  /// Dart files under lib/, as forward-slash paths, with their source.
  final sources = {
    for (final file in Directory('lib').listSync(recursive: true))
      if (file is File && file.path.endsWith('.dart'))
        file.path.replaceAll(r'\', '/'): file.readAsStringSync(),
  };

  /// Files outside [allowedFolders] that import anything under [folder].
  List<String> importersOf(String folder, List<String> allowedFolders) => [
    for (final MapEntry(key: path, value: source) in sources.entries)
      if (source.contains('$package$folder') &&
          !path.startsWith('lib/$folder') &&
          !allowedFolders.any(path.startsWith))
        path,
  ]..sort();

  // The client asked for the staff apps to be left out of the demo, and
  // lib/main.dart must never compile them in. A release build only contains
  // what its entry point imports, so these checks are what keep them out.

  test('only lib/main_staff.dart imports the staff build', () {
    expect(importersOf('staff/', []), ['lib/main_staff.dart']);
  });

  test('only the staff build imports the demo tools', () {
    expect(importersOf('demo_tools/', []), ['lib/staff/staff_build.dart']);
  });

  test('only the staff build and the demo tools import the courier app and '
      'the store panel', () {
    const staffOnly = [
      'lib/staff/',
      'lib/demo_tools/',
      'lib/features/courier/',
      'lib/features/kds/',
    ];
    expect(importersOf('features/courier/', staffOnly), isEmpty);
    expect(importersOf('features/kds/', staffOnly), isEmpty);
    // Guards against the checks above passing because nothing matched.
    expect(sources['lib/staff/staff_build.dart'], contains('features/kds/'));
  });
}
