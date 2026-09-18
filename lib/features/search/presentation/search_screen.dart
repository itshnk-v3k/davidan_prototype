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
import 'package:davidan_prototype/core/widgets/search_field.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_grid.dart';
import 'package:davidan_prototype/features/rental/presentation/widgets/rental_car_grid.dart';
import 'package:davidan_prototype/features/search/application/search_providers.dart';
import 'package:davidan_prototype/features/search/presentation/widgets/category_filter_sheet.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Search, inside Acasă: a field that takes the keyboard as it opens, a filter
/// button beside it, and the results as the customer types. From the hub it
/// searches every brand's menu and the Rent Car fleet, each product card
/// naming its brand; from a brand's home, that brand's menu only. The filter
/// narrows it to one category, shown as a chip under the field; with a
/// category and nothing typed, the page lists that category's products.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.brand, this.initialCategory});

  /// The brand whose menu is searched; null searches everything.
  final Brand? brand;

  /// The category the page opens filtered to, chosen from a home's filter
  /// button.
  final CategoryFilter? initialCategory;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _text = '';
  late CategoryFilter? _category = widget.initialCategory;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    setState(() => _text = '');
  }

  Future<void> _chooseCategory() async {
    final brand = widget.brand;
    final choice = await showCategoryFilterSheet(
      context,
      brands: brand == null ? Brand.values : [brand],
      selected: _category,
    );
    if (choice != null && mounted) setState(() => _category = choice.category);
  }

  @override
  Widget build(BuildContext context) {
    final brand = widget.brand;
    final category = _category;
    final colors = context.colors;
    final (:products, :cars) = ref.watch(
      searchResultsProvider((brand: brand, text: _text, category: category)),
    );
    final categoryName = category == null
        ? null
        : ref
              .watch(categoriesProvider(category.brand))
              .where((each) => each.id == category.categoryId)
              .firstOrNull
              ?.name;
    const margin = TapTarget.iconButtonMargin;
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(SearchField.radius),
      borderSide: color.a == 0
          ? BorderSide.none
          : BorderSide(color: color, width: width),
    );
    // Clear of the floating tab bar.
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final Widget results;
    if (searchWords(_text).isEmpty && category == null) {
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
        message: context.l10n.searchNoResultsMessage(
          _text.trim().isEmpty ? (categoryName ?? '') : _text.trim(),
        ),
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
          SliverToBoxAdapter(child: SizedBox(height: bottomInset)),
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
                    // The soft card of SearchField, raised the way the app's
                    // cards are.
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(SearchField.radius),
                        boxShadow: AppCard.shadowsOf(colors),
                      ),
                      child: TextField(
                        controller: _controller,
                        // Opened for a category, the list comes first.
                        autofocus: widget.initialCategory == null,
                        textInputAction: TextInputAction.search,
                        style: context.textStyles.body.copyWith(fontSize: 15),
                        cursorColor: colors.primary,
                        onChanged: (text) => setState(() => _text = text),
                        decoration: InputDecoration(
                          hintText: brand == null
                              ? context.l10n.searchHubHint
                              : context.l10n.searchMenuHint,
                          hintStyle: SearchField.hintStyleOf(context),
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
                  const SizedBox(width: AppSpacing.md),
                  SearchFilterButton(
                    label: context.l10n.filterByCategory,
                    active: category != null,
                    onTap: _chooseCategory,
                  ),
                ],
              ),
            ),
            if (categoryName != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  AppSpacing.xs,
                  AppSpacing.gutter,
                  0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _FilterChip(
                    label: categoryName,
                    semanticLabel: context.l10n.clearCategoryFilter(
                      categoryName,
                    ),
                    onClear: () => setState(() => _category = null),
                  ),
                ),
              ),
            Expanded(child: results),
          ],
        ),
      ),
    );
  }
}

/// The chosen category under the field; tapping it clears the filter.
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.semanticLabel,
    required this.onClear,
  });

  final String label;
  final String semanticLabel;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: Material(
        color: colors.accentSoft,
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: InkWell(
          onTap: onClear,
          borderRadius: BorderRadius.circular(AppRadii.md),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: TapTarget.min),
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.sm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: context.textStyles.bodyStrong.copyWith(
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Icon(PhosphorIconsBold.x, size: 16, color: colors.primary),
                ],
              ),
            ),
          ),
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
