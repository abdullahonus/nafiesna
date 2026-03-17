import 'package:flutter/material.dart';
import '../../init/theme/app_colors.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key, this.color, this.size = 24});

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: color ?? AppColors.primary,
        ),
      ),
    );
  }
}
