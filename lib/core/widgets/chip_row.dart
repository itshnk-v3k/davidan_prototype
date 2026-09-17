import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_spacing.dart';

/// A row of [AppChip]s that scrolls sideways and always brings the selected
/// one into view, centred when the row is long enough to centre it: a chip
/// picked at the far end of the row, or one already selected when the screen
/// opens, scrolls itself into sight instead of staying off-screen. The menu's
/// category chips and Rent Car's car classes both use it, so both behave the
/// same way.
///
/// It scrolls itself and nothing else. [Scrollable.ensureVisible] walks up
/// through every scroll view around the chip, so inside a feed it would also
/// scroll the page to centre the row — a jump the customer never asked for.
/// This asks the row's own viewport where the chip is and animates only that.
class ChipRow extends StatefulWidget {
  const ChipRow({
    super.key,
    required this.itemCount,
    required this.selectedIndex,
    required this.itemBuilder,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
    this.spacing = AppSpacing.sm,
  });

  final int itemCount;

  /// Which chip is selected; -1 for none, which leaves the row where it is.
  final int selectedIndex;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsets padding;

  /// Between one chip and the next.
  final double spacing;

  /// How long the row takes to bring a newly selected chip into view.
  static const revealDuration = Duration(milliseconds: 250);

  @override
  State<ChipRow> createState() => _ChipRowState();
}

class _ChipRowState extends State<ChipRow> {
  final _controller = ScrollController();
  final _chipKeys = <int, GlobalKey>{};

  @override
  void initState() {
    super.initState();
    // The screen may open on a chip near the end of the row.
    _revealSelected(animate: false);
  }

  @override
  void didUpdateWidget(ChipRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _revealSelected(animate: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Scrolls the row so the selected chip sits in the middle of it, or as
  /// close to the middle as the row's ends allow. After the frame, since the
  /// chip that changed is being laid out right now.
  void _revealSelected({required bool animate}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.hasClients) return;
      final chip = _chipKeys[widget.selectedIndex]?.currentContext;
      if (chip == null || !chip.mounted) return;
      final box = chip.findRenderObject();
      if (box is! RenderBox || !box.hasSize) return;
      final position = _controller.position;
      // Where the row would have to sit for the chip to be in its middle.
      final centred = RenderAbstractViewport.of(box)
          .getOffsetToReveal(box, 0.5)
          .offset;
      final target = centred.clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      );
      if ((target - position.pixels).abs() < 1) return;
      if (animate) {
        _controller.animateTo(
          target,
          duration: ChipRow.revealDuration,
          curve: Curves.easeOut,
        );
      } else {
        _controller.jumpTo(target);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      // The chips' clear tap margins reach past the row's ends.
      clipBehavior: Clip.none,
      padding: widget.padding,
      child: Row(
        children: [
          for (var index = 0; index < widget.itemCount; index++)
            Padding(
              padding: EdgeInsets.only(left: index == 0 ? 0 : widget.spacing),
              // On the chip alone, not on the gap before it, so the row
              // centres the chip rather than the pair.
              child: KeyedSubtree(
                key: _chipKeys.putIfAbsent(index, GlobalKey.new),
                child: widget.itemBuilder(context, index),
              ),
            ),
        ],
      ),
    );
  }
}
