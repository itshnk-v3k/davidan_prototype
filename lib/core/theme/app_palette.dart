import 'package:flutter/widgets.dart';

/// Every raw colour in the app, and the only file with hex values. The dark
/// and light [AppColors] give these names their roles; widgets never read
/// the palette directly.
///
/// Rich rather than pastel: each brand's tones are saturated and deep, the
/// dark background is near-black so cards stand out, and secondary text keeps
/// a strong contrast. Every text pairing stays at 4.5:1 or more.
abstract final class AppPalette {
  // Caramel, from the site's accent (#C3812D)
  /// Honey caramel for text and icons on dark surfaces.
  static const caramel300 = Color(0xFFFFA42E);

  /// Bright honey caramel, from the site's accent. Decoration and large shapes
  /// only.
  static const caramel500 = Color(0xFFF58F12);

  /// Deep amber caramel for text and buttons on light surfaces: 6.0:1 with
  /// white text.
  static const caramel700 = Color(0xFF9A4F00);

  /// Pale caramel tint behind icons on light surfaces.
  static const caramel100 = Color(0xFFFDE2BF);

  /// Deep caramel tint behind icons on dark surfaces.
  static const caramel950 = Color(0xFF40260A);

  /// Near-black brown for text on a caramel fill in the dark theme.
  static const espresso = Color(0xFF1F1408);

  // Vermilion of DaviDan Sushi: a warm, orange-leaning red, bright enough to
  // read as energetic and far enough from the bakery's caramel (and from Rent
  // Car's green) that the brands never look alike
  /// Coral orange for text and icons on dark surfaces.
  static const vermilion300 = Color(0xFFFF673D);

  /// Vivid vermilion. Decoration and large shapes only.
  static const vermilion500 = Color(0xFFF2451C);

  /// Deep vermilion for text and buttons on light surfaces: 5.9:1 with white
  /// text. The brand's own surfaces (the hub bubble, the header band) are this
  /// one; its buttons and prices take [vermilion600].
  static const vermilion700 = Color(0xFFBF2A0A);

  /// The light theme's sushi accent: the same vermilion carried a few degrees
  /// towards orange, where the delivery apps the client picked out sit, so
  /// prices and buttons read as a warm red rather than maroon. Still 5.3:1
  /// with white text and 4.6:1 on the muted surface, which [vermilion500]
  /// (3.7:1) is too bright for.
  static const vermilion600 = Color(0xFFBE4310);

  static const vermilion100 = Color(0xFFFFD9CC);
  static const vermilion950 = Color(0xFF48160A);

  /// Near-black red for text on a [vermilion300] fill.
  static const vermilionInk = Color(0xFF2B0A03);

  // Emerald of DaviDan Rent Car: its site shares Sushi's red, so the app gives
  // it a colour of its own, a fresh green no other brand comes near
  /// Mint green for text and icons on dark surfaces.
  static const emerald300 = Color(0xFF20D37F);

  /// Vivid emerald. Decoration and large shapes only.
  static const emerald500 = Color(0xFF00B878);

  /// Deep emerald for text and buttons on light surfaces: 6.1:1 with white
  /// text.
  static const emerald700 = Color(0xFF00704A);

  static const emerald100 = Color(0xFFCBF1DE);
  static const emerald950 = Color(0xFF06341F);

  /// Near-black green for text on an [emerald300] fill.
  static const emeraldInk = Color(0xFF03261A);

  // Blue of Apa DaviDan: no site has one, so it is the label of the still
  // water bottle in its davidan.md photo (the mean of the label's blue pixels)
  /// Sky blue for text and icons on dark surfaces.
  static const blue300 = Color(0xFF529AFF);

  /// Vivid azure, from the bottle label, for text and buttons on light
  /// surfaces: 7.0:1 with white text.
  static const blue700 = Color(0xFF0D52C0);

  static const blue100 = Color(0xFFD3E4FF);
  static const blue950 = Color(0xFF0B2549);

  /// Near-black blue for text on a [blue300] fill.
  static const blueInk = Color(0xFF04142E);

  // Warm darks, close to the brown backdrops of the product photos
  static const ink950 = Color(0xFF0C0B0A);
  static const ink900 = Color(0xFF1C1A17);
  static const ink850 = Color(0xFF262320);
  static const ink800 = Color(0xFF3A3530);
  static const ink700 = Color(0xFF26211C);

  // Warm lights for text on dark
  static const cream = Color(0xFFF3EEE7);
  static const stone300 = Color(0xFFB9B2A7);
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
  static const taupe600 = Color(0xFF5C5B61);
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
  static const gold400 = Color(0xFFFFB321);
  static const gold500 = Color(0xFFF29D00);

  /// The top edge of a brand's header, behind the status bar and buttons.
  static const black45 = Color(0x73000000);
  static const clear = Color(0x00000000);
}
