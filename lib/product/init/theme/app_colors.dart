import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand — Teal primary, Gold accent (spec FR-007)
  static const Color primary = Color(0xFF008080);
  static const Color primaryLight = Color(0xFF4DB6AC);
  static const Color primaryDark = Color(0xFF00695C);
  static const Color accent = Color(0xFFD4AF37);
  static const Color accentLight = Color(0xFFFFD700);

  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFCF6679);
  static const Color info = Color(0xFF2196F3);

  // Dark Surface
  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceVariant = Color(0xFF242424);
  static const Color surfaceElevated = Color(0xFF2C2C2C);

  // Text
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFFE8E8E8);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color textDisabled = Color(0xFF616161);
  static const Color textHint = Color(0xFF757575);

  // Bottom Nav
  static const Color navBackground = Color(0xFF141414);
  static const Color navSelected = primary;
  static const Color navUnselected = Color(0xFF6B6B6B);

  // Divider / Border
  static const Color divider = Color(0xFF2A2A2A);
  static const Color border = Color(0xFF333333);
}
