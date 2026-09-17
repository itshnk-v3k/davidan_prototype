import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/toast/toast_notifier.dart';
import 'package:davidan_prototype/core/widgets/top_notice.dart';

/// Shows the current toast at the top of the phone apps, in the colour of the
/// brand it's about. Only the notice itself takes touches, a swipe up to
/// dismiss it, so the screen around it (a back button, a heart) still works
/// while it's up. PhoneFrame places it above every screen.
class ToastHost extends ConsumerWidget {
  const ToastHost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toast = ref.watch(toastProvider);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          AppSpacing.sm,
          AppSpacing.gutter,
          0,
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: TopNoticeSwitcher(
            onDismiss: () => ref.read(toastProvider.notifier).dismiss(),
            notice: toast == null
                ? null
                : TopNotice(
                    key: ValueKey(toast.id),
                    icon: PhosphorIconsFill.checkCircle,
                    message: toast.message,
                    brand: toast.brand,
                  ),
          ),
        ),
      ),
    );
  }
}
