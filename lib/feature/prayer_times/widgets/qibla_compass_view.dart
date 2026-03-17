import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/constants/app_spacing.dart';
import '../provider/qibla_provider.dart';

class QiblaCompassView extends ConsumerStatefulWidget {
  const QiblaCompassView({super.key});

  @override
  ConsumerState<QiblaCompassView> createState() => _QiblaCompassViewState();
}

class _QiblaCompassViewState extends ConsumerState<QiblaCompassView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(qiblaProvider.notifier).init());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(qiblaProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Kıble Bulucu',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.accent,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),
      body: state.isLoading
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.accent),
                  SizedBox(height: AppSpacing.lg),
                  Text('Konum alınıyor...', style: AppTextStyles.bodyMedium),
                ],
              ),
            )
          : state.errorMessage != null
              ? _buildError(state.errorMessage!)
              : !state.hasCompass
                  ? _buildNoCompass(state)
                  : _buildCompass(state),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_off_rounded,
              color: AppColors.error,
              size: 56,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: () => ref.read(qiblaProvider.notifier).init(),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Tekrar Dene'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoCompass(dynamic state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.explore_off_rounded,
              color: AppColors.accent,
              size: 56,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Bu cihazda pusula sensörü bulunamadı.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Kıble yönü: ${state.qiblaDirection.toStringAsFixed(1)}° (Kuzeyden)',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.accent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Kabe\'ye uzaklık: ${state.distanceKm.toStringAsFixed(0)} km',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompass(dynamic state) {
    final double needleAngle = state.needleAngle as double;
    final double distanceKm = state.distanceKm as double;
    final double heading = state.deviceHeading as double;

    final bool isAligned = (needleAngle % 360).abs() < 5 ||
        (360 - (needleAngle % 360).abs()) < 5;

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xl),
          Text(
            _getDirectionLabel(heading),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1.5,
              fontSize: 13,
            ),
          ),
          Text(
            '${heading.toStringAsFixed(0)}°',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.onBackground,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 300,
            height: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Pusula diski — cihaz heading'ine göre döner
                Transform.rotate(
                  angle: -heading * (pi / 180),
                  child: CustomPaint(
                    size: const Size(300, 300),
                    painter: _CompassPainter(),
                  ),
                ),
                // Kıble iğnesi — qibla direction'a göre döner
                Transform.rotate(
                  angle: needleAngle * (pi / 180),
                  child: _buildQiblaIndicator(isAligned),
                ),
                // Merkez Kabe ikonu
                _buildCenterIcon(isAligned),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isAligned
                  ? AppColors.success.withValues(alpha: 0.15)
                  : AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              border: Border.all(
                color: isAligned
                    ? AppColors.success.withValues(alpha: 0.4)
                    : AppColors.accent.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              isAligned ? 'Kıble Yönündesiniz' : 'Cihazı Kıbleye Çevirin',
              style: AppTextStyles.labelLarge.copyWith(
                color: isAligned ? AppColors.success : AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Kabe\'ye uzaklık: ${distanceKm.toStringAsFixed(0)} km',
            style: AppTextStyles.bodySmall,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              'Doğru sonuç için cihazınızı metal yüzeylerden ve '
              'mıknatıslı nesnelerden uzak tutun.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.7),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQiblaIndicator(bool isAligned) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3,
          height: 90,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                isAligned
                    ? AppColors.success
                    : AppColors.accent,
                Colors.transparent,
              ],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildCenterIcon(bool isAligned) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isAligned
            ? AppColors.success.withValues(alpha: 0.2)
            : AppColors.surface,
        border: Border.all(
          color: isAligned ? AppColors.success : AppColors.accent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isAligned ? AppColors.success : AppColors.accent)
                .withValues(alpha: 0.3),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        Icons.mosque_rounded,
        color: isAligned ? AppColors.success : AppColors.accent,
        size: 24,
      ),
    );
  }

  String _getDirectionLabel(double heading) {
    if (heading >= 337.5 || heading < 22.5) return 'KUZEY';
    if (heading >= 22.5 && heading < 67.5) return 'KUZEYDOĞU';
    if (heading >= 67.5 && heading < 112.5) return 'DOĞU';
    if (heading >= 112.5 && heading < 157.5) return 'GÜNEYDOĞU';
    if (heading >= 157.5 && heading < 202.5) return 'GÜNEY';
    if (heading >= 202.5 && heading < 247.5) return 'GÜNEYBATI';
    if (heading >= 247.5 && heading < 292.5) return 'BATI';
    return 'KUZEYBATI';
  }
}

class _CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double radius = size.width / 2 - 8;

    // Dış halka
    final Paint ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.border;
    canvas.drawCircle(Offset(cx, cy), radius, ringPaint);

    // İç halka
    final Paint innerRingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = AppColors.border.withValues(alpha: 0.5);
    canvas.drawCircle(Offset(cx, cy), radius * 0.75, innerRingPaint);

    // Derece işaretleri
    for (int i = 0; i < 360; i += 5) {
      final bool isMajor = i % 30 == 0;
      final bool isCardinal = i % 90 == 0;
      final double angle = i * (pi / 180);

      final double startR = radius - (isMajor ? 18 : 10);
      final double endR = radius - 4;

      final Paint tickPaint = Paint()
        ..strokeWidth = isCardinal ? 2.5 : (isMajor ? 1.5 : 0.5)
        ..color = isCardinal
            ? AppColors.accent
            : (isMajor
                ? AppColors.onBackground.withValues(alpha: 0.5)
                : AppColors.textSecondary.withValues(alpha: 0.3));

      canvas.drawLine(
        Offset(cx + startR * sin(angle), cy - startR * cos(angle)),
        Offset(cx + endR * sin(angle), cy - endR * cos(angle)),
        tickPaint,
      );
    }

    // Yön etiketleri
    const List<_DirectionLabel> labels = [
      _DirectionLabel(angle: 0, text: 'K', isMain: true),
      _DirectionLabel(angle: 90, text: 'D', isMain: false),
      _DirectionLabel(angle: 180, text: 'G', isMain: false),
      _DirectionLabel(angle: 270, text: 'B', isMain: false),
    ];

    for (final label in labels) {
      final double angle = label.angle * (pi / 180);
      final double labelR = radius - 32;
      final Offset pos = Offset(
        cx + labelR * sin(angle),
        cy - labelR * cos(angle),
      );

      final TextPainter tp = TextPainter(
        text: TextSpan(
          text: label.text,
          style: TextStyle(
            color: label.isMain ? AppColors.accent : AppColors.onBackground,
            fontSize: label.isMain ? 18 : 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DirectionLabel {
  const _DirectionLabel({
    required this.angle,
    required this.text,
    required this.isMain,
  });

  final double angle;
  final String text;
  final bool isMain;
}
