import 'package:flutter/material.dart';
import '../notifier/home_notifier.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/constants/app_spacing.dart';

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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.accent.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tırnak ikonu + Başlık satırı
          Row(
            children: [
              Icon(
                Icons.format_quote_rounded,
                color: AppColors.accent.withValues(alpha: 0.7),
                size: 28,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  'Günün Hadisi',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              if (hadith.grade.isNotEmpty) _GradeBadge(grade: hadith.grade),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Arapça metin (sağdan sola)
          if (hadith.arabicText.isNotEmpty) ...[
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                hadith.arabicText,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontFamily: 'serif',
                  fontSize: 17,
                  height: 1.9,
                  color: AppColors.accent.withValues(alpha: 0.9),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Divider(color: AppColors.border, thickness: 0.5),
            const SizedBox(height: AppSpacing.sm),
          ],

          // Türkçe metin
          Text(
            hadith.text,
            style: AppTextStyles.bodyLarge.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.7,
            ),
          ),

          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.border, thickness: 0.5),
          const SizedBox(height: AppSpacing.sm),

          // Kaynak bilgisi
          Row(
            children: [
              const Icon(
                Icons.menu_book_rounded,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  hadith.attribution,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.accent,
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
        color: AppColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        grade,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.accent,
          fontSize: 10,
        ),
      ),
    );
  }
}
