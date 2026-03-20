import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand — Kubbetül Hadra yeşili + Gold accent
  static const Color primary = Color(0xFF235926);
  static const Color primaryLight = Color(0xFF4CAF62);
  static const Color primaryDark = Color(0xFF0E5C2B);
  static const Color accent = Color(0xFFB8860B); // Daha soft altın
  static const Color accentLight = Color(0xFFD4AF37);

  // Semantic
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF1976D2);

  // Light/Cream Surface (Kuran Teması ile Uyumlu)
  static const Color background = Color(0xFFE4D5B7); // Daha koyu kum / parşömen
  static const Color surface = Color(0xFFEBE0C5);
  static const Color surfaceVariant = Color(0xFFDCC8A3);
  static const Color surfaceElevated = Color(0xFFF0E6D0);

  // Text
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF2B1E0E); // Koyu kahvemtırak siyah
  static const Color textSecondary = Color(0xFF8B7355); // Koyu kum/krem rengi
  static const Color textDisabled = Color(0xFFBCAAA4);
  static const Color textHint = Color(0xFFA1887F);

  // Bottom Nav
  static const Color navBackground = Color(
    0xFFDCC8A3,
  ); // Sayfa rengi (alt tablar popup çıksın diye)
  static const Color navSelected = primary;
  static const Color navUnselected = Color(0xFF8B7355);

  // Divider / Border
  static const Color divider = Color(0xFFE2D5C4);
  static const Color border = Color(0xFFD7C4A3);
}
