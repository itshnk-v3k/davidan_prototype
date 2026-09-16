import 'package:davidan_prototype/bootstrap.dart';
import 'package:davidan_prototype/staff/staff_build.dart';

/// Phase 2, not for client demos: the customer app plus the courier app, the
/// store panel and the all-roles board, opened from a demo launcher:
///   flutter run -d chrome --web-port=8080 -t lib/main_staff.dart
Future<void> main() => bootstrap(overrides: staffBuildOverrides);
