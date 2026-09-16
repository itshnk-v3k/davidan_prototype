// Reads the ARB files, so it runs on the VM and `--platform chrome` skips it:
//   flutter test test/architecture
@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  /// The messages of lib/l10n/app_[language].arb, without their metadata.
  Map<String, String> messages(String language) {
    final arb = jsonDecode(
      File('lib/l10n/app_$language.arb').readAsStringSync(),
    ) as Map<String, Object?>;
    return {
      for (final MapEntry(:key, :value) in arb.entries)
        if (!key.startsWith('@')) key: value! as String,
    };
  }

  /// `{name}`, and `{count, plural, …}`'s count.
  Set<String> placeholders(String message) => {
    for (final match in RegExp(r'\{(\w+)[,}]').allMatches(message))
      match.group(1)!,
  };

  final romanian = messages('ro');
  final russian = messages('ru');

  test('Romanian, the source language, has the messages', () {
    // Guards the checks below against passing on a file that didn't parse.
    expect(romanian.length, greaterThan(100));
  });

  // A message missing from app_ru.arb doesn't break the build: the Russian
  // app silently shows the Romanian text instead. This is what catches it.
  test(
    'every message has a Russian translation',
    () {
      expect(romanian.keys.where((key) => !russian.containsKey(key)), isEmpty);
    },
    skip:
        'Russian is written in step 8 of the hub round; until then '
        'app_ru.arb is empty on purpose',
  );

  test('Russian has no message that Romanian lacks, and none left empty', () {
    expect(russian.keys.where((key) => !romanian.containsKey(key)), isEmpty);
    expect(russian.entries.where((m) => m.value.trim().isEmpty), isEmpty);
  });

  test('each Russian message uses the same placeholders as the Romanian', () {
    for (final MapEntry(:key, :value) in russian.entries) {
      expect(placeholders(value), placeholders(romanian[key]!), reason: key);
    }
  });
}
