import 'dart:async';
import 'dart:ui' show ImageFilter;

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

/// Branded screen the customer app opens on: the logo and tagline on a soft
/// card over a gently blurred, lightly dimmed photo of DaviDan pastries. The
/// card fades in as it settles from a touch smaller, and the tagline follows a
/// moment later, rising into place ([AppMotion.reveal]); with animations
/// turned off on the phone everything is simply there. After [holdDuration]
/// it moves on:
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

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final Timer _hold;

  late final _reveal = AnimationController(
    vsync: this,
    duration: AppMotion.reveal,
  );

  /// The card and its logo: most of the entrance.
  late final _card = CurvedAnimation(
    parent: _reveal,
    curve: const Interval(0, 0.9, curve: AppMotion.standard),
  );

  /// Settles from a touch smaller: never from nothing, which reads as a pop.
  late final _cardScale = Tween(begin: 0.95, end: 1.0).animate(_card);

  /// The tagline, [AppMotion.fast] behind the card.
  late final _tagline = CurvedAnimation(
    parent: _reveal,
    curve: Interval(
      AppMotion.fast.inMilliseconds / AppMotion.reveal.inMilliseconds,
      1,
      curve: AppMotion.standard,
    ),
  );

  /// How far below its place the tagline starts.
  static const _taglineRise = 10.0;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_reveal.isAnimating || _reveal.isCompleted) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _reveal.value = 1;
    } else {
      _reveal.forward();
    }
  }

  @override
  void dispose() {
    // Leaving the splash early (e.g. browser back) must not navigate later.
    _hold.cancel();
    _card.dispose();
    _tagline.dispose();
    _reveal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      // Dark like the photo in either theme, so it doesn't flash while the
      // photo decodes.
      backgroundColor: AppColors.dark.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Softly out of focus, so the pastries set the mood without
          // competing with the card.
          RepaintBoundary(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Transform.scale(
                // Keeps the blur's soft edge off the screen.
                scale: 1.06,
                child: Image.asset(
                  AppAssets.splashBackground,
                  fit: BoxFit.cover,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) =>
                          wasSynchronouslyLoaded
                          ? child
                          : AnimatedOpacity(
                              opacity: frame == null ? 0 : 1,
                              duration: AppMotion.of(context, AppMotion.medium),
                              curve: AppMotion.standard,
                              child: child,
                            ),
                ),
              ),
            ),
          ),
          // A light, even dim with a little more at the bottom: the photo
          // stays bright and warm, and the card still reads first.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x26000000),
                  Color(0x33000000),
                  Color(0x66000000),
                ],
                stops: [0, 0.55, 1],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: FadeTransition(
                    opacity: _card,
                    child: ScaleTransition(
                      scale: _cardScale,
                      child: RepaintBoundary(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(AppRadii.card),
                            border: colors.cardOutline.a == 0
                                ? null
                                : Border.all(color: colors.cardOutline),
                            boxShadow: const [
                              // Soft and wide: the card rests on the photo.
                              BoxShadow(
                                color: Color(0x33000000),
                                blurRadius: 48,
                                spreadRadius: -8,
                                offset: Offset(0, 20),
                              ),
                              BoxShadow(
                                color: Color(0x14000000),
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.xl + AppSpacing.xs,
                              AppSpacing.xxl + AppSpacing.xs,
                              AppSpacing.xl + AppSpacing.xs,
                              AppSpacing.xl + AppSpacing.xs,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const BrandLogo(height: 44),
                                const SizedBox(height: AppSpacing.lg),
                                // The rule and the tagline rise in together,
                                // after the logo, on their own layer so the
                                // card under them isn't repainted each frame.
                                RepaintBoundary(
                                  child: FadeTransition(
                                    opacity: _tagline,
                                    child: AnimatedBuilder(
                                      animation: _tagline,
                                      builder: (context, child) =>
                                          Transform.translate(
                                            offset: Offset(
                                              0,
                                              (1 - _tagline.value) *
                                                  _taglineRise,
                                            ),
                                            child: child,
                                          ),
                                      child: const RepaintBoundary(
                                        child: _Tagline(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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

/// The accent rule and DaviDan's tagline under the logo.
class _Tagline extends StatelessWidget {
  const _Tagline();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 3,
          decoration: BoxDecoration(
            color: context.colors.accent,
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          context.content.text(BrandFacts.tagline),
          style: context.textStyles.bodySecondary.copyWith(
            fontSize: 15,
            height: 1.45,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
