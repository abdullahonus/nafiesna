import 'package:flutter/material.dart';

import '../../../product/constants/app_spacing.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';

class SilsileData {
  static const List<String> list = [
    'Seyyidü’l Evvelîn ve’l Âhirîn\nHazreti Muhammed Mustafa (s.a.v.)',
    'Ebu’l Haseneyn İmam Hazreti Aliyy-i Murtezâ (k.v.)',
    'Şeyh Hasan-ı Basrî',
    'Şeyh Habîb-i A’cemî',
    'Şeyh Dâvud-ı Tâî',
    'Şeyh Mâruf-ı Kerhî',
    'Şeyh Seri-yi Sakatî',
    'Şeyh Cüneyd-i Bağdâdî',
    'Şeyh Mimşâd-ı Dîneverî',
    'Şeyh Abdullah Muhammed-i Dîneverî',
    'Şeyh Muhammed-i Bekrî',
    'Şeyh Ömer Vecîhüddîn-i Bekrî',
    'Şeyh Ebün’necîb Abdülkâhir-i Sühreverdî',
    'Şeyh Kutbüddîn-i Ebherî',
    'Şeyh Muhammed Rüknüddîn-i Nühâsî',
    'Şeyh Şihâbüddîn Muhammed-i Şîrâzî',
    'Şeyh Muhammed Cemâlüddîn-i Şirâzî',
    'Şeyh İbrâhim Zâhid-i Gîlânî',
    'Şeyh Kerîmüddîn Ahi Muhammed Nûr-ı Halvetî',
    'Pîr-i Tarîk Sirâcüddîn Ömer-i Halvetî',
    'Şeyh Ahi Emre Muhammed İrşâdi-i Halvetî',
    'Şeyh İzzüddîn-i Halvetî',
    'Şeyh Sadrüddîn-i Hıyavî',
    'Şeyh Celâlüddîn Yahya-i Şirvânî',
    'Şeyh Muhammed Bahâüddîn-i Erzincânî',
    'Şeyh Tâcüddîn İbrâhim-i Kayserî',
    'Şeyh Alâuddîn-i Uşşâkî',
    'Şeyh Ahmed Şemsüddîn-i Marmaravî (Yiğitbâş-ı Velî)',
    'Şeyh İzzeddîn-i Karâmanî',
    'Şeyh İbrâhim Ümmî Sinân',
    'Şeyh Emir Ahmed Semerkandî',
    'Hazreti Pîr Seyyid Hüsâmüddîn Hasan Buhârî-i Uşşâkî',
    'Şeyh Mehmed Memicân-ı Saruhânî',
    'Şeyh Ömer Karîbî-i Bolayırî-i Geliboluvî',
    'Şeyh Alim Sinân Muğlavî-i Keşânî',
    'Şeyh Mehmed Drâmâvî-i Keşânî',
    'Şeyh Halil-i Gümülcinevî',
    'Şeyh Abdülkerim-i Gümülcinevî',
    'Şeyh Osman Sıdkî Gümülcinevî-i Edirnevî',
    'Şeyh Hamdi Edirnevî (Bağdâdî)',
    '2. Pîr Şeyh Mehmed Cemâlüddîn Uşşâkî Edirnevî',
    '3. Pîr Şeyh Abdullah Salahuddîn Uşşâkî Kesriyevî',
    'Şeyh Mehmed Zühdi-i Nâzillivî',
    'Şeyh Ali Gâlib Vasfi-i Nâzillivî',
    'Şeyh Mehmed Tevfik-i Nâzillivî',
    'Şeyh Ömer Hulûsi-i Boğazhisârî',
    'Şeyh Hüseyin Hakkı-yı Kasabavî',
    'Şeyh Ahmed Tâlibî İrşâdî Bayındırî-i Kilitbahrî',
    'Şeyh Ahmed Şücâüddîn-i Geliboluvî',
    'Şeyh Abdurrahman Sâmî Niyâzî-i Saruhânî',
    'Şeyh Bekir Sıdkı Visâlî-i Kulevî',
    'Şeyh Mehmed Rûhî-i Kulevî',
    'Şeyh Seyyid Kâzım Siverekî',
    'Şeyh Hacı Hüseyin Rıdvan Özaydın el-Balıkesirî',
    'Şeyh Murat Beyazıt Akdemirelli',
  ];
}

class SilsilePage extends StatelessWidget {
  const SilsilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Silsile-i Tarîk-i Uşşâkiyye'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.background, AppColors.surfaceVariant],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            itemCount: SilsileData.list.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                  child: Column(
                    children: [
                      Text(
                        'Bismillahirrahmanirrahim',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: AppColors.accent,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Divider(
                        color: AppColors.accentLight,
                        indent: 40,
                        endIndent: 40,
                        thickness: 0.5,
                      ),
                    ],
                  ),
                );
              }
              if (index == SilsileData.list.length + 1) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.xl,
                    bottom: AppSpacing.xxl,
                  ),
                  child: Text(
                    '“Allahümme salli alâ seyyidinâ Muhammedin\nve alâ âli seyyidinâ Muhammed”',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.accent,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final realIndex = index - 1;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${realIndex + 1}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd,
                          ),
                          border: Border.all(
                            color: AppColors.border.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          SilsileData.list[realIndex],
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.onBackground,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
