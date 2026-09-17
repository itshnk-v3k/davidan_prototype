import 'package:flutter/widgets.dart';

/// Every raw colour in the app, and the only file with hex values. The dark
/// and light [AppColors] give these names their roles; widgets never read
/// the palette directly.
abstract final class AppPalette {
  // Caramel, from the site's accent (#C3812D)
  /// Honey caramel for text and icons on dark surfaces.
  static const caramel300 = Color(0xFFF0A951);

  /// Bright honey caramel, from the site's accent. Decoration and large shapes
  /// only.
  static const caramel500 = Color(0xFFE8962E);

  /// Deep amber caramel for text and buttons on light surfaces: 4.9:1 with
  /// white text.
  static const caramel700 = Color(0xFFA0590F);

  /// Pale caramel tint behind icons on light surfaces.
  static const caramel100 = Color(0xFFFCEBD6);

  /// Deep caramel tint behind icons on dark surfaces.
  static const caramel950 = Color(0xFF3A2A16);

  /// Near-black brown for text on a caramel fill in the dark theme.
  static const espresso = Color(0xFF1F1408);

  // Red of DaviDan Sushi and DaviDan Rent Car: both sites use #DD3333 for
  // their buttons, so the two brands share it
  /// Coral red for text and icons on dark surfaces.
  static const crimson300 = Color(0xFFFF6B72);

  /// The sites' red. Decoration and large shapes only.
  static const crimson500 = Color(0xFFEF3B45);

  /// Clear red for text and buttons on light surfaces: 5.7:1 with white text.
  static const crimson700 = Color(0xFFC8202C);

  static const crimson100 = Color(0xFFFDE3E4);
  static const crimson950 = Color(0xFF3A1518);

  /// Near-black red for text on a [crimson300] fill.
  static const crimsonInk = Color(0xFF2A0508);

  // Blue of Apa DaviDan: no site has one, so it is the label of the still
  // water bottle in its davidan.md photo (the mean of the label's blue pixels)
  /// Sky blue for text and icons on dark surfaces.
  static const blue300 = Color(0xFF6AA8FF);

  /// Vivid azure, from the bottle label, for text and buttons on light
  /// surfaces: 5.9:1 with white text.
  static const blue700 = Color(0xFF155FCC);

  static const blue100 = Color(0xFFE0EDFD);
  static const blue950 = Color(0xFF13233D);

  /// Near-black blue for text on a [blue300] fill.
  static const blueInk = Color(0xFF04142E);

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

  // Light surfaces: a clean off-white with white cards, so the brands'
  // colours and the photos carry the warmth
  /// The light theme's background.
  static const linen = Color(0xFFF8F7F5);
  static const white = Color(0xFFFFFFFF);

  /// Muted surfaces on light.
  static const oat = Color(0xFFF1EFEC);
  static const sandLine = Color(0xFFE6E3DE);
  static const sand = Color(0xFFEDE6DC);

  /// Logo wordmark colour.
  static const charcoal = Color(0xFF242430);

  /// Text on light surfaces.
  static const graphite = Color(0xFF1A1A1C);

  // Neutral greys for text on light
  /// Secondary text; also the outline of unticked radio buttons and
  /// checkboxes.
  static const taupe600 = Color(0xFF6B6A70);
  static const taupe400 = Color(0xFFA9A8AD);

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

  /// A card's wide, soft shadow on light surfaces.
  static const charcoal08 = Color(0x14242430);

  /// A card's faint contact shadow along its edge on light surfaces.
  static const charcoal04 = Color(0x0A242430);

  /// A card's wide shadow on dark surfaces: only black this deep shows on the
  /// near-black background.
  static const black50 = Color(0x80000000);
  static const black30 = Color(0x4D000000);

  /// A card's hairline edge on dark surfaces, a touch lighter than the card.
  static const white06 = Color(0x0FFFFFFF);

  /// The star beside a rating.
  static const gold400 = Color(0xFFF5B63D);
  static const gold500 = Color(0xFFEFA31A);

  /// The top edge of a brand's header, behind the status bar and buttons.
  static const black45 = Color(0x73000000);
  static const clear = Color(0x00000000);
}
