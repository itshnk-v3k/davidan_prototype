import 'package:davidan_prototype/bootstrap.dart';
import 'package:davidan_prototype/demo_tools/demo_tools.dart';

/// The app plus the internal demo tools (the all-roles board), for presenting
/// the prototype:
///   flutter run -d chrome --web-port=8080 -t lib/main_demo.dart
Future<void> main() => bootstrap(overrides: demoToolsOverrides);
