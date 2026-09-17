import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/core/widgets/chip_row.dart';
import 'package:davidan_prototype/data/models/menu_category.dart';

/// Horizontally scrolling category chips. Scrolls the selected chip into view,
/// e.g. when the catalog opens on a category near the end of the row
/// ([ChipRow]).
class CategoryChips extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ChipRow(
      itemCount: categories.length,
      selectedIndex: categories.indexWhere(
        (category) => category.id == selectedId,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return AppChip(
          label: category.name,
          selected: category.id == selectedId,
          onTap: () => onSelected(category),
        );
      },
    );
  }
}
