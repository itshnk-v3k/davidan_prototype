import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/location/location_result.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
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
import 'package:davidan_prototype/features/client/application/catalog_providers.dart';
import 'package:davidan_prototype/features/client/application/nearby.dart';
import 'package:davidan_prototype/features/client/application/sign_in_draft_notifier.dart';

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
              title: AppStrings.detailsTitle,
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
                      labelText: AppStrings.nameLabel,
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      errorText: draft.showDetailsErrors && draft.nameMissing
                          ? AppStrings.nameMissing
                          : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    AppStrings.sectorTitle,
                    style: context.textStyles.subtitle,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (final sector in ChisinauSector.values)
                        AppChip(
                          label: AppStrings.sectorName(sector),
                          selected: sector == draft.sector,
                          onTap: () => signIn().setSector(sector),
                        ),
                    ],
                  ),
                  if (draft.showDetailsErrors && draft.sector == null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      AppStrings.sectorMissing,
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
                  AppButton(label: AppStrings.createAccount, onPressed: create),
                  const SizedBox(height: AppSpacing.xl),
                  const InfoNote(text: AppStrings.demoSignInNote),
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
        nearestLocation(point, locations),
      ),
      LocationNotFound(:final failure) => AppStrings.locationFailedUseSector(
        failure,
      ),
      null => null,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          label: draft.locating
              ? AppStrings.locating
              : AppStrings.useMyLocationForShop,
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
    ({StoreLocation location, double meters}) nearest,
  ) => AppStrings.locationFoundNearest(
    formatDistance(nearest.meters),
    nearest.location.name,
  );
}
