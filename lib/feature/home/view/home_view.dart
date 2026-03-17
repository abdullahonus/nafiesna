import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifier/home_notifier.dart';
import '../provider/home_provider.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/constants/app_spacing.dart';
import '../../../product/widget/common/app_loading_indicator.dart';
import '../../../product/widget/common/app_error_state.dart';
import '../widgets/hadith_card.dart';
import '../widgets/live_stream_card.dart';
import '../widgets/prayer_times_bar.dart';
import '../widgets/hijri_calendar_card.dart';
import '../../prayer_times/provider/prayer_times_provider.dart';

@RoutePage()
class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(homeProvider.notifier).init();
      ref.read(prayerTimesProvider.notifier).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 60,
            floating: true,
            snap: true,
            backgroundColor: AppColors.surface,
            elevation: 0,
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: AppSpacing.md),
              title: Text(
                'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيمِ',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: 'serif',
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LiveStreamCard(),
                  const SizedBox(height: AppSpacing.md),
                  const PrayerTimesBar(),
                  const SizedBox(height: AppSpacing.md),
                  const HijriCalendarCard(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildHadithSection(state),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHadithSection(HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text('Günün Hadisi', style: AppTextStyles.headlineSmall),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (state.isLoading)
          const SizedBox(height: 120, child: AppLoadingIndicator())
        else if (state.errorMessage != null)
          AppErrorState(
            message: state.errorMessage!,
            onRetry: () => ref.read(homeProvider.notifier).loadHadith(),
          )
        else if (state.hadith != null)
          HadithCard(hadith: state.hadith!)
        else
          const HadithCard(
            hadith: HadithData(
              text:
                  'Kolaylaştırınız, güçleştirmeyiniz. Müjdeleyiniz, nefret ettirmeyiniz.',
              arabicText: '',
              attribution: 'Sahih-i Buhârî',
              grade: 'Sahih',
            ),
          ),
      ],
    );
  }
}
