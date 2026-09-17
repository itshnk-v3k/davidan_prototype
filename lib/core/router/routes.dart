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

  // The tabs
  /// Acasă. It has no screen of its own: it opens on the brand last shopped
  /// in (LastBrandNotifier), and every screen above the tabs comes back here.
  static const clientHome = '/client/home';
  static const clientOrders = '/client/orders';

  /// The Comenzi tab showing only [brand]'s orders.
  static String clientOrdersOf(Brand brand) => Uri(
    path: clientOrders,
    queryParameters: {'brand': brand.name},
  ).toString();

  /// The latest news of the customer's orders and requests, from the bell:
  /// a browse screen inside Acasă.
  static const clientNotifications = '$clientHome/notifications';

  static const clientFavorites = '/client/favorites';
  static const clientProfile = '/client/profile';
  static String clientOrder(String orderId) => '$clientOrders/$orderId';

  /// A car rental request, full screen above the tabs.
  static String clientBooking(String bookingId) =>
      '/client/bookings/$bookingId';

  /// Every brand's cart that has something in it, full screen above the tabs.
  static const openCarts = '/client/carts';

  // A brand. Its feed and its category pages open inside Acasă's shell, under
  // the bar and the brand switcher that stay in place while they change
  // (BrandShell), and under the bottom bar. Its search and its information
  // page cover that shell, having a top of their own. Its task screens, the
  // ones with their own bottom button (product, cart, checkout, car,
  // request), open full screen above the tabs. Every brand has its own cart.
  //
  // A task screen reaches a browse screen with go(), never push(): pushed
  // from above the tabs, a route inside them builds the tabs a second time
  // (test/core/router/go_router_tabs_test.dart).
  static const brandParam = 'brand';
  static String brandHome(Brand brand) => '$clientHome/b/${brand.name}';

  /// Search in the brand's menu, narrowed to [categoryId] when given.
  static String brandSearch(Brand brand, {String? categoryId}) => Uri(
    path: '${brandHome(brand)}/search',
    queryParameters: {'category': ?categoryId},
  ).toString();

  /// Every category of the brand, from its home's "Mai multe" tile.
  static String brandCategories(Brand brand) =>
      '${brandHome(brand)}/categories';

  /// The brand's menu at [categoryId], or at its first category.
  static String brandMenu(Brand brand, {String? categoryId}) => Uri(
    path: '${brandHome(brand)}/menu',
    queryParameters: {'category': ?categoryId},
  ).toString();

  /// [heroScope] names the row the product was opened from when a screen
  /// shows it in more than one (home's rows), so its photo flies from the card
  /// that was tapped.
  static String brandProduct(ProductKey product, {String? heroScope}) => Uri(
    path: '/b/${product.brand.name}/product/${product.id}',
    queryParameters: {'from': ?heroScope},
  ).toString();
  static String brandCart(Brand brand) => '/b/${brand.name}/cart';
  static String brandCheckout(Brand brand) => '/b/${brand.name}/checkout';

  /// A car of the rental fleet, and its request form.
  static String rentalCar(String carId) =>
      '/b/${Brand.carRental.name}/car/$carId';
  static String rentalRequest(String carId) => '${rentalCar(carId)}/request';

  /// The brand's contacts and legal pages, for a brand that has them, inside
  /// the [tab] they're opened from: Acasă (the brand's home) or Profil.
  static String brandInfo(Brand brand, {String tab = clientHome}) =>
      '$tab/b/${brand.name}/info';

  /// One of the brand's legal pages, by its slug on the brand's site.
  static String brandLegal(
    Brand brand,
    String documentId, {
    String tab = clientHome,
  }) => '${brandInfo(brand, tab: tab)}/$documentId';

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
