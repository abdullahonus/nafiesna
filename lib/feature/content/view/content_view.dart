import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nafiesna/product/widget/common/username_badge.dart';

import '../../../product/constants/app_spacing.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/widget/common/watermark_overlay.dart';
import '../widgets/islamic_info_page.dart';
import '../widgets/missed_prayers_page.dart';
import '../widgets/nearby_mosques_page.dart';
import '../widgets/religious_days_page.dart';
import '../widgets/silsile_page.dart';

@RoutePage()
class ContentView extends ConsumerWidget {
  const ContentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [UsernameBadge(), SizedBox(width: 8)],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const IslamicInfoPage(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            context.colors.primary.withValues(alpha: 0.8),
                            context.colors.primary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusLg,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: context.colors.primary.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.menu_book_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sohbet Notları ve İslami Bilgiler, Dualar',
                                  style: context.textTheme.headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        height: 1.3,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Diğer İçerikler',
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.9,
                    children: [
                      _MenuCard(
                        icon: Icons.calendar_month_rounded,
                        label: 'Dini Günler',
                        color: context.colors.accent,
                        page: const ReligiousDaysPage(),
                      ),
                      _MenuCard(
                        icon: Icons.mosque_rounded,
                        label: 'Yakın Camiler',
                        color: context.colors.info,
                        page: const NearbyMosquesPage(),
                      ),
                      _MenuCard(
                        icon: Icons.replay_rounded,
                        label: 'Kazalar',
                        color: context.colors.success,
                        page: const MissedPrayersPage(),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  // Silsile Bölümü
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SilsilePage(),
                      ),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.lg,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusLg,
                        ),
                        border: Border.all(
                          color: context.colors.primary.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'SİLSİLE-İ TARÎK-İ ‘UŞŞÂKİYYE',
                            style: context.textTheme.headlineSmall?.copyWith(
                              color: context.colors.accent,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Bismillahirrahmanirrahim',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colors.onBackground.withValues(
                                alpha: 0.8,
                              ),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          SizedBox(
                            height: 120,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: SilsileData.list.length,
                              separatorBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xs,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: context.colors.primary,
                                  size: 16,
                                ),
                              ),
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 140,
                                  padding: const EdgeInsets.all(AppSpacing.sm),
                                  decoration: BoxDecoration(
                                    color: context.colors.surface,
                                    borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusMd,
                                    ),
                                    border: Border.all(
                                      color: context.colors.border.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: context.colors.primary,
                                        child: Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            SilsileData.list[index],
                                            textAlign: TextAlign.center,
                                            style: context.textTheme.bodySmall
                                                ?.copyWith(
                                                  fontSize: 11,
                                                  color: context
                                                      .colors
                                                      .onBackground,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.2,
                                                ),
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                            ),
                            child: Text(
                              '“Allahümme salli alâ seyyidinâ Muhammedin\nve alâ âli seyyidinâ Muhammed”',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colors.accent,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  // Çıkış Yap Butonu
                  /*  _buildLogoutButton(context, ref), */
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
          // Watermark
          const WatermarkOverlay(),
        ],
      ),
    );
  }

  /*  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutDialog(context, ref),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.error.withValues(alpha: 0.1),
          foregroundColor: context.colors.error,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            side: BorderSide(color: context.colors.error, width: 0.5),
          ),
        ),
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: const Text(
          'Çıkış Yap',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text(
          'Hesabınızdan çıkış yapmak istediğinize emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
            },
            style: TextButton.styleFrom(foregroundColor: context.colors.error),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
  } */
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
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => page)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          color: context.colors.surface,
          border: Border.all(
            color: context.colors.border.withValues(alpha: 0.6),
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
                color: color.withValues(alpha: 0.3),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: context.textTheme.labelLarge?.copyWith(
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

class SilsileData {
  static const List<String> list = [
    'Hz. Seyyid-i Kâinat Muhammed Mustafa (s.a.v.)',
    'Amirre\'l-Mü\'minin Ali bin Ebî Tâlib (k.v.)',
    'Hasan el-Basrî (k.s.)',
    'Habîb el-Acemî (k.s.)',
    'Dâvud et-Tâî (k.s.)',
    'Ma\'ruf el-Kerhî (k.s.)',
    'Serî es-Sakatî (k.s.)',
    'Cüneyd-i Bağdâdî (k.s.)',
    'Ebû Ali er-Rûdbârî (k.s.)',
    'Ebû Ali el-Kâtib (k.s.)',
    'Ebû Osmân el-Mağribî (k.s.)',
    'Ebû’l-Kâsım el-Gürgânî (k.s.)',
    'Ebû Bekir en-Nessâc (k.s.)',
    'Ahmed el-Gazzâlî (k.s.)',
    'Ebû’l-Fadl el-Bağdâdî (k.s.)',
    'Ebû’l-Berekât (k.s.)',
    'Ebû Said el-Endülüsî (k.s.)',
    'Şeyfe’d-dîn İbn-i Sahrüverdî (k.s.)',
    'Necmeddîn-i Kübrâ (k.s.)',
    'Mecdüddîn-i Bağdâdî (k.s.)',
    'Radıyyüddîn Ali Lala (k.s.)',
    'Seyfeddîn el-Bâherzî (k.s.)',
    'Bedruddîn-i Semerkandî (k.s.)',
    'Zeyneddîn-i Hâfi (k.s.)',
    'Sadreddîn el-Hayyâmî (k.s.)',
    'Murtazâ el-Eşrefoğlu (k.s.)',
    'İbrahim el-Kayserî (k.s.)',
    'Pîr Hüsameddîn-i Uşşâkî (k.s.)',
    'Hazret-i Şeyh Memi Can (k.s.)',
    'Hazret-i Şeyh Ahmed Semerkandî (k.s.)',
    'Hazret-i Şeyh Veli Efendi (k.s.)',
    'Hazret-i Şeyh Seyyid Sâlih Efendi (k.s.)',
    'Hazret-i Şeyh Cihangirli Muhammed Efendi (k.s.)',
    'Hazret-i Şeyh Nurullah Efendi (k.s.)',
    'Hazret-i Şeyh Hüsameddin Efendi (k.s.)',
    'Hazret-i Şeyh Abdurrauf Efendi (k.s.)',
    'Hazret-i Şeyh Abdurrahman Efendi (k.s.)',
    'Hazret-i Şeyh Abdullatif Efendi (k.s.)',
    'Hazret-i Şeyh Abdulkadir Efendi (k.s.)',
    'Hazret-i Şeyh İbrahim İzzettin (k.s.)',
    'Hazret-i Şeyh Seyyid Bekir Sıdkı Visâlî (k.s.)',
    'Hazret-i Şeyh Hüseyin Hüsnü Efendi (k.s.)',
    'Hazret-i Şeyh Seyyid Bekir Sıdkı Visâlî müridi',
  ];
}
