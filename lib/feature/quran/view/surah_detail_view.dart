import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/quran_provider.dart';
import '../model/quran_verse_model.dart';

// ── Aynı krem tema ───────────────────────────────────────────────────────────
final Color _kBg = Color(0xFFE4D5B7);
final Color _kPaper = Color(0xFFEBE0C5);
final Color _kText = Color(0xFF2B1E0E);
final Color _kAccent = Color(0xFFB8860B);
final Color _kVerseNum = Color(0xFFCC6666);   // pembe-kırmızı (resimdeki gibi)
final Color _kSurahHeader = Color(0xFF8B4513);
final Color _kMuted = Color(0xFF7A6040);

@RoutePage()
class SurahDetailView extends ConsumerWidget {
  final int surahId;
  final String surahName;
  final String arabicName;

  SurahDetailView({
    super.key,
    required this.surahId,
    required this.surahName,
    required this.arabicName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncVerses = ref.watch(surahDetailProvider(surahId));
    final showTransliteration = ref.watch(quranPreferencesProvider);

    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: _kBg,
        appBarTheme: AppBarTheme(
          backgroundColor: _kPaper,
          foregroundColor: _kText,
          elevation: 0.5,
          shadowColor: _kAccent.withValues(alpha: 0.3),
          iconTheme: IconThemeData(color: _kText),
        ),
        dividerColor: _kAccent.withValues(alpha: 0.25),
      ),
      child: Scaffold(
        backgroundColor: _kBg,
        appBar: AppBar(
          title: Column(
            children: [
              Text(
                surahName,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _kSurahHeader,
                ),
              ),
              Text(
                arabicName,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 16,
                  color: _kAccent,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: _kPaper,
          actions: [
            IconButton(
              icon: Icon(
                showTransliteration ? Icons.text_fields_rounded : Icons.translate_rounded,
                color: showTransliteration ? _kVerseNum : _kMuted,
              ),
              tooltip: showTransliteration ? 'Okunuşu Gizle' : 'Okunuşu Göster',
              onPressed: () {
                ref.read(quranPreferencesProvider.notifier).toggleTransliteration();
              },
            ),
            SizedBox(width: 4),
          ],
        ),
        body: asyncVerses.when(
          data: (verses) => _buildContent(verses, showTransliteration),
          loading: () => Center(
            child: CircularProgressIndicator(color: _kAccent, strokeWidth: 2),
          ),
          error: (e, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off_rounded, color: _kAccent, size: 48),
                SizedBox(height: 12),
                Text('Sure yüklenemedi.', style: TextStyle(color: _kText)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(List<QuranVerse> verses, bool showTranslit) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(12, 12, 12, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── BLOK 1: Arapça metin (kağıt çerçeveli) ─────────────────────
          _paperCard(
            child: _buildArabicBlock(verses),
          ),

          SizedBox(height: 10),

          // ── BLOK 2: Türkçe okunuş (gizlenebilir) ───────────────────────
          if (showTranslit) ...[
            _paperCard(
              label: 'Okunuş',
              child: _buildTransliterationBlock(verses),
            ),
            SizedBox(height: 10),
          ],

          // ── BLOK 3: Türkçe meal ─────────────────────────────────────────
          _paperCard(
            label: 'Meâl',
            child: _buildTranslationBlock(verses),
          ),
        ],
      ),
    );
  }

  Widget _paperCard({required Widget child, String? label}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _kPaper,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _kAccent.withValues(alpha: 0.4), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(14, 12, 14, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null) ...[
              Row(
                children: [
                  Text('❖ ', style: TextStyle(color: _kAccent, fontSize: 12)),
                  Text(
                    label,
                    style: TextStyle(
                      color: _kAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Divider(color: _kAccent.withValues(alpha: 0.3), height: 16, thickness: 0.8),
            ],
            child,
          ],
        ),
      ),
    );
  }

  // Tüm ayetler birleşik Arapça (resimdeki gibi)
  Widget _buildArabicBlock(List<QuranVerse> verses) {
    final spans = <InlineSpan>[];
    for (final v in verses) {
      spans.add(TextSpan(
        text: '${v.arabicText} ',
        style: TextStyle(
          fontFamily: 'Amiri',
          fontSize: 25,
          fontWeight: FontWeight.w400,
          height: 2.2,
          color: _kText,
        ),
      ));
      // Pembe ayet gülü (resimdeki gibi)
      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 3),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _kVerseNum, width: 1.2),
            color: _kVerseNum.withValues(alpha: 0.1),
          ),
          child: Text(
            _toArabicNumeral(v.number),
            style: TextStyle(
              fontSize: 10,
              color: _kVerseNum,
              fontWeight: FontWeight.bold,
              fontFamily: 'Amiri',
            ),
          ),
        ),
      ));
      spans.add(TextSpan(text: '  '));
    }

    return RichText(
      textAlign: TextAlign.justify,
      textDirection: TextDirection.rtl,
      text: TextSpan(children: spans),
    );
  }

  // Numaralı Türkçe okunuş (düz metin)
  Widget _buildTransliterationBlock(List<QuranVerse> verses) {
    final spans = <InlineSpan>[];
    for (final v in verses) {
      spans.add(TextSpan(
        text: '${v.number} ',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: _kVerseNum,
        ),
      ));
      spans.add(TextSpan(
        text: '${v.transliteration}  ',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.9,
          color: _kText,
        ),
      ));
    }
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(children: spans),
    );
  }

  // Numaralı Türkçe meal
  Widget _buildTranslationBlock(List<QuranVerse> verses) {
    final spans = <InlineSpan>[];
    for (final v in verses) {
      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Container(
          margin: EdgeInsets.only(right: 6, bottom: 2),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _kVerseNum, width: 1.2),
            color: _kVerseNum.withValues(alpha: 0.1),
          ),
          child: Text(
            '${v.number}',
            style: TextStyle(
              fontSize: 10,
              color: _kVerseNum,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ));
      spans.add(TextSpan(
        text: '${v.translation}  ',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.9,
          color: _kText.withValues(alpha: 0.9),
        ),
      ));
    }
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(children: spans),
    );
  }

  String _toArabicNumeral(int n) {
    const d = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return n.toString().split('').map((c) => d[int.parse(c)]).join();
  }
}