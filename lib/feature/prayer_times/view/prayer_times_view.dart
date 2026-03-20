import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifier/prayer_times_notifier.dart';
import '../provider/prayer_times_provider.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/constants/app_spacing.dart';
import '../../../product/widget/common/app_loading_indicator.dart';

class PrayerTimesView extends ConsumerStatefulWidget {
  const PrayerTimesView({super.key});

  @override
  ConsumerState<PrayerTimesView> createState() => _PrayerTimesViewState();
}

class _PrayerTimesViewState extends ConsumerState<PrayerTimesView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(prayerTimesProvider.notifier).init(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(prayerTimesProvider);
    final c = AppThemeColors.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Namaz Vakitleri'),
        backgroundColor: c.surface,
        elevation: 0,
        actions: [
          if (state.locationStatus == LocationStatus.permitted)
            IconButton(
              onPressed: state.isLoading
                  ? null
                  : () => ref.read(prayerTimesProvider.notifier).refresh(),
              icon: state.isLocationLoading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: c.accent,
                      ),
                    )
                  : Icon(
                      Icons.my_location_rounded,
                      color: c.accent,
                    ),
              tooltip: 'Konumu yenile',
            ),
        ],
      ),
      body: state.isLoading
          ? const AppLoadingIndicator()
          : _buildContent(state),
    );
  }

  Widget _buildContent(PrayerTimesState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateHeader(state),
          const SizedBox(height: AppSpacing.xl),

          // İzin / GPS durumu kartı
          if (_shouldShowPermissionBanner(state)) ...[
            _buildPermissionBanner(state),
            const SizedBox(height: AppSpacing.lg),
          ],

          _buildPrayerList(state),
          const SizedBox(height: AppSpacing.xl),
          _buildLocationNote(state),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  bool _shouldShowPermissionBanner(PrayerTimesState state) {
    return state.isPermissionDenied ||
        state.isPermissionDeniedForever ||
        state.isServiceDisabled;
  }

  // ── Tarih başlığı ─────────────────────────────────────────────────────────

  Widget _buildDateHeader(PrayerTimesState state) {
    final c = AppThemeColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            c.primary.withValues(alpha: 0.15),
            c.primary.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: c.primary.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.hijriDate.isNotEmpty)
            Text(
              state.hijriDate,
              style: AppTextStyles.labelLarge.copyWith(color: c.accent),
            ),
          if (state.hijriDate.isNotEmpty) const SizedBox(height: AppSpacing.xs),
          Text(state.dateLabel, style: AppTextStyles.headlineSmall),
        ],
      ),
    );
  }

  // ── İzin / GPS servis banneri ─────────────────────────────────────────────

  Widget _buildPermissionBanner(PrayerTimesState state) {
    final isForever = state.isPermissionDeniedForever;
    final isServiceOff = state.isServiceDisabled;

    final String title;
    final String subtitle;
    final String buttonLabel;
    final VoidCallback onTap;

    if (isServiceOff) {
      title = 'Konum Servisi Kapalı';
      subtitle = 'Bulunduğunuz yerin namaz vakitlerini görmek için '
          'cihazınızın konum servisini açın.';
      buttonLabel = 'Konum Ayarlarını Aç';
      onTap = () =>
          ref.read(prayerTimesProvider.notifier).openLocationSettings();
    } else if (isForever) {
      title = 'Konum İzni Gerekli';
      subtitle = 'Uygulama ayarlarından konum iznini etkinleştirerek '
          'bulunduğunuz yere ait Diyanet vakitlerini görebilirsiniz.';
      buttonLabel = 'Uygulama Ayarlarını Aç';
      onTap = () => ref.read(prayerTimesProvider.notifier).openAppSettings();
    } else {
      title = 'Konum İzni';
      subtitle = 'Bulunduğunuz yere ait doğru namaz vakitlerini '
          'Diyanet verisinden göstermek için konum izni gereklidir.';
      buttonLabel = 'İzin Ver';
      onTap = () => ref
          .read(prayerTimesProvider.notifier)
          .requestLocationPermission();
    }

    final c = AppThemeColors.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        color: c.accent.withValues(alpha: 0.07),
        border: Border.all(
          color: c.accent.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isServiceOff
                ? Icons.location_off_rounded
                : Icons.location_on_rounded,
            color: c.accent,
            size: 22,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: c.accent,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: c.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    buttonLabel,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: c.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: c.primary,
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

  // ── Vakitler listesi ──────────────────────────────────────────────────────

  Widget _buildPrayerList(PrayerTimesState state) {
    return Column(
      children: List.generate(state.prayers.length, (index) {
        final prayer = state.prayers[index];
        final isActive = index == state.currentPrayerIndex;
        return _buildPrayerRow(prayer, isActive);
      }),
    );
  }

  Widget _buildPrayerRow(PrayerTime prayer, bool isActive) {
    final c = AppThemeColors.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        color: isActive
            ? c.primary.withValues(alpha: 0.15)
            : c.surface,
        border: Border.all(
          color: isActive ? c.primary : c.border,
          width: isActive ? 1 : 0.5,
        ),
      ),
      child: Row(
        children: [
          Text(prayer.icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              prayer.name,
              style: isActive
                  ? AppTextStyles.headlineSmall
                      .copyWith(color: c.primary)
                  : AppTextStyles.bodyLarge,
            ),
          ),
          Text(
            prayer.time,
            style: isActive
                ? AppTextStyles.headlineMedium.copyWith(
                    color: c.accent,
                    fontWeight: FontWeight.w700,
                  )
                : AppTextStyles.headlineSmall,
          ),
          if (isActive) ...[
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: c.primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: const Text(
                'ŞİMDİ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Konum notu ────────────────────────────────────────────────────────────

  Widget _buildLocationNote(PrayerTimesState state) {
    final c = AppThemeColors.of(context);
    final locationText = state.locationName.isNotEmpty
        ? state.locationName
        : 'İstanbul — Diyanet İşleri Başkanlığı';

    final isGpsActive = state.locationStatus == LocationStatus.permitted;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isGpsActive
              ? Icons.my_location_rounded
              : Icons.location_on_outlined,
          color: isGpsActive ? c.accent : c.textSecondary,
          size: 14,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            locationText,
            style: AppTextStyles.bodySmall.copyWith(
              color: isGpsActive
                  ? c.accent.withValues(alpha: 0.8)
                  : c.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}