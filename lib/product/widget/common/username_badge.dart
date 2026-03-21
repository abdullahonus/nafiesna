import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../init/theme/app_text_styles.dart';

/// Kullanıcının e-posta adresinden @ öncesi kısmını
/// altın renkli küçük bir chip olarak gösterir.
///
/// Kullanım: AppBar actions içine ekle.
/// ```dart
/// actions: [const UsernameBadge(), const SizedBox(width: 8)],
/// ```
class UsernameBadge extends StatelessWidget {
  const UsernameBadge({super.key});

  String get _username {
    final String? email = FirebaseAuth.instance.currentUser?.email;
    if (email != null && email.contains('@')) return email.split('@').first;
    return 'Misafir';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: context.colors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.colors.accent.withValues(alpha: 0.35),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_rounded,
            size: 13,
            color: context.colors.accent,
          ),
          const SizedBox(width: 4),
          Text(
            _username,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colors.accent,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
