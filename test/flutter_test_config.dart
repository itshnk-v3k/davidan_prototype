import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

/// Runs before every test file. Under `--platform chrome` a failing widget
/// test only reports "See exception logs above": the details go to the
/// browser console. Print them too, so they show up in the terminal.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final report = reportTestException;
  reportTestException = (details, testDescription) {
    // ignore: avoid_print
    print(details);
    report(details, testDescription);
  };
  await testMain();
}
