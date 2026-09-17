// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'DaviDan';

  @override
  String priceLei(String amount) {
    return '$amount лей';
  }

  @override
  String get launcherTitle => 'Прототип DaviDan';

  @override
  String get launcherSubtitle =>
      'Выбери часть системы, которую хочешь посмотреть.';

  @override
  String get launcherClient => 'Приложение клиента';

  @override
  String get launcherClientHint => 'Меню, корзина, заказ и отслеживание';

  @override
  String get launcherCourier => 'Приложение курьера';

  @override
  String get launcherCourierHint => 'Заказы на доставку и статус доставки';

  @override
  String get launcherKds => 'Панель магазина';

  @override
  String get launcherKdsHint => 'Новые заказы, таймер и приём';

  @override
  String get resetDemoData => 'Сбросить демо-данные';

  @override
  String get resetDemoDataDone => 'Демо-данные сброшены.';

  @override
  String get launcherFooter =>
      'Прототип для презентации. Данные вымышленные и хранятся только на этом устройстве.';

  @override
  String get openLauncher => 'Назад к прототипу';

  @override
  String get themeTitle => 'Тема приложения';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeSystem => 'Как в телефоне';

  @override
  String get languageTitle => 'Язык приложения';

  @override
  String get languageSystem => 'Как в телефоне';

  @override
  String get navHome => 'Главная';

  @override
  String get navOrders => 'Заказы';

  @override
  String get navFavorites => 'Избранное';

  @override
  String get navProfile => 'Профиль';

  @override
  String get locationTitle => 'Доставка или самовывоз';

  @override
  String get menuTitle => 'Меню';

  @override
  String brandCartTitle(String brand) {
    return 'Корзина · $brand';
  }

  @override
  String get checkoutTitle => 'Оформление заказа';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get courierOrdersTitle => 'Заказы на доставку';

  @override
  String get kdsTitle => 'Панель магазина';

  @override
  String get back => 'Назад';

  @override
  String get backHome => 'На главную';

  @override
  String get comingSoonTitle => 'Скоро';

  @override
  String brandComingSoonLabel(String name) {
    return '$name, скоро';
  }

  @override
  String forYouTitle(String name) {
    return '$name, для тебя';
  }

  @override
  String get forYouTitleSignedOut => 'Для тебя';

  @override
  String addedToBrandCart(String brand) {
    return 'Добавлено в корзину · $brand';
  }

  @override
  String get locationPrompt =>
      'Выбери, как получать заказы. Это можно изменить в любой момент в верхней строке экрана «Главная».';

  @override
  String get confirmAddress => 'Доставить по этому адресу';

  @override
  String get recentAddressesTitle => 'Недавние адреса';

  @override
  String get nearestToYou => 'Ближе всего к тебе';

  @override
  String get nearestSuggestion =>
      'Мы выбрали ближайшее к тебе заведение. Подтверди его или выбери другое.';

  @override
  String get confirmShop => 'Подтвердить заведение';

  @override
  String get useCurrentLocation => 'Использовать моё местоположение';

  @override
  String get useCurrentLocationHint =>
      'Только для следующего заказа. Сохранённый адрес останется.';

  @override
  String get locating => 'Ищем местоположение…';

  @override
  String get deliverToCurrentLocation => 'Доставка по текущему местоположению';

  @override
  String currentLocationValue(String area) {
    return '$area · только следующий заказ';
  }

  @override
  String get dropCurrentLocation => 'Отказаться от текущего местоположения';

  @override
  String get typeAddressInstead => 'Ввести адрес';

  @override
  String get outsideChisinau => 'За пределами Кишинёва';

  @override
  String areaOf(String sector) {
    return 'Район $sector';
  }

  @override
  String pinnedAddress(String area, String coordinates) {
    return 'Местоположение клиента · $area ($coordinates)';
  }

  @override
  String pinnedAddressCustomer(String area) {
    return 'Твоё местоположение · $area';
  }

  @override
  String get locationFailureDenied => 'Доступ к местоположению не разрешён.';

  @override
  String get locationFailureDeniedForever =>
      'Доступ к местоположению заблокирован в настройках телефона.';

  @override
  String get locationFailureServiceOff => 'Геолокация на телефоне выключена.';

  @override
  String get locationFailureTimeout =>
      'Не удалось вовремя получить сигнал геолокации.';

  @override
  String get locationFailureUnavailable =>
      'Местоположение недоступно на этом устройстве.';

  @override
  String get mapPickerTitle => 'Выбери место на карте';

  @override
  String get mapPickerHint => 'Нажми на карту или выбери район доставки.';

  @override
  String get schematicMap => 'Схематическая карта Кишинёва';

  @override
  String get chosenPoint => 'Выбранная точка';

  @override
  String distanceToShop(String distance, String shopName) {
    return '$distance до $shopName';
  }

  @override
  String get deliverHere => 'Доставить сюда';

  @override
  String get signInTitle => 'Войти';

  @override
  String get signInPrompt =>
      'Введи номер телефона. Мы отправим код, чтобы его подтвердить.';

  @override
  String get phoneLabel => 'Номер телефона';

  @override
  String get phoneHint => '69 123 456';

  @override
  String get phoneInvalid =>
      'Введи мобильный номер из 8 цифр, который начинается с 6 или 7.';

  @override
  String get sendCode => 'Получить код';

  @override
  String get signInLater => 'Позже';

  @override
  String get demoSignInNote =>
      'Демо-аккаунт: SMS не отправляется и ничего не проверяется. Данные остаются только на этом устройстве.';

  @override
  String get codeTitle => 'Код из SMS';

  @override
  String codeSentTo(String phone) {
    return 'Введи 4-значный код, отправленный на $phone.';
  }

  @override
  String get codeLabel => 'Код из 4 цифр';

  @override
  String get codeIncomplete => 'Введи все 4 цифры.';

  @override
  String get confirmCode => 'Подтвердить код';

  @override
  String get resendCode => 'Отправить код ещё раз';

  @override
  String resendCodeIn(int seconds) {
    return 'Отправить код ещё раз через $seconds с';
  }

  @override
  String get codeResent => 'Код отправлен ещё раз (демо, без настоящего SMS).';

  @override
  String get demoCodeNote => 'Демо: подходит любой код из 4 цифр.';

  @override
  String get detailsTitle => 'Немного о тебе';

  @override
  String get nameLabel => 'Твоё имя';

  @override
  String get nameMissing => 'Введи своё имя.';

  @override
  String get sectorTitle => 'Сектор, в котором ты живёшь';

  @override
  String get sectorMissing => 'Выбери сектор.';

  @override
  String get useMyLocationForShop => 'Найти заведение по моему местоположению';

  @override
  String locationFoundNearest(String distance, String shopName) {
    return 'Местоположение найдено: $shopName в $distance.';
  }

  @override
  String findShopBySectorAfter(String reason) {
    return '$reason Найдём заведение по выбранному сектору.';
  }

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String welcomeTitle(String name) {
    return 'Добро пожаловать, $name!';
  }

  @override
  String get welcomeMessage =>
      'Твой аккаунт готов. Вот ближайшее к тебе заведение DaviDan.';

  @override
  String get nearestShopTitle => 'Ближайшее заведение';

  @override
  String matchedBySectorOf(String sector) {
    return 'По сектору $sector';
  }

  @override
  String matchedByLocation(String distance) {
    return 'По твоему местоположению · $distance';
  }

  @override
  String get chooseHowToReceive => 'Выбери, как получать заказы';

  @override
  String get sectorBotanica => 'Ботаника';

  @override
  String get sectorBuiucani => 'Буюканы';

  @override
  String get sectorCentru => 'Центр';

  @override
  String get sectorCiocana => 'Чеканы';

  @override
  String get sectorRiscani => 'Рышкановка';

  @override
  String sectorOf(String sector) {
    return 'Сектор $sector';
  }

  @override
  String get accountLockedTitle => 'Твой аккаунт';

  @override
  String get accountLockedMessage =>
      'Войди, чтобы видеть свои заказы и ближайшее заведение.';

  @override
  String get signOut => 'Выйти из аккаунта';

  @override
  String get signOutConfirmTitle => 'Выйти из аккаунта?';

  @override
  String get signOutConfirmMessage =>
      'Корзины, заказы и избранное останутся на этом устройстве.';

  @override
  String get profileBrandsTitle => 'Контакты и информация';

  @override
  String get profileBrandInfoHint => 'Контакты и документы';

  @override
  String get profileDemoTitle => 'Демо';

  @override
  String get ordersEmptyTitle => 'Заказов пока нет';

  @override
  String get ordersEmptyMessage =>
      'Здесь появятся твои заказы с актуальным статусом.';

  @override
  String get ordersActiveTitle => 'Текущие';

  @override
  String get ordersPastTitle => 'Завершённые';

  @override
  String rentalCarClass(String carClass) {
    String _temp0 = intl.Intl.selectLogic(carClass, {
      'economy': 'Эконом',
      'family': 'Семейные',
      'suv': 'Внедорожники',
      'premium': 'Премиум',
      'other': 'Другие',
    });
    return '$_temp0';
  }

  @override
  String get allBrands => 'Все';

  @override
  String openBrandInfo(String brandName) {
    return 'Информация о $brandName';
  }

  @override
  String get brandContactsTitle => 'Контакты';

  @override
  String get brandInfoDeliveryArea => 'Зона доставки';

  @override
  String get brandInfoAddress => 'Адрес';

  @override
  String get brandInfoHours => 'Режим работы';

  @override
  String get brandInfoPhone => 'Телефон';

  @override
  String get brandInfoEmail => 'E-mail';

  @override
  String get brandInfoInstagram => 'Instagram';

  @override
  String get brandInfoCompany => 'Компания';

  @override
  String get legalDocumentsTitle => 'Юридическая информация';

  @override
  String legalDocumentHint(String website) {
    return 'Текст с сайта $website, на румынском';
  }

  @override
  String priceEuro(String amount) {
    return '$amount €';
  }

  @override
  String rentalFleetHint(String fee) {
    return 'Чем больше дней аренды, тем ниже цена за день. К каждой брони добавляются сбор за локацию $fee и страховая сумма автомобиля.';
  }

  @override
  String rentalPriceFrom(String price) {
    return 'от $price / день';
  }

  @override
  String rentalPricePerDay(String price) {
    return '$price / день';
  }

  @override
  String rentalPriceForTier(String price, String tier) {
    return '$price / день при аренде на $tier';
  }

  @override
  String rentalTierRange(int from, int to) {
    String _temp0 = intl.Intl.pluralLogic(
      to,
      locale: localeName,
      other: '$to дня',
      many: '$to дней',
      few: '$to дня',
      one: '$to день',
    );
    return '$from–$_temp0';
  }

  @override
  String rentalTierFrom(int from) {
    String _temp0 = intl.Intl.pluralLogic(
      from,
      locale: localeName,
      other: '$from дня',
      many: '$from дней',
      few: '$from дня',
      one: '$from день',
    );
    return '$_temp0 и больше';
  }

  @override
  String rentalSeats(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count места',
      many: '$count мест',
      few: '$count места',
      one: '$count место',
    );
    return '$_temp0';
  }

  @override
  String get rentalSpecYear => 'Год выпуска';

  @override
  String get rentalSpecFuel => 'Топливо';

  @override
  String get rentalSpecGearbox => 'Коробка передач';

  @override
  String get rentalSpecConsumption => 'Расход топлива';

  @override
  String get rentalSpecPassengers => 'Макс. пассажиров';

  @override
  String get rentalSpecEngine => 'Объём двигателя';

  @override
  String get rentalSpecDoors => 'Двери';

  @override
  String get rentalSpecMileage => 'Пробег';

  @override
  String get rentalFeaturesTitle => 'Оснащение';

  @override
  String get rentalPricesTitle => 'Цены по дням';

  @override
  String get rentalLocationFee => 'Сбор за локацию';

  @override
  String get rentalInsurance => 'Страховая сумма';

  @override
  String get rentalPriceTotal => 'Итого за аренду';

  @override
  String rentalInsuranceExtra(String amount) {
    return '+ $amount страховая сумма';
  }

  @override
  String get rentalTotalWithInsurance => 'Итого со страховой суммой';

  @override
  String get rentalFeesNote =>
      'Сбор за локацию и страховая сумма добавляются к каждой брони один раз, на сколько бы дней она ни была.';

  @override
  String get rentalDocumentsTitle => 'Необходимые документы';

  @override
  String get rentalRequestAction => 'Выбрать даты';

  @override
  String get rentalRequestTitle => 'Заявка на бронирование';

  @override
  String get rentalPickupTitle => 'Получение';

  @override
  String get rentalReturnTitle => 'Возврат';

  @override
  String get rentalLocationAirport => 'Аэропорт Кишинёв';

  @override
  String get rentalLocationChisinau => 'Кишинёв';

  @override
  String get rentalDateLabel => 'Дата';

  @override
  String get rentalTimeLabel => 'Время';

  @override
  String get rentalPickupPassed =>
      'Время получения уже прошло. Выбери более позднее.';

  @override
  String get rentalReturnNotAfterPickup =>
      'Возврат должен быть после получения.';

  @override
  String get rentalExtrasTitle => 'Дополнительные услуги';

  @override
  String get rentalExtraChildSeat => 'Детское кресло';

  @override
  String get rentalExtraUnlimitedKm => 'Безлимитный пробег';

  @override
  String rentalPriceWholeRental(String price) {
    return '$price / бронь';
  }

  @override
  String get rentalContactTitle => 'Твои данные';

  @override
  String get rentalNotesLabel => 'Дополнительная информация';

  @override
  String get rentalQuoteTitle => 'Стоимость брони';

  @override
  String rentalDaysAtRate(int days, String rate) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days дней',
      few: '$days дня',
      one: '$days день',
    );
    return '$_temp0 × $rate';
  }

  @override
  String rentalRateForTier(String tier) {
    return 'Цена за день при аренде на $tier';
  }

  @override
  String get rentalNoPaymentNote =>
      'Сейчас ничего платить не нужно. Мы свяжемся с тобой, чтобы подтвердить бронь.';

  @override
  String get rentalSendRequest => 'Отправить заявку';

  @override
  String get rentalRequestSentTitle => 'Заявка отправлена';

  @override
  String get rentalRequestCancelledTitle => 'Заявка отменена';

  @override
  String get rentalWillContact => 'Мы свяжемся с вами в ближайшее время.';

  @override
  String get rentalRequestNotReserved =>
      'Машина не забронирована, пока мы с тобой не свяжемся. Ничего не оплачено.';

  @override
  String get rentalCancelRequest => 'Отменить заявку';

  @override
  String get rentalCancelRequestTitle => 'Отменить заявку?';

  @override
  String get rentalCancelRequestMessage =>
      'Новую заявку можно отправить в любой момент.';

  @override
  String rentalBookingNumber(String id) {
    return 'Заявка № $id';
  }

  @override
  String activeBookingSummary(String car, String pickup) {
    return '$car · $pickup';
  }

  @override
  String get rentalBookingStatus => 'В ожидании';

  @override
  String get rentalBookingCancelled => 'Отменена';

  @override
  String get rentalBookingNotFound => 'Заявка не найдена.';

  @override
  String get rentalCar => 'Автомобиль';

  @override
  String get rentalContact => 'Контакт';

  @override
  String legalDocumentRomanianOnly(String website) {
    return 'Этот текст есть только на румынском языке, как и на сайте $website.';
  }

  @override
  String get demoProfileNote => 'Демо-аккаунт, без настоящей проверки по SMS.';

  @override
  String get deliverTo => 'Доставка по адресу';

  @override
  String get chooseAddress => 'Выбери адрес или заведение';

  @override
  String get categoriesTitle => 'Категории';

  @override
  String get popularTitle => 'Популярная продукция';

  @override
  String get seeAll => 'Смотреть все';

  @override
  String seeAllProducts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Смотреть все $count товара',
      many: 'Смотреть все $count товаров',
      few: 'Смотреть все $count товара',
      one: 'Смотреть $count товар',
    );
    return '$_temp0';
  }

  @override
  String get categoryEmpty => 'В этой категории пока нет товаров.';

  @override
  String get descriptionTitle => 'Описание';

  @override
  String productPieces(String pieces) {
    return 'Количество: $pieces';
  }

  @override
  String productWeight(String weight) {
    return 'Вес: $weight';
  }

  @override
  String productVolume(String volume) {
    return 'Объём: $volume';
  }

  @override
  String get productNotFound => 'Товар не найден.';

  @override
  String get increaseQuantity => 'Увеличить количество';

  @override
  String get decreaseQuantity => 'Уменьшить количество';

  @override
  String inCart(int count) {
    return 'В корзине: $count';
  }

  @override
  String addToCartTotal(String total) {
    return 'В корзину · $total';
  }

  @override
  String updateCartTotal(String total) {
    return 'Обновить корзину · $total';
  }

  @override
  String cartBarTotal(String total) {
    return 'Корзина · $total';
  }

  @override
  String get removeFromCartAction => 'Убрать из корзины';

  @override
  String addedToCart(int quantity, String productName) {
    return 'Добавлено в корзину: $quantity × $productName';
  }

  @override
  String cartUpdated(int quantity, String productName) {
    return 'Корзина обновлена: $quantity × $productName';
  }

  @override
  String removedFromCart(String productName) {
    return 'Убрано из корзины: $productName';
  }

  @override
  String addToCart(String productName) {
    return 'Добавить $productName в корзину';
  }

  @override
  String removeOneFromCart(String productName) {
    return 'Убрать одну штуку $productName из корзины';
  }

  @override
  String removeFromCart(String productName) {
    return 'Удалить $productName из корзины';
  }

  @override
  String itemsInCart(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count товара в корзине',
      many: '$count товаров в корзине',
      few: '$count товара в корзине',
      one: '$count товар в корзине',
    );
    return '$_temp0';
  }

  @override
  String openCart(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Моя корзина, $count товара',
      many: 'Моя корзина, $count товаров',
      few: 'Моя корзина, $count товара',
      one: 'Моя корзина, $count товар',
      zero: 'Моя корзина',
    );
    return '$_temp0';
  }

  @override
  String get openCartsTitle => 'Мои корзины';

  @override
  String openCarts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Мои корзины, $count товара',
      many: 'Мои корзины, $count товаров',
      few: 'Мои корзины, $count товара',
      one: 'Мои корзины, $count товар',
      zero: 'Мои корзины',
    );
    return '$_temp0';
  }

  @override
  String get openCartsEmptyTitle => 'В корзинах пока пусто';

  @override
  String get openCartsEmptyMessage =>
      'У каждого меню своя корзина. Здесь появятся корзины, в которых что-то есть.';

  @override
  String get lastOrderTitle => 'Последний заказ';

  @override
  String get orderAgain => 'Заказать снова';

  @override
  String get orderAgainHint =>
      'После первого заказа его можно будет повторить здесь одним нажатием.';

  @override
  String get cartEmptyTitle => 'Твоя корзина пуста';

  @override
  String get cartEmptyMessage =>
      'Добавь товары из меню и вернись сюда, чтобы оформить заказ.';

  @override
  String get cartEmptyMessageNoMenu =>
      'Добавь товары и вернись сюда, чтобы оформить заказ.';

  @override
  String get browseMenu => 'Смотреть меню';

  @override
  String get browseProducts => 'Смотреть товары';

  @override
  String get continueOrder => 'Продолжить';

  @override
  String get total => 'Итого';

  @override
  String unitPrice(String price) {
    return '$price / шт.';
  }

  @override
  String lineItem(int quantity, String productName) {
    return '$quantity × $productName';
  }

  @override
  String get fulfilmentTitle => 'Как получить заказ';

  @override
  String get delivery => 'Доставка';

  @override
  String get pickup => 'Самовывоз';

  @override
  String get deliveryAddress => 'Адрес доставки';

  @override
  String get deliveryAddressHint => 'Улица, дом, корпус, квартира';

  @override
  String get deliveryAddressMissing => 'Введи адрес доставки.';

  @override
  String get deliveryTimeTitle => 'Время доставки';

  @override
  String get pickupTimeTitle => 'Время самовывоза';

  @override
  String get asSoonAsPossible => 'Как можно скорее';

  @override
  String get paymentTitle => 'Оплата';

  @override
  String get paymentOnDelivery => 'Оплата курьеру при получении заказа.';

  @override
  String get paymentOnPickup => 'Оплата в заведении при получении заказа.';

  @override
  String get orderSummaryTitle => 'Твой заказ';

  @override
  String get placeOrder => 'Оформить заказ';

  @override
  String get paymentCash => 'Наличными';

  @override
  String get paymentCard => 'Картой при получении (POS-терминал)';

  @override
  String get orderPlacedTitle => 'Заказ оформлен';

  @override
  String get orderNotFound => 'Заказ не найден.';

  @override
  String get pickupFrom => 'Самовывоз из';

  @override
  String get orderTime => 'Время';

  @override
  String get trackingComingSoon =>
      'Пошаговое отслеживание заказа появится здесь на следующих этапах.';

  @override
  String orderNumber(String id) {
    return 'Заказ № $id';
  }

  @override
  String activeOrderSummary(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count товара',
      many: '$count товаров',
      few: '$count товара',
      one: '$count товар',
    );
    return '$_temp0 · $total';
  }

  @override
  String get orderStatusPlaced => 'Оформлен';

  @override
  String get orderStatusAccepted => 'Принят';

  @override
  String get orderStatusPreparing => 'Готовится';

  @override
  String get orderStatusReady => 'Готов';

  @override
  String get orderStatusOnTheWay => 'В пути';

  @override
  String get orderStatusCompleted => 'Завершён';

  @override
  String get advanceToAccepted => 'Принять';

  @override
  String get advanceToPreparing => 'Начать готовить';

  @override
  String get advanceToReady => 'Отметить готовым';

  @override
  String get advanceToOnTheWay => 'Заказ забран';

  @override
  String get advanceToCompleted => 'Передан клиенту';

  @override
  String scheduledAt(String time) {
    return 'К $time';
  }

  @override
  String get kdsIncoming => 'Новые';

  @override
  String get kdsInKitchen => 'В работе';

  @override
  String get kdsReady => 'Готовы';

  @override
  String get kdsColumnEmpty => 'Нет заказов';

  @override
  String get kdsEmptyTitle => 'Заказов пока нет';

  @override
  String get kdsEmptyMessage =>
      'Здесь появятся заказы, оформленные в приложении клиента.';

  @override
  String get waitingForCourier => 'Ждёт курьера';

  @override
  String get kdsNewTag => 'НОВЫЙ';

  @override
  String newOrderArrived(String orderId) {
    return 'Новый заказ: $orderId';
  }

  @override
  String pickupAt(String shopName) {
    return 'Самовывоз · $shopName';
  }

  @override
  String timeSincePlaced(String elapsed) {
    return 'Время с оформления: $elapsed';
  }

  @override
  String get favoritesTitle => 'Избранные товары';

  @override
  String get favoritesEmptyTitle => 'Нет избранных товаров';

  @override
  String get favoritesEmptyMessage =>
      'Нажми на сердечко у товара, чтобы быстро найти его здесь.';

  @override
  String addToFavorites(String productName) {
    return 'Добавить $productName в избранное';
  }

  @override
  String removeFromFavorites(String productName) {
    return 'Удалить $productName из избранного';
  }

  @override
  String courierArrivesIn(int minutes) {
    return 'Курьер приедет примерно через $minutes мин';
  }

  @override
  String get courierArrived => 'Курьер прибыл по адресу';

  @override
  String get courierOnline => 'Онлайн';

  @override
  String get courierOffline => 'Офлайн';

  @override
  String get courierOnlineHint => 'Новые заказы приходят';

  @override
  String get courierOfflineHint => 'Новые заказы не приходят';

  @override
  String get courierOnTheWaySection => 'В пути к клиенту';

  @override
  String get courierReadySection => 'Забрать в заведении';

  @override
  String get courierOfflineTitle => 'Ты офлайн';

  @override
  String get courierOfflineMessage =>
      'Выйди на линию, чтобы видеть заказы, которые нужно забрать в заведении.';

  @override
  String get courierEmptyTitle => 'Доставок пока нет';

  @override
  String get courierEmptyMessage =>
      'Заказы с доставкой появятся здесь, когда заведение отметит их готовыми.';

  @override
  String get toCollect => 'К оплате';

  @override
  String get itemsTitle => 'Товары';

  @override
  String get courierWaitingForStore => 'Заведение ещё готовит заказ.';

  @override
  String get deliveryCompleted => 'Доставка завершена.';

  @override
  String get backToDeliveries => 'Назад к заказам';

  @override
  String get deliveryNotFound => 'Доставка не найдена.';

  @override
  String deliveryTitle(String orderId) {
    return 'Доставка $orderId';
  }

  @override
  String amountToCollect(String total, String paymentMethod) {
    return '$total · $paymentMethod';
  }

  @override
  String get bannerCta => 'Заказать';

  @override
  String get searchHubHint => 'Поиск по DaviDan';

  @override
  String get searchMenuHint => 'Поиск по меню';

  @override
  String get searchClear => 'Очистить';

  @override
  String get searchPromptTitle => 'Что ищешь?';

  @override
  String get searchPromptHub =>
      'Напиши название товара, ингредиент или марку автомобиля.';

  @override
  String get searchPromptMenu => 'Напиши название товара или ингредиент.';

  @override
  String get searchNoResultsTitle => 'Ничего не найдено';

  @override
  String searchNoResultsMessage(String query) {
    return 'По запросу «$query» ничего не нашлось. Попробуй другое слово.';
  }

  @override
  String productCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count товара',
      many: '$count товаров',
      few: '$count товара',
      one: '$count товар',
    );
    return '$_temp0';
  }

  @override
  String searchCarsTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count автомобиля',
      many: '$count автомобилей',
      few: '$count автомобиля',
      one: '$count автомобиль',
    );
    return '$_temp0';
  }

  @override
  String get openNotifications => 'Открыть уведомления';

  @override
  String get notificationsTitle => 'Уведомления';

  @override
  String get notificationsEmptyTitle => 'Уведомлений пока нет';

  @override
  String get notificationsEmptyMessage =>
      'Здесь появятся новости о твоих заказах и заявках.';

  @override
  String get showAsList => 'Показать списком';

  @override
  String get showAsGrid => 'Показать плиткой';

  @override
  String get moreCategories => 'Ещё';

  @override
  String get allCategoriesTitle => 'Все категории';

  @override
  String get filterByCategory => 'Фильтр по категории';

  @override
  String clearCategoryFilter(String category) {
    return 'Сбросить фильтр «$category»';
  }

  @override
  String placeholderGrams(int amount) {
    return '$amountг';
  }

  @override
  String placeholderMillilitres(int amount) {
    return '$amountмл';
  }

  @override
  String calories(int amount) {
    return '$amount ккал';
  }

  @override
  String get offersTitle => 'Акции';

  @override
  String get specialDiscount => 'Специальная скидка';

  @override
  String discountPercent(int percent) {
    return '-$percent%';
  }

  @override
  String productWeightLine(String weight) {
    return 'Вес: $weight';
  }

  @override
  String productEnergyLine(int amount) {
    return 'Энергетическая ценность: $amount ккал';
  }
}
