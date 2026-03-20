import 'package:flutter/material.dart';

/// Uygulamaya özgü renk paleti — ThemeExtension sayesinde
/// `Theme.of(context)` üzerinden reaktif olarak okunur.
/// Dark / Light geçişi Widget tree rebuild tarafından otomatik yönetilir.
@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.accent,
    required this.accentLight,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.surfaceElevated,
    required this.onBackground,
    required this.textSecondary,
    required this.textDisabled,
    required this.textHint,
    required this.navBackground,
    required this.navSelected,
    required this.navUnselected,
    required this.border,
    required this.divider,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
    required this.onPrimary,
  });

  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color accent;
  final Color accentLight;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color surfaceElevated;
  final Color onBackground;
  final Color textSecondary;
  final Color textDisabled;
  final Color textHint;
  final Color navBackground;
  final Color navSelected;
  final Color navUnselected;
  final Color border;
  final Color divider;
  final Color error;
  final Color success;
  final Color warning;
  final Color info;
  final Color onPrimary;

  // ── Convenience accessor ──────────────────────────────────────────────────
  static AppThemeColors of(BuildContext context) =>
      Theme.of(context).extension<AppThemeColors>()!;

  // ── Light palette ─────────────────────────────────────────────────────────
  static const light = AppThemeColors(
    primary: Color(0xFF235926),
    primaryLight: Color(0xFF4CAF62),
    primaryDark: Color(0xFF0E5C2B),
    accent: Color(0xFFB8860B),
    accentLight: Color(0xFFD4AF37),
    background: Color(0xFFE4D5B7),
    surface: Color(0xFFEBE0C5),
    surfaceVariant: Color(0xFFDCC8A3),
    surfaceElevated: Color(0xFFF0E6D0),
    onBackground: Color(0xFF2B1E0E),
    textSecondary: Color(0xFF8B7355),
    textDisabled: Color(0xFFBCAAA4),
    textHint: Color(0xFFA1887F),
    navBackground: Color(0xFFDCC8A3),
    navSelected: Color(0xFF235926),
    navUnselected: Color(0xFF8B7355),
    border: Color(0xFFD7C4A3),
    divider: Color(0xFFE2D5C4),
    error: Color(0xFFD32F2F),
    success: Color(0xFF388E3C),
    warning: Color(0xFFF57C00),
    info: Color(0xFF1976D2),
    onPrimary: Color(0xFFFFFFFF),
  );

  // ── Dark palette ──────────────────────────────────────────────────────────
  static const dark = AppThemeColors(
    primary: Color(0xFF2A6B2F),
    primaryLight: Color(0xFF4CAF62), // Reusing similar light primary for dark
    primaryDark: Color(0xFF1B431D),
    accent: Color(0xFFD4AF37),
    accentLight: Color(0xFFF8E287),
    background: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    surfaceVariant: Color(0xFF2C2C2C),
    surfaceElevated: Color(0xFF292929),
    onBackground: Color(0xFFE8E0D8),
    textSecondary: Color(0xFFAAAAAA),
    textDisabled: Color(0xFF757575),
    textHint: Color(0xFF9E9E9E),
    navBackground: Color(0xFF1A1A1A),
    navSelected: Color(0xFFD4AF37),
    navUnselected: Color(0xFF757575),
    border: Color(0xFF3A3A3A),
    divider: Color(0xFF333333),
    error: Color(0xFFCF6679),
    success: Color(0xFF81C784),
    warning: Color(0xFFFFB74D),
    info: Color(0xFF64B5F6),
    onPrimary: Color(0xFF000000),
  );

  // ── ThemeExtension overrides ──────────────────────────────────────────────
  @override
  AppThemeColors copyWith({
    Color? primary,
    Color? primaryLight,
    Color? primaryDark,
    Color? accent,
    Color? accentLight,
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? surfaceElevated,
    Color? onBackground,
    Color? textSecondary,
    Color? textDisabled,
    Color? textHint,
    Color? navBackground,
    Color? navSelected,
    Color? navUnselected,
    Color? border,
    Color? divider,
    Color? error,
    Color? success,
    Color? warning,
    Color? info,
    Color? onPrimary,
  }) =>
      AppThemeColors(
        primary: primary ?? this.primary,
        primaryLight: primaryLight ?? this.primaryLight,
        primaryDark: primaryDark ?? this.primaryDark,
        accent: accent ?? this.accent,
        accentLight: accentLight ?? this.accentLight,
        background: background ?? this.background,
        surface: surface ?? this.surface,
        surfaceVariant: surfaceVariant ?? this.surfaceVariant,
        surfaceElevated: surfaceElevated ?? this.surfaceElevated,
        onBackground: onBackground ?? this.onBackground,
        textSecondary: textSecondary ?? this.textSecondary,
        textDisabled: textDisabled ?? this.textDisabled,
        textHint: textHint ?? this.textHint,
        navBackground: navBackground ?? this.navBackground,
        navSelected: navSelected ?? this.navSelected,
        navUnselected: navUnselected ?? this.navUnselected,
        border: border ?? this.border,
        divider: divider ?? this.divider,
        error: error ?? this.error,
        success: success ?? this.success,
        warning: warning ?? this.warning,
        info: info ?? this.info,
        onPrimary: onPrimary ?? this.onPrimary,
      );

  @override
  AppThemeColors lerp(AppThemeColors? other, double t) {
    if (other == null) return this;
    return AppThemeColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentLight: Color.lerp(accentLight, other.accentLight, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      navBackground: Color.lerp(navBackground, other.navBackground, t)!,
      navSelected: Color.lerp(navSelected, other.navSelected, t)!,
      navUnselected: Color.lerp(navUnselected, other.navUnselected, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
    );
  }
}

abstract class AppColors {
  static const Color primary = Color(0xFF235926);
  static const Color primaryLight = Color(0xFF4CAF62);
  static const Color primaryDark = Color(0xFF0E5C2B);
  static const Color accent = Color(0xFFB8860B);
  static const Color accentLight = Color(0xFFD4AF37);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF1976D2);
  static const Color background = Color(0xFFE4D5B7);
  static const Color surface = Color(0xFFEBE0C5);
  static const Color surfaceVariant = Color(0xFFDCC8A3);
  static const Color surfaceElevated = Color(0xFFF0E6D0);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF2B1E0E);
  static const Color textSecondary = Color(0xFF8B7355);
  static const Color textDisabled = Color(0xFFBCAAA4);
  static const Color textHint = Color(0xFFA1887F);
  static const Color navBackground = Color(0xFFDCC8A3);
  static const Color navSelected = primary;
  static const Color navUnselected = Color(0xFF8B7355);
  static const Color divider = Color(0xFFE2D5C4);
  static const Color border = Color(0xFFD7C4A3);
}
