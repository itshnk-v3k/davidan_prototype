import 'dart:ui' show PointerDeviceKind;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/app_router.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_theme.dart';
import 'package:davidan_prototype/core/widgets/phone_frame.dart';

class DaviDanApp extends ConsumerWidget {
  const DaviDanApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: router,
      // Lets carousels and horizontal lists be dragged with a mouse, so the
      // desktop browser demo behaves like a touch screen.
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: PointerDeviceKind.values.toSet(),
      ),
      builder: (context, child) => ListenableBuilder(
        listenable: router.routerDelegate,
        builder: (context, child) => PhoneFrame(
          // The store panel is a tablet/desktop screen; the rest are phone apps.
          enabled: !router.routerDelegate.currentConfiguration.uri.path
              .startsWith(Routes.kds),
          child: child!,
        ),
        child: child,
      ),
    );
  }
}
