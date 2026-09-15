import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart' show ThemeMode;

import 'package:davidan_prototype/core/storage/local_store.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

/// Dark, light, or following the phone, for the whole prototype. Dark by
/// default; saved to local storage. A presenter's preference rather than demo
/// data, so resetting the demo keeps it.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() =>
      ref
          .watch(localStoreProvider)
          .read(
            StorageKeys.themeMode,
            (json) => ThemeMode.values.byName(json! as String),
          ) ??
      ThemeMode.dark;

  void select(ThemeMode mode) {
    state = mode;
    ref.read(localStoreProvider).write(StorageKeys.themeMode, mode.name);
  }
}
