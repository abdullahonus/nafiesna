import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../product/widget/quran/quran_text_view.dart';
import '../model/quran_verse_model.dart';
import '../provider/quran_provider.dart';

// ── Aynı krem tema ───────────────────────────────────────────────────────────
const Color _kBg = kQuranBg;
const Color _kPaper = kQuranPaper;
const Color _kText = kQuranText;
const Color _kAccent = kQuranAccent;
const Color _kVerseNum = kQuranVerseNum; // pembe-kırmızı (resimdeki gibi)
const Color _kSurahHeader = kQuranSurahHeader;
const Color _kMuted = kQuranMuted;

@RoutePage()
class SurahDetailView extends ConsumerWidget {
  final int surahId;
  final String surahName;
  final String arabicName;

  const SurahDetailView({
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
          iconTheme: const IconThemeData(color: _kText),
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
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _kSurahHeader,
                ),
              ),
              Text(
                arabicName,
                style: const TextStyle(
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
                showTransliteration
                    ? Icons.text_fields_rounded
                    : Icons.translate_rounded,
                color: showTransliteration ? _kVerseNum : _kMuted,
              ),
              tooltip: showTransliteration ? 'Okunuşu Gizle' : 'Okunuşu Göster',
              onPressed: () {
                ref
                    .read(quranPreferencesProvider.notifier)
                    .toggleTransliteration();
              },
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: asyncVerses.when(
          data: (verses) => _buildContent(verses, showTransliteration),
          loading: () => const Center(
            child: CircularProgressIndicator(color: _kAccent, strokeWidth: 2),
          ),
          error: (e, _) => const Center(
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
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _paperCard(child: _buildArabicBlock(verses)),

          const SizedBox(height: 10),

          // ── BLOK 2: Türkçe okunuş (gizlenebilir) ───────────────────────
          if (showTranslit) ...[
            _paperCard(
              label: 'Okunuş',
              child: _buildTransliterationBlock(verses),
            ),
            const SizedBox(height: 10),
          ],

          // ── BLOK 3: Türkçe meal ─────────────────────────────────────────
          _paperCard(label: 'Meâl', child: _buildTranslationBlock(verses)),
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null) ...[
              Row(
                children: [
                  const Text(
                    '❖ ',
                    style: TextStyle(color: _kAccent, fontSize: 12),
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      color: _kAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Divider(
                color: _kAccent.withValues(alpha: 0.3),
                height: 16,
                thickness: 0.8,
              ),
            ],
            child,
          ],
        ),
      ),
    );
  }

  // Tüm ayetler birleşik Arapça (resimdeki gibi)
  Widget _buildArabicBlock(List<QuranVerse> verses) {
    if (verses.isEmpty) return const SizedBox();

    final List<InlineSpan> spans = <InlineSpan>[];
    String? basmala;

    // Basmala tespiti: Fatiha (1) ve Tevbe (9) hariç
    // Genellikle ilk ayetin başında "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ" bulunur.
    const String basmalaText = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ";

    for (int i = 0; i < verses.length; i++) {
      final v = verses[i];
      String verseText = v.arabicText;

      // İlk ayette Besmele varsa ayır (Fatiha hariç, çünkü Fatiha'da Besmele 1. ayettir)
      if (i == 0 &&
          surahId != 1 &&
          surahId != 9 &&
          verseText.startsWith(basmalaText)) {
        basmala = basmalaText;
        verseText = verseText.replaceFirst(basmalaText, "").trim();
      }

      final verseStyle = GoogleFonts.scheherazadeNew(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        height: 2.4,
        color: _kText,
      );

      // Divine Name Highlighting uygula
      spans.addAll(processArabicText(verseText, verseStyle));

      // Ayet sonu gülü
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: VerseRose(number: v.number),
        ),
      );

      if (i < verses.length - 1) {
        spans.add(const TextSpan(text: ' '));
      }
    }

    return Column(
      children: [
        if (basmala != null) ...[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24, top: 8),
              child: Text(
                basmala,
                textAlign: TextAlign.center,
                style: GoogleFonts.scheherazadeNew(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _kText,
                ),
              ),
            ),
          ),
          Divider(color: _kAccent.withValues(alpha: 0.2), height: 1),
          const SizedBox(height: 20),
        ],
        RichText(
          textAlign: TextAlign.justify,
          textDirection: TextDirection.rtl,
          text: TextSpan(children: spans),
        ),
      ],
    );
  }

  // Numaralı Türkçe okunuş (düz metin)
  Widget _buildTransliterationBlock(List<QuranVerse> verses) {
    final spans = <InlineSpan>[];
    for (final v in verses) {
      spans.add(
        TextSpan(
          text: '${v.number} ',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: _kVerseNum,
          ),
        ),
      );
      spans.add(
        TextSpan(
          text: '${v.transliteration}  ',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.9,
            color: _kText,
          ),
        ),
      );
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
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            margin: const EdgeInsets.only(right: 6, bottom: 2),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _kVerseNum, width: 1.2),
              color: _kVerseNum.withValues(alpha: 0.1),
            ),
            child: Text(
              '${v.number}',
              style: const TextStyle(
                fontSize: 10,
                color: _kVerseNum,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
      spans.add(
        TextSpan(
          text: '${v.translation}  ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.9,
            color: _kText.withValues(alpha: 0.9),
          ),
        ),
      );
    }
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(children: spans),
    );
  }
}
