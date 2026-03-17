import '../../data/model/prayer_times_model.dart';

abstract class PrayerTimesRepository {
  /// Şehir adıyla bugünün namaz vakitlerini getirir.
  /// Varsayılan: İstanbul, Türkiye
  Future<PrayerTimesModel> getTodayTimings({
    String city = 'Istanbul',
    String country = 'Turkey',
  });

  /// GPS koordinatlarıyla namaz vakitlerini getirir.
  Future<PrayerTimesModel> getTodayTimingsByCoordinates({
    required double latitude,
    required double longitude,
  });
}
