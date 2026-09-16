import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_assets.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_motion.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/brand_logo.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/features/account/application/account_notifier.dart';
import 'package:davidan_prototype/features/account/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Branded screen the customer app opens on: the logo and tagline on a card
/// over a photo of DaviDan pastries. After [holdDuration] it moves on:
/// to the demo sign-in until the customer signs in or skips it, then to the
/// location screen while nothing is chosen, otherwise home.
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
      final signedIn = ref.read(accountProvider) != null;
      final skipped = ref.read(signInSkippedProvider);
      final firstRun = ref.read(fulfilmentChoiceProvider) == null;
      if (!signedIn && !skipped) {
        context.go(Routes.signIn);
      } else {
        context.go(firstRun ? Routes.clientLocation : Routes.clientHome);
      }
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
      // Dark like the photo in either theme, so it doesn't flash while the
      // photo decodes.
      backgroundColor: AppColors.dark.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.splashBackground,
            fit: BoxFit.cover,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
                wasSynchronouslyLoaded
                ? child
                : AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: AppMotion.of(context, AppMotion.medium),
                    curve: AppMotion.standard,
                    child: child,
                  ),
          ),
          // Tones the busy photo down so the card reads as the focus.
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  context.colors.scrim.withValues(alpha: 0.35),
                  context.colors.scrim,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(AppRadii.xl),
                    boxShadow: [
                      BoxShadow(
                        color: context.colors.shadow,
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const BrandLogo(height: 48),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          context.content.text(BrandFacts.tagline),
                          style: context.textStyles.bodySecondary,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
