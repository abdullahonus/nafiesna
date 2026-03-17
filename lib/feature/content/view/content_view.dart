import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/constants/app_spacing.dart';
import '../widgets/religious_days_page.dart';
import '../widgets/missed_prayers_page.dart';
import '../widgets/dream_journal_page.dart';
import '../widgets/nearby_mosques_page.dart';
import '../widgets/islamic_info_page.dart';

@RoutePage()
class ContentView extends StatelessWidget {
  const ContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Menü'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.9,
          children: const [
            _MenuCard(
              icon: Icons.calendar_month_rounded,
              label: 'Dini Günler',
              color: AppColors.accent,
              page: ReligiousDaysPage(),
            ),
            _MenuCard(
              icon: Icons.mosque_rounded,
              label: 'Yakın Camiler',
              color: AppColors.primary,
              page: NearbyMosquesPage(),
            ),
            _MenuCard(
              icon: Icons.replay_rounded,
              label: 'Kazalar',
              color: Color(0xFF4CAF50),
              page: MissedPrayersPage(),
            ),
            _MenuCard(
              icon: Icons.auto_stories_rounded,
              label: 'Rüya Defteri',
              color: Color(0xFF9C27B0),
              page: DreamJournalPage(),
            ),
            _MenuCard(
              icon: Icons.info_outline_rounded,
              label: 'İslami Bilgiler',
              color: Color(0xFF2196F3),
              page: IslamicInfoPage(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.page,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => page),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          color: AppColors.surface,
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.6),
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                color: color.withValues(alpha: 0.15),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onBackground,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
