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
  static const orderTrackingTitle = 'Urmărește comanda';
  static const profileTitle = 'Profil';
  static const courierOrdersTitle = 'Comenzi de livrat';
  static const courierDeliveryTitle = 'Livrare';
  static const kdsTitle = 'Comenzi noi';

  // Placeholder screens
  static const placeholderBody =
      'Acest ecran este în lucru și va fi construit în etapele următoare.';
  static const back = 'Înapoi';
  static const continueLabel = 'Continuă';
  static const goToCheckout = 'Spre finalizare';
  static const placeOrder = 'Plasează comanda';
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
  static String itemsInCart(int count) => '$count produse în coș';
}
