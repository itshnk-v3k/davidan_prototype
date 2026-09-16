import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/location/location_result.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/distance.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/core/widgets/info_note.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/data/models/chisinau_sector.dart';
import 'package:davidan_prototype/data/models/store_location.dart';
import 'package:davidan_prototype/features/account/application/nearby.dart';
import 'package:davidan_prototype/features/account/application/sign_in_draft_notifier.dart';
import 'package:davidan_prototype/features/food/application/shop_providers.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Last step of the demo sign-in: name and sector, and optionally the phone's
/// location to find the nearest shop by distance. Creating the account opens
/// the welcome screen.
class SignInDetailsScreen extends ConsumerWidget {
  const SignInDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(signInDraftProvider);
    final locations = ref.watch(locationsProvider);
    SignInDraftNotifier signIn() => ref.read(signInDraftProvider.notifier);

    void create() {
      if (signIn().finish() != null) context.go(Routes.welcome);
    }

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: context.l10n.detailsTitle,
              onBack: () =>
                  context.canPop() ? context.pop() : context.go(Routes.signIn),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  0,
                  AppSpacing.gutter,
                  AppSpacing.xl,
                ),
                children: [
                  TextFormField(
                    initialValue: draft.name,
                    onChanged: (name) => signIn().setName(name),
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.name],
                    style: context.textStyles.body,
                    decoration: InputDecoration(
                      labelText: context.l10n.nameLabel,
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      errorText: draft.showDetailsErrors && draft.nameMissing
                          ? context.l10n.nameMissing
                          : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    context.l10n.sectorTitle,
                    style: context.textStyles.subtitle,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (final sector in ChisinauSector.values)
                        AppChip(
                          label: context.l10n.sectorName(sector),
                          selected: sector == draft.sector,
                          onTap: () => signIn().setSector(sector),
                        ),
                    ],
                  ),
                  if (draft.showDetailsErrors && draft.sector == null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      context.l10n.sectorMissing,
                      style: context.textStyles.caption.copyWith(
                        color: context.colors.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  _LocateSection(
                    draft: draft,
                    locations: locations,
                    onLocate: () => signIn().locate(),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: context.l10n.createAccount,
                    onPressed: create,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  InfoNote(text: context.l10n.demoSignInNote),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Găsește localul după locația mea", and what the lookup found.
class _LocateSection extends StatelessWidget {
  const _LocateSection({
    required this.draft,
    required this.locations,
    required this.onLocate,
  });

  final SignInDraft draft;
  final List<StoreLocation> locations;
  final VoidCallback onLocate;

  @override
  Widget build(BuildContext context) {
    final message = switch (draft.located) {
      LocationFound(:final point) => _foundMessage(
        context.l10n,
        nearestLocation(point, locations),
      ),
      LocationNotFound(:final failure) => context.l10n.locationFailedUseSector(
        failure,
      ),
      null => null,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          label: draft.locating
              ? context.l10n.locating
              : context.l10n.useMyLocationForShop,
          icon: Icons.my_location_rounded,
          variant: AppButtonVariant.secondary,
          onPressed: draft.locating ? () {} : onLocate,
        ),
        if (message != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(message, style: context.textStyles.bodySecondary),
        ],
      ],
    );
  }

  static String _foundMessage(
    AppLocalizations l10n,
    ({StoreLocation location, double meters}) nearest,
  ) => l10n.locationFoundNearest(
    formatDistance(nearest.meters),
    nearest.location.name,
  );
}
