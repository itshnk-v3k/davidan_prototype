import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/entrance.dart';
import 'package:davidan_prototype/features/account/application/account_notifier.dart';
import 'package:davidan_prototype/features/account/presentation/widgets/nearest_shop_card.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// After the demo sign-in: a greeting and the nearest shop. Continuing opens
/// the location screen with that shop selected, for the customer to confirm
/// or change; nothing is chosen for them.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);

    if (account == null) {
      return Scaffold(
        backgroundColor: context.colors.background,
        body: SafeArea(
          child: EmptyState(
            icon: Icons.lock_outline_rounded,
            title: context.l10n.accountLockedTitle,
            message: context.l10n.accountLockedMessage,
            actionLabel: context.l10n.signInTitle,
            onAction: () => context.go(Routes.signIn),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          children: [
            const SizedBox(height: AppSpacing.xxl),
            Center(
              child: Entrance(
                pop: true,
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: context.colors.accentSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.waving_hand_rounded,
                    size: 44,
                    color: context.colors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              context.l10n.welcomeTitle(account.name),
              style: context.textStyles.headline,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              context.l10n.welcomeMessage,
              style: context.textStyles.bodySecondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            NearestShopCard(account: account),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: AppButton(
            label: context.l10n.chooseHowToReceive,
            onPressed: () => context.go(Routes.clientLocationAfterSignUp),
          ),
        ),
      ),
    );
  }
}
