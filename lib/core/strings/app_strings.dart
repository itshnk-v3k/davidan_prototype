import 'package:davidan_prototype/core/location/location_result.dart';
import 'package:davidan_prototype/data/models/chisinau_sector.dart';
import 'package:davidan_prototype/data/models/order.dart';

/// All user-facing UI text (Romanian). Kept in one file so another language
/// can be added later without touching widgets. Product, category and banner
/// names are content and live with the mock data in lib/data/mock/.
abstract final class AppStrings {
  static const appTitle = 'DaviDan Delivery';
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

  // Theme, in the profile and on the demo launcher
  static const themeTitle = 'Tema aplicației';
  static const themeDark = 'Întunecată';
  static const themeLight = 'Luminoasă';
  static const themeSystem = 'Ca telefonul';

  // Customer app navigation
  static const navHome = 'Acasă';
  static const navMenu = 'Meniu';
  static const navFavorites = 'Favorite';
  static const navProfile = 'Profil';

  // Screen titles
  static const locationTitle = 'Livrare sau ridicare';
  static const menuTitle = 'Meniu';
  static const cartTitle = 'Coșul meu';
  static const checkoutTitle = 'Finalizează comanda';
  static const profileTitle = 'Profil';
  static const courierOrdersTitle = 'Comenzi de livrat';
  static const kdsTitle = launcherKds;

  // Navigation
  static const back = 'Înapoi';
  static const backHome = 'Înapoi acasă';

  // Location
  static const locationPrompt =
      'Alege cum primești comenzile. Poți schimba oricând din bara de sus '
      'a ecranului Acasă.';
  static const confirmAddress = 'Livrează la această adresă';
  static const recentAddressesTitle = 'Adrese folosite recent';
  static const nearestToYou = 'Cel mai aproape de tine';
  static const nearestSuggestion =
      'Ți-am selectat localul cel mai apropiat. Confirmă-l sau alege altul.';
  static const confirmShop = 'Confirmă localul';

  // Current location, for one order
  static const useCurrentLocation = 'Folosește locația mea curentă';
  static const useCurrentLocationHint =
      'Doar pentru comanda următoare. Adresa salvată rămâne.';
  static const locating = 'Se caută locația…';
  static const deliverToCurrentLocation = 'Livrare la locația curentă';
  static String currentLocationValue(String area) =>
      '$area · doar comanda următoare';
  static const dropCurrentLocation = 'Renunță la locația curentă';
  static const typeAddressInstead = 'Scrie o adresă';
  static String areaName(ChisinauSector? sector) =>
      sector == null ? 'În afara Chișinăului' : 'Zona ${sectorName(sector)}';
  static String pinnedAddress(String area, String coordinates) =>
      'Locația clientului · $area ($coordinates)';
  static String locationFailure(LocationFailure failure) => switch (failure) {
    LocationFailure.denied => 'Nu ai permis accesul la locație.',
    LocationFailure.deniedForever =>
      'Accesul la locație e blocat din setările telefonului.',
    LocationFailure.serviceOff => 'Localizarea telefonului e oprită.',
    LocationFailure.timeout => 'Nu am primit semnal de localizare la timp.',
    LocationFailure.unavailable =>
      'Locația nu e disponibilă pe acest dispozitiv.',
  };
  static const mapPickerTitle = 'Alege locația pe hartă';
  static const mapPickerHint = 'Atinge harta sau alege zona unde livrăm.';
  static const schematicMap = 'Hartă schematică a Chișinăului';
  static const chosenPoint = 'Punctul ales';
  static String distanceToShop(String distance, String shopName) =>
      '$distance până la $shopName';
  static const deliverHere = 'Livrează aici';

  // Demo sign-in (no real SMS)
  static const signInTitle = 'Intră în cont';
  static const signInPrompt =
      'Scrie numărul de telefon. Îți trimitem un cod ca să-l confirmi.';
  static const phoneLabel = 'Număr de telefon';
  static const phoneHint = '69 123 456';
  static const phoneInvalid =
      'Scrie un număr de mobil din 8 cifre, care începe cu 6 sau 7.';
  static const sendCode = 'Primește codul';
  static const signInLater = 'Mai târziu';
  static const demoSignInNote =
      'Cont demonstrativ: nu se trimite niciun SMS și nimic nu e verificat. '
      'Datele rămân doar pe acest dispozitiv.';
  static const codeTitle = 'Codul din SMS';
  static String codeSentTo(String phone) =>
      'Scrie codul de 4 cifre trimis la $phone.';
  static const codeLabel = 'Cod de 4 cifre';
  static const codeIncomplete = 'Scrie toate cele 4 cifre.';
  static const confirmCode = 'Confirmă codul';
  static const resendCode = 'Retrimite codul';
  static const codeResent = 'Cod retrimis (demo, fără SMS real).';
  static const demoCodeNote = 'Demo: orice cod din 4 cifre este acceptat.';
  static const detailsTitle = 'Câteva detalii';
  static const nameLabel = 'Numele tău';
  static const nameMissing = 'Scrie-ți numele.';
  static const sectorTitle = 'Sectorul în care locuiești';
  static const sectorMissing = 'Alege sectorul.';
  static const useMyLocationForShop = 'Găsește localul după locația mea';
  static String locationFoundNearest(String distance, String shopName) =>
      'Locația găsită: $shopName e la $distance.';
  static String locationFailedUseSector(LocationFailure failure) =>
      '${locationFailure(failure)} Găsim localul după sectorul ales.';
  static const createAccount = 'Creează contul';
  static String welcomeTitle(String name) => 'Bun venit, $name!';
  static const welcomeMessage =
      'Contul tău e gata. Iată localul DaviDan cel mai apropiat de tine.';
  static const nearestShopTitle = 'Cel mai apropiat local';
  static String matchedBySector(ChisinauSector sector) =>
      'După sectorul ${sectorName(sector)}';
  static String matchedByLocation(String distance) =>
      'După locația ta · $distance';
  static const chooseHowToReceive = 'Alege cum primești comenzile';
  static String sectorName(ChisinauSector sector) => switch (sector) {
    ChisinauSector.botanica => 'Botanica',
    ChisinauSector.buiucani => 'Buiucani',
    ChisinauSector.centru => 'Centru',
    ChisinauSector.ciocana => 'Ciocana',
    ChisinauSector.riscani => 'Rîșcani',
  };
  static String sectorLabel(ChisinauSector sector) =>
      'Sectorul ${sectorName(sector)}';

  // Profile
  static const accountLockedTitle = 'Contul tău';
  static const accountLockedMessage =
      'Intră în cont ca să-ți vezi comenzile și localul cel mai apropiat.';
  static const signOut = 'Ieși din cont';
  static const myOrdersTitle = 'Comenzile mele';
  static const ordersEmptyTitle = 'Nicio comandă încă';
  static const ordersEmptyMessage =
      'Comenzile tale apar aici, cu statusul lor la zi.';
  static const demoProfileNote =
      'Cont demonstrativ, fără verificare reală prin SMS.';

  // Home
  static const deliverTo = 'Livrare la';
  static const chooseAddress = 'Alege adresa sau localul';
  static const categoriesTitle = 'Categorii';
  // davidan.md's headings: "Produse DaviDan" over its featured products and
  // "Vezi mai mult" on its category list.
  static const popularTitle = 'Produse DaviDan';
  static const seeAll = 'Vezi mai mult';
  static String seeAllProducts(int count) => 'Vezi toate cele $count produse';

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

  /// The cart button's label, with the count when the cart has anything.
  static String openCart(int count) =>
      count == 0 ? cartTitle : '$cartTitle, ${itemsInCart(count)}';

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

  /// davidan.md's "Livrare și achitare" page calls it achitare, with cash or
  /// the courier's POS terminal.
  static const paymentTitle = 'Achitare';
  static const paymentOnDelivery = 'Plătești curierului, la primirea comenzii.';
  static const paymentOnPickup = 'Plătești în local, la ridicarea comenzii.';
  static const orderSummaryTitle = 'Comanda ta';
  static const placeOrder = 'Plasează comanda';
  static String paymentMethod(PaymentMethod method) => switch (method) {
    PaymentMethod.cash => 'Numerar',
    PaymentMethod.card => 'Card prin POS',
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
    OrderStatus.onTheWay => 'În livrare',
    OrderStatus.completed => 'Finalizată',
  };

  // Order actions on the store panel and in the courier app, named after the
  // status they move the order to
  static String advanceTo(OrderStatus next) => switch (next) {
    OrderStatus.placed => placeOrder,
    OrderStatus.accepted => 'Acceptă',
    OrderStatus.preparing => 'Începe prepararea',
    OrderStatus.ready => 'Marchează gata',
    OrderStatus.onTheWay => 'Am preluat comanda',
    OrderStatus.completed => 'Predată clientului',
  };
  static String scheduledAt(String time) => 'La $time';

  // Store panel
  static const kdsIncoming = 'Noi';
  static const kdsInKitchen = 'În lucru';
  static const kdsReady = 'Gata';
  static const kdsColumnEmpty = 'Nicio comandă';
  static const kdsEmptyTitle = 'Nicio comandă deocamdată';
  static const kdsEmptyMessage =
      'Comenzile plasate din aplicația clientului apar aici.';
  static const waitingForCourier = 'Așteaptă curierul';
  static const kdsNewTag = 'NOUĂ';
  static String newOrderArrived(String orderId) => 'Comandă nouă: $orderId';
  static String pickupAt(String shopName) => 'Ridicare · $shopName';
  static String timeSincePlaced(String elapsed) =>
      'Timp de la plasare: $elapsed';

  // Favorites
  static const favoritesTitle = 'Produse favorite';
  static const favoritesEmptyTitle = 'Niciun produs favorit';
  static const favoritesEmptyMessage =
      'Apasă inima de pe un produs ca să-l găsești repede aici.';
  static String addToFavorites(String productName) =>
      'Adaugă $productName la favorite';
  static String removeFromFavorites(String productName) =>
      'Scoate $productName din favorite';

  // Delivery map
  static String courierArrivesIn(int minutes) =>
      'Curierul ajunge în aproximativ $minutes min';
  static const courierArrived = 'Curierul a ajuns la adresă';

  // Courier app
  static const courierOnline = 'Online';
  static const courierOffline = 'Offline';
  static const courierOnlineHint = 'Primești comenzi noi';
  static const courierOfflineHint = 'Nu primești comenzi noi';
  static const courierOnTheWaySection = 'Pe drum spre client';
  static const courierReadySection = 'De preluat din local';
  static const courierOfflineTitle = 'Ești offline';
  static const courierOfflineMessage =
      'Intră online ca să vezi comenzile de preluat din local.';
  static const courierEmptyTitle = 'Nicio livrare deocamdată';
  static const courierEmptyMessage =
      'Comenzile cu livrare apar aici când localul le marchează gata.';
  static const toCollect = 'De încasat';
  static const itemsTitle = 'Produse';
  static const courierWaitingForStore = 'Localul încă pregătește comanda.';
  static const deliveryCompleted = 'Livrare finalizată.';
  static const backToDeliveries = 'Înapoi la comenzi';
  static const deliveryNotFound = 'Livrarea nu a fost găsită.';
  static String deliveryTitle(String orderId) => 'Livrare $orderId';
  static String amountToCollect(String total, String paymentMethod) =>
      '$total · $paymentMethod';
}
