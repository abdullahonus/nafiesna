import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../data/model/prayer_times_model.dart';
import '../product/init/network/network_config.dart';

/// Aladhan API — method=13 (Diyanet İşleri Başkanlığı hesaplama yöntemi)
///
/// Tek kaynak: api.aladhan.com/v1
/// - Şehir bazlı: /timingsByCity/{DD-MM-YYYY}
/// - Koordinat bazlı: /timings/{DD-MM-YYYY}
///
/// Hicri tarih düzeltme: Aladhan'ın Hicri takvimi Diyanet'ten 1 gün ileride.
/// Düzeltme HijriDateData.fromAladhanJson içinde client-side yapılır.
class PrayerTimesService {
  PrayerTimesService() : _dio = NetworkConfig.aladhanDio;

  final Dio _dio;

  static const int _method = 13;

  /// Şehir adıyla bugünün vakitlerini getirir (varsayılan: İstanbul).
  Future<PrayerTimesModel> getTodayTimings({
    String city = 'Istanbul',
    String country = 'Turkey',
  }) async {
    final dateStr = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final response = await _dio.get<Map<String, dynamic>>(
      '/timingsByCity/$dateStr',
      queryParameters: {
        'city': city,
        'country': country,
        'method': _method,
      },
    );

    return _parseResponse(response.data);
  }

  /// GPS koordinatlarıyla bugünün vakitlerini getirir.
  Future<PrayerTimesModel> getTodayTimingsByCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    final dateStr = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final response = await _dio.get<Map<String, dynamic>>(
      '/timings/$dateStr',
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'method': _method,
      },
    );

    return _parseResponse(response.data);
  }

  PrayerTimesModel _parseResponse(Map<String, dynamic>? body) {
    final data = body?['data'] as Map<String, dynamic>?;
    if (data == null) throw Exception('Aladhan yanıtı boş');

    final timingsJson = data['timings'] as Map<String, dynamic>;
    final hijriJson = (data['date'] as Map<String, dynamic>?)?['hijri']
            as Map<String, dynamic>? ??
        {};

    return PrayerTimesModel(
      timings: PrayerTimingsData.fromAladhanJson(timingsJson),
      hijriDate: HijriDateData.fromAladhanJson(hijriJson),
    );
  }
}
