import 'package:flutter/material.dart';
import '../../init/theme/app_colors.dart';
import '../../init/theme/app_text_styles.dart';
import '../../constants/app_spacing.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    this.message = 'Bir hata oluştu.',
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              TextButton(
                onPressed: onRetry,
                child: const Text('Tekrar Dene'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
