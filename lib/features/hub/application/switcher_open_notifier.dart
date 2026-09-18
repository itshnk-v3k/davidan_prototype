import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether Acasă's brand switcher is folded out under the bar. The customer
/// opens and closes it with the handle under the row (BrandShell); nothing
/// else moves it, least of all the page's own scrolling.
///
/// It is kept for as long as the app is open and never written to local
/// storage. A row closed to see more of the menu should stay closed while the
/// customer browses — otherwise the handle would undo itself on the first
/// category opened — but the five brands are how the app introduces itself,
/// so every fresh start shows them.
final switcherOpenProvider = NotifierProvider<SwitcherOpenNotifier, bool>(
  SwitcherOpenNotifier.new,
);

class SwitcherOpenNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
}
