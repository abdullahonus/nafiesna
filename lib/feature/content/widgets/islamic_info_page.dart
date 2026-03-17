import 'package:flutter/material.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/constants/app_spacing.dart';

class IslamicInfoPage extends StatelessWidget {
  const IslamicInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'İslami Bilgiler',
          style: AppTextStyles.headlineSmall.copyWith(color: AppColors.accent),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: _infos.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (_, int index) => _InfoCard(info: _infos[index]),
      ),
    );
  }
}

class _InfoCard extends StatefulWidget {
  const _InfoCard({required this.info});

  final _IslamicInfo info;

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          color: AppColors.surface,
          border: Border.all(
            color: _expanded
                ? AppColors.accent.withValues(alpha: 0.3)
                : AppColors.border,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.info.category,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.accent,
                      fontSize: 10,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(widget.info.title, style: AppTextStyles.headlineSmall),
            if (_expanded) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                widget.info.content,
                style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _IslamicInfo {
  const _IslamicInfo({
    required this.title,
    required this.content,
    required this.category,
  });

  final String title;
  final String content;
  final String category;
}

const List<_IslamicInfo> _infos = [
  _IslamicInfo(
    title: 'İslam\'ın Beş Şartı',
    content:
        'Kelime-i Şehadet, Namaz, Oruç, Zekât ve Hac. Bu beş temel ibadet '
        'İslam\'ın direğini oluşturur.',
    category: 'Temel Bilgiler',
  ),
  _IslamicInfo(
    title: 'Beş Vakit Namaz',
    content:
        'Sabah, Öğle, İkindi, Akşam ve Yatsı. Günde beş vakit kılınan namaz, '
        'müminin Allah ile buluşmasıdır.',
    category: 'İbadet',
  ),
  _IslamicInfo(
    title: 'Kur\'ân-ı Kerim',
    content:
        'Allah\'ın son vahyi. 114 sure, 6236 ayetten oluşur. '
        'Hz. Peygamber\'e (s.a.v.) 23 yılda indirilmiştir.',
    category: 'Kur\'ân',
  ),
  _IslamicInfo(
    title: 'Sünnet ve Hadis',
    content:
        'Hz. Peygamber\'in (s.a.v.) sözleri, fiilleri ve tasvipleri. '
        'İslam\'ın ikinci ana kaynağını oluşturur.',
    category: 'Sünnet',
  ),
  _IslamicInfo(
    title: 'Dua Adabı',
    content:
        'Kıbleye yönelmek, abdestli olmak, eller açık tutmak ve kalp huzuruyla '
        'yönelmek dua adabındandır.',
    category: 'İbadet',
  ),
  _IslamicInfo(
    title: 'İmanın Şartları',
    content:
        'Allah\'a, Meleklerine, Kitaplarına, Peygamberlerine, Ahiret gününe, '
        'Kader ve Kazaya iman etmek.',
    category: 'Temel Bilgiler',
  ),
  _IslamicInfo(
    title: 'Abdest',
    content:
        'Farzları: Yüzü yıkamak, iki kolu dirseklerle birlikte yıkamak, '
        'başın dörtte birini meshetmek, iki ayağı topuklarla birlikte yıkamak.',
    category: 'İbadet',
  ),
];
