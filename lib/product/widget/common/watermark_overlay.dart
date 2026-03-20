import 'package:flutter/material.dart';

class WatermarkOverlay extends StatelessWidget {
  const WatermarkOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Opacity(
          opacity: 0.03, // Çok daha kısık bir filigran
          child: Image.asset('assets/icon/appicon.png', fit: BoxFit.cover),
        ),
      ),
    );
  }
}
