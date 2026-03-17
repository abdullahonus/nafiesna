import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../init/theme/app_colors.dart';

/// Tüm uygulama arka planında yüzen partikül animasyonu.
///
/// Kullanım — TabView'da Stack'in ilk elemanı olarak:
/// ```dart
/// Stack(children: [
///   RepaintBoundary(child: FloatingParticlesBackground()),
///   AutoTabsScaffold(backgroundColor: Colors.transparent, ...),
/// ])
/// ```
class FloatingParticlesBackground extends StatefulWidget {
  const FloatingParticlesBackground({super.key});

  @override
  State<FloatingParticlesBackground> createState() =>
      _FloatingParticlesBackgroundState();
}

class _FloatingParticlesBackgroundState
    extends State<FloatingParticlesBackground>
    with SingleTickerProviderStateMixin {
  static const int _count = 28;

  // Uygulama renk paletine uygun: teal tonu + gold tonu
  static const List<Color> _palette = [
    AppColors.primary,
    AppColors.primaryLight, // #4DB6AC açık teal
    Color(0xFF26A69A),      // orta teal
    AppColors.accent,       // #D4AF37 gold
    AppColors.accentLight,  // #FFD700 parlak gold
    Color(0xFF4DB6AC),      // teal highlight
  ];

  late final Ticker _ticker;
  final List<_Particle> _particles = [];
  final _repaintNotifier = _RepaintNotifier();
  Size _size = Size.zero;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    // Ticker doğrudan repaint notifier'ı tetikler — setState çağrısı yok
    _ticker = createTicker((_) {
      if (_size == Size.zero) return;
      for (final p in _particles) {
        p.update(_size);
      }
      _repaintNotifier.notify();
    })..start();
  }

  void _initParticles(Size size) {
    for (int i = 0; i < _count; i++) {
      _particles.add(_Particle(
        x: _rng.nextDouble() * size.width,
        y: _rng.nextDouble() * size.height,
        // Yavaş, sakin hareket
        vx: (_rng.nextDouble() * 0.5 - 0.25),
        vy: (_rng.nextDouble() * 0.5 - 0.25),
        // Çok küçük boyutlar — tıpkı React versiyonu gibi
        radius: _rng.nextDouble() * 1.8 + 0.4,
        // Hafif şeffaflık: %10–%40
        opacity: _rng.nextDouble() * 0.30 + 0.10,
        color: _palette[_rng.nextInt(_palette.length)],
      ));
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _repaintNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final newSize = constraints.biggest;
        if (_size != newSize) {
          _size = newSize;
          if (_particles.isEmpty) _initParticles(_size);
        }
        return CustomPaint(
          size: _size,
          painter: _ParticlesPainter(
            particles: _particles,
            repaint: _repaintNotifier,
          ),
        );
      },
    );
  }
}

// ── Partikül modeli ────────────────────────────────────────────────────────

class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required double vx,
    required double vy,
    required this.radius,
    required this.opacity,
    required this.color,
  })  : _vx = vx,
        _vy = vy;

  double x, y;
  double _vx, _vy;
  final double radius;
  final double opacity;
  final Color color;

  void update(Size bounds) {
    x += _vx;
    y += _vy;

    if (x < 0) {
      x = 0;
      _vx = _vx.abs();
    } else if (x > bounds.width) {
      x = bounds.width;
      _vx = -_vx.abs();
    }

    if (y < 0) {
      y = 0;
      _vy = _vy.abs();
    } else if (y > bounds.height) {
      y = bounds.height;
      _vy = -_vy.abs();
    }
  }
}

// ── Painter ────────────────────────────────────────────────────────────────

class _ParticlesPainter extends CustomPainter {
  const _ParticlesPainter({
    required this.particles,
    required super.repaint,
  });

  final List<_Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    // Arka plan rengi (Scaffold transparent olduğu için burada çiziyoruz)
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = AppColors.background,
    );

    for (final p in particles) {
      final center = Offset(p.x, p.y);

      // Dış hale (neon glow etkisi — MaskFilter yerine ışımalı daire)
      canvas.drawCircle(
        center,
        p.radius * 4,
        Paint()
          ..color = p.color.withValues(alpha: p.opacity * 0.18)
          ..style = PaintingStyle.fill,
      );

      // Orta hale
      canvas.drawCircle(
        center,
        p.radius * 2,
        Paint()
          ..color = p.color.withValues(alpha: p.opacity * 0.35)
          ..style = PaintingStyle.fill,
      );

      // Parlak merkez
      canvas.drawCircle(
        center,
        p.radius,
        Paint()
          ..color = p.color.withValues(alpha: p.opacity)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter old) => false; // repaint notifier yönetiyor
}

// ── Repaint notifier ───────────────────────────────────────────────────────

class _RepaintNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}
