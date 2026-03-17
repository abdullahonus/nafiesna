import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/constants/app_spacing.dart';
import '../../../service/missed_prayer_service.dart';

final _missedPrayerServiceProvider = Provider(
  (ref) => MissedPrayerService(),
);

final _countersProvider = FutureProvider.autoDispose<Map<String, int>>((ref) {
  return ref.read(_missedPrayerServiceProvider).getAll();
});

final _lastUpdatedProvider = FutureProvider.autoDispose<String?>((ref) {
  return ref.read(_missedPrayerServiceProvider).getLastUpdated();
});

class MissedPrayersPage extends ConsumerStatefulWidget {
  const MissedPrayersPage({super.key});

  @override
  ConsumerState<MissedPrayersPage> createState() => _MissedPrayersPageState();
}

class _MissedPrayersPageState extends ConsumerState<MissedPrayersPage> {
  late Map<String, int> _counters;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _counters = {for (final String key in MissedPrayerService.prayerKeys) key: 0};
  }

  @override
  Widget build(BuildContext context) {
    final countersAsync = ref.watch(_countersProvider);

    if (!_isLoaded) {
      countersAsync.whenData((Map<String, int> data) {
        if (!_isLoaded) {
          setState(() {
            _counters = Map<String, int>.from(data);
            _isLoaded = true;
          });
        }
      });
    }

    final lastUpdatedAsync = ref.watch(_lastUpdatedProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Kazalar',
          style: AppTextStyles.headlineSmall.copyWith(color: AppColors.accent),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                color: AppColors.surface,
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < MissedPrayerService.prayerKeys.length; i++) ...[
                    if (i > 0)
                      Divider(
                        color: AppColors.border.withValues(alpha: 0.5),
                        height: 1,
                      ),
                    _CounterRow(
                      prayerKey: MissedPrayerService.prayerKeys[i],
                      count: _counters[MissedPrayerService.prayerKeys[i]] ?? 0,
                      onIncrement: () => _increment(MissedPrayerService.prayerKeys[i]),
                      onDecrement: () => _decrement(MissedPrayerService.prayerKeys[i]),
                      onSetValue: (int v) => _setDirectly(MissedPrayerService.prayerKeys[i], v),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Toplu kaza girişi için rakamların üzerine dokununuz.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            lastUpdatedAsync.when(
              data: (String? date) {
                if (date == null) return const SizedBox.shrink();
                final DateTime parsed = DateTime.parse(date);
                final String formatted =
                    DateFormat('dd.MM.yyyy HH:mm', 'tr_TR').format(parsed);
                return Text(
                  '(*) Son Kayıt Tarihi: $formatted',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _increment(String key) async {
    setState(() => _counters[key] = (_counters[key] ?? 0) + 1);
    await ref.read(_missedPrayerServiceProvider).increment(key);
    ref.invalidate(_countersProvider);
    ref.invalidate(_lastUpdatedProvider);
  }

  Future<void> _decrement(String key) async {
    final int current = _counters[key] ?? 0;
    if (current <= 0) return;
    setState(() => _counters[key] = current - 1);
    await ref.read(_missedPrayerServiceProvider).decrement(key);
    ref.invalidate(_countersProvider);
    ref.invalidate(_lastUpdatedProvider);
  }

  Future<void> _setDirectly(String key, int value) async {
    setState(() => _counters[key] = value);
    await ref.read(_missedPrayerServiceProvider).set(key, value);
    ref.invalidate(_countersProvider);
    ref.invalidate(_lastUpdatedProvider);
  }
}

class _CounterRow extends StatelessWidget {
  const _CounterRow({
    required this.prayerKey,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
    required this.onSetValue,
  });

  final String prayerKey;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<int> onSetValue;

  @override
  Widget build(BuildContext context) {
    final String label =
        MissedPrayerService.prayerLabels[prayerKey] ?? prayerKey;
    final String icon =
        MissedPrayerService.prayerIcons[prayerKey] ?? '🕌';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(label, style: AppTextStyles.bodyLarge),
          ),
          GestureDetector(
            onTap: () => _showEditDialog(context),
            child: SizedBox(
              width: 48,
              child: Text(
                '$count',
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildButton(Icons.remove, onDecrement, count <= 0),
          const SizedBox(width: AppSpacing.xs),
          _buildButton(Icons.add, onIncrement, false),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onTap, bool disabled) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          color: disabled
              ? AppColors.surfaceVariant.withValues(alpha: 0.3)
              : AppColors.surfaceVariant,
          border: Border.all(
            color: disabled
                ? AppColors.border.withValues(alpha: 0.3)
                : AppColors.border,
            width: 0.5,
          ),
        ),
        child: Icon(
          icon,
          color: disabled ? AppColors.textDisabled : AppColors.onBackground,
          size: 18,
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: '$count');

    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            '${MissedPrayerService.prayerLabels[prayerKey]} Kaza Sayısı',
            style: AppTextStyles.headlineSmall,
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            style: AppTextStyles.headlineMedium,
            decoration: InputDecoration(
              hintText: 'Sayı girin',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textHint,
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.accent),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'İptal',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                final int? value = int.tryParse(controller.text);
                if (value != null && value >= 0) {
                  Navigator.of(ctx).pop();
                  onSetValue(value);
                }
              },
              child: Text(
                'Kaydet',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}
