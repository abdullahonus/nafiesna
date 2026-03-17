# Flutter Uygulama Mimarisi — Evrensel Referans Dokümanı

> **Amaç:** Bu doküman, herhangi bir Flutter uygulaması için başlangıç mimarisi ve tasarım kararları referansı olarak kullanılmak üzere hazırlanmıştır.  
> Fintech, e-ticaret, sosyal, sağlık veya kurumsal — her kategorideki uygulama bu şablonu temel alabilir.  
>
> **Versiyon Notu:** Bu dokümandaki paket versiyonları sabit değildir.  
> Her zaman [pub.dev](https://pub.dev) üzerinden güncel, stabil versiyonu kontrol ederek kullanın.  
> Örnek: `flutter pub add riverpod` komutu otomatik olarak güncel versiyonu ekler.

---

## İçindekiler

1. [Mimari Felsefe](#1-mimari-felsefe)
2. [Clean Architecture Katmanları](#2-clean-architecture-katmanları)
3. [Monorepo — Modül Yapısı](#3-monorepo--modül-yapısı)
4. [Klasör & Dosya Yapısı](#4-klasör--dosya-yapısı)
5. [State Management](#5-state-management)
6. [Dependency Injection](#6-dependency-injection)
7. [Navigation](#7-navigation)
8. [Network Katmanı](#8-network-katmanı)
9. [Güvenlik Katmanı](#9-güvenlik-katmanı)
10. [Servisler & 3. Parti Entegrasyonlar](#10-servisler--3-parti-entegrasyonlar)
11. [Uygulama Başlatma Akışı](#11-uygulama-başlatma-akışı)
12. [Oturum Yönetimi](#12-oturum-yönetimi)
13. [Tema & UI Sistemi](#13-tema--ui-sistemi)
14. [Kod Üretimi (Code Generation)](#14-kod-üretimi-code-generation)
15. [Paket Seçim Rehberi](#15-paket-seçim-rehberi)
16. [Performans Optimizasyonları](#16-performans-optimizasyonları)
17. [Test Stratejisi](#17-test-stratejisi)
18. [Geliştirici Kuralları & Checklist](#18-geliştirici-kuralları--checklist)

---

## 1. Mimari Felsefe

Bu mimarinin temelinde üç ilke yatar:

| İlke | Açıklama |
|---|---|
| **Ayrışma (Separation of Concerns)** | Her sınıfın tek bir sorumluluğu olmalı. UI, iş mantığı ve veri erişimi birbirinden bağımsız katmanlarda yaşamalı. |
| **Ölçeklenebilirlik** | Yeni bir feature eklemek mevcut kodu kırmamalı. Her feature kendi mini-mimarisine sahip olmalı. |
| **Test Edilebilirlik** | İş mantığı UI'dan bağımsız olduğu için birim test yazılabilmeli. Repository pattern sayesinde sahte (mock) veri kaynakları kullanılabilmeli. |

### Hangi Uygulama Tiplerine Uygundur?

Bu mimari aşağıdaki uygulama kategorilerinde doğrudan uygulanabilir:

- Fintech / Dijital Cüzdan / Bankacılık
- E-Ticaret / Marketplace
- Sosyal Medya / İçerik
- Sağlık / Fitness Takibi
- Kurumsal / B2B Araçları
- Eğitim / E-Learning
- Haber / Medya
- Ulaşım / Harita Tabanlı

---

## 2. Clean Architecture Katmanları

```
┌──────────────────────────────────────────────────────────────────┐
│                      PRESENTATION LAYER                          │
│                                                                  │
│   lib/feature/**/view/        → Ekranlar (Screen/Page)          │
│   lib/feature/**/notifier/    → State Logic (Notifier)          │
│   lib/feature/**/state/       → State sınıfları (immutable)     │
│   lib/feature/**/provider/    → Riverpod Provider tanımları     │
│   lib/feature/**/viewModel/   → UI hesaplama yardımcıları       │
│   lib/feature/**/widgets/     → Feature'a özgü widget'lar       │
│   lib/product/widget/         → Global paylaşılan widget'lar    │
│                                                                  │
├──────────────────────────────────────────────────────────────────┤
│                        DOMAIN LAYER                              │
│                                                                  │
│   lib/domain/repository/      → Soyut repository arayüzleri    │
│   lib/domain/usecase/         → (Opsiyonel) Use case sınıfları  │
│   lib/domain/entity/          → (Opsiyonel) Domain entity'leri  │
│                                                                  │
│   Bu katman saf Dart'tır — Flutter veya HTTP çerçevesi yok.     │
│                                                                  │
├──────────────────────────────────────────────────────────────────┤
│                         DATA LAYER                               │
│                                                                  │
│   lib/data/repository/        → Repository implementasyonları   │
│   lib/data/model/ (veya dto/) → API DTO / JSON modelleri        │
│   lib/service/                → Remote data source (API)        │
│   lib/product/manager/        → Local data source (Storage)     │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### Bağımlılık Kuralı

> **Dıştaki katmanlar içtekilere bağımlı olabilir; içtekiler dışarilere bağımlı olamaz.**

```
Presentation → Domain ← Data
```

- `Notifier`, `Repository` interface'ini kullanır (implementasyonunu değil).
- `RepositoryImpl`, network veya storage'a doğrudan erişir.
- `Domain` katmanı hiçbir şeye bağımlı değildir.

### Tam Veri Akışı

```
UI Widget (View)
    │  ref.watch(featureProvider)
    ▼
Riverpod Provider
    │  StateNotifierProvider
    ▼
Notifier (business logic)
    │  repository.fetchData()
    ▼
Repository Interface (domain)
    │  implemented by
    ▼
Repository Implementation (data)
    │  service.getData()
    ▼
Service (Dio / GraphQL / local)
    │
    ▼
Remote API   OR   Local Storage
```

---

## 3. Monorepo — Modül Yapısı

Orta ve büyük ölçekli uygulamalarda monorepo yapısı kod paylaşımını, bağımlılık izolasyonunu ve build sürelerini optimize eder.

### Önerilen Yapı

```
my_app/
├── lib/                          # Ana uygulama kodu
├── module/
│   ├── core/                     # Ağ, güvenlik, depolama çekirdeği
│   ├── design_system/            # Tema, renkler, tipografi, temel widget'lar
│   ├── analytics/                # Analytics entegrasyon katmanı
│   └── <domain_module>/          # Büyük bir domain'i izole etmek için
│                                 # Örn: chat/, payments/, maps/
├── ios/
├── android/
├── test/
└── pubspec.yaml
```

### Modül Sorumlulukları

| Modül | İçerik | Bağımlılıklar |
|---|---|---|
| `core` | Network (Dio), SecureStorage, Interceptors, DeviceInfo | Sadece standart Dart/Flutter paketleri |
| `design_system` | Renkler, tipografi, spacing, temel widget'lar, asset gen | `core` hariç bağımsız |
| `analytics` | Analytics olayları, crash reporting arayüzü | `core` |
| `<domain_module>` | Büyük bir iş alanını kapsüller | `core`, `design_system` |

### pubspec.yaml'da Modül Bağlantısı

```yaml
dependencies:
  core:
    path: module/core
  design_system:
    path: module/design_system
```

### Ne Zaman Modüle Ayırmalı?

- Birden fazla uygulamada paylaşılacak kod varsa
- Bir domain belirgin biçimde büyüdüğünde (50+ dosya)
- Bağımsız takımlar aynı anda geliştiriyorsa
- Build sürelerini kısaltmak gerekiyorsa

---

## 4. Klasör & Dosya Yapısı

### `lib/` Tam Yapısı

```
lib/
├── main.dart                           # Uygulama giriş noktası
│
├── data/                               # Data katmanı
│   ├── model/                          # JSON DTO sınıfları
│   │   ├── user_model.dart
│   │   ├── user_model.g.dart           # (generated)
│   │   └── ...
│   └── repository/                     # Repository implementasyonları
│       ├── auth_repository_impl.dart
│       └── ...
│
├── domain/                             # Domain katmanı (saf Dart)
│   ├── repository/                     # Soyut arayüzler
│   │   ├── auth_repository.dart
│   │   ├── repositories.dart           # Tüm export'lar
│   │   └── ...
│   └── usecase/                        # (Opsiyonel) İş kuralları
│       └── login_use_case.dart
│
├── feature/                            # Feature-first organizasyon
│   │
│   ├── auth/                           # Kimlik doğrulama feature grubu
│   │   ├── login/
│   │   │   ├── notifier/
│   │   │   │   ├── login_notifier.dart
│   │   │   │   └── login_state.dart
│   │   │   ├── provider/
│   │   │   │   └── login_provider.dart
│   │   │   ├── view/
│   │   │   │   └── login_view.dart
│   │   │   ├── viewModel/              # (gerektiğinde)
│   │   │   └── widgets/
│   │   ├── register/
│   │   └── reset_password/
│   │
│   ├── home/                           # Ana sayfa feature'ı
│   │   ├── notifier/
│   │   ├── provider/
│   │   ├── view/
│   │   │   ├── home_view.dart
│   │   │   └── component/             # Ekran bileşenleri
│   │   └── widgets/
│   │
│   ├── profile/                        # Profil yönetimi
│   │
│   ├── settings/                       # Ayarlar
│   │
│   ├── <domain_feature>/               # Uygulamaya özgü domain feature'ları
│   │   ├── model/                      # Feature-specific modeller
│   │   ├── notifier/
│   │   │   ├── xxx_notifier.dart
│   │   │   └── xxx_state.dart
│   │   ├── provider/
│   │   │   └── xxx_provider.dart
│   │   ├── view/
│   │   │   └── xxx_view.dart
│   │   └── widgets/
│   │
│   ├── general/                        # Cross-feature paylaşılan state
│   │   ├── notifier/                   # Örn: UserNotifier, ThemeNotifier
│   │   ├── state/
│   │   └── provider/
│   │
│   ├── splash/                         # Splash & Onboarding
│   └── tab/                            # Bottom nav bar scaffold
│
├── service/                            # Remote API servisleri (Dio tabanlı)
│   ├── auth_service.dart
│   └── ...
│
└── product/                            # Uygulama altyapısı
    ├── constants/
    │   ├── app_spacing.dart            # Boşluk sabitleri (4, 8, 16, 24...)
    │   └── app_strings.dart            # Statik string sabitleri
    ├── init/
    │   ├── app_init.dart               # Uygulama başlatma orkestrasyonu
    │   ├── theme/                      # Tema konfigürasyonu
    │   └── network/                    # Ağ ortamı yönetimi
    ├── manager/                        # Singleton yöneticiler
    │   ├── secure_storage_manager.dart
    │   ├── session_manager.dart
    │   ├── notification_manager.dart
    │   └── deeplink_manager.dart
    ├── navigation/
    │   ├── app_router.dart             # Route tanımları
    │   └── app_router.gr.dart          # (generated)
    ├── provider/
    │   └── global_providers.dart       # Uygulama geneli provider'lar
    ├── utility/
    │   ├── enum/                       # Uygulama enumları
    │   ├── extension/                  # Dart extension'ları
    │   │   ├── context_extension.dart
    │   │   ├── string_extension.dart
    │   │   └── num_extension.dart
    │   ├── formatter/                  # Tarih, para, telefon formatlayıcıları
    │   ├── injection/                  # DI konfigürasyonu
    │   │   ├── injection.dart
    │   │   └── injection.config.dart   # (generated)
    │   └── regex/                      # Doğrulama regex'leri
    └── widget/                         # Global reusable widget kataloğu
        ├── button/
        ├── card/
        ├── common/
        │   ├── app_empty_state.dart
        │   ├── app_error_state.dart
        │   └── app_loading_indicator.dart
        ├── dialog/
        ├── textfield/
        └── ...
```

### Feature Klasörü Standart Şablonu

Her feature tam bu yapıyı takip etmelidir — tutarlılık kod okumayı kolaylaştırır:

```
feature/<feature_name>/
├── model/          # Sadece bu feature'a ait veri modelleri
├── notifier/       # XxxNotifier + XxxState
│   ├── xxx_notifier.dart
│   └── xxx_state.dart   VEYA   state/ alt klasörü
├── provider/       # Riverpod provider tanımları
│   └── xxx_provider.dart
├── view/           # Ekran widget'ları (*View)
│   ├── xxx_view.dart
│   └── component/  # Büyük view'ların parçaları
├── viewModel/      # (Gerektiğinde) Saf UI hesaplama mantığı
└── widgets/        # Bu feature'a özgü küçük widget'lar
```

---

## 5. State Management

### Seçilen Yaklaşım: Riverpod + StateNotifier

**Neden Riverpod?**

| Özellik | Açıklama |
|---|---|
| Compile-time güvenlik | Provider'lar tip-güvenli; runtime hatası olmaz |
| Flutter bağımsızlık | `BuildContext` gerekmez; testability artar |
| Otomatik dispose | Ref sayacı ile provider'lar otomatik temizlenir |
| Code generation | `riverpod_generator` ile boilerplate azalır |
| DevTools desteği | Riverpod inspector ile state debug'ı |

### Temel Desenler

#### 1. State Sınıfı (Immutable)

```dart
// Equatable ile value equality sağlanır
class FeatureState extends Equatable {
  const FeatureState({
    this.isLoading = false,
    this.data,
    this.errorMessage,
  });

  final bool isLoading;
  final FeatureData? data;
  final String? errorMessage;

  bool get hasError => errorMessage != null;
  bool get hasData => data != null;

  FeatureState copyWith({
    bool? isLoading,
    FeatureData? data,
    String? errorMessage,
  }) {
    return FeatureState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, data, errorMessage];
}
```

#### 2. Notifier Sınıfı

```dart
class FeatureNotifier extends StateNotifier<FeatureState> {
  FeatureNotifier(this._repository) : super(const FeatureState());

  final FeatureRepository _repository;

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _repository.getData();
      state = state.copyWith(isLoading: false, data: result);
    } on NetworkException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Beklenmedik hata');
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
```

#### 3. Provider Tanımı

```dart
// StateNotifierProvider
final featureProvider = StateNotifierProvider<FeatureNotifier, FeatureState>(
  (ref) => FeatureNotifier(ref.read(featureRepositoryProvider)),
);

// Basit veri için FutureProvider
final userListProvider = FutureProvider.autoDispose<List<User>>(
  (ref) => ref.read(userRepositoryProvider).getUsers(),
);

// Parametre gereken durum için
final itemDetailProvider = FutureProvider.autoDispose
    .family<ItemDetail, String>((ref, id) {
  return ref.read(itemRepositoryProvider).getDetail(id);
});
```

#### 4. View'da Kullanım

```dart
class FeatureView extends ConsumerWidget {
  const FeatureView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sadece ihtiyaç duyulan slice'ı izle → gereksiz rebuild önlenir
    final isLoading = ref.watch(featureProvider.select((s) => s.isLoading));
    final errorMessage = ref.watch(featureProvider.select((s) => s.errorMessage));
    final data = ref.watch(featureProvider.select((s) => s.data));

    if (isLoading) return const AppLoadingIndicator();
    if (errorMessage != null) return AppErrorState(message: errorMessage);
    if (data == null) return const AppEmptyState();

    return FeatureContent(data: data);
  }
}
```

### AsyncValue Yaklaşımı (Riverpod Generator ile)

```dart
// riverpod_generator kullanıldığında daha sade yazım
@riverpod
class FeatureNotifier extends _$FeatureNotifier {
  @override
  Future<FeatureData> build() async {
    return ref.read(featureRepositoryProvider).getData();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

// View'da kullanım
featureNotifierProvider.when(
  data: (data) => FeatureContent(data: data),
  loading: () => const AppLoadingIndicator(),
  error: (e, _) => AppErrorState(message: e.toString()),
);
```

### Global State (Cross-Feature)

```
lib/feature/general/
├── notifier/
│   ├── user_notifier.dart       # Giriş yapmış kullanıcı
│   ├── theme_notifier.dart      # Uygulama teması
│   └── locale_notifier.dart     # Dil/lokalizasyon
└── provider/
    └── global_providers.dart
```

---

## 6. Dependency Injection

**GetIt** (service locator) + **injectable** (kod üretimi) kombinasyonu kullanılır.

### Kurulum

```dart
// lib/product/utility/injection/injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
```

### Kayıt Anotasyonları

```dart
// Singleton — uygulama boyunca tek instance
@singleton
class NetworkManager {
  // ...
}

// Lazy Singleton — ilk kullanımda oluşturulur
@lazySingleton
class SecureStorageManager {
  // ...
}

// Transient — her çağrıda yeni instance
@injectable
class FeatureRepositoryImpl implements FeatureRepository {
  FeatureRepositoryImpl(this._service);
  final FeatureService _service;
}

// Factory (async init gerektiğinde)
@module
abstract class AppModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
```

### Kod Üretimi

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### DI ile Repository Binding

```dart
@Injectable(as: FeatureRepository) // Interface'e bind et
class FeatureRepositoryImpl implements FeatureRepository {
  // ...
}

// Riverpod provider içinde getIt'ten al
final featureRepositoryProvider = Provider<FeatureRepository>(
  (ref) => getIt<FeatureRepository>(),
);
```

---

## 7. Navigation

**auto_route** ile tip-güvenli, declarative navigasyon.

### Yapılandırma

```dart
// lib/product/navigation/app_router.dart
@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    // İlk açılış
    AutoRoute(page: SplashRoute.page, initial: true),

    // Auth akışı
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(page: OtpVerificationRoute.page),

    // Ana uygulama — tab tabanlı
    AutoRoute(
      path: '/',
      page: MainScaffoldRoute.page,
      children: [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: SearchRoute.page),
        AutoRoute(page: ProfileRoute.page),
      ],
    ),

    // Feature route'ları
    AutoRoute(page: ItemDetailRoute.page),
    AutoRoute(page: SettingsRoute.page),

    // Özel geçiş animasyonu
    CustomRoute<void>(
      page: ModalRoute.page,
      transitionsBuilder: TransitionsBuilders.slideBottom,
    ),
  ];
}
```

### Navigator Injection

```dart
// GetIt ile kayıt
getIt.registerSingleton<AppRouter>(AppRouter());

// Kullanım (herhangi bir yerden)
getIt<AppRouter>().push(const ItemDetailRoute(id: '123'));
getIt<AppRouter>().replace(const LoginRoute());
getIt<AppRouter>().pushAndPopUntil(
  const HomeRoute(),
  predicate: (_) => false, // Tüm stack temizle
);
```

### Deeplink & Push Notification Yönlendirmesi

```
Deeplink / Push Notification Geldi
    │
    ▼
NotificationManager / DeeplinkManager
    │
    ▼
RouteMapper (URI veya payload → AutoRoute)
    │
    ▼
AppRouter.push(targetRoute)
```

---

## 8. Network Katmanı

### Yapı (module/core/lib/network/)

```
network/
├── base/
│   ├── base_network_manager.dart   # Soyut ağ yöneticisi
│   └── base_service.dart           # Tüm servislerin base sınıfı
├── config/
│   ├── network_config.dart         # Singleton — Dio instance yönetimi
│   └── network_options.dart        # SSL, retry, timeout seçenekleri
├── interceptors/
│   ├── auth_interceptor.dart       # JWT token ekleme / yenileme
│   ├── error_interceptor.dart      # HTTP hata yönetimi, 401 handling
│   └── logging_interceptor.dart    # Debug log
├── manager/
│   └── network_manager.dart        # Dio singleton
├── model/
│   ├── api_response.dart           # Generic wrapper
│   └── network_exception.dart      # Tip-güvenli hata modeli
└── security/
    └── ssl_pinning_adapter.dart    # Certificate pinning
```

### Generic API Response

```dart
class ApiResponse<T> {
  const ApiResponse({
    this.success,
    this.data,
    this.message,
    this.statusCode,
    this.errors,
  });

  final bool? success;
  final T? data;
  final String? message;
  final int? statusCode;
  final List<String>? errors;

  bool get isSuccess => success == true && statusCode != null && statusCode! < 400;
}
```

### Servis Base Sınıfı

```dart
abstract class BaseService {
  BaseService(this._networkManager);
  final NetworkManager _networkManager;

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _networkManager.dio.get(
        path,
        queryParameters: queryParameters,
      );
      return ApiResponse(
        success: true,
        data: fromJson != null ? fromJson(response.data) : response.data as T,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw NetworkException.fromDio(e);
    }
  }

  // post, put, delete... aynı pattern
}
```

### Interceptor Zinciri

```
Her Request:
  AuthInterceptor     → Bearer token header'a ekle
  LoggingInterceptor  → Debug modda request/response logla
  [API Call]
  ErrorInterceptor    → 401 → token refresh veya logout
                      → 5xx → NetworkException fırlat
                      → timeout → TimeoutException
```

### Ortam (Environment) Yönetimi

```dart
enum AppEnvironment { dev, preprod, prod }

// Build-time ile seçim (--dart-define ile)
// flutter run --dart-define=ENV=prod

class EnvironmentManager {
  static late AppEnvironment environment;
  static late String apiBaseUrl;

  static void init() {
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');
    switch (env) {
      case 'prod':
        environment = AppEnvironment.prod;
        apiBaseUrl = 'https://api.myapp.com';
      case 'preprod':
        environment = AppEnvironment.preprod;
        apiBaseUrl = 'https://api-preprod.myapp.com';
      default:
        environment = AppEnvironment.dev;
        apiBaseUrl = 'https://api-dev.myapp.com';
    }
  }
}
```

---

## 9. Güvenlik Katmanı

### Temel Güvenlik Bileşenleri

Her uygulama kategorisi için önerilen minimum güvenlik seti:

| Bileşen | Paket | Uygulama Tipi |
|---|---|---|
| Güvenli depolama | `flutter_secure_storage` | Tüm uygulamalar |
| Biyometrik kimlik | `local_auth` | Hassas veri içerenler |
| SSL Pinning | `dio` + custom adapter | Fintech, Sağlık |
| Jailbreak/Root tespiti | `safe_device` | Fintech, Ödeme |
| Uygulama blur (arka plan) | Custom widget | Fintech, Sağlık |
| Certificate Transparency | Remote Config | Kurumsal |

### Güvenli Depolama Hiyerarşisi

```dart
// Hassas veriler → flutter_secure_storage (Keychain/Keystore)
class SecureStorageManager {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) =>
      _storage.write(key: 'access_token', value: token);

  Future<String?> getToken() =>
      _storage.read(key: 'access_token');

  Future<void> deleteToken() =>
      _storage.delete(key: 'access_token');

  Future<void> clearAll() => _storage.deleteAll();
}

// Hassas olmayan veriler → shared_preferences
class SharedManager {
  final SharedPreferences _prefs;
  SharedManager(this._prefs);

  bool get isOnboardingShown => _prefs.getBool('onboarding_shown') ?? false;
  Future<void> setOnboardingShown() => _prefs.setBool('onboarding_shown', true);
}
```

### Ekran Güvenliği (Arka Plan Blur)

```dart
// Uygulama arka plana gittiğinde içeriği gizle
class AppSecurityWrapper extends StatefulWidget {
  const AppSecurityWrapper({required this.child, super.key});
  final Widget child;

  @override
  State<AppSecurityWrapper> createState() => _AppSecurityWrapperState();
}

class _AppSecurityWrapperState extends State<AppSecurityWrapper>
    with WidgetsBindingObserver {
  bool _isBackground = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _isBackground = state == AppLifecycleState.paused ||
                      state == AppLifecycleState.inactive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isBackground)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: const ColoredBox(color: Colors.transparent),
          ),
      ],
    );
  }
}
```

---

## 10. Servisler & 3. Parti Entegrasyonlar

### Entegrasyon Önerileri (Uygulama Kategorisine Göre)

#### Tüm Uygulamalar

| Servis | Önerilen Paket | Amaç |
|---|---|---|
| Analytics | `firebase_analytics` | Kullanıcı davranışı |
| Crash Reporting | `firebase_crashlytics` | Hata takibi |
| Push Notification | `firebase_messaging` | Bildirimler |
| Remote Config | `firebase_remote_config` | Feature flag, dinamik config |
| Logging | `logger` paketi veya `dart:developer` | Debug log |

#### E-Ticaret / Marketplace

| Servis | Paket | Amaç |
|---|---|---|
| Ödeme | `in_app_purchase` veya entegrasyon | Satın alma |
| Harita | `flutter_map` / `google_maps_flutter` | Mağaza/teslimat |
| Kamera/Barkod | `mobile_scanner` | Ürün tarama |

#### Sosyal / İçerik

| Servis | Paket | Amaç |
|---|---|---|
| Paylaşım | `share_plus` | İçerik paylaşımı |
| Fotoğraf | `image_picker` | Profil/içerik fotoğrafı |
| Video | `video_player` | İçerik oynatma |
| Önbellekli görsel | `cached_network_image` | Performans |

#### Fintech / Ödeme

| Servis | Paket | Amaç |
|---|---|---|
| Biyometrik | `local_auth` | Kimlik doğrulama |
| Güvenli depolama | `flutter_secure_storage` | Token/anahtar saklama |
| QR Kod | `mobile_scanner` + `qr_flutter` | Ödeme QR'ı |
| SSL Pinning | Custom Dio adapter | Man-in-the-middle önlemi |

#### Sağlık / Fitness

| Servis | Paket | Amaç |
|---|---|---|
| Sağlık verileri | `health` | HealthKit / Health Connect |
| Bildirim | `flutter_local_notifications` | Hatırlatma |
| Sensör | `sensors_plus` | Adım sayar |

### Firebase Entegrasyon Yapısı

```
lib/product/init/firebase/
├── firebase_manager.dart           # init(), initCrashlytics()
├── firebase_analytics_service.dart # Olay loglama arayüzü
├── firebase_remote_config_service.dart # Feature flag okuma
└── firebase_options.dart           # (generated by FlutterFire CLI)
```

```dart
// Analitik olayları için soyutlama — vendor bağımsız
abstract class AnalyticsService {
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters});
  Future<void> setUserId(String userId);
  Future<void> logScreenView(String screenName);
}

@singleton
class FirebaseAnalyticsServiceImpl implements AnalyticsService {
  // FirebaseAnalytics implementasyonu
}
```

### Push Bildirim Akışı

```
FCM / OneSignal Push Geldi
    │
    ▼
NotificationManager.handleMessage(payload)
    │
    ▼
NotificationRouteMapper.map(payload) → AutoRoute
    │
    ▼
AppRouter.push(route)
```

---

## 11. Uygulama Başlatma Akışı

### AppInit Orkestrasyonu

```dart
// lib/product/init/app_init.dart
class AppInit {
  static Future<void> make() async {
    // 1. Flutter binding
    WidgetsFlutterBinding.ensureInitialized();

    // 2. Ortam & lokalizasyon
    EnvironmentManager.init();
    await initializeDateFormatting();

    // 3. Dependency injection
    await configureDependencies();

    // 4. Firebase (hata olsa dahi devam et)
    try {
      await FirebaseManager.instance.init();
    } catch (e) {
      debugPrint('Firebase init failed: $e');
    }

    // 5. Ağ konfigürasyonu
    await NetworkConfig.instance.init(
      baseUrl: EnvironmentManager.apiBaseUrl,
    );

    // 6. Push bildirim servisi
    await NotificationManager().init();

    // 7. Deeplink servisi
    await DeeplinkManager().initialize();
  }
}
```

### main.dart

```dart
void main() async {
  await AppInit.make();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = getIt<AppRouter>();
    final themeMode = ref.watch(themeProvider);

    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 14 base size
      builder: (_, child) => MaterialApp.router(
        routerConfig: router.config(),
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        debugShowCheckedModeBanner: false,
        builder: (context, child) => MediaQuery(
          // Sistem font büyütmeyi devre dışı bırak
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child!,
        ),
      ),
    );
  }
}
```

---

## 12. Oturum Yönetimi

### Session Timeout

```dart
// lib/product/manager/session_timeout_manager.dart
class SessionTimeoutManager {
  static final SessionTimeoutManager I = SessionTimeoutManager._();
  SessionTimeoutManager._();

  static const Duration _idleTimeout = Duration(minutes: 10);
  static const Duration _warningTime = Duration(minutes: 9);

  Timer? _timer;
  VoidCallback? onShowWarning;
  VoidCallback? onTimeout;

  void configure({
    required VoidCallback onShowWarning,
    required VoidCallback onTimeout,
  }) {
    this.onShowWarning = onShowWarning;
    this.onTimeout = onTimeout;
  }

  void registerUserInteraction() => _resetTimer();

  void onPaused() => _timer?.cancel();
  void onResumed() => _resetTimer();

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(_warningTime, () {
      onShowWarning?.call();
      Timer(_idleTimeout - _warningTime, () => onTimeout?.call());
    });
  }

  void stop() => _timer?.cancel();
}
```

### Session Invalidation (401 Auto-Logout)

```dart
// ErrorInterceptor içinde
if (response.statusCode == 401) {
  await SecureStorageManager().deleteToken();
  SessionTimeoutManager.I.stop();
  getIt<AppRouter>().pushAndPopUntil(
    const LoginRoute(),
    predicate: (_) => false,
  );
}
```

### Lifecycle Yönetimi (main.dart)

```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  switch (state) {
    case AppLifecycleState.paused:
    case AppLifecycleState.inactive:
      SessionTimeoutManager.I.onPaused();
      _showSecurityBlur = true;
    case AppLifecycleState.resumed:
      SessionTimeoutManager.I.onResumed();
      _showSecurityBlur = false;
    default:
      break;
  }
  setState(() {});
}
```

---

## 13. Tema & UI Sistemi

### Tema Yapısı

```
lib/product/init/theme/
├── app_theme.dart           # ThemeData fabrikası
├── app_colors.dart          # Renk paleti (Color constants)
├── app_text_styles.dart     # Tipografi sistemi
├── app_spacing.dart         # Spacing sabitleri (4, 8, 12, 16, 24, 32...)
└── app_shadows.dart         # Gölge tanımları
```

### Renk Sistemi

```dart
// Semantic renk isimlendirme — component değil anlam
abstract class AppColors {
  // Brand
  static const Color primary = Color(0xFF...);
  static const Color primaryVariant = Color(0xFF...);
  static const Color secondary = Color(0xFF...);

  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Surface
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Text
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
}
```

### Spacing Sistemi

```dart
abstract class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;
}

// Kullanım
Padding(
  padding: const EdgeInsets.all(AppSpacing.lg),
  child: ...,
)
```

### Responsive Tasarım

```dart
// flutter_screenutil ile — Design size'ı cihaz boyutuna göre ayarla
ScreenUtilInit(
  designSize: const Size(390, 844), // iPhone 14 baz boyutu
  minTextAdapt: true,
  splitScreenMode: true,
)

// Kullanım
Container(
  width: 200.w,    // Genişliğe orantılı
  height: 100.h,   // Yüksekliğe orantılı
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 16.sp), // Yazı tipi orantılı
  ),
)
```

### Global Widget Kataloğu — Zorunlu Minimum Set

```
lib/product/widget/
├── common/
│   ├── app_loading_indicator.dart  # Yükleme göstergesi
│   ├── app_empty_state.dart        # Boş liste/durum
│   ├── app_error_state.dart        # Hata gösterimi
│   └── app_network_image.dart      # Önbellekli ağ görseli
├── button/
│   ├── app_primary_button.dart     # Ana CTA düğmesi
│   ├── app_secondary_button.dart   # İkincil düğme
│   └── app_icon_button.dart        # İkon düğmesi
├── textfield/
│   ├── app_text_field.dart         # Standart metin alanı
│   └── app_search_field.dart       # Arama alanı
├── dialog/
│   ├── app_bottom_sheet.dart       # Modal bottom sheet
│   ├── app_dialog.dart             # Alert dialog
│   └── app_snackbar.dart           # Bildirim bar
└── card/
    └── app_card.dart               # Temel kart bileşeni
```

---

## 14. Kod Üretimi (Code Generation)

### Araçlar ve Amaçları

| Araç | Komut | Üretilen Dosya | Amaç |
|---|---|---|---|
| `json_serializable` | `build_runner` | `*.g.dart` | JSON serialize/deserialize |
| `auto_route_generator` | `build_runner` | `app_router.gr.dart` | Tip-güvenli route sınıfları |
| `injectable_generator` | `build_runner` | `injection.config.dart` | DI kayıt kodu |
| `riverpod_generator` | `build_runner` | `*.g.dart` | Provider boilerplate azaltma |
| `flutter_gen` | `fluttergen` | `assets.gen.dart` | Tip-güvenli asset/renk |

### Tek Komut ile Tüm Üretim

```bash
# Temizleyerek yeniden üret (CI/CD için ideal)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (geliştirme sırasında)
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Model Şablonu

```dart
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'user_model.g.dart';  // generated

@JsonSerializable()
class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.name,
    this.email,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String? email;

  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [id, name, email, avatarUrl];
}
```

---

## 15. Paket Seçim Rehberi

> **Versiyon Notu:** Aşağıdaki paketler için her zaman `pub.dev` üzerinden güncel versiyonu kontrol edin.  
> Komut: `flutter pub add <package_name>` → en son stabil versiyonu otomatik ekler.

### Temel Altyapı (Her Projede)

| Kategori | Paket | Neden |
|---|---|---|
| **State** | `flutter_riverpod` + `riverpod_generator` | Tip-güvenli, test edilebilir, compile-time hata yakalama |
| **DI** | `get_it` + `injectable` | Lightweight, Flutter bağımsız, kod üretimiyle kolay kayıt |
| **Navigation** | `auto_route` | Tip-güvenli parametreler, nested routing, kod üretimi |
| **Network** | `dio` | Interceptor, timeout, SSL pinning desteği |
| **Local Storage** | `shared_preferences` | Basit key-value depolama |
| **Secure Storage** | `flutter_secure_storage` | Keychain/Keystore tabanlı güvenli depolama |
| **JSON** | `json_serializable` + `json_annotation` | Kod üretimi, null-safety uyumlu |
| **Value Equality** | `equatable` | State değişimi tespiti için |
| **Responsive** | `flutter_screenutil` | Multi-device UI tutarlılığı |
| **SVG** | `flutter_svg` | Vektörel ikon/görsel desteği |
| **Lokalizasyon** | `intl` | Tarih/para formatı, çoklu dil |

### Firebase (Uzaktan Kontrol Gerektiren Her Projede)

| Paket | Amaç |
|---|---|
| `firebase_core` | Firebase başlatma |
| `firebase_analytics` | Kullanıcı olayları takibi |
| `firebase_crashlytics` | Crash raporlama |
| `firebase_messaging` | Push bildirimleri |
| `firebase_remote_config` | Feature flag / dinamik config |

### Opsiyonel (Kategoriye Göre)

| Kategori | Paket |
|---|---|
| Grafik / Chart | `fl_chart` |
| Harita | `flutter_map` (OSM) veya `google_maps_flutter` |
| Kamera / QR | `mobile_scanner` |
| Görsel Seçici | `image_picker` |
| Görsel Önbellek | `cached_network_image` |
| Biyometrik | `local_auth` |
| Paylaşım | `share_plus` |
| URL Açma | `url_launcher` |
| WebView | `webview_flutter` |
| PDF Görüntüleme | `syncfusion_flutter_pdfviewer` |
| PIN / OTP Input | `pinput` |
| Video | `video_player` |
| Carousel | `carousel_slider` |
| Animasyon | `animate_do` |
| İzin Yönetimi | `permission_handler` |
| Rehber Erişimi | `flutter_contacts` |
| Deeplink | `app_links` |

### Paket Değerlendirme Kriterleri

Bir paketi eklemeden önce şunları kontrol et:

```
✅ pub.dev skoru > 130 puan mı?
✅ Son güncelleme 6 aydan eski değil mi?
✅ Null safety destekli mi?
✅ Aktif issue çözümü var mı?
✅ Popüler maintainer veya resmi Flutter ekibi mi?
✅ Alternatifler değerlendirildi mi?
✅ Core Flutter/Dart ile aynı işi yapabilir miyim?
```

---

## 16. Performans Optimizasyonları

### Widget Rebuild Azaltma

```dart
// ✅ Doğru: Sadece ilgili state slice'ını izle
final isLoading = ref.watch(
  featureProvider.select((state) => state.isLoading),
);

// ❌ Yanlış: Tüm state'i izlemek → herhangi bir değişimde rebuild
final state = ref.watch(featureProvider);
```

### Const Constructor

```dart
// ✅ Doğru: const constructor widget'ı cache'ler
class MyWidget extends StatelessWidget {
  const MyWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppLoadingIndicator(), // const → rebuild'den muaf
        Text(title),
      ],
    );
  }
}
```

### Liste Performansı

```dart
// ✅ ListView.builder ile lazy render
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ItemCard(
      key: ValueKey(items[index].id), // Stabil key → doğru diff
      item: items[index],
    );
  },
)

// Büyük listelerde sayfalama
ref.watch(itemListProvider(page: _currentPage))
```

### Görsel Optimizasyonu

```dart
// Ağ görseli önbellekleme
Image.network(
  url,
  cacheWidth: 200,  // Decode boyutunu sınırla → bellek tasarrufu
  cacheHeight: 200,
)

// SVG kullanımında const
const SvgPicture.asset(Assets.icons.arrowRight)
```

### Başlatma Performansı

```dart
// Adımları ölçerek darboğaz bul
class PerformanceMonitor {
  static final Map<String, Duration> _timings = {};

  static Future<void> measureAsync(
    String label,
    Future<void> Function() action,
  ) async {
    final sw = Stopwatch()..start();
    await action();
    sw.stop();
    _timings[label] = sw.elapsed;
  }

  static void printReport() {
    final sorted = _timings.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    for (final entry in sorted) {
      debugPrint('⏱ ${entry.key}: ${entry.value.inMilliseconds}ms');
    }
  }
}
```

### Text Scaling Kontrolü

```dart
// Sistem font büyütmesini uygulama düzeyinde devre dışı bırak
// (UI layout bozulması önleme)
MediaQuery(
  data: MediaQuery.of(context).copyWith(
    textScaler: TextScaler.noScaling,
  ),
  child: child,
)
```

---

## 17. Test Stratejisi

### Test Piramidi

```
         ┌──────────────────┐
         │   Integration    │  ← Az sayıda, kritik user flow'lar
         │     Tests        │
        ┌┴──────────────────┴┐
        │   Widget Tests     │ ← Orta düzey, önemli widget'lar
       ┌┴────────────────────┴┐
       │     Unit Tests       │ ← Çok sayıda, tüm business logic
       └──────────────────────┘
```

### Unit Test — Notifier Testi

```dart
// test/feature/auth/login_notifier_test.dart
void main() {
  late LoginNotifier notifier;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    notifier = LoginNotifier(mockRepository);
  });

  group('LoginNotifier', () {
    test('initial state is correct', () {
      expect(notifier.state, const LoginState());
      expect(notifier.state.isLoading, false);
    });

    test('login success updates state correctly', () async {
      when(mockRepository.login(any, any))
          .thenAnswer((_) async => const LoginModel(token: 'test_token'));

      await notifier.login('user@test.com', 'password');

      expect(notifier.state.isLoading, false);
      expect(notifier.state.errorMessage, null);
    });

    test('login failure sets error message', () async {
      when(mockRepository.login(any, any))
          .thenThrow(NetworkException(message: 'Unauthorized'));

      await notifier.login('user@test.com', 'wrong_password');

      expect(notifier.state.isLoading, false);
      expect(notifier.state.errorMessage, isNotNull);
    });
  });
}
```

### Widget Test

```dart
// test/product/widget/app_primary_button_test.dart
void main() {
  testWidgets('AppPrimaryButton shows loading when isLoading is true',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppPrimaryButton(
            label: 'Submit',
            isLoading: true,
            onPressed: null,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Submit'), findsNothing);
  });
}
```

### Repository Mock

```dart
// test/mock/mock_repositories.dart
@GenerateMocks([
  AuthRepository,
  UserRepository,
  FeatureRepository,
])
void main() {}

// Kullanım: build_runner ile mock sınıfları üretilir
// flutter pub run build_runner build
```

### Test Dizin Yapısı

```
test/
├── feature/
│   ├── auth/
│   │   ├── login_notifier_test.dart
│   │   └── register_notifier_test.dart
│   └── home/
│       └── home_notifier_test.dart
├── product/
│   └── widget/
│       ├── app_button_test.dart
│       └── app_text_field_test.dart
├── mock/
│   ├── mock_repositories.dart
│   └── mock_repositories.mocks.dart  # (generated)
└── widget_test.dart
```

---

## 18. Geliştirici Kuralları & Checklist

### Naming Conventions

| Tür | Kural | Örnek |
|---|---|---|
| Sınıflar | `PascalCase` | `LoginNotifier`, `UserModel` |
| Dosyalar | `snake_case` | `login_notifier.dart` |
| Değişkenler & metodlar | `camelCase` | `isLoading`, `fetchData()` |
| Sabitler | `camelCase` veya `SCREAMING_SNAKE` | `appName` veya `API_TIMEOUT` |
| Boolean | `is/has/can/should` prefix | `isLoading`, `hasError`, `canSubmit` |
| Enum değerleri | `camelCase` | `AppEnvironment.dev` |
| Notifier | `XxxNotifier` | `LoginNotifier` |
| State | `XxxState` | `LoginState` |
| Provider | `xxxProvider` | `loginProvider` |
| View | `XxxView` | `LoginView` |
| Service | `XxxService` | `AuthService` |
| Repository | `XxxRepository` / `XxxRepositoryImpl` | `AuthRepositoryImpl` |

### Kod Kalite Kuralları

```yaml
# pubspec.yaml — dev dependency
dev_dependencies:
  very_good_analysis: latest  # Katı lint kuralları
  # veya
  flutter_lints: latest       # Resmi Flutter lint kuralları
```

```
Fonksiyonlar   : ≤ 20 satır, tek sorumluluk prensibi
Sınıflar       : ≤ 200 satır; büyüdüğünde parçala
Parametre      : Bir fonksiyona ≤ 4 parametre; çoksa class kullan
Nesting        : ≤ 3 iç içe seviye; early return kullan
dynamic/var    : KULLANMA — explicit type zorunlu
Null assertion : ! operatöründen kaçın; ?. ve ?? kullan
Magic number   : Sabit (const) tanımla, doğrudan sayı yazma
```

### Early Return Prensibi

```dart
// ❌ Kötü: Derin nesting
Future<void> processOrder(Order? order) async {
  if (order != null) {
    if (order.isValid) {
      if (order.items.isNotEmpty) {
        await _repository.save(order);
      }
    }
  }
}

// ✅ İyi: Early return ile düz akış
Future<void> processOrder(Order? order) async {
  if (order == null) return;
  if (!order.isValid) return;
  if (order.items.isEmpty) return;

  await _repository.save(order);
}
```

### Commit Öncesi Checklist

```
ARCHITECTURE (Mimari)
- [ ] Clean architecture katmanları doğru mu? (UI → Domain → Data)
- [ ] Business logic widget'ta değil notifier'da mı?
- [ ] Repository interface kullanıldı mı (impl değil)?
- [ ] Yeni servis DI'a kaydedildi mi?

STATE MANAGEMENT (State Yönetimi)
- [ ] State sınıfı immutable mi (copyWith var mı)?
- [ ] Loading + error + data state'leri yönetiliyor mu?
- [ ] ref.watch sadece build() içinde mi kullanıldı?
- [ ] ref.watch yerine select() ile optimizasyon yapıldı mı?

PERFORMANCE (Performans)
- [ ] const constructor'lar kullanıldı mı?
- [ ] Listelerde ValueKey kullanıldı mı?
- [ ] Async operasyonlar try/catch ile sarmalandı mı?

SECURITY (Güvenlik)
- [ ] Hassas veri secure storage'da mı?
- [ ] API key / secret kod içinde hard-code değil mi?
- [ ] Token loglarda görünmüyor mu?

CODE QUALITY (Kod Kalitesi)
- [ ] Tüm tipler explicit mi? (dynamic/var yok)
- [ ] Lint hataları temizlendi mi?
- [ ] Magic number sabit olarak tanımlandı mı?
- [ ] Fonksiyon ≤ 20 satır mı?

TEST (Test)
- [ ] Business logic için unit test yazıldı mı?
- [ ] Edge case'ler test edildi mi?
```

### Yeni Feature Ekleme Adımları

```
1. Domain Layer
   └── lib/domain/repository/xxx_repository.dart  → Interface tanımla

2. Data Layer
   ├── lib/data/model/xxx_model.dart               → DTO / Model
   ├── lib/data/model/xxx_model.g.dart             → build_runner ile üret
   └── lib/data/repository/xxx_repository_impl.dart → Implementasyon

3. Service Layer
   └── lib/service/xxx_service.dart                → Dio HTTP çağrıları

4. DI Kaydı
   └── injectable anotasyon ekle → build_runner çalıştır

5. Feature Layer
   └── lib/feature/<name>/
       ├── notifier/xxx_notifier.dart + xxx_state.dart
       ├── provider/xxx_provider.dart
       ├── view/xxx_view.dart
       └── widgets/

6. Navigation
   └── lib/product/navigation/app_router.dart  → AutoRoute ekle → build_runner

7. Test
   └── test/feature/<name>/xxx_notifier_test.dart
```

### Yeni Modül Ekleme Adımları

```
1. module/<module_name>/ klasörü oluştur
2. module/<module_name>/pubspec.yaml tanımla
3. Ana pubspec.yaml'a path dependency ekle
4. Module içinde lib/<module_name>.dart barrel export dosyası oluştur
5. Ana uygulamada import 'package:<module_name>/<module_name>.dart'
```

---

## Notlar & Geliştirme Notları

### Genel Teknik Borç Yönetimi

- Paket versiyonlarını 3 ayda bir kontrol et ve güncelle
- `flutter pub outdated` komutu ile güncelleme gereken paketleri listele
- Breaking change içeren güncelleme öncesi migration guide oku
- `analysis_options.yaml` lint kurallarını proje büyüdükçe sıkılaştır
- `provider` paketinden `flutter_riverpod`'a geçiş yol haritasını belgele

### Ölçeklenme Kararları

```
< 10 feature     → Tekli paket yapısı (module/ gerekmez)
10–30 feature    → Core ve design_system modüllerine ayır
30+ feature      → Domain bazlı modüllere ayır
Birden fazla app → Monorepo + paylaşılan modüller
```

### Güvenlik Güncellemeleri

- SSL sertifika hashini hard-code etme → Remote Config kullan
- `flutter pub audit` ile güvenlik açıkları olan paketleri kontrol et
- Üretim buildlerinde `kDebugMode` kontrollü code path'leri temizle

---

*Bu doküman bir mimari şablon olarak hazırlanmıştır. Projeye özgü kararlar buraya eklenerek yaşayan bir doküman haline getirilmelidir. Her büyük mimari değişiklikte güncellenmelidir.*
