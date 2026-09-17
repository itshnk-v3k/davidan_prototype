import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/theme/theme_mode_notifier.dart';
import 'package:davidan_prototype/core/toast/toast_notifier.dart';
import 'package:davidan_prototype/core/utils/phone.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/bottom_bar_space.dart';
import 'package:davidan_prototype/core/widgets/confirm_dialog.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/language_selector.dart';
import 'package:davidan_prototype/core/widgets/link_card.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/core/widgets/section_title.dart';
import 'package:davidan_prototype/core/widgets/theme_mode_selector.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/data/models/customer_account.dart';
import 'package:davidan_prototype/features/account/application/account_notifier.dart';
import 'package:davidan_prototype/features/account/presentation/widgets/nearest_shop_card.dart';
import 'package:davidan_prototype/features/launcher/application/demo_reset_notifier.dart';
import 'package:davidan_prototype/l10n/app_language.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Profile tab. The account comes first once the customer goes through the
/// demo sign-in (their name, number, sector and nearest shop), or a way to sign
/// in. Then, either way: the brands' contacts and legal pages, the theme and
/// language switches, the demo reset (the customer app build has no launcher
/// to hold it) and, last, signing out, which asks first.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(title: context.l10n.profileTitle),
            Expanded(
              child: account == null
                  // The lock message fills the space above the settings, and
                  // on a short phone the page scrolls instead of squeezing
                  // the "Intră în cont" button out of sight.
                  ? CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: EmptyState(
                                  icon: PhosphorIconsRegular.lockSimple,
                                  title: context.l10n.accountLockedTitle,
                                  message: context.l10n.accountLockedMessage,
                                  actionLabel: context.l10n.signInTitle,
                                  onAction: () => context.push(Routes.signIn),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  AppSpacing.gutter,
                                  0,
                                  AppSpacing.gutter,
                                  AppSpacing.xl + BottomBarSpace.of(context),
                                ),
                                child: const _ProfileSections(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : ListView(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.gutter,
                        0,
                        AppSpacing.gutter,
                        // Clear of the floating tab bar.
                        AppSpacing.xl + BottomBarSpace.of(context),
                      ),
                      children: [
                        _AccountCard(account: account),
                        const SizedBox(height: AppSpacing.md),
                        NearestShopCard(account: account),
                        const _ProfileSections(),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          context.l10n.demoProfileNote,
                          style: context.textStyles.caption,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        AppButton(
                          label: context.l10n.signOut,
                          icon: PhosphorIconsRegular.signOut,
                          variant: AppButtonVariant.secondary,
                          onPressed: () async {
                            final l10n = context.l10n;
                            final confirmed = await showConfirmDialog(
                              context,
                              title: l10n.signOutConfirmTitle,
                              message: l10n.signOutConfirmMessage,
                              confirmLabel: l10n.signOut,
                              cancelLabel: l10n.back,
                            );
                            if (confirmed) {
                              ref.read(accountProvider.notifier).signOut();
                            }
                          },
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// What Profil shows signed in or not: the brands' information pages, the
/// theme and language switches, and the demo reset. Resetting starts the demo
/// over from the splash, the way a first launch would; the theme and the
/// language stay as chosen.
class _ProfileSections extends ConsumerWidget {
  const _ProfileSections();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        SectionTitle(title: context.l10n.profileBrandsTitle),
        const SizedBox(height: AppSpacing.md),
        for (final brand in brandInfos.keys) ...[
          LinkCard(
            icon: PhosphorIconsRegular.info,
            title: context.content.introOf(brand).name,
            hint: context.l10n.profileBrandInfoHint,
            onTap: () => context.push(
              Routes.brandInfo(brand, tab: Routes.clientProfile),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        const SizedBox(height: AppSpacing.lg),
        ThemeModeSelector(
          selected: ref.watch(themeModeProvider),
          onSelected: ref.read(themeModeProvider.notifier).select,
        ),
        const SizedBox(height: AppSpacing.lg),
        LanguageSelector(
          selected: ref.watch(appLanguageProvider),
          onSelected: ref.read(appLanguageProvider.notifier).select,
        ),
        const SizedBox(height: AppSpacing.xl),
        SectionTitle(title: context.l10n.profileDemoTitle),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: context.l10n.resetDemoData,
          icon: PhosphorIconsRegular.arrowsCounterClockwise,
          variant: AppButtonVariant.secondary,
          onPressed: () async {
            await ref.read(demoResetProvider.notifier).reset();
            if (!context.mounted) return;
            context.go(Routes.clientSplash);
            ref
                .read(toastProvider.notifier)
                .show(ref.read(stringsProvider).resetDemoDataDone);
          },
        ),
      ],
    );
  }
}

/// Initial, name, masked number and sector.
class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.account});

  final CustomerAccount account;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: context.colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.colors.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                account.name.characters.first.toUpperCase(),
                style: context.textStyles.title.copyWith(
                  color: context.colors.onPrimary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(account.name, style: context.textStyles.subtitle),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    MoldovanPhone.masked(account.phone),
                    style: context.textStyles.bodySecondary,
                  ),
                  Text(
                    context.l10n.sectorLabel(account.sector),
                    style: context.textStyles.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
