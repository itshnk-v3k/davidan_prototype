/// Moldovan mobile numbers: +373, then 8 digits starting with 6 or 7.
abstract final class MoldovanPhone {
  static const prefix = '+373';
  static const length = 8;

  static final _mobile = RegExp(r'^[67]\d{7}$');

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
