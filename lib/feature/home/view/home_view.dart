import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../product/constants/app_spacing.dart';
import '../../../product/init/theme/app_text_styles.dart'; // BuildContext extensions
import '../../../product/state/auth/auth_provider.dart';
import '../../../product/state/auth/model/user_role.dart';
import '../../../product/state/theme_provider.dart';
import '../../../product/widget/common/app_error_state.dart';
import '../../../product/widget/common/app_loading_indicator.dart';
import '../../../product/widget/common/permission_warnings.dart';
import '../../../product/widget/common/sohbet_popup.dart';
import '../../../product/widget/common/watermark_overlay.dart';
import '../../prayer_times/provider/prayer_times_provider.dart';
import '../notifier/home_notifier.dart';
import '../provider/home_provider.dart';
import '../widgets/hadith_card.dart';
import '../widgets/hijri_calendar_card.dart';
import '../widgets/live_stream_card.dart';
import '../widgets/prayer_times_bar.dart';

@RoutePage()
class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider.notifier).init();
      ref.read(prayerTimesProvider.notifier).init();

      // Random Sohbet Popup
      SohbetPopup.show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                floating: true,
                pinned: false,
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(
                    Icons.logout_rounded,
                    color: context.colors.onBackground,
                  ),
                  onPressed: () => _showLogoutDialog(context, ref),
                ),
                title: Text(
                  _resolveUsername(ref),
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colors.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      ref.watch(themeProvider) == ThemeMode.dark
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      color: context.colors.onBackground,
                      size: 26,
                    ),
                    onPressed: () {
                      ref.read(themeProvider.notifier).toggleTheme();
                    },
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const NotificationWarningWidget(),
                      if (ref.watch(authProvider).role == UserRole.authorized)
                        const LiveStreamCard(),
                      const SizedBox(height: AppSpacing.md),
                      const PrayerTimesBar(),
                      const SizedBox(height: AppSpacing.md),
                      const HijriCalendarCard(),
                      const SizedBox(height: AppSpacing.xl),
                      _buildHadithSection(state),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Tüm sayfanın (ve butonların) üzerine binen ama tıklanmayı engellemeyen filigran
          const WatermarkOverlay(),
        ],
      ),
    );
  }

  /// E-posta adresinden @ öncesi kısmı döndürür.
  /// Ör: nafiesna@nafiesna.com → nafiesna
  /// Misafir kullanıcı için 'Misafir' döner.
  String _resolveUsername(WidgetRef ref) {
    final String? email = FirebaseAuth.instance.currentUser?.email;
    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }
    final UserRole role = ref.watch(authProvider.select((s) => s.role));
    return role == UserRole.guest ? 'Misafir' : 'Kullanıcı';
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text(
          'Hesabınızdan çıkış yapmak istediğinize emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
            },
            style: TextButton.styleFrom(foregroundColor: context.colors.error),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
  }

  Widget _buildHadithSection(HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 20,
              decoration: BoxDecoration(
                color: context.colors.accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text('Günün Hadisi', style: context.textTheme.headlineSmall),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (state.isLoading)
          const SizedBox(height: 120, child: AppLoadingIndicator())
        else if (state.errorMessage != null)
          AppErrorState(
            message: state.errorMessage!,
            onRetry: () => ref.read(homeProvider.notifier).loadHadith(),
          )
        else if (state.hadith != null)
          HadithCard(hadith: state.hadith!)
        else
          const HadithCard(
            hadith: HadithData(
              text:
                  'Kolaylaştırınız, güçleştirmeyiniz. Müjdeleyiniz, nefret ettirmeyiniz.',
              arabicText: '',
              attribution: 'Sahih-i Buhârî',
              grade: 'Sahih',
            ),
          ),
      ],
    );
  }
}
