import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../product/init/theme/app_colors.dart';
import '../../../../product/init/theme/app_text_styles.dart';

class IslamicStar extends StatelessWidget {
  final String text;
  const IslamicStar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: pi / 4,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.8), width: 1.2),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.8), width: 1.2),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Text(
            text,
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}
