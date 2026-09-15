import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/demo_tool.dart';
import 'package:davidan_prototype/demo_tools/all_roles_screen.dart';
import 'package:davidan_prototype/demo_tools/demo_tool_strings.dart';

// Internal demo tools. Nothing imports this folder except lib/main_demo.dart
// (test/architecture checks that), so the regular entry point, lib/main.dart,
// never compiles these screens in, on any platform.

/// Registers the demo tools with the router and the launcher.
final List<Override> demoToolsOverrides = [
  demoToolsProvider.overrideWithValue([
    DemoTool(
      title: DemoToolStrings.allRolesTitle,
      hint: DemoToolStrings.allRolesHint,
      icon: Icons.view_column_rounded,
      route: GoRoute(
        path: AllRolesScreen.path,
        builder: (_, state) =>
            AllRolesScreen(orderId: state.uri.queryParameters['order']),
      ),
    ),
  ]),
];
