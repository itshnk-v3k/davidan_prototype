import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// A screen for presenting the prototype that isn't part of the app, such as
/// every role side by side. The app itself knows none: an entry point
/// registers them by overriding [demoToolsProvider] (see lib/main_demo.dart),
/// then the router adds their routes and the launcher links to them.
@immutable
class DemoTool {
  const DemoTool({
    required this.title,
    required this.hint,
    required this.icon,
    required this.route,
  });

  final String title;
  final String hint;
  final IconData icon;

  /// A top-level route, outside the phone frame.
  final GoRoute route;
}

/// Empty in the regular app.
final demoToolsProvider = Provider<List<DemoTool>>((ref) => const []);
