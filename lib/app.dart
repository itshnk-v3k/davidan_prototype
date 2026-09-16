import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/app_router.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_theme.dart';
import 'package:davidan_prototype/core/theme/theme_mode_notifier.dart';
import 'package:davidan_prototype/features/orders/application/order_simulation.dart';
import 'package:davidan_prototype/features/orders/presentation/order_simulator.dart';

class DaviDanApp extends ConsumerWidget {
  const DaviDanApp({super.key});

  static final _light = AppTheme.light();
  static final _dark = AppTheme.dark();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final simulateOrders = ref.watch(orderSimulationProvider);

    return MaterialApp.router(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: _light,
      darkTheme: _dark,
      themeMode: ref.watch(themeModeProvider),
      builder: (context, child) {
        // No screen has an AppBar to set them, so the phone's status bar
        // icons follow the theme here: light icons on the dark theme.
        final app = AnnotatedRegion<SystemUiOverlayStyle>(
          value: Theme.of(context).brightness == Brightness.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: child!,
        );
        // Without the staff apps, the simulation moves orders on.
        return simulateOrders ? OrderSimulator(child: app) : app;
      },
      routerConfig: ref.watch(appRouterProvider),
      // Lets carousels and horizontal lists be dragged with a mouse, so the
      // desktop browser demo behaves like a touch screen.
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: PointerDeviceKind.values.toSet(),
      ),
    );
  }
}
