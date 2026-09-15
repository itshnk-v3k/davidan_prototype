import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The current time. Tests override it so time-based UI is predictable.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Formats a time of day as "HH:mm": 9:05 → "09:05".
String formatTime(DateTime time) =>
    '${time.hour.toString().padLeft(2, '0')}:'
    '${time.minute.toString().padLeft(2, '0')}';

/// Formats a duration as "mm:ss", or "h:mm:ss" from one hour on:
/// 4 min 12 s → "04:12". A negative duration (clock changed) shows "00:00".
String formatElapsed(Duration elapsed) {
  final seconds = elapsed.isNegative ? 0 : elapsed.inSeconds;
  String twoDigits(int value) => value.toString().padLeft(2, '0');
  final minutesAndSeconds =
      '${twoDigits(seconds ~/ 60 % 60)}:${twoDigits(seconds % 60)}';
  final hours = seconds ~/ 3600;
  return hours == 0 ? minutesAndSeconds : '$hours:$minutesAndSeconds';
}
