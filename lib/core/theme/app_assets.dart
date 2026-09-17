/// Brand asset paths. Product and banner images are referenced from
/// lib/data/mock/.
abstract final class AppAssets {
  static const logo = 'assets/images/brand/logo-davidan.webp';

  /// The logo with a cream wordmark, for dark backgrounds. Generated from
  /// [logo] by tools/brand/generate_logo_on_dark_test.dart.
  static const logoOnDark = 'assets/images/brand/logo-davidan-on-dark.png';

  /// DaviDan Sushi's logo as its site has it: a near-white wordmark with a
  /// red fish, for dark backgrounds.
  static const sushiLogoOnDark = 'assets/images/brand/logo-davidan-sushi.webp';

  /// The sushi logo with a charcoal wordmark, for light backgrounds. Generated
  /// from [sushiLogoOnDark] by
  /// tools/brand/generate_sushi_logo_on_light_test.dart.
  static const sushiLogo =
      'assets/images/brand/logo-davidan-sushi-on-light.png';

  /// Each brand's logo in white, for its colour on the hub's bubbles and its
  /// header band. Generated from the site logos by
  /// tools/brand/generate_white_logos_test.dart.
  static const logoWhite = 'assets/images/brand/logo-davidan-white.png';

  /// The wheat "D" of DaviDan's logo alone, in white.
  static const markWhite = 'assets/images/brand/logo-davidan-mark-white.png';
  static const sushiLogoWhite =
      'assets/images/brand/logo-davidan-sushi-white.png';
  static const waterLogoWhite =
      'assets/images/brand/logo-apa-davidan-white.png';
  static const rentCarLogoWhite =
      'assets/images/brand/logo-davidan-rent-car-white.png';

  /// Splash screen background: DaviDan's glazed croissants. Portrait, so it
  /// fills a phone screen with little cropping.
  static const splashBackground =
      'assets/images/banners/banner-croissante.webp';
}
