import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../product/constants/app_spacing.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../service/islamic_calendar_service.dart';
import '../../prayer_times/provider/prayer_times_provider.dart';

final _calendarServiceProvider = Provider((ref) => IslamicCalendarService());

final _nextEventProvider = FutureProvider<IslamicEvent?>((ref) {
  final service = ref.read(_calendarServiceProvider);
  return service.getNextEvent();
});

class HijriCalendarCard extends ConsumerWidget {
  const HijriCalendarCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hijriDate = ref.watch(prayerTimesProvider.select((s) => s.hijriDate));
    final isLoading = ref.watch(prayerTimesProvider.select((s) => s.isLoading));
    final nextEventAsync = ref.watch(_nextEventProvider);

    if (isLoading) return const SizedBox.shrink();

    // Gündüz/Gece görseli uygulama temasıyla senkronize çalışmalı
    final bool isDay = !context.isDark;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        gradient: isDay
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF63B8EE), // Parlak gökyüzü mavisi
                  Color(0xFF3895D3), // Daha doygun mavi
                ],
              )
            : null,
        color: !isDay ? const Color(0xFF151520) : null,
        border: Border.all(
          color: context.colors.border.withValues(alpha: 0.5),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.15),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: context.colors.accent.withValues(alpha: 0.15),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (isDay) const _CloudField(),
          if (!isDay) const _StarField(),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                _buildHeader(context, hijriDate, isDay),
                const SizedBox(height: AppSpacing.lg),
                if (isDay) const _GlowingSun(),
                if (!isDay) const _CrescentMoon(),
                const SizedBox(height: AppSpacing.xl),
                nextEventAsync.when(
                  data: (event) => event != null
                      ? _buildEventInfo(context, event)
                      : const SizedBox.shrink(),
                  loading: () => SizedBox(
                    height: 40,
                    child: Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          // Mavi üzerinde iyi durması için gündüz beyaz
                          color: isDay ? Colors.white : context.colors.accent,
                        ),
                      ),
                    ),
                  ),
                  error: (_, __) => _buildFallbackEvent(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String hijriDate, bool isDay) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hicri Takvim',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              if (hijriDate.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  hijriDate,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDay
                        ? Colors.white.withValues(alpha: 0.9)
                        : context.colors.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
        Icon(
          Icons.diamond_rounded,
          color: isDay ? Colors.white : context.colors.accent,
          size: 18,
        ),
      ],
    );
  }

  Widget _buildEventInfo(BuildContext context, IslamicEvent event) {
    final String dateFormatted = DateFormat(
      'd MMMM, EEEE',
      'tr_TR',
    ).format(event.date);
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
          style: context.textTheme.bodyMedium?.copyWith(
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
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          child: Text(
            countdownText,
            style: context.textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackEvent(BuildContext context) {
    final fallback = IslamicCalendarService.getFallback2026();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final event in fallback) {
      final eventDay = DateTime(
        event.date.year,
        event.date.month,
        event.date.day,
      );
      if (!eventDay.isBefore(today)) {
        return _buildEventInfo(context, event);
      }
    }
    return const SizedBox.shrink();
  }
}

/// Yıldız alanı — gece teması için
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

/// Bulut alanı — gündüz teması için
class _CloudField extends StatelessWidget {
  const _CloudField();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: CustomPaint(painter: _CloudPainter()),
    );
  }
}

class _CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint cloudPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    _drawCloud(
      canvas,
      Offset(size.width * 0.2, size.height * 0.2),
      0.8,
      cloudPaint,
    );
    _drawCloud(
      canvas,
      Offset(size.width * 0.8, size.height * 0.15),
      0.6,
      cloudPaint,
    );
    _drawCloud(
      canvas,
      Offset(size.width * 0.65, size.height * 0.6),
      1.0,
      cloudPaint,
    );
    _drawCloud(
      canvas,
      Offset(size.width * 0.15, size.height * 0.7),
      0.5,
      cloudPaint,
    );
  }

  void _drawCloud(Canvas canvas, Offset center, double scale, Paint paint) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale);

    canvas.drawCircle(const Offset(-15, 5), 15, paint);
    canvas.drawCircle(const Offset(15, 5), 15, paint);
    canvas.drawCircle(const Offset(0, -5), 20, paint);

    canvas.drawRect(const Rect.fromLTRB(-15, 5, 15, 20), paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Parlayan Güneş — gündüz teması için
class _GlowingSun extends StatelessWidget {
  const _GlowingSun();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: CustomPaint(painter: _SunPainter()),
    );
  }
}

class _SunPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = size.width * 0.35;

    final Paint sunPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.2, -0.2),
        colors: [
          Color(0xFFFFF9C4), // Çok açık sarı
          Color(0xFFFFD54F), // Amber
          Color(0xFFFFB300), // Turuncu
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));

    canvas.drawCircle(Offset(cx, cy), r, sunPaint);

    final Paint glowPaint = Paint()
      ..color = const Color(0xFFFFD54F).withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(Offset(cx, cy), r + 8, glowPaint);

    final Paint wideGlowPaint = Paint()
      ..color = const Color(0xFFFFB300).withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24);
    canvas.drawCircle(Offset(cx, cy), r + 20, wideGlowPaint);
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
        colors: [Color(0xFFE8E0D0), Color(0xFFB0A890), Color(0xFF787060)],
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
