/// Spacing tokens on a 4 px grid.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;

  /// Every card-style block: product cards, category tiles, promo cards and
  /// banners, the hub's brand cards, and the floating tab bar.
  static const double card = 10;
  static const double xl = 24;
  static const double xxl = 32;

  /// Horizontal padding between screen content and the screen edge.
  static const double gutter = 16;
}

/// Corner radius tokens.
abstract final class AppRadii {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;

  /// Every card-style block: product cards, category tiles, promo cards and
  /// banners, the hub's brand cards, and the floating tab bar.
  static const double card = 10;
  static const double xl = 24;
  static const double pill = 999;
}

/// Layout constants for presenting mobile screens on a desktop browser.
abstract final class AppLayout {
  /// Logical width of the phone frame the customer and courier apps render in.
  static const double phoneWidth = 400;
  static const double phoneMaxHeight = 860;

  /// Below this viewport width the app renders full-screen, without a frame.
  static const double frameBreakpoint = 600;
}
