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

  // Vermilion of DaviDan Sushi: a warm, orange-leaning red, bright enough to
  // read as energetic and far enough from the bakery's caramel (and from Rent
  // Car's green) that the brands never look alike
  /// Coral orange for text and icons on dark surfaces.
  static const vermilion300 = Color(0xFFFF7D57);

  /// Vivid vermilion. Decoration and large shapes only.
  static const vermilion500 = Color(0xFFF2542D);

  /// Clear vermilion for text and buttons on light surfaces: 5.4:1 with white
  /// text.
  static const vermilion700 = Color(0xFFC92E12);

  static const vermilion100 = Color(0xFFFFE6DE);
  static const vermilion950 = Color(0xFF3D1810);

  /// Near-black red for text on a [vermilion300] fill.
  static const vermilionInk = Color(0xFF2B0A03);

  // Emerald of DaviDan Rent Car: its site shares Sushi's red, so the app gives
  // it a colour of its own, a fresh green no other brand comes near
  /// Mint green for text and icons on dark surfaces.
  static const emerald300 = Color(0xFF3DD68C);

  /// Vivid emerald. Decoration and large shapes only.
  static const emerald500 = Color(0xFF10B981);

  /// Deep emerald for text and buttons on light surfaces: 5.4:1 with white
  /// text.
  static const emerald700 = Color(0xFF047A4C);

  static const emerald100 = Color(0xFFDAF5E9);
  static const emerald950 = Color(0xFF0E2F22);

  /// Near-black green for text on an [emerald300] fill.
  static const emeraldInk = Color(0xFF03261A);

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
