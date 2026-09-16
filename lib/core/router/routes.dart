import 'package:davidan_prototype/core/location/location_result.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/product.dart';

/// Route paths. Widgets navigate with these instead of string literals.
abstract final class Routes {
  static const launcher = '/';

  // Customer app
  static const clientSplash = '/client/splash';
  static const clientLocation = '/client/location';

  /// The location screen right after sign-up: pickup, with the nearest shop
  /// selected for the customer to confirm.
  static const clientLocationAfterSignUp = '$clientLocation?suggest=nearest';

  /// Map picker for a one-off delivery point, when the phone's location
  /// isn't available; [failure] says why.
  static String clientLocationMap(LocationFailure? failure) => Uri(
    path: '$clientLocation/map',
    queryParameters: {'reason': ?failure?.name},
  ).toString();
  static const clientHome = '/client/home';
  static const clientMenu = '/client/menu';
  static String clientCategory(String categoryId) => Uri(
    path: clientMenu,
    queryParameters: {'category': categoryId},
  ).toString();
  static const clientFavorites = '/client/favorites';
  static const clientProfile = '/client/profile';
  static String clientOrder(String orderId) => '/client/orders/$orderId';

  // A brand's product, cart and checkout. Every brand has its own cart.
  static const brandParam = 'brand';

  /// [heroScope] names the row the product was opened from when a screen
  /// shows it in more than one (home's rows), so its photo flies from the card
  /// that was tapped.
  static String brandProduct(ProductKey product, {String? heroScope}) => Uri(
    path: '/b/${product.brand.name}/product/${product.id}',
    queryParameters: {'from': ?heroScope},
  ).toString();
  static String brandCart(Brand brand) => '/b/${brand.name}/cart';
  static String brandCheckout(Brand brand) => '/b/${brand.name}/checkout';

  // Demo sign-in (no real SMS): phone, code, details, then a welcome
  static const signIn = '/client/sign-in';
  static const signInCode = '$signIn/code';
  static const signInDetails = '$signIn/details';
  static const welcome = '/client/welcome';

  // Courier app
  static const courierOrders = '/courier/orders';
  static String courierDelivery(String orderId) => '/courier/orders/$orderId';

  // Store panel (KDS)
  static const kds = '/kds';
}
