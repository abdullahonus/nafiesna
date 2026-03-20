import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import 'widgets/surah_list_tab.dart';
import 'widgets/juz_list_tab.dart';

@RoutePage()
class QuranView extends StatelessWidget {
  const QuranView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Kur\'an-ı Kerim',
            style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: AppColors.accent,
            labelColor: AppColors.onBackground,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.bold),
            unselectedLabelStyle: AppTextStyles.bodyLarge,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Sûreler'),
              Tab(text: 'Cüzler'),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        body: const TabBarView(
          children: [
            SurahListTab(),
            JuzListTab(),
          ],
        ),
      ),
    );
  }
}
