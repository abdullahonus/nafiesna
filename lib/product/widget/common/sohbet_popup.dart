import 'dart:math';

import 'package:flutter/material.dart';

import '../../../feature/content/widgets/islamic_info_page.dart';
import '../../constants/app_spacing.dart';
import '../../init/theme/app_text_styles.dart';
import '../quran/quran_text_view.dart';

class SohbetPopup extends StatelessWidget {
  const SohbetPopup({super.key, required this.info, required this.item});

  final IslamicInfo info;
  final IslamicInfoItem item;

  static void show(BuildContext context) {
    final islamicInfos = IslamicInfoPage.getIslamicInfos(context);
    if (islamicInfos.isEmpty) return;

    final random = Random();
    final randomInfo = islamicInfos[random.nextInt(islamicInfos.length)];
    if (randomInfo.items.isEmpty) return;

    final randomItem =
        randomInfo.items[random.nextInt(randomInfo.items.length)];

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Sohbet',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return SohbetPopup(info: randomInfo, item: randomItem);
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: Curves.easeInOutBack.transform(anim1.value),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          boxShadow: [
            BoxShadow(
              color: info.color.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: info.color.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.radiusXl),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: info.color.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(info.icon, color: info.color, size: 24),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            info.title,
                            style: context.textTheme.labelSmall?.copyWith(
                              color: info.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            item.title,
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded, size: 20),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    if (item.count != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: info.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.count!,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: info.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    ScholarlyArabicTextWithHighlight(
                      text: item.content,
                      query: '',
                      style: context.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        color: context.colors.onBackground.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: info.color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMd,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Allah Kabul Etsin',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
