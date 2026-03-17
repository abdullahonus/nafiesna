import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/constants/app_spacing.dart';
import '../../../service/islamic_calendar_service.dart';

final _eventsProvider = FutureProvider<List<IslamicEvent>>((ref) {
  return IslamicCalendarService().getUpcomingEvents();
});

class ReligiousDaysPage extends ConsumerWidget {
  const ReligiousDaysPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(_eventsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Dini Günler & Bayramlar',
          style: AppTextStyles.headlineSmall.copyWith(color: AppColors.accent),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),
      body: eventsAsync.when(
        data: (List<IslamicEvent> events) => _buildList(events),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (_, __) => _buildList(IslamicCalendarService.getFallback2026()),
      ),
    );
  }

  Widget _buildList(List<IslamicEvent> events) {
    if (events.isEmpty) {
      return const Center(
        child: Text('Yaklaşan dini gün bulunamadı.', style: AppTextStyles.bodyMedium),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: events.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, int index) {
        final IslamicEvent event = events[index];
        return _EventCard(event: event);
      },
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});

  final IslamicEvent event;

  @override
  Widget build(BuildContext context) {
    final int days = event.daysUntil;
    final bool isToday = days == 0;
    final bool isSoon = days <= 7 && days > 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        color: AppColors.surface,
        border: Border.all(
          color: isToday
              ? AppColors.success.withValues(alpha: 0.5)
              : isSoon
                  ? AppColors.primary.withValues(alpha: 0.4)
                  : AppColors.border,
          width: isToday ? 1.2 : 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isToday
                  ? AppColors.success.withValues(alpha: 0.15)
                  : isSoon
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.surfaceVariant,
            ),
            child: Icon(
              _getIcon(event.name),
              color: isToday
                  ? AppColors.success
                  : isSoon
                      ? AppColors.primary
                      : AppColors.accent,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.name, style: AppTextStyles.headlineSmall),
                const SizedBox(height: 2),
                Text(
                  _formatDate(event.date),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
          _buildBadge(days, isToday),
        ],
      ),
    );
  }

  Widget _buildBadge(int days, bool isToday) {
    final String text;
    final Color bgColor;
    final Color textColor;

    if (isToday) {
      text = 'BUGÜN';
      bgColor = AppColors.success.withValues(alpha: 0.2);
      textColor = AppColors.success;
    } else if (days == 1) {
      text = 'YARIN';
      bgColor = AppColors.primary.withValues(alpha: 0.2);
      textColor = AppColors.primary;
    } else {
      text = '$days gün';
      bgColor = AppColors.surfaceVariant;
      textColor = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const List<String> months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
    ];
    const List<String> weekdays = [
      'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}, ${weekdays[date.weekday - 1]}';
  }

  IconData _getIcon(String name) {
    if (name.contains('Bayram')) return Icons.celebration_rounded;
    if (name.contains('Kandil')) return Icons.auto_awesome_rounded;
    if (name.contains('Kadir')) return Icons.star_rounded;
    if (name.contains('Ramazan')) return Icons.mosque_rounded;
    if (name.contains('Aşure')) return Icons.water_drop_rounded;
    if (name.contains('Hicri')) return Icons.event_rounded;
    if (name.contains('Arefe')) return Icons.wb_twilight_rounded;
    return Icons.calendar_today_rounded;
  }
}
