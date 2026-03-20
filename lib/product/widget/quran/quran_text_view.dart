import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ── Quranic Colors ──────────────────────────────────────────────────────────
const Color kQuranBg = Color(0xFFE4D5B7);
const Color kQuranPaper = Color(0xFFEBE0C5);
const Color kQuranText = Color(0xFF2B1E0E);
const Color kQuranAccent = Color(0xFFB8860B);
const Color kQuranVerseNum = Color(0xFFCC6666);
const Color kQuranSurahHeader = Color(0xFF8B4513);
const Color kQuranMuted = Color(0xFF7A6040);

/// ── Text Processing ─────────────────────────────────────────────────────────

/// Processes Arabic text to highlight Divine Names (Allah, Rabb) in a distinct
/// pink/red color, matching scholarly Mushaf styles.
List<InlineSpan> processArabicText(String text, TextStyle baseStyle) {
  final spans = <InlineSpan>[];
  // Match variants (Allah, Lillah, Rabb)
  // Rabb tespiti bazen yanıltıcı olabilir ama Mushaf görsellerinde 
  // genellikle "Allah" (ﷲ, الله) vurgulanır.
  final regex = RegExp(r'(الله|اللّٰه|لِلّٰهِ|لله|رَبِّ|رَبَّ|رَبُّ|رَبِّي)');

  int start = 0;
  for (final match in regex.allMatches(text)) {
    if (match.start > start) {
      spans.add(TextSpan(
        text: text.substring(start, match.start),
        style: baseStyle,
      ));
    }
    spans.add(TextSpan(
      text: match.group(0),
      style: baseStyle.copyWith(
        color: kQuranVerseNum, // Pembe-Kırmızı vurgu
        fontWeight: FontWeight.bold,
      ),
    ));
    start = match.end;
  }

  if (start < text.length) {
    spans.add(TextSpan(
      text: text.substring(start),
      style: baseStyle,
    ));
  }

  return spans;
}

/// ── Verse Rose (Ayet Gülü) ──────────────────────────────────────────────────

/// An ornate 8-pointed star widget used to mark the end of Quranic verses.
class VerseRose extends StatelessWidget {
  const VerseRose({super.key, required this.number, this.size = 32});

  final int number;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: VerseRosePainter(color: kQuranVerseNum),
          ),
          Center(
            child: Text(
              _toArabicNumeral(number),
              style: TextStyle(
                fontSize: size * 0.35,
                fontWeight: FontWeight.bold,
                color: kQuranText,
                fontFamily: 'Amiri',
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _toArabicNumeral(int n) {
    const d = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return n.toString().split('').map((c) => d[int.parse(c)]).join();
  }
}

/// Painter for the ornate 8-pointed star (Ayet Gülü).
class VerseRosePainter extends CustomPainter {
  VerseRosePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final mainPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (math.pi / 180);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      final innerAngle = (i * 45 + 22.5) * (math.pi / 180);
      final ix = center.dx + radius * 0.5 * math.cos(innerAngle);
      final iy = center.dy + radius * 0.5 * math.sin(innerAngle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      path.lineTo(ix, iy);
    }
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, mainPaint);

    // İç halka (parlama efekti gibi)
    canvas.drawCircle(
      center,
      radius * 0.45,
      Paint()
        ..color = color.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );

    // Küçük süsleme noktaları
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (math.pi / 180);
      final x = center.dx + radius * 0.55 * math.cos(angle);
      final y = center.dy + radius * 0.55 * math.sin(angle);
      canvas.drawCircle(Offset(x, y), 0.8, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ── Scholarly Arabic Text with Search Highlight ────────────────────────────

class ScholarlyArabicTextWithHighlight extends StatelessWidget {
  const ScholarlyArabicTextWithHighlight({
    super.key,
    required this.text,
    required this.query,
    this.style,
    this.highlightColor = const Color(0x33FFD700),
  });

  final String text;
  final String query;
  final TextStyle? style;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return _buildScholarlyRichText(text);
    }

    final lowercaseText = text.toLowerCase();
    final lowercaseQuery = query.toLowerCase();
    final spans = <InlineSpan>[];
    int start = 0;

    while (true) {
      final index = lowercaseText.indexOf(lowercaseQuery, start);
      if (index == -1) {
        spans.addAll(_processMixedText(text.substring(start)));
        break;
      }

      if (index > start) {
        spans.addAll(_processMixedText(text.substring(start, index)));
      }

      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: (style ?? const TextStyle()).copyWith(
          backgroundColor: highlightColor,
          fontWeight: FontWeight.bold,
        ),
      ));

      start = index + query.length;
    }

    return RichText(text: TextSpan(children: spans));
  }

  Widget _buildScholarlyRichText(String text) {
    return RichText(
      text: TextSpan(children: _processMixedText(text)),
    );
  }

  /// Processes text that might contain Arabic script to apply scholarly styling.
  List<InlineSpan> _processMixedText(String text) {
    final spans = <InlineSpan>[];
    // Regex for Arabic script blocks
    final arabicRegex = RegExp(r'([\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]+)');
    
    int start = 0;
    final matches = arabicRegex.allMatches(text);

    if (matches.isEmpty) {
      spans.add(TextSpan(text: text, style: style));
      return spans;
    }

    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start), style: style));
      }

      final arabicTextPart = match.group(0)!;
      final arabicStyle = GoogleFonts.scheherazadeNew(
        textStyle: style,
        fontSize: 25,
        height: 2.5,
        wordSpacing: 3,
      );

      spans.addAll(processArabicText(arabicTextPart, arabicStyle));
      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: style));
    }

    return spans;
  }
}
