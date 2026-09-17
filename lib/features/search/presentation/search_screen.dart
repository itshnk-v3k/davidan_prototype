import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_card.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/search_bar_button.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_grid.dart';
import 'package:davidan_prototype/features/rental/presentation/widgets/rental_car_grid.dart';
import 'package:davidan_prototype/features/search/application/search_providers.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Search, inside Acasă: a field that takes the keyboard as it opens, and the
/// results as the customer types. From the hub it searches every brand's menu
/// and the Rent Car fleet, each product card naming its brand; from a brand's
/// home, that brand's menu only.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.brand});

  /// The brand whose menu is searched; null searches everything.
  final Brand? brand;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _text = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    setState(() => _text = '');
  }

  @override
  Widget build(BuildContext context) {
    final brand = widget.brand;
    final colors = context.colors;
    final (:products, :cars) = ref.watch(
      searchResultsProvider((brand: brand, text: _text)),
    );
    const margin = TapTarget.iconButtonMargin;
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(SearchBarButton.radius),
      borderSide: color.a == 0
          ? BorderSide.none
          : BorderSide(color: color, width: width),
    );

    final Widget results;
    if (searchWords(_text).isEmpty) {
      results = EmptyState(
        icon: PhosphorIconsRegular.magnifyingGlass,
        title: context.l10n.searchPromptTitle,
        message: brand == null
            ? context.l10n.searchPromptHub
            : context.l10n.searchPromptMenu,
      );
    } else if (products.isEmpty && cars.isEmpty) {
      results = EmptyState(
        icon: PhosphorIconsRegular.smileyMeh,
        title: context.l10n.searchNoResultsTitle,
        message: context.l10n.searchNoResultsMessage(_text.trim()),
      );
    } else {
      results = CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          if (products.isNotEmpty) ...[
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
            ProductGrid(
              products: products,
              title: context.l10n.productCount(products.length),
              showBrand: brand == null,
            ),
          ],
          if (cars.isNotEmpty) ...[
            _SectionTitle(context.l10n.searchCarsTitle(cars.length)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                0,
                AppSpacing.gutter,
                AppSpacing.xl,
              ),
              sliver: SliverToBoxAdapter(
                child: RentalCarGrid(
                  cars: cars,
                  onOpen: (car) => context.push(Routes.rentalCar(car.id)),
                ),
              ),
            ),
          ],
        ],
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter - margin,
                AppSpacing.md - margin,
                AppSpacing.gutter,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  AppIconButton(
                    icon: PhosphorIconsRegular.arrowLeft,
                    semanticLabel: context.l10n.back,
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: AppSpacing.sm - margin),
                  Expanded(
                    // The same soft card as the field that opened this page.
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          SearchBarButton.radius,
                        ),
                        boxShadow: AppCard.shadowsOf(colors),
                      ),
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        textInputAction: TextInputAction.search,
                        style: context.textStyles.body.copyWith(fontSize: 15),
                        cursorColor: colors.primary,
                        onChanged: (text) => setState(() => _text = text),
                        decoration: InputDecoration(
                          hintText: brand == null
                              ? context.l10n.searchHubHint
                              : context.l10n.searchMenuHint,
                          hintStyle: SearchBarButton.hintStyleOf(context),
                          filled: true,
                          fillColor: colors.surface,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md + AppSpacing.xxs,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(
                              left: AppSpacing.lg,
                              right: AppSpacing.md,
                            ),
                            child: Icon(
                              PhosphorIconsRegular.magnifyingGlass,
                              size: 22,
                              color: colors.primary,
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(),
                          suffixIcon: _text.isEmpty
                              ? null
                              : IconButton(
                                  icon: const Icon(PhosphorIconsRegular.x),
                                  color: colors.textSecondary,
                                  tooltip: context.l10n.searchClear,
                                  onPressed: _clear,
                                ),
                          border: border(colors.cardOutline, 1),
                          enabledBorder: border(colors.cardOutline, 1),
                          focusedBorder: border(colors.primary, 1.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: results),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.md,
        AppSpacing.gutter,
        AppSpacing.md,
      ),
      sliver: SliverToBoxAdapter(
        child: Text(title, style: context.textStyles.subtitle),
      ),
    );
  }
}
