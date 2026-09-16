import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/toast/toast_notifier.dart';
import 'package:davidan_prototype/core/utils/phone.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/info_note.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/features/account/application/sign_in_draft_notifier.dart';

/// Second step of the demo sign-in: the code "sent by SMS". No SMS is sent
/// and any 4 digits are accepted (see SignInDraftNotifier); the screen says so.
/// The fourth digit continues on its own.
class SignInCodeScreen extends ConsumerWidget {
  const SignInCodeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(signInDraftProvider);
    SignInDraftNotifier signIn() => ref.read(signInDraftProvider.notifier);

    void confirm() {
      if (signIn().submitCode()) context.push(Routes.signInDetails);
    }

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: AppStrings.codeTitle,
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
                  Text(
                    AppStrings.codeSentTo(MoldovanPhone.format(draft.phone)),
                    style: context.textStyles.bodySecondary,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _CodeBoxes(
                    code: draft.code,
                    onChanged: (value) {
                      signIn().setCode(value);
                      if (value.length == SignInDraft.codeLength) confirm();
                    },
                  ),
                  if (draft.showCodeError && !draft.codeComplete) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      AppStrings.codeIncomplete,
                      style: context.textStyles.caption.copyWith(
                        color: context.colors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(label: AppStrings.confirmCode, onPressed: confirm),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: () => ref
                        .read(toastProvider.notifier)
                        .show(AppStrings.codeResent),
                    style: TextButton.styleFrom(
                      foregroundColor: context.colors.primary,
                      textStyle: context.textStyles.bodyStrong,
                    ),
                    child: const Text(AppStrings.resendCode),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const InfoNote(text: AppStrings.demoCodeNote),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Four digit boxes over an invisible text field, like the code inputs of
/// delivery apps. Tapping the boxes focuses the field.
class _CodeBoxes extends StatelessWidget {
  const _CodeBoxes({required this.code, required this.onChanged});

  final String code;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ExcludeSemantics(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var index = 0; index < SignInDraft.codeLength; index++)
                Container(
                  width: 56,
                  height: 64,
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    border: index == code.length
                        ? Border.all(color: context.colors.primary, width: 2)
                        : Border.all(color: context.colors.border),
                  ),
                  child: Text(
                    index < code.length ? code[index] : '',
                    style: context.textStyles.headline,
                  ),
                ),
            ],
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0,
            child: TextFormField(
              initialValue: code,
              autofocus: true,
              onChanged: onChanged,
              keyboardType: TextInputType.number,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(SignInDraft.codeLength),
              ],
              showCursor: false,
              enableInteractiveSelection: false,
              decoration: const InputDecoration.collapsed(
                hintText: AppStrings.codeLabel,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
