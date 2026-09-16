import 'package:flutter/widgets.dart';

/// Every raw colour in the app, and the only file with hex values. The dark
/// and light [AppColors] give these names their roles; widgets never read
/// the palette directly.
abstract final class AppPalette {
  // Caramel, from the site's accent (#C3812D)
  /// Caramel for text and icons on dark surfaces: 7.6:1 on [ink900].
  static const caramel300 = Color(0xFFD9A15A);

  /// The site's caramel. Decoration and large shapes only: 3.2:1 with white.
  static const caramel500 = Color(0xFFC3812D);

  /// Caramel for text and buttons on light surfaces: 4.85:1 on [snow] and
  /// 5.1:1 with white text.
  static const caramel700 = Color(0xFF966322);

  /// Pale caramel tint behind icons on light surfaces.
  static const caramel100 = Color(0xFFF3E4D0);

  /// Deep caramel tint behind icons on dark surfaces.
  static const caramel950 = Color(0xFF3A2C1B);

  /// Near-black brown for text on a caramel fill in the dark theme.
  static const espresso = Color(0xFF1F1408);

  // Red of DaviDan Sushi and DaviDan Rent Car: both sites use #DD3333 for
  // their buttons, so the two brands share it
  /// Red for text and icons on dark surfaces: 4.8:1 on [ink850].
  static const crimson300 = Color(0xFFE66666);

  /// The sites' red. Decoration and large shapes only.
  static const crimson500 = Color(0xFFDD3333);

  /// Red for text and buttons on light surfaces: 4.8:1 on [mist] and 5.4:1
  /// with white text.
  static const crimson700 = Color(0xFFCF2222);

  static const crimson100 = Color(0xFFF2DEDE);
  static const crimson950 = Color(0xFF361C1C);

  /// Near-black red for text on a [crimson300] fill.
  static const crimsonInk = Color(0xFF1F0505);

  // Blue of Apa DaviDan: no site has one, so it is the label of the still
  // water bottle in its davidan.md photo (the mean of the label's blue pixels)
  /// Blue for text and icons on dark surfaces: 4.8:1 on [ink850].
  static const blue300 = Color(0xFF5B8EE6);

  /// The label's blue, for text and buttons on light surfaces: 8.7:1 on
  /// [mist] and 9.8:1 with white text.
  static const blue700 = Color(0xFF15408C);

  static const blue100 = Color(0xFFDEE5F2);
  static const blue950 = Color(0xFF1B2536);

  /// Near-black blue for text on a [blue300] fill.
  static const blueInk = Color(0xFF050E1F);

  // Warm darks, close to the brown backdrops of the product photos
  static const ink950 = Color(0xFF121110);
  static const ink900 = Color(0xFF1C1A17);
  static const ink850 = Color(0xFF262320);
  static const ink800 = Color(0xFF3A3530);
  static const ink700 = Color(0xFF26211C);

  // Warm lights for text on dark
  static const cream = Color(0xFFF3EEE7);
  static const stone300 = Color(0xFFADA69C);
  static const stone500 = Color(0xFF6E6860);

  // Light surfaces and the logo's charcoal
  static const snow = Color(0xFFFCF8F8);
  static const white = Color(0xFFFFFFFF);
  static const mist = Color(0xFFF3F2EE);
  static const line = Color(0xFFE2E2E2);
  static const sand = Color(0xFFEDE6DC);

  /// Logo wordmark colour.
  static const charcoal = Color(0xFF242430);

  /// 4.8:1 on [mist], the lightest surface secondary text sits on.
  static const grey600 = Color(0xFF6A6A6A);
  static const grey400 = Color(0xFFABABAB);

  // Feedback
  static const red700 = Color(0xFFB3261E);
  static const red200 = Color(0xFFF2B8B5);
  static const amber700 = Color(0xFFA84D08);
  static const amber300 = Color(0xFFF5B06B);

  // Translucent
  static const white90 = Color(0xE6FFFFFF);
  static const charcoal70 = Color(0xB3242430);
  static const charcoal16 = Color(0x29242430);
  static const black40 = Color(0x66000000);
}
