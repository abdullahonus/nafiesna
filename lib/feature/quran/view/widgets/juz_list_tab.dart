import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../product/constants/app_spacing.dart';
import '../../../../product/init/theme/app_colors.dart';
import '../../../../product/init/theme/app_text_styles.dart';
import '../../../../product/navigation/app_router.dart';
import '../../model/juz_list_data.dart';

class JuzListTab extends StatelessWidget {
  const JuzListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      itemCount: juzList.length,
      itemBuilder: (context, index) {
        final juz = juzList[index];
        final startPage = juz.startPage;
        final endPage = juz.endPage;
        
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.border.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          color: Colors.transparent,
          child: ExpansionTile(
            title: Row(
              children: [
                _buildIslamicStar(juz.id),
                const SizedBox(width: AppSpacing.md),
                Text(
                  '${juz.id}. Cüz',
                  style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${juz.startSurahName}-${juz.startAyah}',
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary),
                    ),
                    Text(
                      '${juz.endSurahName}-${juz.endAyah}',
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            iconColor: AppColors.accent,
            collapsedIconColor: AppColors.textSecondary,
            children: List.generate(
              (endPage - startPage) + 1,
              (pageIndex) {
                final pageNo = startPage + pageIndex;
                if (pageNo > 604) return const SizedBox.shrink(); // Kuran 604 sayfa
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 60, right: 16),
                  leading: Icon(
                    Icons.star_half_rounded,
                    size: 20,
                    color: AppColors.accent.withValues(alpha: 0.6),
                  ),
                  title: Text(
                    'Sayfa $pageNo',
                    style: AppTextStyles.bodyMedium,
                  ),
                  trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.textSecondary),
                  onTap: () {
                    context.router.push(MushafPageRoute(pageNumber: pageNo));
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildIslamicStar(int number) {
     return SizedBox(
      width: 32,
      height: 32,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: 3.14159 / 4,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.6), width: 1.2),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.6), width: 1.2),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Text(
            '$number',
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
