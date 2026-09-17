import 'package:material_ui/material_ui.dart';

/// The room a tab screen leaves at the end of its scrolling content, so the
/// last of it can scroll clear of the floating tab bar. The tabs' Scaffold
/// lets content run behind the bar and reports the bar's height as the
/// bottom padding; outside the tabs this is just the phone's own inset.
abstract final class BottomBarSpace {
  /// The height to add under a tab screen's last item.
  static double of(BuildContext context) =>
      MediaQuery.paddingOf(context).bottom;
}

/// [BottomBarSpace] as the last sliver of a CustomScrollView.
class SliverBottomBarSpace extends StatelessWidget {
  const SliverBottomBarSpace({super.key});

  @override
  Widget build(BuildContext context) =>
      SliverToBoxAdapter(child: SizedBox(height: BottomBarSpace.of(context)));
}
