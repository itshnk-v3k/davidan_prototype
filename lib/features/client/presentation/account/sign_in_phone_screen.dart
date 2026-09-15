import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/phone.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/info_note.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/features/client/application/account_notifier.dart';
import 'package:davidan_prototype/features/client/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/features/client/application/sign_in_draft_notifier.dart';

/// First step of the demo sign-in: the phone number, as in Glovo and Yandex
/// Eda. Opened by the splash on first launch, where "Mai târziu" lets the
/// customer browse without an account, or pushed from the locked profile.
class SignInPhoneScreen extends ConsumerWidget {
  const SignInPhoneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(signInDraftProvider);
    SignInDraftNotifier signIn() => ref.read(signInDraftProvider.notifier);
    // The splash opens this screen with nothing underneath.
    final canPop = context.canPop();

    void sendCode() {
      if (signIn().submitPhone()) context.push(Routes.signInCode);
    }

    void skip() {
      ref.read(signInSkippedProvider.notifier).skip();
      final firstRun = ref.read(fulfilmentChoiceProvider) == null;
      context.go(firstRun ? Routes.clientLocation : Routes.clientHome);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: AppStrings.signInTitle,
              onBack: canPop ? () => context.pop() : null,
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
                  const Text(
                    AppStrings.signInPrompt,
                    style: AppTextStyles.bodySecondary,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextFormField(
                    initialValue: draft.phone,
                    onChanged: (value) => signIn().setPhone(value),
                    onFieldSubmitted: (_) => sendCode(),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [
                      AutofillHints.telephoneNumberNational,
                    ],
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(MoldovanPhone.length),
                    ],
                    style: AppTextStyles.body,
                    decoration: InputDecoration(
                      labelText: AppStrings.phoneLabel,
                      hintText: AppStrings.phoneHint,
                      prefixText: '${MoldovanPhone.prefix} ',
                      prefixIcon: const Icon(Icons.phone_iphone_rounded),
                      errorText: draft.showPhoneError && !draft.phoneValid
                          ? AppStrings.phoneInvalid
                          : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(label: AppStrings.sendCode, onPressed: sendCode),
                  if (!canPop) ...[
                    const SizedBox(height: AppSpacing.sm),
                    AppButton(
                      label: AppStrings.signInLater,
                      variant: AppButtonVariant.secondary,
                      onPressed: skip,
                    ),
                  ],
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
