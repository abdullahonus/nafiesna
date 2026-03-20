import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../product/constants/app_spacing.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/widget/quran/quran_text_view.dart';
import '../notifier/home_notifier.dart';

class HadithCard extends StatelessWidget {
  const HadithCard({super.key, required this.hadith});

  final HadithData hadith;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        color: context.colors.surface,
        border: Border.all(
          color: context.colors.primary.withValues(alpha: 0.3),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.12),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: context.colors.accent.withValues(alpha: 0.1),
            blurRadius: 6,
            spreadRadius: 0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tırnak ikonu + Başlık satırı
          Row(
            children: [
              Icon(
                Icons.format_quote_rounded,
                color: context.colors.accent.withValues(alpha: 0.7),
                size: 28,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  'Günün Hadisi',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colors.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              if (hadith.grade.isNotEmpty)
                _GradeBadge(grade: hadith.grade),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Arapça metin (sağdan sola)
          if (hadith.arabicText.isNotEmpty) ...[
            Directionality(
              textDirection: TextDirection.rtl,
              child: RichText(
                text: TextSpan(
                  children: processArabicText(
                    hadith.arabicText,
                    GoogleFonts.scheherazadeNew(
                      fontSize: 25,
                      height: 2.5,
                      wordSpacing: 3,
                      color: context.colors.accent.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Divider(color: context.colors.border, thickness: 0.5),
            const SizedBox(height: AppSpacing.sm),
          ],

          // Türkçe metin
          Text(
            hadith.text,
            style: context.textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.7,
              color: context.colors.onBackground,
            ),
          ),

          const SizedBox(height: AppSpacing.md),
          Divider(color: context.colors.border, thickness: 0.5),
          const SizedBox(height: AppSpacing.sm),

          // Kaynak bilgisi
          Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                size: 14,
                color: context.colors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  hadith.attribution,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colors.accent,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GradeBadge extends StatelessWidget {
  const _GradeBadge({required this.grade});

  final String grade;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: context.colors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: context.colors.accent.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        grade,
        style: context.textTheme.labelSmall?.copyWith(
          color: context.colors.accent,
          fontSize: 10,
        ),
      ),
    );
  }
}
