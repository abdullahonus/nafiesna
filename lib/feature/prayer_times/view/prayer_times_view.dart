import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifier/prayer_times_notifier.dart';
import '../provider/prayer_times_provider.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/constants/app_spacing.dart';
import '../../../product/widget/common/app_loading_indicator.dart';

@RoutePage()
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Namaz Vakitleri'),
        backgroundColor: AppColors.surface,
        elevation: 0,
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
          _buildPrayerList(state),
          const SizedBox(height: AppSpacing.xl),
          _buildLocationNote(),
        ],
      ),
    );
  }

  Widget _buildDateHeader(PrayerTimesState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.hijriDate,
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(state.dateLabel, style: AppTextStyles.headlineSmall),
        ],
      ),
    );
  }

  Widget _buildPrayerList(PrayerTimesState state) {
    return Column(
      children: List.generate(state.prayers.length, (index) {
        final prayer = state.prayers[index];
        final isActive = index == state.currentPrayerIndex;
        return _buildPrayerRow(prayer, isActive, index);
      }),
    );
  }

  Widget _buildPrayerRow(PrayerTime prayer, bool isActive, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        color: isActive ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surface,
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.border,
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
                  ? AppTextStyles.headlineSmall.copyWith(color: AppColors.primary)
                  : AppTextStyles.bodyLarge,
            ),
          ),
          Text(
            prayer.time,
            style: isActive
                ? AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.accent,
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
                color: AppColors.primary,
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

  Widget _buildLocationNote() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.location_on_rounded, color: AppColors.textSecondary, size: 14),
        SizedBox(width: 4),
        Text(
          'İstanbul vakitleri — Diyanet İşleri Başkanlığı',
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }
}
