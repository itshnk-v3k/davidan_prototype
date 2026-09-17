import 'package:flutter/services.dart';

/// Moldovan mobile numbers: +373, then 8 digits starting with 6 or 7.
abstract final class MoldovanPhone {
  static const prefix = '+373';
  static const length = 8;

  static final _mobile = RegExp(r'^[67]\d{7}$');

  /// The digits after +373 in what someone typed or pasted: spaces and signs
  /// go, and so do a leading 373 (a pasted +373 69 123 456) and the 0 people
  /// dial inside Moldova (069 123 456), then it's cut to [length].
  static String digitsOf(String value) {
    var digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length > length && digits.startsWith('373')) {
      digits = digits.substring(3);
    }
    digits = digits.replaceFirst(RegExp(r'^0+'), '');
    return digits.length > length ? digits.substring(0, length) : digits;
  }

  /// For a number field after a +373 prefix: keeps it to [digitsOf].
  static final inputFormatter = TextInputFormatter.withFunction((_, value) {
    final digits = digitsOf(value.text);
    return digits == value.text
        ? value
        : TextEditingValue(
            text: digits,
            selection: TextSelection.collapsed(offset: digits.length),
          );
  });

  /// Whether [digits], without +373, is a mobile number.
  static bool isValid(String digits) => _mobile.hasMatch(digits);

  /// "69123456" → "+373 69 123 456".
  static String format(String digits) => _grouped(digits, digits);

  /// "69123456" → "+373 69 *** 456", for showing the number on screen.
  static String masked(String digits) => _grouped(
    digits,
    digits.length == length ? digits.replaceRange(2, 5, '***') : digits,
  );

  static String _grouped(String digits, String shown) {
    if (digits.length != length) return '$prefix $shown'.trim();
    return '$prefix ${shown.substring(0, 2)} ${shown.substring(2, 5)} '
        '${shown.substring(5)}';
  }
}
