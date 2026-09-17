import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/theme/brand_colors.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Every brand's cart that has something in it, opened over the hub's tabs by
/// their carts button. Each brand keeps its own cart and checkout, the way
/// Glovo and Wolt keep one basket per shop; this list is how carts left in
/// several brands stay easy to find. A cart opens over this list, so back
/// returns here.
class OpenCartsScreen extends ConsumerWidget {
  const OpenCartsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carts = ref.watch(openCartsProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: context.l10n.openCartsTitle,
              // Opened straight from a link, there's nothing to go back to.
              onBack: () => context.canPop()
                  ? context.pop()
                  : context.go(Routes.clientHome),
            ),
            Expanded(
              child: carts.isEmpty
                  ? EmptyState(
                      icon: Icons.shopping_bag_rounded,
                      title: context.l10n.openCartsEmptyTitle,
                      message: context.l10n.openCartsEmptyMessage,
                      actionLabel: context.l10n.backHome,
                      onAction: () => context.go(Routes.clientHome),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.gutter,
                        0,
                        AppSpacing.gutter,
                        AppSpacing.lg,
                      ),
                      itemCount: carts.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final (:brand, :count, :totalBani) = carts[index];
                        return _OpenCartCard(
                          brand: brand,
                          summary:
                              '${context.l10n.itemsInCart(count)} · '
                              '${context.l10n.formatLei(totalBani)}',
                          onTap: () => context.push(Routes.brandCart(brand)),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The brand's photo and name, what its cart holds, and a chevron.
class _OpenCartCard extends StatelessWidget {
  const _OpenCartCard({
    required this.brand,
    required this.summary,
    required this.onTap,
  });

  final Brand brand;
  final String summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final intro = context.content.introOf(brand);
    final image = intro.image;

    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        side: BorderSide(color: colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: colors.accentSoft,
                  shape: BoxShape.circle,
                ),
                child: image == null
                    ? Icon(Icons.storefront_rounded, color: colors.primary)
                    : Image.asset(image, fit: BoxFit.cover),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      intro.name,
                      style: context.textStyles.subtitle.copyWith(
                        color: BrandColors.of(
                          brand,
                          Theme.of(context).brightness,
                        ).primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(summary, style: context.textStyles.bodySecondary),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: colors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
