import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../product/constants/app_spacing.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/widget/common/app_loading_indicator.dart';
import '../../../product/widget/common/app_error_state.dart';
import '../provider/quran_provider.dart';
import '../model/quran_verse_model.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(surahName, style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.bold)),
            Text(arabicName, style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent)),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              showTransliteration ? Icons.text_fields_rounded : Icons.translate_rounded,
              color: showTransliteration ? AppColors.accent : AppColors.textSecondary,
            ),
            tooltip: showTransliteration ? 'Okunuşu Gizle' : 'Okunuşu Göster',
            onPressed: () {
              ref.read(quranPreferencesProvider.notifier).toggleTransliteration();
            },
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: asyncVerses.when(
        data: (verses) => _buildVerseList(verses, showTransliteration),
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (error, stack) => AppErrorState(
          message: error.toString(),
          onRetry: () => ref.read(surahDetailProvider(surahId)),
        ),
      ),
    );
  }

  Widget _buildVerseList(List<QuranVerse> verses, bool showTransliteration) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── BLOK 1: Tüm sure Arapça metni (sağdan sola akıcı) ──────────
          _buildArabicBlock(verses),

          const SizedBox(height: AppSpacing.xl),
          Divider(color: AppColors.accent.withValues(alpha: 0.25), thickness: 1),
          const SizedBox(height: AppSpacing.lg),

          // ── BLOK 2: Numaralı Türkçe okunuş (resimdeki gibi) ─────────────
          if (showTransliteration) ...[
            _buildTransliterationBlock(verses),
            const SizedBox(height: AppSpacing.xl),
            Divider(color: AppColors.accent.withValues(alpha: 0.25), thickness: 1),
            const SizedBox(height: AppSpacing.lg),
          ],

          // ── BLOK 3: Numaralı Türkçe meal ────────────────────────────────
          _buildTranslationBlock(verses),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  // Arapça metin — sağdan sola, hepsi birleşik akıyor (resimdeki gibi)
  Widget _buildArabicBlock(List<QuranVerse> verses) {
    final spans = <InlineSpan>[];
    for (final verse in verses) {
      spans.add(
        TextSpan(
          text: '${verse.arabicText} ',
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 26,
            fontWeight: FontWeight.w400,
            height: 2.2,
            color: AppColors.onBackground,
          ),
        ),
      );
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: _buildVerseMarker(verse.number),
        ),
      );
      spans.add(const TextSpan(text: '  '));
    }

    return RichText(
      textAlign: TextAlign.justify,
      textDirection: TextDirection.rtl,
      text: TextSpan(children: spans),
    );
  }

  // Türkçe okunuş — numaralı, düz metin (resimdeki gibi birleşik paragraf)
  Widget _buildTransliterationBlock(List<QuranVerse> verses) {
    final spans = <InlineSpan>[];
    for (final verse in verses) {
      // Numara — koyu renkli
      spans.add(
        TextSpan(
          text: '${verse.number} ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: AppColors.accent,
          ),
        ),
      );
      // Okunuş metni — düz, okunaklı
      spans.add(
        TextSpan(
          text: '${verse.transliteration}  ',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            height: 1.9,
            color: AppColors.onBackground,
          ),
        ),
      );
    }

    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(children: spans),
    );
  }

  // Türkçe meal — numaralı, her ayet ayrı satırda
  Widget _buildTranslationBlock(List<QuranVerse> verses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: verses.map((verse) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVerseMarker(verse.number),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  verse.translation,
                  style: AppTextStyles.bodyMedium.copyWith(
                    height: 1.7,
                    color: AppColors.onBackground.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVerseMarker(int number) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceVariant.withValues(alpha: 0.3),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.6), width: 1),
      ),
      child: Text(
        '$number',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.accent,
        ),
      ),
    );
  }
}
