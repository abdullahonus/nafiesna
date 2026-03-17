import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../domain/repository/prayer_times_repository.dart';
import '../../../data/model/prayer_times_model.dart';

class PrayerTime extends Equatable {
  const PrayerTime({
    required this.name,
    required this.time,
    required this.icon,
  });

  final String name;
  final String time;
  final String icon;

  @override
  List<Object?> get props => [name, time, icon];
}

class PrayerTimesState extends Equatable {
  const PrayerTimesState({
    this.isLoading = false,
    this.prayers = const [],
    this.errorMessage,
    this.currentPrayerIndex = -1,
    this.dateLabel = '',
    this.hijriDate = '',
  });

  final bool isLoading;
  final List<PrayerTime> prayers;
  final String? errorMessage;
  final int currentPrayerIndex;
  final String dateLabel;
  final String hijriDate;

  PrayerTimesState copyWith({
    bool? isLoading,
    List<PrayerTime>? prayers,
    String? errorMessage,
    int? currentPrayerIndex,
    String? dateLabel,
    String? hijriDate,
  }) {
    return PrayerTimesState(
      isLoading: isLoading ?? this.isLoading,
      prayers: prayers ?? this.prayers,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPrayerIndex: currentPrayerIndex ?? this.currentPrayerIndex,
      dateLabel: dateLabel ?? this.dateLabel,
      hijriDate: hijriDate ?? this.hijriDate,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, prayers, errorMessage, currentPrayerIndex, dateLabel, hijriDate];
}

class PrayerTimesNotifier extends StateNotifier<PrayerTimesState> {
  PrayerTimesNotifier(this._repository) : super(const PrayerTimesState());

  final PrayerTimesRepository _repository;

  Future<void> init() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final model = await _repository.getTodayTimings(locationId: 9541);
      final prayers = _buildPrayerList(model.timings);
      final now = DateTime.now();

      state = state.copyWith(
        isLoading: false,
        prayers: prayers,
        currentPrayerIndex: _findCurrentPrayer(prayers, now),
        dateLabel: DateFormat('d MMMM yyyy, EEEE', 'tr_TR').format(now),
        hijriDate: model.hijriDate.formatted,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: null,
      );
      _loadFallback();
    }
  }

  List<PrayerTime> _buildPrayerList(PrayerTimingsData timings) {
    return [
      PrayerTime(name: 'İmsak', time: timings.imsak, icon: '🌙'),
      PrayerTime(name: 'Sabah', time: timings.fajr, icon: '🌅'),
      PrayerTime(name: 'Öğle', time: timings.dhuhr, icon: '☀️'),
      PrayerTime(name: 'İkindi', time: timings.asr, icon: '🌤'),
      PrayerTime(name: 'Akşam', time: timings.maghrib, icon: '🌆'),
      PrayerTime(name: 'Yatsı', time: timings.isha, icon: '🌃'),
    ];
  }

  int _findCurrentPrayer(List<PrayerTime> prayers, DateTime now) {
    final currentMinutes = now.hour * 60 + now.minute;
    int current = -1;
    for (int i = 0; i < prayers.length; i++) {
      final parts = prayers[i].time.split(':');
      if (parts.length < 2) continue;
      final prayerMinutes =
          int.parse(parts[0]) * 60 + int.parse(parts[1]);
      if (currentMinutes >= prayerMinutes) current = i;
    }
    return current;
  }

  // Ağ bağlantısı yoksa aylık ortalama İstanbul vakitleri
  void _loadFallback() {
    final now = DateTime.now();
    final month = now.month;

    const fallback = <int, List<String>>{
      1: ['06:47', '08:18', '13:26', '15:57', '17:56', '19:17'],
      2: ['06:32', '08:04', '13:27', '16:08', '18:09', '19:32'],
      3: ['06:08', '07:41', '13:21', '16:20', '18:24', '19:47'],
      4: ['05:30', '07:05', '13:12', '16:35', '18:44', '20:07'],
      5: ['04:46', '06:23', '13:00', '16:47', '19:02', '20:26'],
      6: ['04:14', '05:57', '12:53', '16:57', '19:17', '20:46'],
      7: ['04:21', '06:05', '13:00', '17:08', '19:20', '20:48'],
      8: ['04:58', '06:38', '13:11', '17:08', '19:07', '20:26'],
      9: ['05:33', '07:09', '13:19', '17:02', '18:46', '20:00'],
      10: ['06:07', '07:39', '13:20', '16:51', '18:20', '19:35'],
      11: ['06:42', '08:11', '13:23', '16:39', '17:58', '19:13'],
      12: ['07:07', '08:37', '13:31', '16:29', '17:43', '18:57'],
    };

    final times = fallback[month] ??
        ['05:30', '07:00', '13:00', '16:30', '19:00', '20:30'];

    final timings = PrayerTimingsData(
      imsak: times[0],
      fajr: times[1],
      dhuhr: times[2],
      asr: times[3],
      maghrib: times[4],
      isha: times[5],
    );

    final prayers = _buildPrayerList(timings);

    state = state.copyWith(
      prayers: prayers,
      currentPrayerIndex: _findCurrentPrayer(prayers, now),
      dateLabel: DateFormat('d MMMM yyyy, EEEE', 'tr_TR').format(now),
      hijriDate: '',
    );
  }
}
