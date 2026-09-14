import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';

/// On wide browser windows, renders [child] in a phone-sized frame so the
/// mobile apps look like a phone during a desktop demo. On narrow viewports
/// [child] fills the screen.
///
/// The widget tree is the same shape in both modes, so resizing the window
/// across the breakpoint never rebuilds the navigator underneath.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final framed = media.size.width >= AppLayout.frameBreakpoint;
    final size = framed
        ? Size(
            AppLayout.phoneWidth,
            math.max(
              0,
              math.min(
                media.size.height - 2 * AppSpacing.xl,
                AppLayout.phoneMaxHeight,
              ),
            ),
          )
        : media.size;

    return ColoredBox(
      color: framed ? AppColors.desktopBackdrop : AppColors.background,
      child: Center(
        child: Container(
          width: size.width,
          height: size.height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(framed ? 32 : 0),
            boxShadow: framed
                ? const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 48,
                      offset: Offset(0, 20),
                    ),
                  ]
                : null,
          ),
          child: MediaQuery(
            data: framed
                ? media.copyWith(
                    size: size,
                    padding: EdgeInsets.zero,
                    viewPadding: EdgeInsets.zero,
                  )
                : media,
            child: child,
          ),
        ),
      ),
    );
  }
}
