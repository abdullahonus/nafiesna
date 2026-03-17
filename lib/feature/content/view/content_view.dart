import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifier/content_notifier.dart';
import '../provider/content_provider.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/constants/app_spacing.dart';
import '../../../product/widget/common/app_loading_indicator.dart';

@RoutePage()
class ContentView extends ConsumerStatefulWidget {
  const ContentView({super.key});

  @override
  ConsumerState<ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends ConsumerState<ContentView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() => ref.read(contentProvider.notifier).init());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(contentProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Dini Bilgiler'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Kandil & Bayramlar'),
            Tab(text: 'İslami Bilgiler'),
          ],
        ),
      ),
      body: state.isLoading
          ? const AppLoadingIndicator()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildReligiousDays(state.religiousDays),
                _buildIslamicInfo(state.islamicInfos),
              ],
            ),
    );
  }

  Widget _buildReligiousDays(List<ReligiousDay> days) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: days.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final day = days[index];
        return _DayCard(day: day);
      },
    );
  }

  Widget _buildIslamicInfo(List<IslamicInfo> infos) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: infos.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        return _InfoCard(info: infos[index]);
      },
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({required this.day});

  final ReligiousDay day;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        color: AppColors.surface,
        border: Border.all(
          color: day.isUpcoming
              ? AppColors.primary.withValues(alpha: 0.4)
              : AppColors.border,
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: day.isUpcoming
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.surfaceVariant,
            ),
            child: Center(
              child: Text(day.icon, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        day.name,
                        style: AppTextStyles.headlineSmall,
                      ),
                    ),
                    if (day.isUpcoming)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Text(
                          'YAKINDA',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primary,
                            fontSize: 9,
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  day.date,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(day.description, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatefulWidget {
  const _InfoCard({required this.info});

  final IslamicInfo info;

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          color: AppColors.surface,
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
