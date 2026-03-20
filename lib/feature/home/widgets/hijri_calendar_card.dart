import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../prayer_times/provider/prayer_times_provider.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/constants/app_spacing.dart';
import '../../../service/islamic_calendar_service.dart';

final _calendarServiceProvider = Provider(
  (ref) => IslamicCalendarService(),
);

final _nextEventProvider = FutureProvider<IslamicEvent?>((ref) {
  final service = ref.read(_calendarServiceProvider);
  return service.getNextEvent();
});

class HijriCalendarCard extends ConsumerWidget {
  const HijriCalendarCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hijriDate = ref.watch(
      prayerTimesProvider.select((s) => s.hijriDate),
    );
    final isLoading = ref.watch(
      prayerTimesProvider.select((s) => s.isLoading),
    );
    final nextEventAsync = ref.watch(_nextEventProvider);

    if (isLoading) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        color: const Color(0xFF151520),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.06),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          const _StarField(),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                _buildHeader(hijriDate),
                const SizedBox(height: AppSpacing.lg),
                const _CrescentMoon(),
                const SizedBox(height: AppSpacing.xl),
                nextEventAsync.when(
                  data: (event) =>
                      event != null ? _buildEventInfo(event) : const SizedBox.shrink(),
                  loading: () => const SizedBox(
                    height: 40,
                    child: Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ),
                  error: (_, __) => _buildFallbackEvent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String hijriDate) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hicri Takvim',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              if (hijriDate.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  hijriDate,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
        const Icon(
          Icons.diamond_rounded,
          color: AppColors.accent,
          size: 18,
        ),
      ],
    );
  }

  Widget _buildEventInfo(IslamicEvent event) {
    final String dateFormatted =
        DateFormat('d MMMM, EEEE', 'tr_TR').format(event.date);
    final int daysLeft = event.daysUntil;

    final String countdownText;
    if (daysLeft == 0) {
      countdownText = 'Bugün';
    } else if (daysLeft == 1) {
      countdownText = 'Yarın';
    } else {
      countdownText = '$daysLeft Gün Kaldı';
    }

    return Column(
      children: [
        Text(
          '${event.name}: $dateFormatted',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          child: Text(
            countdownText,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackEvent() {
    final fallback = IslamicCalendarService.getFallback2026();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final event in fallback) {
      final eventDay = DateTime(event.date.year, event.date.month, event.date.day);
      if (!eventDay.isBefore(today)) {
        return _buildEventInfo(event);
      }
    }
    return const SizedBox.shrink();
  }
}

/// Yıldız alanı — sabit konumlu küçük noktalar
class _StarField extends StatelessWidget {
  const _StarField();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: CustomPaint(painter: _StarPainter()),
    );
  }
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Random rng = Random(42);
    final Paint starPaint = Paint()..color = Colors.white;

    for (int i = 0; i < 60; i++) {
      final double x = rng.nextDouble() * size.width;
      final double y = rng.nextDouble() * size.height;
      final double radius = rng.nextDouble() * 1.2 + 0.3;
      final double opacity = rng.nextDouble() * 0.5 + 0.15;

      starPaint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), radius, starPaint);
    }

    _drawSparkle(canvas, size.width * 0.15, size.height * 0.3, 3, 0.6);
    _drawSparkle(canvas, size.width * 0.82, size.height * 0.15, 2.5, 0.5);
    _drawSparkle(canvas, size.width * 0.65, size.height * 0.7, 2, 0.4);
  }

  void _drawSparkle(
    Canvas canvas,
    double cx,
    double cy,
    double armLen,
    double opacity,
  ) {
    final Paint paint = Paint()
      ..color = Colors.white.withValues(alpha: opacity)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(cx - armLen, cy), Offset(cx + armLen, cy), paint);
    canvas.drawLine(Offset(cx, cy - armLen), Offset(cx, cy + armLen), paint);

    final double d = armLen * 0.55;
    canvas.drawLine(Offset(cx - d, cy - d), Offset(cx + d, cy + d), paint);
    canvas.drawLine(Offset(cx + d, cy - d), Offset(cx - d, cy + d), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Hilal (crescent moon) çizimi
class _CrescentMoon extends StatelessWidget {
  const _CrescentMoon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: CustomPaint(painter: _MoonPainter()),
    );
  }
}

class _MoonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = size.width * 0.42;

    final Paint moonPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.3),
        colors: [
          Color(0xFFE8E0D0),
          Color(0xFFB0A890),
          Color(0xFF787060),
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));

    canvas.drawCircle(Offset(cx, cy), r, moonPaint);

    final Paint shadowPaint = Paint()..color = const Color(0xFF151520);
    canvas.drawCircle(
      Offset(cx + r * 0.55, cy - r * 0.1),
      r * 0.85,
      shadowPaint,
    );

    final Paint glowPaint = Paint()
      ..color = const Color(0xFFE8E0D0).withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(Offset(cx, cy), r + 8, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
