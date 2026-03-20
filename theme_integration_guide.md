# Flutter Riverpod & SharedPreferences ile Kapsamlı Dark/Light Tema Mimarisi Entegrasyon Rehberi

Bu doküman, Teorikort projesinde kullanılan modern ve reaktif dark/light tema yönetim yapısını analiz eder ve bu yapının başka bir normal Flutter (v3+) projesine sıfırdan nasıl entegre edilip çalıştırılacağını adım adım detaylı olarak açıklar.

---

## 🏗 Mimari Analizi

Tema yapısı temelde üç ana bileşenden (dosyadan) oluşur:

1. **[AppColors](file:///Users/abdullahonus/Desktop/TK/Teorikort/lib/core/theme/app_colors.dart#3-33)** ([app_colors.dart](file:///Users/abdullahonus/Desktop/TK/Teorikort/lib/core/theme/app_colors.dart)): Uygulamanın temel renk paletinin Light ve Dark modlar için ayrı gruplarla tanımlandığı yerdir. Tamamen sabit (`static const`) değişkenler içerir ve tek bir kaynaktan yönetimi sağlar.
2. **[AppTheme](file:///Users/abdullahonus/Desktop/TK/Teorikort/lib/core/theme/app_theme.dart#5-305)** ([app_theme.dart](file:///Users/abdullahonus/Desktop/TK/Teorikort/lib/core/theme/app_theme.dart)): Flutter'ın Material 3 (`ThemeData`) tasarım prensibini kullanarak bileşen düzeyinde (Card, AppBar, Buttonlar vb.) detaylı yapılandırıldığı yerdir. [AppColors](file:///Users/abdullahonus/Desktop/TK/Teorikort/lib/core/theme/app_colors.dart#3-33) değişkenlerini `ColorScheme` haritasına bağlar, böylece projede custom override'lara ihtiyaç bırakmadan her yerden standart `Theme.of(context)` ile ulaşılabilir.
3. **`ThemeProvider`** ([theme_provider.dart](file:///Users/abdullahonus/Desktop/TK/Teorikort/lib/core/providers/theme_provider.dart)): **Flutter Riverpod** tabanlı bir state management yapısıdır. Değişen temayı state olarak tutarken eş zamanlı olarak **SharedPreferences** paketi yardımıyla bellekte saklar. Böylece uygulama tekrar başlatıldığında en son seçilmiş temanın hatırlanmasını sağlar.

---

## 🚀 Entegrasyon Adımları

Bu güçlü tema yapısını başka bir projeye entegre etmek için aşağıdaki adımları sırasıyla uygulayabilirsiniz.

### 1️⃣ Gereksinimleri Yükleme

Uygulamanın çalışması için state yönetimi ve verilerin önbellekte saklanmasını sağlayacak paketlere ihtiyacınız var. Terminalinizi açın ve `pubspec.yaml` dosyasının bulunduğu dizinde aşağıdaki komutu çalıştırın:

```bash
flutter pub add flutter_riverpod shared_preferences
```

### 2️⃣ Dosya Yapısını Hazırlama

Temiz bir mimari için standart olarak aşağıdaki gibi bir dosya yapısı kullanmanız önerilir:

```
lib/
 └── core/
      ├── theme/
      │    ├── app_colors.dart
      │    └── app_theme.dart
      └── providers/
           └── theme_provider.dart
```

---

### 3️⃣ [app_colors.dart](file:///Users/abdullahonus/Desktop/TK/Teorikort/lib/core/theme/app_colors.dart) (Renk Paleti)

Tüm renklerin merkezi kaynağıdır. Hem Light hem de Dark tema hex kodlarını barındırır. Yeni bir dosyaya aşağıdaki içeriği ekleyin:

```dart
// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // ─── Light Tema Renkleri ────────────────────────────────────────────────
  static const primary = Color(0xFF2ABAAB);
  static const primaryLight = Color(0xFF4ECDC4);
  static const secondary = Color(0xFF1FA89A);
  static const error = Color(0xFFE53935);

  static const background = Color(0xFFFFFFFF);
  static const cardBackground = Color(0xFFF5F7F7);
  static const surfaceVariant = Color(0xFFE8F5F4);
  
  static const textPrimary = Color(0xFF1A2E35);
  static const textSecondary = Color(0xFF7B9099);

  // ─── Dark Tema Renkleri ─────────────────────────────────────────────────
  static const backgroundDark = Color(0xFF0D1F24);
  static const cardBackgroundDark = Color(0xFF162830);
  static const textPrimaryDark = Color(0xFFE0F2F1);
  static const textSecondaryDark = Color(0xFF80CBC4);
}
```

---

### 4️⃣ [app_theme.dart](file:///Users/abdullahonus/Desktop/TK/Teorikort/lib/core/theme/app_theme.dart) (ThemeData Tanımlamaları)

ThemeData nesnelerini projeniz için yapılandırdığınız alandır. Dikkat edilmesi gereken en önemli nokta, `ColorScheme` ayarı ve her bir widget tipine özel (Örn; AppBar, ElevatedButton, TextFormField) genel görünümün Material 3 aracılığıyla verilmesidir.

```dart
// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  
  // ─── Light Tema ───────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      
      // Temel Renk Şeması: Context üzerinden alınıp kolayca widget'lara bindirilecek alan.
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        surface: AppColors.background,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
      ),

      // AppBar Ayarları
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      // Input(TextField) Ayarları
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDDE6E5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      
      // Button Ayarları
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // ─── Dark Tema ────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight,
        onPrimary: AppColors.backgroundDark,
        secondary: AppColors.secondary,
        surface: AppColors.backgroundDark,
        onSurface: AppColors.textPrimaryDark,
        error: AppColors.error,
      ),

      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textPrimaryDark,
        centerTitle: true,
      ),

       inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBackgroundDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.backgroundDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
```

---

### 5️⃣ [theme_provider.dart](file:///Users/abdullahonus/Desktop/TK/Teorikort/lib/core/providers/theme_provider.dart) (Riverpod Notifier & SharedPreferences)

Bu dosya uygulamanın tema seçim verisini tutacaktır. Riverpod'un [Notifier](file:///Users/abdullahonus/Desktop/TK/Teorikort/lib/core/providers/theme_provider.dart#14-49) yapısı kullanılarak daha modern bir implementasyon yapılmıştır. Cihaz hafızasına (Shared Prefs) kaydetme asenkron yapıldığı için build edildikten hemen sonra uygulama hafızayı okur:

```dart
// lib/core/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// UI'ın izleyeceği global Provider nesnesi
final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

class ThemeNotifier extends Notifier<ThemeMode> {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    _loadThemeMode();
    return ThemeMode.light; // İlk başlangıçta varsayılan, load olup bitince ezilecek.
  }

  // Cihazın hafızasındaki tercih verisini çeken fonksiyon
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_key) ?? false;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  // Temayı birbiri arasında değiştiren fonksiyon
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = state == ThemeMode.dark;
    await prefs.setBool(_key, !isDark); // Değeri hafızada tersine çevirerek kaydet
    state = isDark ? ThemeMode.light : ThemeMode.dark; // Riverpod UI State'ini güncelle
  }

  // Opsiyonel: Sadece Dark/Light setleme metodları
  Future<void> setDark() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
    state = ThemeMode.dark;
  }

  Future<void> setLight() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, false);
    state = ThemeMode.light;
  }
}
```

---

### 6️⃣ [main.dart](file:///Users/abdullahonus/Desktop/TK/Teorikort/lib/main.dart) Kurulumu

Artık mimariyi ana uygulamamıza entegre etmemiz gerekiyor.

1. [main()](file:///Users/abdullahonus/Desktop/TK/Teorikort/lib/main.dart#14-28) metodunu `ProviderScope` ile sarmalayın.
2. `MaterialApp` üzerinde provider state'ini okuyan (watch) bir yapıyı kullanarak tema modunu enjekte edin.

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    // 1- Riverpod Provider Scope
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// 2- Tüketici Widget olarak çalışması için ConsumerWidget yapılır.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tema değişikliği olduğu an bu Widget'ı baştan çizen tetikleme:
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tema Entegre Uygulaması',
      
      // Oluşturduğumuz tema paketleri
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      
      // Dinamik Riverpod değişkeni ThemeMode.light veya ThemeMode.dark verecek
      themeMode: themeMode, 
      
      home: const TestPage(),
    );
  }
}
```

---

## 💡 Nasıl Kullanılır ve Çalıştırılır?

Bu kurulum bittikten sonra uygulamanın içerisinde iki temel operasyon yapmanız gerekir: Renkleri dinamik olarak atamak ve kullanıcıya bir butonda temanın değiştirilebilirliğini sağlamak.

### Renkleri Kullanımı (Önerilen Yöntem)

Flutter M3 mimarisinde, hiçbir zaman widgetlara statik (`AppColors.primary` vb.) bir renk **verilmemelidir**. Temanın o anki statüsüne (dark/light) göre değişkenlik göstermesi için `Theme.of(context)` ile erişilir.

```dart
Widget build(BuildContext context) {
  // context üzerindeki dinamik tema paleti değerini çekme
  final colors = Theme.of(context).colorScheme;

  return Container(
    // O an Dark Modda isek arka temayı AppColors.backgroundDark olarak getirecektir.
    color: colors.surface, 
    child: Text(
      'Başlık',
      style: TextStyle(color: colors.onSurface), // Yazı rengi dinamik değişti
    ),
  );
}
```

> [!TIP]
> `Scaffold`, `AppBar`, `ElevatedButton`, `Card` veya `TextField` gibi genel Material widgetları kullanırken renk tanımlamanıza **gerek yoktur**. Siz Material Widget'ını koyduğunuzda default renkleri otomatik olarak sizin [app_theme.dart](file:///Users/abdullahonus/Desktop/TK/Teorikort/lib/core/theme/app_theme.dart) içindeki tanımlarınızdaki ilgili renklerden alacaktır. Tema değiştirildiğinde Widget ağacı güncellenir ve renkler kendiliğinden harika bir şekilde dark veya light yapıya dönüşür!

### Tema Değiştirme (Switching) Kullanımı

Kullanıcının butona bastığında uygulamanın baştan aşağı temasını değiştirmesini sağlamak:

```dart
class TestPage extends ConsumerWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // İkonun yönünü bilmek için mevcut state'i okuruz
    final themeMode = ref.watch(themeProvider); 
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tema Testi'),
        actions: [
          IconButton(
            // Tıklanıldığındığında toggleTheme fonksiyonu çağırılır
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('Material Buton'),
        ),
      ),
    );
  }
}
```

Bu rehberle kendi sıfır(0) Flutter projenizde [AppColors](file:///Users/abdullahonus/Desktop/TK/Teorikort/lib/core/theme/app_colors.dart#3-33) -> [AppTheme](file:///Users/abdullahonus/Desktop/TK/Teorikort/lib/core/theme/app_theme.dart#5-305) listesini dilediğinizce değiştirerek Riverpod temalı kalıcı bellekle beraber eşzamanlı bir Dark Mod yapısını kurabilmek için ihtiyacınız olan her şeye sahipsiniz.
