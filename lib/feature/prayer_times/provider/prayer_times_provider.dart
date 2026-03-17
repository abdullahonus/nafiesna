import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifier/prayer_times_notifier.dart';
import '../../../data/repository/prayer_times_repository_impl.dart';
import '../../../service/prayer_times_service.dart';

final _prayerTimesRepositoryProvider = Provider(
  (ref) => PrayerTimesRepositoryImpl(PrayerTimesService()),
);

final prayerTimesProvider =
    StateNotifierProvider<PrayerTimesNotifier, PrayerTimesState>(
  (ref) => PrayerTimesNotifier(ref.read(_prayerTimesRepositoryProvider)),
);
