import 'package:davidan_prototype/core/strings/app_strings.dart';

/// Formats a price in bani (1/100 MDL): 1900 → "19 lei", 1950 → "19,50 lei".
String formatLei(int bani) {
  final lei = bani ~/ 100;
  final rest = bani % 100;
  final amount = rest == 0 ? '$lei' : '$lei,${rest.toString().padLeft(2, '0')}';
  return '$amount ${AppStrings.currency}';
}
