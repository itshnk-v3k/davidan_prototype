import 'package:davidan_prototype/data/models/order.dart';

/// All user-facing UI text (Romanian). Kept in one file so another language
/// can be added later without touching widgets. Product, category and banner
/// names are content and live with the mock data in lib/data/mock/.
abstract final class AppStrings {
  static const appTitle = 'DaviDan';
  static const currency = 'lei';

  // Demo launcher
  static const launcherTitle = 'Prototip DaviDan';
  static const launcherSubtitle =
      'Alege partea sistemului pe care vrei s-o vezi.';
  static const launcherClient = 'Aplicația clientului';
  static const launcherClientHint = 'Meniu, coș, comandă și urmărire';
  static const launcherCourier = 'Aplicația curierului';
  static const launcherCourierHint = 'Comenzi de livrat și statusul livrării';
  static const launcherKds = 'Panoul magazinului';
  static const launcherKdsHint = 'Comenzi noi, cronometru și acceptare';
  static const resetDemoData = 'Resetează datele demo';
  static const resetDemoDataDone = 'Datele demo au fost resetate.';
  static const launcherFooter =
      'Prototip pentru prezentare. Datele sunt fictive și se păstrează doar '
      'pe acest dispozitiv.';
  static const openLauncher = 'Înapoi la prototip';

  // Customer app navigation
  static const navHome = 'Acasă';
  static const navMenu = 'Meniu';
  static const navCart = 'Coș';
  static const navProfile = 'Profil';

  // Screen titles
  static const splashTitle = 'Ecran de pornire';
  static const locationTitle = 'Livrare sau ridicare';
  static const menuTitle = 'Meniu';
  static const cartTitle = 'Coșul meu';
  static const checkoutTitle = 'Finalizează comanda';
  static const profileTitle = 'Profil';
  static const courierOrdersTitle = 'Comenzi de livrat';
  static const courierDeliveryTitle = 'Livrare';
  static const kdsTitle = 'Comenzi noi';

  // Placeholder screens
  static const placeholderBody =
      'Acest ecran este în lucru și va fi construit în etapele următoare.';
  static const back = 'Înapoi';
  static const continueLabel = 'Continuă';
  static const backHome = 'Înapoi acasă';
  static const openDelivery = 'Deschide livrarea';

  // Home
  static const deliverTo = 'Livrare la';
  static const chooseAddress = 'Alege adresa sau localul';
  static const categoriesTitle = 'Categorii';
  static const popularTitle = 'Populare';
  static const seeAll = 'Vezi tot';

  // Catalog
  static const categoryEmpty = 'Momentan nu sunt produse în această categorie.';

  // Product detail
  static const descriptionTitle = 'Descriere';
  static const productNotFound = 'Produsul nu a fost găsit.';
  static const increaseQuantity = 'Mărește cantitatea';
  static const decreaseQuantity = 'Micșorează cantitatea';
  static String inCart(int count) => 'În coș: $count';
  static String addToCartTotal(String total) => 'Adaugă în coș · $total';
  static String addedToCart(int quantity, String productName) =>
      'Adăugat în coș: $quantity × $productName';

  // Cart actions
  static String addToCart(String productName) => 'Adaugă $productName în coș';
  static String removeOneFromCart(String productName) =>
      'Scoate o bucată de $productName din coș';
  static String removeFromCart(String productName) =>
      'Scoate $productName din coș';
  static String itemsInCart(int count) => '$count produse în coș';

  // Cart
  static const cartEmptyTitle = 'Coșul tău e gol';
  static const cartEmptyMessage =
      'Adaugă produse din meniu, apoi revino aici ca să finalizezi comanda.';
  static const browseMenu = 'Vezi meniul';
  static const continueOrder = 'Continuă comanda';
  static const total = 'Total';
  static String unitPrice(String price) => '$price / buc.';
  static String lineItem(int quantity, String productName) =>
      '$quantity × $productName';

  // Checkout
  static const fulfilmentTitle = 'Cum primești comanda';
  static const delivery = 'Livrare';
  static const pickup = 'Ridicare din local';
  static const deliveryAddress = 'Adresa de livrare';
  static const deliveryAddressHint = 'Strada, numărul, blocul, apartamentul';
  static const deliveryAddressMissing = 'Scrie adresa unde livrăm comanda.';
  static const deliveryTimeTitle = 'Ora livrării';
  static const pickupTimeTitle = 'Ora ridicării';
  static const asSoonAsPossible = 'Cât mai curând';
  static const paymentTitle = 'Plata';
  static const paymentOnDelivery = 'Plătești curierului, la primirea comenzii.';
  static const paymentOnPickup = 'Plătești în local, la ridicarea comenzii.';
  static const orderSummaryTitle = 'Comanda ta';
  static const placeOrder = 'Plasează comanda';
  static String paymentMethod(PaymentMethod method) => switch (method) {
    PaymentMethod.cash => 'Numerar',
    PaymentMethod.card => 'Card prin terminal POS',
  };

  // Order confirmation
  static const orderPlacedTitle = 'Comanda a fost plasată';
  static const orderNotFound = 'Comanda nu a fost găsită.';
  static const pickupFrom = 'Ridicare din';
  static const orderTime = 'Ora';
  static const trackingComingSoon =
      'Urmărirea comenzii pas cu pas va apărea aici în etapele următoare.';
  static String orderNumber(String id) => 'Comanda nr. $id';
  static String orderStatus(OrderStatus status) => switch (status) {
    OrderStatus.placed => 'Plasată',
    OrderStatus.accepted => 'Acceptată',
    OrderStatus.preparing => 'Se pregătește',
    OrderStatus.ready => 'Gata',
    OrderStatus.onTheWay => 'În drum spre tine',
    OrderStatus.completed => 'Finalizată',
  };
}
