import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';

/// A part of the prototype besides the customer app: a staff app (the courier
/// app, the store panel) or an internal demo tool (the all-roles board). The
/// customer app knows none of them. An entry point registers them by
/// overriding [extraAppsProvider] (see lib/staff/staff_build.dart); the router
/// then adds their routes, the demo launcher links to them, and a demo reset
/// clears what they saved.
@immutable
class ExtraApp {
  const ExtraApp({
    required this.title,
    required this.hint,
    required this.icon,
    required this.location,
    this.phoneRoutes = const [],
    this.windowRoutes = const [],
    this.savedState = const [],
  });

  final String title;
  final String hint;
  final IconData icon;

  /// Where the launcher opens it.
  final String location;

  /// Routes shown inside the phone frame on a desktop, like the customer app.
  final List<RouteBase> phoneRoutes;

  /// Routes that use the whole window: a tablet panel or a demo board.
  final List<RouteBase> windowRoutes;

  /// Providers that restore saved state. A demo reset invalidates them after
  /// clearing storage.
  final List<ProviderOrFamily> savedState;
}

/// Empty in the customer app build (lib/main.dart), which then has no demo
/// launcher and opens straight on the customer app.
final extraAppsProvider = Provider<List<ExtraApp>>((ref) => const []);
