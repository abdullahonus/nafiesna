# Flutter Uygulama Mimarisi — NafieSna Yaşayan Referans Dokümanı

> **Bu doküman her geliştirme adımından önce okunmalıdır.**
>
> **Temel Kural:** Projede olmayan bir yapıyı oluşturma.  
> Bir widget, servis, modül veya pattern ancak gerçekten ihtiyaç duyulduğunda eklenir.  
> İhtiyaç duyulmadan "belki lazım olur" mantığıyla yapı oluşturulmaz.
>
> **Paket Versiyonları:** Sabit versiyon yazılmaz.  
> `flutter pub add <paket>` komutu güncel stabil versiyonu otomatik ekler.

---

## Bu Dokümanı Nasıl Kullanmalısın (AI için)

```
Kullanıcı bir istek yaptığında:

1. Bu bölümü oku → Mevcut projenin neleri var, neleri yok?
2. "Faz Durumu" bölümünü oku → Hangi yapılar aktif, hangisi planlandı?
3. İsteği mevcut mimariye uygun mu değerlendir.
4. Eğer yeni bir yapı (widget/servis/modül) eklenmesi gerekiyorsa
   → önce bu dokümana kaydet, sonra yaz.
5. Projede olmayan bir şeyi sormadan ekleme.
   Emin değilsen kullanıcıya sor.
```

---

## İçindekiler

1. [Proje Profili](#1-proje-profili)
2. [Faz Durumu — Ne Var, Ne Planlandı](#2-faz-durumu--ne-var-ne-planlandı)
3. [Mimari Katmanlar](#3-mimari-katmanlar)
4. [Klasör Yapısı — Mevcut](#4-klasör-yapısı--mevcut)
5. [State Management — Aktif Pattern](#5-state-management--aktif-pattern)
6. [Dependency Injection — Aktif Kurulum](#6-dependency-injection--aktif-kurulum)
7. [Navigation — Aktif Kurulum](#7-navigation--aktif-kurulum)
8. [Network Katmanı](#8-network-katmanı)
9. [Güvenlik](#9-güvenlik)
10. [Servisler & Entegrasyonlar](#10-servisler--entegrasyonlar)
11. [Tema & UI Sistemi — Aktif](#11-tema--ui-sistemi--aktif)
12. [Kod Üretimi — Aktif Araçlar](#12-kod-üretimi--aktif-araçlar)
13. [Naming & Kod Kuralları](#13-naming--kod-kuralları)
14. [Yeni Şey Eklerken İzlenecek Adımlar](#14-yeni-şey-eklerken-izlenecek-adımlar)
15. [Değişiklik Geçmişi](#15-değişiklik-geçmişi)

---

## 1. Proje Profili

| Alan | Değer |
|---|---|
| **Uygulama Adı** | NafieSna |
| **Kategori** | İslami İçerik / Dini Uygulama |
| **Platform** | iOS, Android |
| **Dart SDK** | ^3.9.2 |
| **Flutter SDK** | Güncel stabil |
| **Başlangıç Tarihi** | 2026-03-17 |
| **Geliştirici Sayısı** | 1 |

### Uygulamanın Temel Amacı

```
NafieSna; @NafiEsna YouTube kanalının canlı yayınlarını,
günlük hadisleri, namaz vakitlerini, Kaside-i Bürde PDF'ini
ve dini bilgileri tek bir uygulamada sunan İslami içerik platformudur.
Auth gerektirmez — tüm içerikler herkese açıktır.
```

### Ana Domain'ler (Feature Grupları)

```
- Ana Sayfa (home)        → YouTube canlı yayın kartı + günlük hadis
- Namaz Vakitleri (prayer_times) → Günlük 6 vakit, aktif vakit vurgusu
- Kaside PDF (pdf)        → Kaside-i Bürde sürekli dikey scroll
- Dini Bilgiler (content) → Kandil/bayram takvimi + İslami bilgiler
- Tab Scaffold (tab)      → Bottom navigation (4 tab)
```

---

## 2. Faz Durumu — Ne Var, Ne Planlandı

> **AI için kritik bölüm.**  
> Bir yapı "Aktif" değilse, o yapıya ait kod oluşturma.  
> "Planlandı" olan yapılar için sadece bu tabloda kayıt tut; kod yazma.  
> "Aktif" olan yapı için istek geldiğinde mevcut desene uyu.

### Katman & Altyapı Durumu

| Yapı | Durum | Notlar |
|---|---|---|
| State Management (Riverpod + StateNotifier) | ✅ Aktif | `flutter_riverpod ^2.6.1` |
| Navigation (AutoRoute) | ✅ Aktif | `auto_route ^9.3.0`, kod üretimi aktif |
| Dependency Injection (GetIt) | ✅ Aktif | Sadece AppRouter kaydı; injectable anotasyon YOK |
| Tema Sistemi (Dark Mode) | ✅ Aktif | AppColors / AppTheme / AppTextStyles / AppSpacing |
| Kod Üretimi (build_runner) | ✅ Aktif | auto_route_generator + injectable_generator |
| AppInit Orkestrasyonu | ✅ Aktif | `lib/product/init/app_init.dart` |
| Network (Dio + Chucker) | ✅ Aktif | `dio ^5.9.2` + `chucker_flutter ^1.9.1` (debug only), Aladhan tek kaynak |
| Pusula (compassx) | ❌ Kaldırıldı | Kıble bulucu özelliği kaldırıldı |
| Secure Storage | ⬜ Planlandı | Auth yokken gereksiz |
| Shared Preferences | ✅ Aktif | `shared_preferences` — Kazalar sayacı (key-value) |
| Local DB (sqflite) | ✅ Aktif | `sqflite` — Rüya defteri CRUD |
| Firebase | ⬜ Planlandı | — |
| Push Notification | ⬜ Planlandı | — |
| Deeplink | ⬜ Planlandı | — |
| Session Timeout | ❌ Kullanılmıyor | Auth yok |
| SSL Pinning | ❌ Kullanılmıyor | Network katmanı henüz yok |
| Responsive UI (ScreenUtil) | ⬜ Planlandı | İhtiyaç duyulduğunda eklenecek |
| Clean Architecture (Domain/Data) | ⬜ Planlandı | API entegrasyonu gelince eklenecek |

> **Durum Değerleri:**
> - ✅ Aktif — Projede mevcut, bu desene uyu
> - 🔄 Geliştiriliyor — Yarı tamamlandı, dikkatli ol
> - ⬜ Planlandı — Henüz yok, ekleme
> - ❌ Kullanılmıyor — Bu projede kasıtlı olarak yok

### Feature Durumu

| Feature | Durum | Notlar |
|---|---|---|
| Tab Scaffold | ✅ Aktif | `lib/feature/tab/view/tab_view.dart` |
| Ana Sayfa (home) | ✅ Aktif | YouTube kartı + namaz vakitleri barı + Hicri takvim kartı + günlük hadis |
| Rüya Defteri (dream) | ✅ Aktif | SharedPreferences CRUD, hilal-yıldız temalı UI, tab olarak erişim |
| Namaz Vakitleri (prayer_times) | ⚠️ Sadece veri | Tab kaldırıldı; notifier/provider ana sayfada PrayerTimesBar için kullanılıyor |
| Kaside PDF (pdf) | ✅ Aktif | `syncfusion_flutter_pdfviewer`, continuous scroll |
| Menü (content) | ✅ Aktif | Grid menü: Dini Günler, Yakın Camiler, Kazalar, İslami Bilgiler |

> Yeni feature eklendiğinde bu tabloya satır ekle ve durumu güncelle.

### Global Widget Kataloğu Durumu

| Widget | Durum | Kullanıldığı Yerler |
|---|---|---|
| AppLoadingIndicator | ✅ Aktif | home, prayer_times, pdf, content |
| AppErrorState | ✅ Aktif | home, pdf |
| AppEmptyState | ❌ Kullanılmıyor | Hiç kullanılmadı — silindi |
| AppPrimaryButton | ⬜ Planlandı | — |
| AppTextField | ⬜ Planlandı | — |
| AppBottomSheet | ⬜ Planlandı | — |
| AppSnackbar | ⬜ Planlandı | — |

> Bir widget en az 2 farklı yerde kullanılacaksa global widget yap.  
> Kullanılmayacaksa satırı sil. İhtiyaç doğduğunda satır ekle.

---

## 3. Mimari Katmanlar

> Bu bölüm mimari kararı belgeler.  
> Katman aktif (✅) olmadan o katmana ait kod oluşturma.

### MVP Katman Modeli (Aktif)

```
┌──────────────────────────────────────────────────────────────────┐
│                      PRESENTATION LAYER  ✅ Aktif                │
│   view/ → notifier/ → state/ → provider/ → widgets/             │
├──────────────────────────────────────────────────────────────────┤
│              DOMAIN + DATA LAYER  ⬜ Planlandı                   │
│   API entegrasyonu geldiğinde eklenecek                          │
│   domain/repository/ → interface  |  data/repository/ → impl    │
└──────────────────────────────────────────────────────────────────┘
```

### Bağımlılık Kuralı (Domain/Data aktif olduğunda)

```
Presentation  →  Domain  ←  Data

- Notifier, repository INTERFACE'ini kullanır (impl değil)
- Domain katmanı hiçbir dış çerçeveye bağımlı değildir
- Data katmanı Dio, storage vb. kullanabilir
```

### Şu Anki Veri Akışı

```
UI Widget
  │ ref.watch(provider)
  ▼
Riverpod Provider
  │
  ▼
Notifier → Service (Dio / API)
  │ State güncelleme
  ▼
UI rebuild
```

---

## 4. Klasör Yapısı — Mevcut

> Bu bölüm projenin **gerçek** klasör yapısını yansıtır.  
> Klasör yoksa buraya yazma. Klasör oluşturulduğunda buraya ekle.

```
lib/
├── main.dart
│
├── feature/
│   ├── home/
│   │   ├── notifier/
│   │   │   └── home_notifier.dart     (HomeNotifier + HomeState + HadithData)
│   │   ├── provider/
│   │   │   └── home_provider.dart
│   │   ├── view/
│   │   │   └── home_view.dart
│   │   └── widgets/
│   │       ├── hadith_card.dart
│   │       ├── hijri_calendar_card.dart (Hicri takvim + ay illüstrasyonu + etkinlik geri sayımı)
│   │       ├── live_stream_card.dart
│   │       └── prayer_times_bar.dart  (Namaz vakitleri + büyük geri sayım)
│   │
│   ├── dream/
│   │   └── view/
│   │       └── dream_view.dart           (Rüya Defteri — hilal-yıldız temalı UI, CRUD)
│   │
│   ├── prayer_times/                     (Tab kaldırıldı, sadece veri katmanı)
│   │   ├── notifier/
│   │   │   └── prayer_times_notifier.dart  (PrayerTimesNotifier + State + PrayerTime)
│   │   └── provider/
│   │       └── prayer_times_provider.dart
│   │
│   ├── pdf/
│   │   └── view/
│   │       └── pdf_view.dart          (SfPdfViewer, continuous scroll)
│   │
│   ├── content/
│   │   ├── notifier/
│   │   │   └── content_notifier.dart  (ContentNotifier + State + ReligiousDay + IslamicInfo)
│   │   ├── provider/
│   │   │   └── content_provider.dart
│   │   ├── view/
│   │   │   └── content_view.dart       (Grid menü — 3x2 kart)
│   │   └── widgets/
│   │       ├── religious_days_page.dart  (Dini günler listesi — API'den canlı)
│   │       ├── missed_prayers_page.dart  (Kazalar sayacı — SharedPreferences)
│   │       ├── dream_journal_page.dart   (Rüya defteri — sqflite CRUD)
│   │       ├── nearby_mosques_page.dart  (Yakın camiler — Overpass API)
│   │       └── islamic_info_page.dart    (İslami bilgiler — accordion)
│   │
│   └── tab/
│       └── view/
│           └── tab_view.dart          (AutoTabsScaffold, bottom nav)
│
├── service/
│   ├── hadith_service.dart              (HadeethEnc API + sayfa cache)
│   ├── islamic_calendar_service.dart    (Aladhan gToHCalendar → dini günler, session cache)
│   ├── location_service.dart            (GPS + Nominatim ters geocoding)
│   ├── missed_prayer_service.dart       (Kazalar — SharedPreferences CRUD)
│   ├── dream_journal_service.dart       (Rüya defteri — sqflite CRUD)
│   ├── nearby_mosques_service.dart      (Overpass API — yakın cami arama)
│   ├── prayer_times_service.dart        (Aladhan namaz vakitleri + Hicri tarih)
│
└── product/
    ├── constants/
    │   └── app_spacing.dart           (xs/sm/md/lg/xl/xxl + radius sabitleri)
    ├── init/
    │   ├── app_init.dart              (AppInit.make — başlatma orkestrasyonu)
    │   └── theme/
    │       ├── app_colors.dart        (AppColors — teal + gold dark palette)
    │       ├── app_text_styles.dart   (AppTextStyles)
    │       └── app_theme.dart         (AppTheme.dark)
    ├── navigation/
    │   ├── app_router.dart            (AppRouter — auto_route)
    │   └── app_router.gr.dart         (generated)
    ├── utility/
    │   └── injection/
    │       ├── injection.dart         (GetIt kurulumu)
    │       └── injection.config.dart  (generated)
    └── widget/
        └── common/
            ├── app_loading_indicator.dart
            └── app_error_state.dart
```

### Feature Klasörü Şablonu (İhtiyaç Duyulduğunda)

```
feature/<isim>/
├── notifier/     → XxxNotifier + XxxState (aynı dosyada veya ayrı)
├── provider/     → Riverpod provider tanımı
├── view/         → XxxView ekran widget'ları
├── viewModel/    → (Gerekirse) Saf UI hesaplama mantığı
└── widgets/      → Feature'a özgü küçük widget'lar
```

> `viewModel/` ve `widgets/` klasörlerini feature'a gerçekten ihtiyaç olmadıkça oluşturma.

---

## 5. State Management — Aktif Pattern

> **Durum:** ✅ Aktif

### Seçilen Araç

**Riverpod** (`flutter_riverpod ^2.6.1`) — StateNotifier pattern

### State Sınıfı Deseni

```dart
// Immutable, copyWith destekli
class FeatureState {
  const FeatureState({
    this.isLoading = false,
    this.data,
    this.errorMessage,
  });

  final bool isLoading;
  final FeatureData? data;
  final String? errorMessage;

  bool get hasError => errorMessage != null;

  FeatureState copyWith({
    bool? isLoading,
    FeatureData? data,
    String? errorMessage,
  }) =>
      FeatureState(
        isLoading: isLoading ?? this.isLoading,
        data: data ?? this.data,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
```

### Notifier Deseni

```dart
class FeatureNotifier extends StateNotifier<FeatureState> {
  FeatureNotifier() : super(const FeatureState());

  Future<void> load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // iş mantığı
      state = state.copyWith(isLoading: false, data: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
```

### Provider Tanımı

```dart
final featureProvider =
    StateNotifierProvider<FeatureNotifier, FeatureState>(
  (ref) => FeatureNotifier(),
);
```

### View'da Kullanım

```dart
class FeatureView extends ConsumerWidget {
  const FeatureView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sadece ilgili slice'ı izle → gereksiz rebuild önlenir
    final isLoading = ref.watch(
      featureProvider.select((s) => s.isLoading),
    );
  }
}
```

---

## 6. Dependency Injection — Aktif Kurulum

> **Durum:** ✅ Aktif (yalnızca AppRouter kaydı — `@injectable` anotasyon kullanılmıyor)

### Araçlar

- `get_it ^8.0.3` — Service locator
- `injectable ^2.5.0` — Hazır (ancak anotasyon henüz kullanılmıyor)

### Mevcut Kurulum

```dart
// lib/product/utility/injection/injection.dart
final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

// lib/product/init/app_init.dart içinde:
getIt.registerSingleton<AppRouter>(AppRouter());
```

> `@injectable`, `@singleton` anotasyonları Domain/Data katmanı gelince kullanılacak.  
> Şu an için sadece GetIt üzerinden manuel kayıt yapılıyor.

---

## 7. Navigation — Aktif Kurulum

> **Durum:** ✅ Aktif

### Araç

**auto_route ^9.3.0** — Tip-güvenli, declarative navigasyon

### Router (Mevcut)

```
AppRouter
└── TabRoute (path: '/')
    ├── HomeRoute       (path: 'home', initial: true)
    ├── PrayerTimesRoute (path: 'prayer')
    ├── PdfRoute        (path: 'pdf')
    └── ContentRoute    (path: 'content')
```

### Route Tablosu

| Route | View | Durum |
|---|---|---|
| `/` | `TabView` | ✅ Aktif |
| `/home` | `HomeView` | ✅ Aktif |
| `/prayer` | `PrayerTimesView` | ✅ Aktif |
| `/pdf` | `PdfView` | ✅ Aktif |
| `/content` | `ContentView` | ✅ Aktif |

> Yeni route eklendiğinde bu tabloya satır ekle.

---

## 8. Network Katmanı

> **Durum:** ✅ Aktif — Dio ile API çağrıları yapılıyor.

### Aktif Yapı

- Araç: **Dio** (`dio ^5.9.2`)
- Yapılandırma: `lib/product/init/network/network_config.dart`
- 3 ayrı Dio instance: aladhanDio, hadeethEncDio, nominatimDio
- Debug HTTP Logger: **Chucker** (`chucker_flutter ^1.9.1`) — sadece `kDebugMode`'da aktif

### Chucker (Debug Network Inspector)

```
Etkinleştirme : kDebugMode → otomatik (interceptor + navigator observer)
Ekran açma    : Uygulama içi bildirime tıkla veya ChuckerFlutter.showChuckerScreen()
Güvenlik      : Production'da tamamen devre dışı (kDebugMode guard)
```

### Planlanan İyileştirmeler

- Environment: `--dart-define=ENV=prod` ile build-time URL yönetimi

---

## 9. Güvenlik

> **Durum:** ⬜ Planlandı — Auth olmadığı için güvenlik katmanı henüz gereksiz.

### Eklendiğinde Kurulacak Yapılar

| Bileşen | Koşul |
|---|---|
| `flutter_secure_storage` | Auth / token sistemi eklenince |
| `local_auth` | Biyometrik giriş istenince |
| SSL Pinning | Production'a geçmeden önce |
| Session Timeout | Auth + idle-risk varsa |

---

## 10. Servisler & Entegrasyonlar

> **Durum:** ✅ Aktif

### Aktif Servisler

| Servis | Açıklama | Dosya | Not |
|---|---|---|---|
| **api.aladhan.com/v1** | Namaz vakitleri (method=13 Diyanet) + Hicri tarih | `prayer_times_service.dart` | Tek kaynak, şehir + koordinat bazlı, her zaman güncel |
| **api.aladhan.com/v1** | Hicri takvim + dini günler (gToHCalendar) | `islamic_calendar_service.dart` | holidays dizisi + Hicri tarih bazlı Kandil tespiti, session cache |
| **hadeethenc.com/api/v1** | Türkçe hadisler (20+ dil, tam metin) | `hadith_service.dart` | Ücretsiz, kayıtsız, Kategori 5 = Faziletler, sayfa cache |
| **overpass-api.de** | Yakın camiler (OpenStreetMap) | `nearby_mosques_service.dart` | amenity=place_of_worship + religion=muslim, 3km yarıçap |
| **SharedPreferences** | Kazalar sayacı (local) | `missed_prayer_service.dart` | Sabah/Öğle/İkindi/Akşam/Yatsı/Vitr/Oruç sayaçları |
| **sqflite** | Rüya defteri (local DB) | `dream_journal_service.dart` | CRUD, tarih/saat otomatik, düzenleme desteği |

### API Detayları

#### Namaz Vakitleri — Aladhan (api.aladhan.com)
```
Şehir    : GET /v1/timingsByCity/{DD-MM-YYYY}?city=Istanbul&country=Turkey&method=13
Koordinat: GET /v1/timings/{DD-MM-YYYY}?latitude={lat}&longitude={lng}&method=13
Method 13: Diyanet İşleri Başkanlığı hesaplama yöntemi
Mapping  : Fajr → İmsak, Sunrise → Güneş, Dhuhr → Öğle, Asr → İkindi, Maghrib → Akşam, Isha → Yatsı
Hicri    : data.date.hijri objesi (Arapça ay adı → Türkçe dönüşüm kodda)
Not      : Diyanet ile max 1 dk fark — kabul edilebilir
```

#### Hicri Takvim & Dini Günler — Aladhan (gToHCalendar)
```
Takvim   : GET /v1/gToHCalendar/{month}/{year}
Veri     : Her gün → hijri.holidays dizisi (Eid-ul-Fitr, Lailat-ul-Qadr vb.)
Kandiller: hijri.day + hijri.month.number ile hesaplanır (27 Receb = Miraç, 15 Şaban = Berat)
Strateji : Mevcut ay + 5 sonraki ay paralel çekilir → session boyunca cache
TR Map   : Eid-ul-Fitr → Ramazan Bayramı, Eid-ul-Adha → Kurban Bayramı vb.
Fallback : API başarısızsa Diyanet 2026 verisine dayalı statik liste
```

#### Hadis — HadeethEnc
```
Liste    : GET /hadeeths/list/?language=tr&category_id=5&page={p}&per_page=20
Detay    : GET /hadeeths/one/?language=tr&id={id}
Rotasyon : dayOfYear % 35 → sayfa, dayOfYear % 20 → sıra
Alanlar  : hadeeth (TR), hadeeth_ar (AR), attribution, grade
Cache    : Sayfa bazlı in-memory cache (aynı 20-gün periyodunda tek API çağrısı)
```

### Planlanan Entegrasyonlar

| Servis | Neden | Koşul |
|---|---|---|
| YouTube Data API | Canlı yayın embed / thumbnail | UI geliştirme ihtiyacı |
| Firebase Messaging | Push bildirim | Bildirim özelliği istenince |

---

## 11. Tema & UI Sistemi — Aktif

> **Durum:** ✅ Aktif

### Tema Dosyaları

| Dosya | Durum | Konum |
|---|---|---|
| `app_theme.dart` | ✅ Aktif | `lib/product/init/theme/` |
| `app_colors.dart` | ✅ Aktif | `lib/product/init/theme/` |
| `app_text_styles.dart` | ✅ Aktif | `lib/product/init/theme/` |
| `app_spacing.dart` | ✅ Aktif | `lib/product/constants/` |
| Dark mode | ✅ Aktif | `AppTheme.dark` |
| Light mode | ❌ Kullanılmıyor | Spec gereği sadece dark |

### Renk Kararları (Spec FR-007)

```
Primary  : #008080 (Teal)
Accent   : #D4AF37 (Gold)
Background: #0D0D0D
Surface  : #1A1A1A
```

### Tasarım Baz Boyutu

```
390x844 (iPhone 14) — ScreenUtil henüz aktif değil
```

### Global Widget Oluşturma Kuralı

```
❌ "Belki lazım olur" diye widget oluşturma.

✅ Bir widget en az 2 farklı yerde kullanılacaksa global widget yap.
✅ İlk kullanımda feature içinde widget/ klasörüne koy.
✅ İkinci kullanımda product/widget/ altına taşı ve bu tabloya ekle.
```

---

## 12. Kod Üretimi — Aktif Araçlar

> Araç aktif değilse ilgili anotasyonu kullanma.

| Araç | Durum | Ürettiği Dosya |
|---|---|---|
| `auto_route_generator ^9.3.1` | ✅ Aktif | `app_router.gr.dart` |
| `injectable_generator ^2.7.0` | ✅ Aktif | `injection.config.dart` |
| `json_serializable ^6.9.5` | ✅ Hazır | `*.g.dart` — model gelince kullanılacak |
| `riverpod_generator` | ❌ Kullanılmıyor | StateNotifier yeterli |

### Tek Komut ile Tüm Üretim

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 13. Naming & Kod Kuralları

> Bu kurallar projedeki her kod için geçerlidir. İstisna yok.

### İsimlendirme

| Tür | Kural | Örnek |
|---|---|---|
| Sınıf | `PascalCase` | `LoginNotifier` |
| Dosya | `snake_case` | `login_notifier.dart` |
| Değişken / Metod | `camelCase` | `isLoading`, `fetchData()` |
| Sabit | `camelCase` | `apiTimeout` |
| Boolean | `is/has/can/should` | `isLoading`, `hasError` |
| Notifier | `XxxNotifier` | `HomeNotifier` |
| State | `XxxState` | `HomeState` |
| Provider | `xxxProvider` | `homeProvider` |
| View | `XxxView` | `HomeView` |
| Servis | `XxxService` | `AuthService` |
| Repository | `XxxRepository` / `XxxRepositoryImpl` | — |

### Zorunlu Kurallar

```
✅ Tüm tipler explicit — dynamic ve var KULLANILMAZ
✅ Null safety zorunlu — ! operatöründen kaçın
✅ Fonksiyon ≤ 20 satır, tek sorumluluk
✅ Sınıf ≤ 200 satır
✅ Nesting ≤ 3 seviye — early return kullan
✅ Magic number yasak — const ile tanımla
✅ const constructor her yerde kullanılır
```

### ref.watch Kuralı

```dart
// ❌ Tüm state → her değişimde rebuild
final state = ref.watch(featureProvider);

// ✅ Sadece ilgili alan → gereksiz rebuild olmaz
final isLoading = ref.watch(featureProvider.select((s) => s.isLoading));
```

---

## 14. Yeni Şey Eklerken İzlenecek Adımlar

### Yeni Feature Eklendiğinde

```
1. Bölüm 2 — Feature Durumu tablosuna yeni satır ekle (⬜ Planlandı)
2. Eğer API çağrısı varsa:
   Domain Layer: lib/domain/repository/xxx_repository.dart → interface
   Data Layer:   lib/data/model/ + lib/data/repository/
   Service:      lib/service/xxx_service.dart
3. Feature Layer:
   lib/feature/<isim>/
   ├── notifier/ + provider/ + view/
   └── widgets/ (2+ widget gerektirirse)
4. Route: app_router.dart'a AutoRoute ekle + Bölüm 7 tablosunu güncelle
5. Faz Durumu tablosunda durumu ✅ Aktif yap
6. Bölüm 15 Değişiklik Geçmişine kayıt ekle
```

### Yeni Global Widget Eklendiğinde

```
1. Önce feature'ın widgets/ klasöründe oluştur
2. İkinci bir yerde kullanılacaksa:
   lib/product/widget/<kategori>/xxx_widget.dart'a taşı
3. Bölüm 2 Global Widget tablosunu ✅ Aktif yap
4. Bölüm 15 Değişiklik Geçmişine kayıt ekle
```

### Yeni Paket Eklendiğinde

```
1. pub.dev'de kontrol: skor > 130, son güncelleme < 6 ay
2. flutter pub add <paket>
3. pubspec.yaml'a yorum satırı ile neden eklendiğini yaz
4. Bölüm 2 tablolarında ilgili satırı ✅ Aktif yap
5. Bölüm 15 Değişiklik Geçmişine kayıt ekle
```

---

## 15. Değişiklik Geçmişi

| Tarih | Değişiklik | Neden |
|---|---|---|
| 2026-03-17 | Proje başlatıldı, Flutter MVP scaffold | Spec 001-nafiesna-mvp |
| 2026-03-17 | Riverpod, AutoRoute, GetIt eklendi | State/DI/Navigation altyapısı |
| 2026-03-17 | AppTheme (dark), AppColors, AppSpacing oluşturuldu | Spec FR-007: Teal+Gold dark theme |
| 2026-03-17 | HomeView (hadis + YouTube kartı) eklendi | Spec FR-001, FR-002 |
| 2026-03-17 | PrayerTimesView eklendi | Spec FR-003 |
| 2026-03-17 | PdfView (SfPdfViewer continuous scroll) eklendi | Spec FR-004 |
| 2026-03-17 | ContentView (kandil takvimi + İslami bilgiler) eklendi | Spec FR-005 |
| 2026-03-17 | AppLoadingIndicator, AppErrorState global widget yapıldı | 2+ feature'da kullanılıyor |
| 2026-03-17 | Kullanılmayan paketler (dio, flutter_secure_storage, flutter_svg, flutter_screenutil) kaldırıldı | Minimal mimari kuralı |
| 2026-03-17 | Boş klasörler (data/, domain/, service/, features/) silindi | Minimal mimari kuralı |
| 2026-03-17 | AppEmptyState silindi | Hiç kullanılmıyordu |
| 2026-03-17 | AlAdhan API (Diyanet metod) → **prayertimes.api.abdus.dev** (direkt Diyanet verisi) | Türkçe dil talebi, daha doğru veri |
| 2026-03-17 | fawazahmed0 Nawawi 40 (İngilizce) → **hadeethenc.com** Türkçe Faziletler kategori | Tüm metin Türkçe, Arapça orijinal + kaynak + derece eklendi |
| 2026-03-17 | HadithCard güncellendi: Arapça metin (RTL), derece rozeti, Türkçe kaynak | Yeni API alanlarını göstermek için |
| 2026-03-17 | İmsak hesabı: fajr - 10 dk (Diyanet API imsak vermiyor) | Türkiye standardı |
| 2026-03-17 | `geolocator` eklendi | GPS konum desteği |
| 2026-03-17 | Nominatim (OSM) ters coğrafi kodlama eklendi | Koordinat → şehir adı |
| 2026-03-17 | `LocationService` oluşturuldu | GPS + Nominatim + Diyanet location search |
| 2026-03-17 | `PrayerTimesService` koordinat bazlı metod eklendi | GPS ile namaz vakti |
| 2026-03-17 | `PrayerTimesNotifier` konum durumu eklendi (`LocationStatus`) | İzin yönetimi |
| 2026-03-17 | `PrayerTimesView` izin banneri + GPS ikonu eklendi | Kullanıcıya konum bilgisi |
| 2026-03-17 | iOS Info.plist + Android Manifest konum izinleri eklendi | Native entegrasyon |
| 2026-03-17 | Konum izni AppInit'e taşındı — uygulama açılışında isteniyor | Kullanıcı deneyimi: erken izin alma |
| 2026-03-17 | **prayertimes.api.abdus.dev** → **ezanvakti.imsakiyem.com** | Diyanet orijinal verisi, imsak dahil, Hicri tarih Türkçe, aktif bakım |
| 2026-03-17 | `fajr - 10 dk` imsak hack'i kaldırıldı | Yeni API imsak saatini doğrudan veriyor |
| 2026-03-17 | Hicri tarih için ayrı Aladhan çağrısı kaldırıldı | Yeni API Hicri tarihi Türkçe dahil ediyor |
| 2026-03-17 | Model Türkçe alanlara geçirildi: gunes, ogle, ikindi, aksam, yatsi | ezanvakti.imsakiyem.com Türkçe response |
| 2026-03-17 | Ana sayfaya `PrayerTimesBar` eklendi (LiveStreamCard altı) | Kompakt vakitler + sonraki vakte geri sayım |
| 2026-03-17 | `chucker_flutter` eklendi — debug HTTP inspector | API isteklerini/yanıtlarını uygulama içinden izleme |
| 2026-03-17 | `intl` ^0.19.0 → ^0.20.2, `syncfusion_flutter_pdfviewer` ^27.1.48 → ^28.2.7 | chucker_flutter uyumluluğu |
| 2026-03-17 | **ezanvakti.imsakiyem.com** kaldırıldı → **api.aladhan.com** tek kaynak | ezanvakti stale veri döndürüyordu (güncellenmemiş), Aladhan her zaman güncel |
| 2026-03-17 | İmsak mapping düzeltildi: Aladhan Fajr → İmsak | Aladhan "Imsak" = Fajr-10dk (yanlış), Diyanet İmsak = Aladhan Fajr (doğru) |
| 2026-03-17 | `diyanetDio` instance kaldırıldı, NetworkConfig 4→3 Dio | ezanvakti API artık kullanılmıyor |
| 2026-03-17 | GPS akışı sadeleştirildi: Nominatim + Aladhan paralel çağrı | 4 ardışık API → GPS + 2 paralel = ~%50 hız artışı |
| 2026-03-17 | `searchDiyanetLocationId` metodu kaldırıldı | Diyanet district_id arama artık gereksiz |
| 2026-03-17 | HadithService sayfa bazlı in-memory cache eklendi | Aynı 20-gün periyodunda 2 API → 1 API çağrısı |
| 2026-03-17 | `IslamicCalendarService` oluşturuldu | Aladhan gToHCalendar API ile canlı dini günler (statik veri kaldırıldı) |
| 2026-03-17 | HijriCalendarCard canlı API'ye bağlandı | Hardcoded event listesi → FutureProvider + API, fallback korundu |
| 2026-03-17 | ContentNotifier canlı API'ye geçirildi | Dini günler artık IslamicCalendarService üzerinden geliyor |
| 2026-03-17 | `compassx ^1.0.1` paketi eklendi (flutter_compass yerine) | True heading, kalibrasyon tespiti, daha stabil pusula |
| 2026-03-17 | `QiblaService` oluşturuldu | Great Circle formülü ile kıble açısı hesaplama (API gerektirmez) |
| 2026-03-17 | Kıble Bulucu (QiblaCompassView) eklendi | Namaz tab'ında pusula UI, canlı yön gösterme, mesafe bilgisi |
| 2026-03-17 | Content tab grid menü yapısına dönüştürüldü | TabBar → 3 sütunlu kart grid (screenshot referanslı) |
| 2026-03-17 | `shared_preferences`, `sqflite`, `path` eklendi | Kazalar + Rüya defteri local storage |
| 2026-03-17 | Dini Günler sayfası eklendi | IslamicCalendarService API'den canlı dini günler listesi |
| 2026-03-17 | Kazalar sayacı eklendi | SharedPreferences ile kalıcı, +/- butonlu, topluca düzenleme |
| 2026-03-17 | Rüya Defteri eklendi | sqflite CRUD, başlık + içerik + tarih, düzenleme + silme |
| 2026-03-17 | Yakın Camiler eklendi | Overpass API (OSM), 3km yarıçap, mesafe, harita yönlendirme |
| 2026-03-17 | İslami Bilgiler ayrı sayfaya taşındı | Content grid menüden erişim |
| 2026-03-17 | Kıble Bulucu tamamen kaldırıldı | QiblaService, QiblaNotifier, QiblaCompassView, compassx paketi silindi |
| 2026-03-17 | Namaz tab'ı → Rüya Defteri tab'ına dönüştürüldü | DreamView oluşturuldu, gül motifli UI, PrayerTimesRoute kaldırıldı |
| 2026-03-17 | Rüya Defteri content menüden kaldırıldı | Artık ana tab olarak erişiliyor |
| 2026-03-17 | Rüya Defteri UI yenilendi | Gül motifi kaldırıldı → hilal-yıldız temalı dini rüya UI, gold accent + dark surface uyumlu |

---

*Bu doküman projeyle birlikte büyür. Bir şey eklenmeden önce buraya yazılır. Buraya yazılmayan şey kod olarak oluşturulmaz.*
