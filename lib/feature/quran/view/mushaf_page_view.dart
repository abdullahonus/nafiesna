import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../product/constants/app_spacing.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/widget/common/app_loading_indicator.dart';
import '../../../product/widget/common/app_error_state.dart';
import '../provider/quran_provider.dart';
import '../model/quran_page_model.dart';

@RoutePage()
class MushafPageView extends ConsumerWidget {
  final int pageNumber;

  const MushafPageView({
    super.key,
    required this.pageNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPage = ref.watch(pageDetailProvider(pageNumber));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sayfa $pageNumber',
          style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: asyncPage.when(
        data: (verses) {
          if (verses.isEmpty) {
            return const Center(child: Text("Bu sayfada veri bulunamadı."));
          }
          return _buildMushafPage(context, verses);
        },
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (error, stack) => AppErrorState(
          message: error.toString(),
          onRetry: () => ref.read(pageDetailProvider(pageNumber)),
        ),
      ),
    );
  }

  Widget _buildMushafPage(BuildContext context, List<QuranPageVerse> verses) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sure Başlığı Ekleme Mantığı
          ..._buildPageContentWithHeaders(context, verses),
        ],
      ),
    );
  }

  List<Widget> _buildPageContentWithHeaders(BuildContext context, List<QuranPageVerse> verses) {
    final List<Widget> children = [];
    int currentSurahId = -1;
    List<InlineSpan> currentSpans = [];

    void flushSpans() {
      if (currentSpans.isNotEmpty) {
        children.add(
          RichText(
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
            text: TextSpan(children: List.from(currentSpans)),
          ),
        );
        currentSpans.clear();
      }
    }

    for (var verse in verses) {
      if (verse.surahId != currentSurahId) {
        flushSpans();
        currentSurahId = verse.surahId;
        children.add(
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.md),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
            ),
            child: Text(
              'سُورَةُ ${verse.surahName.replaceAll("سُورَةُ", "").trim()}',
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineMedium.copyWith(
                fontFamily: 'Amiri',
                fontWeight: FontWeight.bold,
                color: AppColors.accent,
              ),
            ),
          ),
        );
      }

      currentSpans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            onTap: () => _showTranslation(context, verse),
            child: Text(
              '${verse.arabicText} ',
              style: const TextStyle(
                fontFamily: 'Amiri',
                height: 2.4,
                fontSize: 22,
                fontWeight: FontWeight.w400,  // ince, okunabilir
                color: Color(0xFF1A1A2E),     // koyu ama mat, bold değil
              ),
            ),
          ),
        ),
      );

      currentSpans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: _buildEndMarker(verse.numberInSurah),
        ),
      );
      
      currentSpans.add(const TextSpan(text: ' '));
    }

    flushSpans();

    return children;
  }

  Widget _buildEndMarker(int number) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.accent, width: 1.5),
        color: AppColors.surfaceVariant.withValues(alpha: 0.3),
      ),
      child: Text(
        '$number',
        style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent, fontSize: 10),
      ),
    );
  }

  void _showTranslation(BuildContext context, QuranPageVerse verse) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${verse.surahName} - ${verse.numberInSurah}. Ayet',
                  style: AppTextStyles.headlineSmall.copyWith(color: AppColors.accent),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  verse.translationText,
                  style: AppTextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        );
      },
    );
  }
}
