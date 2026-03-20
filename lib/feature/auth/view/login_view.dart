import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../product/constants/app_spacing.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/navigation/app_router.dart';
import '../../../product/state/auth/auth_provider.dart';
import '../../../product/state/auth/model/user_role.dart';
import '../../../product/state/theme_provider.dart';
import '../../../product/widget/common/floating_particles_background.dart';

@RoutePage()
class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.role != UserRole.unauthenticated) {
        context.router.replaceAll([const TabRoute()]);
      }
    });

    final c = AppThemeColors.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [c.background, c.surface],
              ),
            ),
          ),

          // Animasyonlu partiküller (TabView'daki gibi)
          const RepaintBoundary(child: FloatingParticlesBackground()),

          SafeArea(
            child: Stack(
              children: [
                // Tema toggle butonu — sağ üst köşe
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: Icon(
                      ref.watch(themeProvider) == ThemeMode.dark
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      color: AppThemeColors.of(context).onBackground,
                      size: 26,
                    ),
                    onPressed: () {
                      ref.read(themeProvider.notifier).toggleTheme();
                    },
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo / App Name
                        Hero(
                          tag: 'app_logo',
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: c.surfaceVariant.withValues(
                                alpha: 0.3,
                              ),
                              border: Border.all(
                                color: c.accent.withValues(alpha: 0.3),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: c.accent.withValues(
                                    alpha: 0.1,
                                  ),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/icon/icon.png',
                              height: 80,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'NafiEsna',
                          style: AppTextStyles.headlineLarge.copyWith(
                            color: c.accent,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.5,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),

                        // Satırdan değil Sadırdan yazısı
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: c.textSecondary,
                              fontSize: 15,
                              letterSpacing: 0.5,
                            ),
                            children: [
                              const TextSpan(text: 'Satırdan değil '),
                              TextSpan(
                                text: 'Sadır',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: c.accent, // Daha belirgin
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const TextSpan(text: "'dan"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),

                        // Login Fields
                        _buildTextField(
                          controller: _usernameController,
                          hint: 'Kullanıcı Adı veya E-posta',
                          icon: Icons.person_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ActionChip(
                            backgroundColor: c.accent.withValues(
                              alpha: 0.1,
                            ),
                            side: BorderSide(
                              color: c.accent.withValues(alpha: 0.3),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 0,
                            ),
                            labelStyle: TextStyle(
                              color: c.accent,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            label: const Text('+ @nafiesna.com Ekle'),
                            onPressed: () {
                              final currentText = _usernameController.text;
                              if (!currentText.contains('@')) {
                                _usernameController.text =
                                    '$currentText@nafiesna.com';
                                _usernameController.selection =
                                    TextSelection.fromPosition(
                                      TextPosition(
                                        offset: _usernameController.text.length,
                                      ),
                                    );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _buildTextField(
                          controller: _passwordController,
                          hint: 'Şifre',
                          icon: Icons.lock_outline_rounded,
                          isPassword: true,
                        ),
                        if (authState.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.md),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline_rounded,
                                  color: c.error,
                                  size: 16,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    authState.errorMessage!,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: c.error,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: AppSpacing.xl),
                        _buildPrimaryButton(
                          context,
                          label: authState.isLoading
                              ? 'Giriş Yapılıyor...'
                              : 'Giriş Yap',
                          onPressed: authState.isLoading
                              ? () {}
                              : () async {
                                  final username = _usernameController.text
                                      .trim();
                                  final password = _passwordController.text
                                      .trim();
                                  if (username.isEmpty || password.isEmpty) {
                                    return;
                                  }

                                  final email = username.contains('@')
                                      ? username
                                      : '$username@nafiesna.com';

                                  await ref
                                      .read(authProvider.notifier)
                                      .loginAsAuthorized(email, password);
                                },
                        ),

                        const SizedBox(height: 40),

                        // Ayırıcı
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: c.border.withValues(alpha: 0.5),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                              ),
                              child: Text(
                                'veya',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: c.textSecondary.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: c.border.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // Misafir Girişi
                        _buildGuestButton(
                          context,
                          label: 'Misafir Olarak Başla',
                          onPressed: () async {
                            await ref
                                .read(authProvider.notifier)
                                .loginAsGuest();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? suffixText,
  }) {
    final c = AppThemeColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: c.surfaceVariant.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: c.accent.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: AppTextStyles.bodyLarge.copyWith(color: c.onBackground),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: c.textHint,
          ),
          prefixIcon: Icon(
            icon,
            color: c.accent.withValues(alpha: 0.8),
            size: 22,
          ),
          suffixText: suffixText,
          suffixStyle: AppTextStyles.bodyMedium.copyWith(
            color: c.textSecondary.withValues(alpha: 0.5),
            letterSpacing: 0.5,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(
    BuildContext context, {
    required String label,
    required VoidCallback onPressed,
  }) {
    final c = AppThemeColors.of(context);
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: c.accent,
          foregroundColor: Colors.black, // Dark temada buton metni siyah
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          elevation: 8,
          shadowColor: c.accent.withValues(alpha: 0.3),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildGuestButton(
    BuildContext context, {
    required String label,
    required VoidCallback onPressed,
  }) {
    final c = AppThemeColors.of(context);
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.labelLarge.copyWith(
              color: c.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            Icons.arrow_forward_rounded,
            size: 18,
            color: c.textSecondary,
          ),
        ],
      ),
    );
  }
}
