// Reads source files, so it runs on the VM and `--platform chrome` skips it:
//   flutter test test/architecture
@TestOn('vm')
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('only lib/main_demo.dart imports the demo tools', () {
    const demoTools = 'package:davidan_prototype/demo_tools/';
    final importers = <String>[];
    for (final file in Directory('lib').listSync(recursive: true)) {
      final path = file.path.replaceAll(r'\', '/');
      if (file is! File || !path.endsWith('.dart')) continue;
      if (path.startsWith('lib/demo_tools/')) continue;
      if (file.readAsStringSync().contains(demoTools)) importers.add(path);
    }

    expect(importers, ['lib/main_demo.dart']);
  });
}
