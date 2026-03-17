import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/constants/app_spacing.dart';
import '../../../service/islamic_calendar_service.dart';

final _eventsProvider = FutureProvider.autoDispose<List<IslamicEvent>>((ref) {
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
          'Dini Günler ${DateTime.now().year}',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.onBackground,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.calendar_month_rounded,
                color: AppColors.accent, size: 22),
          ),
        ],
      ),
      body: eventsAsync.when(
        data: (List<IslamicEvent> events) => events.isEmpty
            ? _buildEmpty()
            : _buildGroupedList(events),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (_, __) =>
            _buildGroupedList(IslamicCalendarService.getFallback2026()),
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Text(
        'Yaklaşan dini gün bulunamadı.',
        style: AppTextStyles.bodyMedium,
      ),
    );
  }

  Widget _buildGroupedList(List<IslamicEvent> events) {
    final Map<String, List<IslamicEvent>> grouped = _groupByMonth(events);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      itemCount: grouped.length,
      itemBuilder: (BuildContext context, int index) {
        final String monthKey = grouped.keys.elementAt(index);
        final List<IslamicEvent> monthEvents = grouped[monthKey]!;

        return _MonthSection(
          monthTitle: monthKey,
          events: monthEvents,
        );
      },
    );
  }

  Map<String, List<IslamicEvent>> _groupByMonth(List<IslamicEvent> events) {
    final Map<String, List<IslamicEvent>> groups = {};
    for (final IslamicEvent event in events) {
      final String key = _monthName(event.date.month);
      groups.putIfAbsent(key, () => []).add(event);
    }
    return groups;
  }

  String _monthName(int month) {
    const List<String> names = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
    ];
    return names[month - 1];
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Ay Bölümü (Month Section)
// ═══════════════════════════════════════════════════════════════════════════════
class _MonthSection extends StatelessWidget {
  const _MonthSection({required this.monthTitle, required this.events});

  final String monthTitle;
  final List<IslamicEvent> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.xl,
            bottom: AppSpacing.md,
          ),
          child: Text(
            monthTitle,
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.onBackground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        for (int i = 0; i < events.length; i++)
          _TimelineEventCard(
            event: events[i],
            isLast: i == events.length - 1,
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Timeline Event Card
// ═══════════════════════════════════════════════════════════════════════════════
class _TimelineEventCard extends StatelessWidget {
  const _TimelineEventCard({required this.event, required this.isLast});

  final IslamicEvent event;
  final bool isLast;

  static const List<String> _months = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
  ];

  static const List<String> _weekdays = [
    'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe',
    'Cuma', 'Cumartesi', 'Pazar',
  ];

  @override
  Widget build(BuildContext context) {
    final int days = event.daysUntil;
    final bool isToday = days == 0;
    final bool isTomorrow = days == 1;
    final bool isSoon = days <= 7 && days > 0;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Sol: Tarih bloğu ────────────────────────────────────────────
          SizedBox(
            width: 80,
            child: Column(
              children: [
                Container(
                  width: 80,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Column(
                    children: [
                      Text(
                        '${event.date.day}',
                        style: AppTextStyles.displayLarge.copyWith(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: isToday
                              ? AppColors.accent
                              : isSoon
                                  ? AppColors.primary
                                  : AppColors.onBackground,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _months[event.date.month - 1],
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        _weekdays[event.date.weekday - 1],
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                // Timeline çizgisi
                if (!isLast)
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 1,
                        color: AppColors.border.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // ── Sağ: İçerik kartı ──────────────────────────────────────────
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                bottom: isLast ? 0 : AppSpacing.sm,
              ),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                color: AppColors.surface,
                border: Border.all(
                  color: isToday
                      ? AppColors.accent.withValues(alpha: 0.4)
                      : isSoon
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : AppColors.border.withValues(alpha: 0.5),
                  width: isToday ? 1 : 0.5,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Etkinlik adı
                        Text(
                          event.name,
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: isToday
                                ? AppColors.accent
                                : isSoon
                                    ? AppColors.primary
                                    : AppColors.primaryLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (event.hijriDate.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            event.hijriDate,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                        const SizedBox(height: 6),
                        // Geri sayım
                        _buildCountdown(days, isToday, isTomorrow),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary.withValues(alpha: 0.4),
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdown(int days, bool isToday, bool isTomorrow) {
    final String text;
    final Color color;

    if (isToday) {
      text = 'Bugün';
      color = AppColors.accent;
    } else if (isTomorrow) {
      text = 'Yarın';
      color = AppColors.primary;
    } else if (days < 30) {
      text = '$days Gün Kaldı';
      color = AppColors.textSecondary;
    } else {
      final int months = days ~/ 30;
      final int remainingDays = days % 30;
      text = remainingDays > 0
          ? '$months Ay $remainingDays Gün Kaldı'
          : '$months Ay Kaldı';
      color = AppColors.textSecondary;
    }

    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isToday ? AppColors.accent : AppColors.primary,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTextStyles.bodySmall.copyWith(
            color: color,
            fontWeight: isToday || isTomorrow ? FontWeight.w600 : FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
