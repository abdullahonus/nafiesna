import '../../data/model/prayer_times_model.dart';

abstract class PrayerTimesRepository {
  /// Bugünün Diyanet namaz vakitlerini getirir.
  /// [locationId]: Diyanet konum kodu (varsayılan: 9541 = İstanbul merkez)
  Future<PrayerTimesModel> getTodayTimings({int locationId = 9541});
}
