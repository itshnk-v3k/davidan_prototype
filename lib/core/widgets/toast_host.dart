import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/toast/toast_notifier.dart';
import 'package:davidan_prototype/core/widgets/top_notice.dart';

/// Shows the current toast at the top of the phone apps, in the same style as
/// the store panel's new-order notice, in the colour of the brand it's about. It lets taps through, so it never
/// covers a back button or a heart while it's up. PhoneFrame places it above
/// every screen.
class ToastHost extends ConsumerWidget {
  const ToastHost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toast = ref.watch(toastProvider);

    return IgnorePointer(
      child: SafeArea(
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
              notice: toast == null
                  ? null
                  : TopNotice(
                      key: ValueKey(toast.id),
                      icon: Icons.check_circle_rounded,
                      message: toast.message,
                      brand: toast.brand,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
