import 'package:flutter/material.dart';
import 'app_colors.dart';

/// AppTextStyles — static getter'lar, AppColors.light const değerlerini kullanır.
/// Widget tree içinde doğru rengi almak için `Theme.of(context).textTheme` kullanın.
/// Bu class geriye dönük uyumluluk içindir.
abstract class AppTextStyles {
  static TextStyle get displayLarge => const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static TextStyle get displayMedium => const TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get headlineLarge => const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get headlineMedium => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get headlineSmall => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get bodyLarge => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get bodyMedium => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get bodySmall => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle get labelLarge => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static TextStyle get labelSmall => const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static TextStyle get accent => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.accent,
    letterSpacing: 0.2,
  );
}

/// BuildContext üzerinden tema renkleri ve text stilleri için kolaylık extension'ı.
/// Yeni kod için bu yöntemi kullanın — tema değişimine tam reaktif.
extension AppThemeContext on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  AppThemeColors get colors => AppThemeColors.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}