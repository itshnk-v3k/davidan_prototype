import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A short confirmation in the phone apps, e.g. "Adăugat în coș".
@immutable
class Toast {
  const Toast({required this.id, required this.message});

  /// Tells toasts apart, so the same text shown twice comes in again.
  final int id;
  final String message;
}

final toastProvider = NotifierProvider<ToastNotifier, Toast?>(
  ToastNotifier.new,
);

/// The toast on screen, if any. A new toast replaces the current one, and
/// each goes away after [duration]. ToastHost shows it at the top of the
/// screen; the phone apps have no bottom snack bars.
class ToastNotifier extends Notifier<Toast?> {
  static const duration = Duration(seconds: 3);

  Timer? _timer;
  int _shown = 0;

  @override
  Toast? build() {
    ref.onDispose(() => _timer?.cancel());
    return null;
  }

  void show(String message) {
    _timer?.cancel();
    state = Toast(id: _shown++, message: message);
    _timer = Timer(duration, () => state = null);
  }
}
