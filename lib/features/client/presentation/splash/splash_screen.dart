import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_assets.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/features/client/application/fulfilment_choice_notifier.dart';

/// Branded screen the customer app opens on. After [holdDuration] it moves
/// on: to home when a delivery address or pickup shop was chosen before, or
/// to the location screen on first run.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  /// Long enough for the brand to register in a live demo. The routing check
  /// itself needs no wait, because bootstrap() loads saved state before the
  /// app starts.
  static const holdDuration = Duration(milliseconds: 1200);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  late final Timer _hold;

  @override
  void initState() {
    super.initState();
    _hold = Timer(SplashScreen.holdDuration, () {
      final firstRun = ref.read(fulfilmentChoiceProvider) == null;
      context.go(firstRun ? Routes.clientLocation : Routes.clientHome);
    });
  }

  @override
  void dispose() {
    // Leaving the splash early (e.g. browser back) must not navigate later.
    _hold.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppAssets.logo, height: 56),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  BrandFacts.tagline,
                  style: AppTextStyles.bodySecondary,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
