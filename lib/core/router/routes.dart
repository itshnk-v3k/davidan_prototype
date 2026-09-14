/// Route paths. Widgets navigate with these instead of string literals.
abstract final class Routes {
  static const launcher = '/';

  // Customer app
  static const clientSplash = '/client/splash';
  static const clientLocation = '/client/location';
  static const clientHome = '/client/home';
  static const clientMenu = '/client/menu';
  static String clientCategory(String categoryId) => Uri(
    path: clientMenu,
    queryParameters: {'category': categoryId},
  ).toString();
  static const clientCart = '/client/cart';
  static const clientProfile = '/client/profile';
  static String clientProduct(String productId) => '/client/product/$productId';
  static const clientCheckout = '/client/checkout';
  static String clientOrder(String orderId) => '/client/orders/$orderId';

  // Courier app
  static const courierOrders = '/courier/orders';
  static String courierDelivery(String orderId) => '/courier/orders/$orderId';

  // Store panel (KDS)
  static const kds = '/kds';
}
