# Super-app hub UX patterns: research notes

Researched 2026-09-16 for the DaviDan hub restructure (5 sub-brands: restaurant, sushi, bakery, bottled water, car rental).

**How to read the labels**
- **[V]** means I checked it against the source text (fetched the page and read the wording).
- **[V-old]** is checked, but the source is from before 2024. The pattern may have changed since.
- **[S]** comes only from a search-engine summary. I could not open the page (paywall, 403 or Cloudflare).
- **[GK]** is general knowledge or my own recollection of the apps. It is not backed by a source I could open, so treat it as a hypothesis to check on a device.

Caveat: WebFetch's summariser made up the content of one Russian article (4PDA, April 2026). It "summarised" a home-screen redesign that the article never mentions. After that I re-checked key claims with raw curl text extraction. Where a quote below is marked [V], it is from the raw page text.

---

## 0. Takeaways in brief

1. **The hub has become a service launcher plus live status.** Yandex Go swapped its map-first home for large service icons in 2023. It also shows the status of active orders from every service on the hub. Uber has a slim home plus a "Services" tab. Glovo moved from fixed bubbles to a modular, personalised layout in 2025. Wolt dropped its tab structure in 2026 for a floating "Search & Browse" button.
2. **Verticals open as full-screen flows that keep their own UI**, and the host keeps a consistent exit ("close" or "back to home"). WeChat and Alipay document this rule explicitly. Yandex says services keep "their familiar order screens".
3. **One design system with room for sub-brand colour.** Gojek assigns colours by category (six colours). Yandex Go widened its palette "to reflect the variety of services". Careem pushes a single unified look.
4. **Baskets are per store or per brand by default.** The 2025–2026 trend is opt-in bundling of two venues with one delivery fee: Wolt Double Order, Uber Eats multi-store, Yandex Eda "Мультизаказ" (Sep 2025) and Grab More (Apr 2026).
5. **History and activity live in one place** (Uber Activity hub, Grab Activity tab, Yandex Go "История заказов"). Upcoming bookings sit beside delivery orders.
6. **Account, payment methods, addresses and loyalty are shared across services.** Examples: the Yandex Go address book is labelled "Адрес для всех заказов: Лавка, Еда, Такси и другие". Removing a card in Bolt Food also removes it from the Bolt ride app. Uber One is "an all-in-one membership… across Uber and Uber Eats".
7. **The biggest documented pitfall is discovery, not clutter.** Most Yandex Go users still saw it as a taxi app with 16 services in Moscow. Wolt says "many customers haven't been aware" of its non-restaurant range.

---

## 1. Hub home screen structure

### Yandex Go (Russia/CIS)
- **April 2023 redesign [V]:** the map-first home became a grid of large service icons. Before that, the home showed a taxi map and address suggestions, with Маркет, Еда, Лавка, Доставка, Самокаты and Драйв as small icons at the bottom.
  - Yandex's own words: "Теперь всё, что нужно сделать при входе в приложение — выбрать необходимый сервис и дальше указать детали, не отвлекаясь на другие сценарии."
  - The updated home always shows the status of all current orders from every service ("Такси", "Лавка", "Доставка", "Маркет").
  - Rolled out on iOS first.
  - Sources: https://yandex.ru/company/news/04-07-23 · https://rozetked.me/news/29011-glavnyy-ekran-prilozheniya-yandeks-go-teper-vstrechaet-vyborom-servisa · https://moskvichmag.ru/gorod/u-yandeks-go-pomenyalsya-glavnyj-ekran/ · https://searchengines.guru/ru/news/2057317 (dated 7 Apr 2023)
- **Home screen as read by a screen reader [V, undated, content suggests ~2024]:** Yandex's accessibility tutorials list the home elements in this order:
  - "Меню" button (top-left)
  - Service buttons: Доставка, Лавка, Транспорт, Маркет, Еда, Магазины, Путешествия, Межгород, Самокаты, Такси
  - "Куда едем" (taxi destination entry) and "К выбору адреса"
  - A promo shelf ("Путешествие теперь в Go": hotel cashback, trip ideas)
  - Recent addresses
  - There is **no bottom tab bar** in the hub description. Profile, payments, history and addresses all sit in the side menu.
  - https://inclusion.yandex.ru/tutorials/go-android · https://inclusion.yandex.ru/tutorials/go-ios
- **Personalised icon set, 2020 launch [V-old]:** "Набор иконок персональный для каждого пользователя, а алгоритмы предугадывают, что именно сейчас нужно". https://www.interfax.ru/russia/722332
- **Scale [V]:** "В Москве в Go уже 16 сервисов". This comes from Yandex's 2025 award-entry case study. https://ratings.sostav.ru/works/1216
- **How new verticals get added, 2025–2026 [V]:**
  - "Цветы" (Jul 2026) is a new tile on the home screen. It reuses the Yandex Eda flower storefront, so no separate app is needed. https://postium.ru/v-yandeks-go-dobavili-bystruyu-dostavku-cvetov/
  - "Катера" boat rental (May 2026) is also a new home-screen section. https://postium.ru/yandeks-go-zapustil-arendu-katerov-v-sankt-peterburge/
  - Scooters, Drive car-sharing and powerbank rental are grouped as "арендные сервисы". They share one add-on subscription, "Яндекс Движ" (Sep 2025). https://postium.ru/yandeks-go-zapustii-yandeks-dvizh/
  - **Pattern:** services that share a journey type are grouped together, and one subscription covers the group.
- **Cross-vertical promo during an active order [V]:** while you wait for a taxi, "часто появляется эта врезка. Это реклама от Яндекс Маркета". Source: the go-ios tutorial above.
- **Anecdotal complaint [V, reader comment, Apr 2026]:** "сначала надо рекламный баннер закрыть, и потом ещё надо найти кнопку, чтобы такси вызвать". https://4pda.to/2026/04/23/455658/yandeks_go_teper_umeet_predskazyvat_dejstviya_polzovatelya/ (The article itself is about AI address prediction for taxi.)

### Glovo (the most relevant local reference: Glovo operates in Moldova [V, App Store listing])
- **19 June 2025 redesign [V]:** "the new homepage evolves from the iconic Glovo bubbles to a new modular, adaptive layout that adjusts to each user based on location, behaviour, and preferences."
  - Core categories are simpler to browse (groceries, health, gifts, essentials).
  - The homepage adapts to occasions (Christmas, Black Friday, local festivities).
  - "A new smart widget carousel at the bottom of the homepage… curated recommendations based on time, habits, and customer context". Users can pin favourite stores and create shortcuts.
  - https://about.glovoapp.com/press/glovo-redesigns-app-for-personalized-experience/
- The Glovo-style home the client described (address pill, category bubbles on a brand-colour background, white sheet with a "for you" carousel) matches the pre-2025 Glovo and current Bolt Food style. **[GK]:** this is from recollection; I did not find a source that describes the Bolt Food home layout.

### Wolt (DoorDash)
- **16 January 2026, "biggest consumer app update to date" [V]:**
  - "the old structure – multiple tabs, long backtracking paths – simply couldn't keep up".
  - The new structure has a **floating Search & Browse button** at the bottom as "a single entry point… restaurants, groceries, beauty, electronics, or package delivery".
  - Universal search results are grouped by intent across verticals, with product-first browsing across stores.
  - Profile is top-left, the activity hub (promos and updates) is top-right, and "your shopping basket is always visible and moves to the bottom".
  - https://press.wolt.com/en-WW/259591-wolt-redesigns-app-to-power-local-commerce-growth/ · https://press.wolt.com/en-WW/259625-wolt-app-updated-a-new-way-to-discover-everything-around-you/
- **Third-party observation, 11 Feb 2026 [V]:** 3 primary top tabs ("Discovery", "Restaurants", "Stores") plus multiple store-vertical entry points. The observer flags that this "can dilute navigation clarity at the highest-traffic entry surface". https://blog.contactpigeon.com/wolt-marketing-strategy/

### Uber (rides + Eats)
- **February 2023 redesign [V-old]:**
  - "simplified the homescreen… book rides and Uber Eats deliveries more easily, with fewer taps".
  - A new **"Services" tab**, "a one stop shop to find all of the rides and delivery offerings available in your city".
  - A new **"Activity Hub"** to "keep track of past and upcoming rides and Eats orders all in one place".
  - https://www.uber.com/us/en/newsroom/were-redesigning-the-uber-app-just-for-you/
- **2025–2026 [V]:**
  - The Account section sits "in the lower-right corner" in both the Uber and Uber Eats apps (Oct 2025). https://www.uber.com/us/en/blog/new-benefits-for-uber-one-members-2025/
  - April 2026: "The new 'hotels' icon on the Uber home screen" lets US users book hotels through Expedia. Uber keeps adding booking verticals as home icons. https://abcnews.com/Business/uber-rolls-new-travel-features-hotel-booking-eats/story?id=132465202

### Grab (Southeast Asia)
- **Service tiles [V-old, 2020]:** "interactive service tiles (these are the icons for the services offered on the app such as Transport, Food, Delivery…)". Tiles vary by city ("available services vary in each city") and are cached. Below the tiles is a personalised **Grab Feed** of ranked cards: "As we continue to add more cards, services… there's a risk that our users will find it harder to find the information relevant to them."
  - https://engineering.grab.com/journey-to-a-faster-everyday-super-app · https://engineering.grab.com/grab-everyday-super-app
- **Bottom bar [V, travel blog, undated]:** Home, Activity, Payment, Messages, Account. Around 2022 some users saw Payment renamed "Finance" (GrabFin). https://confidentlysolo.com/using-grab-in-indonesia/ · https://ringgitplus.com/en/blog/apps/grab-to-introduce-new-financial-focused-grabfin-brand-to-malaysian-users.html
- **GrabX, 8 April 2026 [V]:** AI features that include "Grab More" (see §4) and GrabStays hotel booking "that links directly with ride bookings". https://www.grab.com/sg/press/others/grab-unveils-13-ai-powered-experiences-at-grabx-2026-as-southeast-asias-intelligent-everyday-guide/

### Careem (Middle East)
- **Location-dependent home [V-old, 2020]:** "A Careem user in Dubai… sees Car, Hala Taxi, Bike, Food, Delivery, and Shops… someone in Lahore would see Transport, Delivery, and Recharge." https://kr-asia.com/careem-launches-super-app-to-provide-all-of-its-services-in-one-place
- "Over a dozen services available to customers in Dubai" [V, undated]. https://why.careem.com/en/building-the-everything-app/

### Bolt
- **Two apps, not one hub [V]:** bolt.eu offers a "Rides" app (ride-hailing, Drive car-sharing, scooters, Send) and a "Delivery" app (Bolt Food with groceries and stores).
  - Inside the Rides app you "switch to the Drive section" to rent a car.
  - Bolt Food: "No additional app downloads required — search for the store… directly within the Bolt Food app."
  - https://bolt.eu/en/ · https://bolt.eu/en/drive/ · https://bolt.eu/en/food/
  - **[GK]:** this means the Bolt Food home the client likes is a delivery-only hub (categories inside a single vertical), not a rides-plus-food hub.

### Gojek
- 19+ products in 2019, when Gojek called itself "an app of apps, a SuperApp" [V-old]. https://www.marketing-interactive.com/gojek-revamps-logo-shares-insights-to-new-look-and-creative-challenges

### How many verticals, and in what order
- **Counts:** Yandex Go lists about 10 services on the hub and has 16 in Moscow. Careem showed 3–6 depending on city (2020). Grab and Careem tiles vary by city.
- **Ordering signals:**
  - Personalised by behaviour and time (Yandex 2020 claim; Glovo 2025; Grab Feed).
  - Localised by availability (Grab, Careem).
  - The core or most frequent service keeps a direct entry (Yandex keeps "Куда едем" on the hub; Uber keeps rides and Eats on home, everything else under Services).
- Seasonal or occasion re-ordering: Glovo 2025.

---

## 2. Entering a vertical: full-screen mini-app, or inside the hub's tabs?

- **Yandex Go [V]:** "при переходе в Еду, Такси и другие сервисы, как и раньше, будут отображаться привычные экраны для оформления заказов". Each service keeps its own ordering UI; the hub only launches it and aggregates active orders. The hub itself has a side menu, not bottom tabs.
  - **[GK, not verified]:** Eda and Lavka inside Go open full-screen with their own header, address and basket. The hub's chrome is not visible, and you go back with the back arrow or system back. I could not confirm whether Eda-in-Go has its own bottom tab bar.
- **WeChat mini-program guidelines [V, current docs]:** these are the most explicit published rules for the host-plus-mini-app split.
  - The host places "an official mini program menu in the upper right corner" on all mini-program pages, and "Developers cannot customize its content".
  - Secondary pages get a back button top-left.
  - A mini-app may have its own tab bar ("not less than 2 and not more than 5" tabs). The native bottom tab bar style is only available on the mini-app's home page.
  - Principle: "Navigation needs to tell users where they are currently, where they can go, and how to return."
  - https://developers.weixin.qq.com/miniprogram/en/design/
- **Alipay mini-program guidelines [V, current docs]:**
  - A fixed top navigation bar with "menu" and "close" controls on every page ("Exit-As-You-Go").
  - On deeper pages "the 'Return to Home' button can also be provided… to directly return to the homepage of the Mini Programs".
  - Provide a visible back button, not just a swipe gesture.
  - https://miniprogram.alipay.com/docs-alipayconnect/miniprogram_alipayconnect/design/navigation-bar
- **Uber [V-old, 2019]:** Eats was first embedded in the rides app "via a webview instead of opening up the App Store for download". Uber Eats also remains a standalone app. https://techcrunch.com/2019/06/04/uber-eats-uber-eats/
  - **[GK]:** today, tapping Food in the Uber app opens an Eats experience or hands off to the Eats app.
- **Wolt 2026 [V]:** multiple tabs were removed. One floating browse and search entry now leads to every vertical, and the basket is pinned at the bottom. The vertical ("Restaurants", "Stores") is a destination reached from one entry point, not a separate tabbed app.
- **Bolt [V]:** verticals live in separate apps (Rides versus Food), and inside the Rides app they are sections ("switch to the Drive section").
- **Grab [GK]:** GrabFood and GrabMart open full-screen from a home tile with a back arrow. The global bottom bar (Home/Activity/Payment/Messages/Account) is not shown inside the vertical flow. The global Activity tab still collects all orders. I did not verify this from a source.
- **Pattern summary:**
  - The hub has a global nav (tabs or menu).
  - Tapping a vertical pushes a full-screen flow that covers the global nav.
  - The vertical has its own header (title or brand, address, search, its own basket). Deep verticals may add their own tabs.
  - A consistent, host-owned way back or close sits in the same spot on every vertical page.
  - Active orders surface back on the hub.

---

## 3. Theming per vertical versus one unified theme

- **Gojek, 2019 [V-old]:** "Running out of colours to attribute to new products". Gojek re-architected into **six category colours**: transport & logistics (green), food & retail (red), payments (blue), news & entertainment (pink), daily needs (orange), business (purple). https://www.marketing-interactive.com/gojek-revamps-logo-shares-insights-to-new-look-and-creative-challenges
- **Yandex Go [V]:**
  - 2020: the rebrand had to create "a system where various services could comfortably coexist" and keep continuity with Yandex Taxi. https://adpass.ru/ony-magic-camp-kak-sozdavalos-superprilozhenie-dlya-zhizni-v-gorode-yandex-go/
  - 2024–25 rebrand: "Расширили цветовую гамму Go, чтобы отразить разнообразие сервисов, а не только такси". https://ratings.sostav.ru/works/1216
  - Lavka's logo was designed to sit next to Такси, Еда and Драйв as "harmonious but distinctive" [S]. https://vc.ru/yandex.go/134470-u-lavki-poyavilsya-logotip-kak-vam
- **Careem [V]:** "All services have completely different customer journeys… Yet, they have to feel like they are part of the same app". Careem works on onboarding new services "to make them feel and look as an integrated part of the Careem ecosystem". https://koos.agency/project/multi-service-super-app-design/ · https://engineering.careem.com/posts/designing-a-super-app-experience-for-50-million-users-a-case-study-by-koos
- **Agency guidance, ProCreator (Aug 2025, marketing blog, low rigour) [V]:** "When services are designed independently… Colors shift. Button placements change… This breaks familiarity". Recommends design tokens for a consistent identity. https://procreator.design/blog/how-to-solve-super-app-design-challenges/
- **Wolt 2026 [V]:** "Rounded forms, vibrant colors, and adaptive motion create a modern, scalable interface" as "a foundation for growth" to add categories.
- **Pattern:** one component system and layout grammar across all verticals. Sub-brand identity shows through an accent colour, logo, illustration or imagery, never through different components or button placement. Glovo also applies occasion theming at hub level.

---

## 4. Carts and order history across verticals

### Carts are per store or brand by default; bundling is a 2025–2026 add-on
- **Bolt Food [V]:** "It is not possible to check out items from different restaurants in one/the same cart." You can place simultaneous orders. https://bolt.eu/en/support/articles/360021496759/
- **Wolt Double Order [V, undated help page]:** after placing an order you have 20 minutes to "Add More for Less" from a second venue. It is a second checkout with no second delivery fee, and "Double Orders cannot be combined with Group Orders". https://life.wolt.com/en/geo/howto/double-order
- **Uber Eats, Oct 2023 [V-old via search + Uber newsroom]:** "Bundle another store" before checkout, limited to nearby stores. https://www.uber.com/us/en/newsroom/multi-store-ordering/
- **Yandex Eda / Деливери "Мультизаказ", 17 Sep 2025 [V]:** "В одной корзине можно объединить заказы из двух магазинов, двух ресторанов или же из магазина и ресторана… оплатить всё вместе". The second venue's delivery is free. https://yandex.ru/company/news/17-09-2025-02
- **Grab More, Apr 2026 [V]:** "add another nearby merchant to your order — before or after checkout — with no extra delivery fee". (GrabX link in §1.)
- **Glovo [S/GK]:** a third-party blog claims multi-stop orders, but I found no Glovo source for it. Glovo's own FAQ only says multiple delivery addresses need the website. https://glovoapp.com/docs/en/faq/
- **Yandex Go, Eda versus Lavka [GK]:** separate tiles with separate baskets (Lavka is a single dark-store assortment). Not verified from a source.

### History and activity
- **Uber [V-old]:** one Activity hub for "past and upcoming rides and Eats orders". Rental reservations are managed from an "Upcoming rental" screen with "Manage reservation" (Uber Rent page). Uber Reserve says: "use the 'Upcoming' trips section to cancel, update, or review your upcoming reservations". https://help.uber.com/en/riders/article/using-uber-reserve?nodeId=71708d67-bbac-4dda-9d32-53c2509bdd1b
- **Grab [V, travel blog]:** "Go to the Activity section to find your recent and past rides and deliveries."
- **Yandex Go [V]:**
  - The side menu has a single "История заказов" item, a list "размечен[ный] заголовками" by date, with detail and help per order.
  - Active orders from all services show on the hub (2023).
  - Support: "написать… по последнему заказу, обратиться в конкретный сервис".
  - **[GK]:** I did not verify whether every service's past orders appear in that one list. Some services, such as Market, may keep their own history.
- **Pattern:** one Activity/Orders surface split into Active/Upcoming and Past. Cards are typed (ride, delivery, reservation). Help is per order.

---

## 5. Account, payment and addresses shared across verticals

- **Yandex Go [V]:**
  - One Yandex ID, "ключ ко всем сервисам Яндекса".
  - A single "Способы оплаты" screen (cards, Yandex Pay, Plus points, business account).
  - The address book item is literally named "**Адрес для всех заказов: Лавка, Еда, Такси и другие**". The menu text adds that addresses are for trips "или в других сервисах… например, для доставки продуктов из Лавки или товаров из Маркета".
  - Sources: the go-android and go-ios tutorials in §1.
  - Plus cashback works across Taxi, Lavka, Eda and Market [V, App Store listing]. https://apps.apple.com/us/app/yandex-go-taxi-food-delivery/id472650686
- **Bolt [V]:** "Removing your card from your Bolt Food app will also remove the same payment method from your ride-hailing app." Bolt Drive needs "a verified Bolt account, and a payment method added to your profile", plus a driving licence verified in-app. https://bolt.eu/en/support/articles/360007249019/ · https://bolt.eu/en/drive/
- **Uber [V]:** Uber One is "an all-in-one membership that unlocks savings across Uber and Uber Eats", managed under Account in either app (Oct 2025).
- **Careem [V-old]:** Careem Pay wallet is "at the center of it all" (2020). Careem Plus is one membership across services.
- **Agency guidance [V, ProCreator 2025]:** SSO across services; don't re-ask for login or verification per service.

---

## 6. Booking and rental verticals next to shopping verticals

- **Yandex Аренда авто inside Yandex Go [V, current FAQ]:** "раздел «Аренда авто» в приложении Яндекс Go". The flow:
  1. Choose city and **rental dates**, then tap an offer.
  2. Enter the **pickup or delivery address and the return address**, then "Продолжить".
  3. Leave contacts.
  4. Check that your **age and driving experience** meet the offer conditions and payment terms.
  5. "Оплатить и отправить документы" (prepayment).
  6. Confirmation arrives after the specific model's availability is checked.
  - "Все условия аренды, включая доступную страховку, пункт и время выдачи, вы увидите на карточке конкретного автомобиля на первом шаге бронирования." The car card also shows fuel policy, options (child seat) and a second driver.
  - Support is in the Yandex Go app.
  - The RuStore listing says: "Аренда машины на сутки или дольше. Выберите авто нужного класса в приложении — условия видны до брони."
  - https://rentacar.yandex.ru/faq · https://www.rustore.ru/catalog/app/ru.yandex.taxi
- **Uber Rent [V]:** "Tap the Rental Car icon, then enter the address that your rental car pickup/dropoff will be near and the times and dates… Browse vehicles, compare prices, and consider including add-ons." Car classes: small, midsize, large, SUV, EV, luxury. https://www.uber.com/us/en/ride/car-rentals/
- **Bolt Drive [V]** (car-sharing, a different model from rental):
  - Map-first: "You'll see available cars on the map… Tap a car to view details like model, fuel level, and price before reserving."
  - Free short reservation, then unlock by phone. Hourly and daily packages. Car types: small, electric, medium, premium, SUV, van. All automatic.
  - https://bolt.eu/en/drive/
- **Yandex Go boats, May 2026 [V]:** choose "дату, время и причал", 1–4 h, capacity 5/7/9. "Финальная сумма появляется после выбора даты и времени и не меняется после оформления предзаказа." (Postium link in §1.)
- **Uber hotels, Apr 2026 [V]:** another booking vertical added as a plain home icon beside rides and Eats.
- **Cross-vertical links [V]:** Uber "Eats for the Way" lets you add Uber Eats to a reserved Black ride so food is waiting in the car (ABC, Apr 2026). GrabStays hotel booking "links directly with ride bookings" (GrabX 2026).
- **Pattern:**
  - Booking verticals sit on the same hub as shopping verticals, as a peer icon.
  - Inside, the flow inverts: time and place first (dates, pickup location), then a list of classes or vehicles with total price, then a detail card (specs, insurance, deposit, pickup hours, requirements), then extras, then documents and prepay, then a confirmation.
  - The result is an "Upcoming" entry in the shared activity list, not a cart.

---

## 7. Published pitfalls and case studies (2024–2026)

- **Discovery failure (strongest evidence).**
  - Yandex Go (2025 award case): "большинство пользователей по-прежнему воспринимали нас как приложение для такси и редко использовали что-то ещё". The rebrand campaign raised awareness of 2+ services by 26%. https://ratings.sostav.ru/works/1216
  - Wolt (Jan 2026): "Many customers haven't been aware of the wide range of products and venues already available on Wolt". The fix was universal search, product-first browsing and a single browse button.
  - ContactPigeon (Feb 2026, citing DoorDash data): the share of Wolt MAUs ordering from new verticals rose only from 20% to 25% between Dec 2023 and Dec 2024.
- **Too many tabs and backtracking.** Wolt: "the old structure – multiple tabs, long backtracking paths – simply couldn't keep up" (Jan 2026).
- **Feed and card overload.** Grab (2020): "risk that our users will find it harder to find the information relevant to them". Grab responded with ranking and personalisation, not by removing content.
- **Banner and promo clutter blocking the core task.** 4PDA reader comment on Yandex Go (Apr 2026, anecdotal).
- **Cross-service cognitive load (academic, 2025) [S].** A Springer chapter, "Feature Complexity in Super Apps: How Feature Heterogeneity and Interrelatedness Shape Cognitive Load, Usability, and Continuance", argues that moving between dissimilar services raises cognitive load when the interface does not preserve task context. I could only see the search abstract (paywalled). https://link.springer.com/chapter/10.1007/978-3-032-30552-7_15
- **Agency listicles [V, low rigour]:** ProCreator (Aug 2025) names navigation overload, inconsistent UI across services, "show everything at once" (carousels, popups, micro-promotions), repeated logins, and third-party flows with "conflicting navigation patterns". https://procreator.design/blog/how-to-solve-super-app-design-challenges/ · https://procreator.design/blog/super-app-ui-design-steps-to-get-it-right/
- **Deep links and bottom-nav conflicts.** I found **no dedicated 2024–2026 case study**; no NN/g or Baymard article on super-app hubs turned up. The closest documented guidance is the WeChat and Alipay rules in §2: a fixed host exit control, "Return to Home" on deep pages, max 5 tabs, and native bottom tabs only on the mini-app home. **[GK]:** the common engineering pitfall is a deep link or push notification that opens a vertical's detail page with no hub underneath, so "back" exits the app. The fix is to build the back stack (hub, then vertical home, then detail) when handling the link.
- Snapp (Iran) homepage revamp case study (Medium, blocked 403): "first fold for top priority… related services via an icon-in-icon" [S only]. https://ehsanmadadi.medium.com/snapp-super-app-homepage-revamp-a-case-study-6b5535b4af54

---

## Recommendations for the 5-vertical DaviDan prototype

These are my synthesis. **(!)** marks decisions that are costly to redo later.

1. **Hub home.**
   - Top to bottom: address pill, then an active-order or booking strip (Yandex Go pattern; hidden when empty), then 5 large brand tiles, then a "for you" carousel mixing items from the brands (Glovo widget carousel / Wolt product-first).
   - Five tiles fit above the fold, so no "More" or Services tab is needed.
   - Show the car-rental tile visually as a "book" service. Options are a separate row labelled e.g. "Închirieri", or a distinct tile style, like Yandex grouping its rental services.
   - Keep promos to one shelf. No pop-ups on the hub.
2. **(!) Navigation shape.**
   - Keep the global tabs (e.g. Home · Orders · Profile, plus the existing fourth tab) only on the hub.
   - Tapping a brand pushes a full-screen vertical **outside** the tab shell. It gets its own header (back-to-hub arrow in a fixed spot, brand name or logo, that brand's cart button) and at most light internal navigation (menu categories, not a second bottom bar).
   - Support system back and swipe-back to the hub.
   - Make every vertical screen route-addressable (e.g. `/brand/sushi/item/42`), and have deep links rebuild the hub underneath.
3. **(!) Theming.** One ThemeExtension component set, with a per-brand accent override applied at the vertical's root (CTA, header tint, tile colour). Same components and button positions everywhere (Gojek, Careem, ProCreator). The hub uses the DaviDan master brand.
4. **(!) Carts.**
   - **One cart per brand.** Each brand is a separate kitchen or stock, and this matches Bolt Food, Glovo and Wolt defaults.
   - The header cart inside a vertical shows that brand's cart. On the hub, a cart icon can open a sheet listing non-empty brand carts.
   - Car rental has **no cart**; it is a booking flow.
   - Optional "wow" demo: a Wolt/Yandex/Grab-style "add dessert from the bakery to this sushi order, same courier, no extra fee" prompt after checkout.
5. **Orders tab.** One list with Active/Upcoming and Past sections. Typed cards: delivery (status, ETA, brand accent) and rental (dates, pickup point, car, "Manage booking"). Filter chips by brand.
6. **Profile.** One account, one address book ("addresses for all orders"), one payment list, one loyalty programme. Rental adds driving-licence and ID verification stored in the profile (Bolt Drive and Yandex Rent require this).
7. **Rental vertical flow.**
   1. Dates and times plus pickup/return location (or delivery to address)
   2. Vehicle list by class with price per day and total
   3. Car card with specs (transmission, seats, fuel, insurance, deposit, age and experience requirements, pickup hours)
   4. Extras (child seat, second driver)
   5. Documents and prepay
   6. Confirmation, which appears in Orders under "Upcoming"
   - A list is better than a map here: DaviDan is rental from a location, not free-floating car-sharing.
8. **Don't over-personalise a 5-brand demo.** A static tile order is fine. Spend the effort on showing cross-brand discovery on the hub (carousel and shared search), because the documented failure is users never finding the other services.
9. **Not researched:** bottled-water delivery patterns (subscriptions or recurring orders, bottle deposit or return). This is [GK] and worth a separate look if the water vertical needs more than a normal shop flow.
