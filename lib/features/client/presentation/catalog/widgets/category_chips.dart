import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/data/models/menu_category.dart';

/// Horizontally scrolling category chips. Scrolls the selected chip into view,
/// e.g. when the catalog opens on a category near the end of the row.
class CategoryChips extends StatefulWidget {
  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  final List<MenuCategory> categories;
  final String selectedId;
  final ValueChanged<MenuCategory> onSelected;

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  final _chipKeys = <String, GlobalKey>{};

  @override
  void initState() {
    super.initState();
    _revealSelected(animate: false);
  }

  @override
  void didUpdateWidget(CategoryChips oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedId != widget.selectedId) {
      _revealSelected(animate: true);
    }
  }

  void _revealSelected({required bool animate}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chipContext = _chipKeys[widget.selectedId]?.currentContext;
      if (chipContext == null || !chipContext.mounted) return;
      Scrollable.ensureVisible(
        chipContext,
        alignment: 0.5,
        duration: animate ? const Duration(milliseconds: 250) : Duration.zero,
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
      child: Row(
        children: [
          for (final (index, category) in widget.categories.indexed)
            Padding(
              padding: EdgeInsets.only(left: index == 0 ? 0 : AppSpacing.sm),
              child: AppChip(
                key: _chipKeys.putIfAbsent(category.id, GlobalKey.new),
                label: category.name,
                selected: category.id == widget.selectedId,
                onTap: () => widget.onSelected(category),
              ),
            ),
        ],
      ),
    );
  }
}
