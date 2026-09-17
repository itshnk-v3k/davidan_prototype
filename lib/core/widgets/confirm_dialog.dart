import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';

/// Asks the customer to confirm a step that's hard to take back (signing
/// out, cancelling a request). Resolves to true only when they confirm.
///
/// The dialog opens on the phone's own navigator, the one just under the
/// router's root, so on a desktop browser it stays inside PhoneFrame and
/// covers the tabs too. It keeps the colours of the screen that opened it.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
}) async {
  final theme = Theme.of(context);
  final confirmed = await showDialog<bool>(
    context: phoneNavigatorOf(context).context,
    useRootNavigator: false,
    builder: (_) => Theme(
      data: theme,
      child: _ConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
      ),
    ),
  );
  return confirmed ?? false;
}

/// The navigator right under the root one: PhoneFrame's. The tabs' own
/// navigators sit below it, so a dialog or sheet opened on theirs would leave
/// the tab bar uncovered.
NavigatorState phoneNavigatorOf(BuildContext context) {
  final root = Navigator.of(context, rootNavigator: true);
  var navigator = Navigator.of(context);
  while (true) {
    final parent = navigator.context.findAncestorStateOfType<NavigatorState>();
    if (parent == null || identical(parent, root)) return navigator;
    navigator = parent;
  }
}

class _ConfirmDialog extends StatelessWidget {
  const _ConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    TextButton action(String label, Color color, bool result) => TextButton(
      onPressed: () => Navigator.of(context).pop(result),
      style: TextButton.styleFrom(
        foregroundColor: color,
        textStyle: textStyles.bodyStrong,
        minimumSize: const Size(48, 48),
      ),
      child: Text(label),
    );

    return AlertDialog(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.xl),
      ),
      titlePadding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        0,
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.sm,
        AppSpacing.xl,
        0,
      ),
      actionsPadding: const EdgeInsets.all(AppSpacing.md),
      title: Text(title, style: textStyles.title),
      content: Text(message, style: textStyles.bodySecondary),
      actions: [
        action(cancelLabel, colors.textSecondary, false),
        // Confirming undoes something, so it's the error colour, not the
        // brand's.
        action(confirmLabel, colors.error, true),
      ],
    );
  }
}
