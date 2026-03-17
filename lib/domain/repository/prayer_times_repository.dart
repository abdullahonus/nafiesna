import '../../data/model/prayer_times_model.dart';

abstract class PrayerTimesRepository {
  /// Diyanet konum ID'siyle bugünün namaz vakitlerini getirir.
  /// Varsayılan: 9541 = İstanbul merkez
  Future<PrayerTimesModel> getTodayTimings({int locationId = 9541});

  /// GPS koordinatlarıyla namaz vakitlerini getirir.
  /// [locationId] verilirse Diyanet API kullanılır,
  /// verilmezse AlAdhan koordinat API'si (Diyanet metodu) kullanılır.
  Future<PrayerTimesModel> getTodayTimingsByCoordinates({
    required double latitude,
    required double longitude,
    int? locationId,
  });
}
