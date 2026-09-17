import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/features/orders/application/customer_requests_provider.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The bell at the top of Acasă, opening the latest news about the customer's
/// orders and rental requests. A dot says something is still under way. The
/// app keeps no "read" state, so the dot never claims unread messages.
class NotificationsButton extends ConsumerWidget {
  const NotificationsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final underWay = ref.watch(
      activeRequestsProvider.select((requests) => requests.isNotEmpty),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AppIconButton(
          icon: Icons.notifications_rounded,
          semanticLabel: context.l10n.openNotifications,
          onPressed: () => context.push(Routes.clientNotifications),
        ),
        // On the circle's corner, inside the button's clear margin, where
        // the carts button has its count.
        if (underWay)
          Positioned(
            top: TapTarget.iconButtonMargin + AppSpacing.xxs,
            right: TapTarget.iconButtonMargin + AppSpacing.xxs,
            child: IgnorePointer(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.colors.background,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
