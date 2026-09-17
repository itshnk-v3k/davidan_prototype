import 'package:go_router/go_router.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/router/extra_app.dart';
import 'package:davidan_prototype/demo_tools/all_roles_screen.dart';
import 'package:davidan_prototype/demo_tools/demo_tool_strings.dart';

// Internal demo tools. They show the staff apps, so only the staff build
// (lib/staff/staff_build.dart) registers them; test/architecture checks that
// nothing else imports this folder.

/// The all-roles board.
final List<ExtraApp> demoTools = [
  ExtraApp(
    // Internal, so Romanian only.
    title: (_) => DemoToolStrings.allRolesTitle,
    hint: (_) => DemoToolStrings.allRolesHint,
    icon: PhosphorIconsRegular.columns,
    location: AllRolesScreen.path,
    windowRoutes: [
      GoRoute(
        path: AllRolesScreen.path,
        builder: (_, state) =>
            AllRolesScreen(orderId: state.uri.queryParameters['order']),
      ),
    ],
  ),
];
