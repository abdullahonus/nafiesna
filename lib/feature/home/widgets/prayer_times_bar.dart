import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../prayer_times/notifier/prayer_times_notifier.dart';
import '../../prayer_times/provider/prayer_times_provider.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/constants/app_spacing.dart';
import '../../../product/widget/common/permission_warnings.dart';

class PrayerTimesBar extends ConsumerStatefulWidget {
  const PrayerTimesBar({super.key});

  @override
  ConsumerState<PrayerTimesBar> createState() => _PrayerTimesBarState();
}

class _PrayerTimesBarState extends ConsumerState<PrayerTimesBar> {
  Timer? _countdownTimer;
  Duration _remaining = Duration.zero;
  int _nextPrayerIndex = -1;

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown(List<PrayerTime> prayers) {
    _countdownTimer?.cancel();
    _calculateRemaining(prayers);
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _calculateRemaining(prayers),
    );
  }

  void _calculateRemaining(List<PrayerTime> prayers) {
    if (prayers.isEmpty) return;

    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;

    for (int i = 0; i < prayers.length; i++) {
      final parts = prayers[i].time.split(':');
      if (parts.length < 2) continue;
      final prayerMinutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);
      if (prayerMinutes > currentMinutes) {
        final diffSeconds = (prayerMinutes - currentMinutes) * 60 - now.second;
        if (mounted) {
          setState(() {
            _remaining = Duration(seconds: diffSeconds);
            _nextPrayerIndex = i;
          });
        }
        return;
      }
    }

    if (mounted) {
      setState(() {
        _nextPrayerIndex = 0;
        final imsakParts = prayers.first.time.split(':');
        if (imsakParts.length >= 2) {
          final imsakMinutes =
              int.parse(imsakParts[0]) * 60 + int.parse(imsakParts[1]);
          final minutesUntilMidnight = 1440 - currentMinutes;
          final totalMinutes = minutesUntilMidnight + imsakMinutes;
          _remaining = Duration(
            minutes: totalMinutes,
            seconds: -now.second,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final prayers = ref.watch(
      prayerTimesProvider.select((s) => s.prayers),
    );
    final isLoading = ref.watch(
      prayerTimesProvider.select((s) => s.isLoading),
    );
    final currentIndex = ref.watch(
      prayerTimesProvider.select((s) => s.currentPrayerIndex),
    );
    final dateLabel = ref.watch(
      prayerTimesProvider.select((s) => s.dateLabel),
    );
    final hijriDate = ref.watch(
      prayerTimesProvider.select((s) => s.hijriDate),
    );

    if (isLoading || prayers.isEmpty) {
      return _buildSkeleton();
    }

    if (_countdownTimer == null || !_countdownTimer!.isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startCountdown(prayers);
      });
    }

    final String nextName;
    if (_nextPrayerIndex >= 0 && _nextPrayerIndex < prayers.length) {
      nextName = prayers[_nextPrayerIndex].name;
    } else if (currentIndex >= 0 && currentIndex < prayers.length) {
      nextName = prayers[currentIndex].name;
    } else {
      nextName = '';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        color: AppColors.surface,
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.15),
          width: 0.6,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.15),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildNextPrayerHeader(nextName),
          const SizedBox(height: AppSpacing.xl),
          _buildCountdown(),
          const SizedBox(height: AppSpacing.xl),
          _buildDateRow(dateLabel, hijriDate),
          const SizedBox(height: AppSpacing.lg),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: AppSpacing.lg),
          _buildTimesRow(prayers, currentIndex),
        ],
      ),
    );
  }

  Widget _buildNextPrayerHeader(String nextName) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Align(
          alignment: Alignment.topRight,
          child: LocationInfoWarningButton(),
        ),
        Center(
          child: Column(
            children: [
              Text(
                nextName,
                style: AppTextStyles.headlineLarge.copyWith(
                  color: AppColors.onBackground,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Vaktin Çıkmasına',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCountdown() {
    final hours = _remaining.inHours;
    final minutes = _remaining.inMinutes.remainder(60);
    final seconds = _remaining.inSeconds.remainder(60);

    final String hoursStr = hours.toString().padLeft(2, '0');
    final String minutesStr = minutes.toString().padLeft(2, '0');
    final String secondsStr = seconds.toString().padLeft(2, '0');

    const TextStyle largeDigit = TextStyle(
      fontSize: 52,
      fontWeight: FontWeight.w700,
      color: AppColors.onBackground,
      height: 1,
    );

    const TextStyle colonStyle = TextStyle(
      fontSize: 44,
      fontWeight: FontWeight.w300,
      color: AppColors.textSecondary,
      height: 1,
    );

    const TextStyle secondsStyle = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
      height: 1,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          hoursStr,
          style: largeDigit.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Text(':', style: colonStyle),
        ),
        Text(
          minutesStr,
          style: largeDigit.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 2),
          child: Text(
            ':$secondsStr',
            style: secondsStyle.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRow(String dateLabel, String hijriDate) {
    final String miladiShort = _extractShortDate(dateLabel);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          miladiShort,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        if (hijriDate.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Container(
              width: 1,
              height: 14,
              color: AppColors.divider,
            ),
          ),
          Text(
            hijriDate,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  /// "17 Mart 2026, Salı" → "17 Mart 2026"
  String _extractShortDate(String dateLabel) {
    final commaIndex = dateLabel.indexOf(',');
    if (commaIndex > 0) return dateLabel.substring(0, commaIndex);
    return dateLabel;
  }

  Widget _buildTimesRow(List<PrayerTime> prayers, int currentIndex) {
    return Row(
      children: List.generate(prayers.length, (index) {
        final prayer = prayers[index];
        final bool isActive = index == currentIndex;
        final bool isNext = index == _nextPrayerIndex;

        return Expanded(
          child: _PrayerTimeCell(
            name: prayer.name,
            time: prayer.time,
            isActive: isActive,
            isNext: isNext,
          ),
        );
      }),
    );
  }

  Widget _buildSkeleton() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        color: AppColors.surface,
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _PrayerTimeCell extends StatelessWidget {
  const _PrayerTimeCell({
    required this.name,
    required this.time,
    required this.isActive,
    required this.isNext,
  });

  final String name;
  final String time;
  final bool isActive;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final Color nameColor;
    final Color timeColor;
    final FontWeight timeWeight;

    if (isNext) {
      nameColor = AppColors.accent;
      timeColor = AppColors.accent;
      timeWeight = FontWeight.w700;
    } else if (isActive) {
      nameColor = AppColors.primary;
      timeColor = AppColors.primary;
      timeWeight = FontWeight.w700;
    } else {
      nameColor = AppColors.textSecondary;
      timeColor = AppColors.onBackground;
      timeWeight = FontWeight.w400;
    }

    return Column(
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: nameColor,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          time,
          style: TextStyle(
            fontSize: 14,
            fontWeight: timeWeight,
            color: timeColor,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
