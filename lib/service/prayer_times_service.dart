import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../data/model/prayer_times_model.dart';
import '../product/init/network/network_config.dart';

class PrayerTimesService {
  PrayerTimesService()
      : _diyanetDio = NetworkConfig.diyanetDio,
        _aladhanDio = NetworkConfig.aladhanDio;

  final Dio _diyanetDio;
  final Dio _aladhanDio;

  /// Diyanet API'sinden bugünün namaz vakitlerini getirir.
  /// location_id: Diyanet konum kodu (9541 = İstanbul merkez)
  Future<PrayerTimesModel> getTodayTimings({int locationId = 9541}) async {
    final today = DateTime.now();

    final prayerTimings = await _fetchPrayerTimings(locationId, today);
    final hijriDate = await _fetchHijriDate(today);

    return PrayerTimesModel(timings: prayerTimings, hijriDate: hijriDate);
  }

  Future<PrayerTimingsData> _fetchPrayerTimings(
    int locationId,
    DateTime date,
  ) async {
    final response = await _diyanetDio.get<List<dynamic>>(
      '/prayertimes',
      queryParameters: {'location_id': locationId},
    );

    final allTimings = response.data ?? [];
    if (allTimings.isEmpty) throw Exception('Namaz vakti verisi boş');

    final todayStr = DateFormat('yyyy-MM-dd').format(date);
    final todayEntry = allTimings.firstWhere(
      (e) => (e['date'] as String? ?? '').startsWith(todayStr),
      orElse: () => allTimings.first,
    ) as Map<String, dynamic>;

    final fajr = todayEntry['fajr'] as String? ?? '--:--';

    return PrayerTimingsData(
      // Diyanet API imsak vermez → Sabah'tan 10 dakika önce (Türkiye standardı)
      imsak: _subtractMinutes(fajr, 10),
      fajr: fajr,
      dhuhr: todayEntry['dhuhr'] as String? ?? '--:--',
      asr: todayEntry['asr'] as String? ?? '--:--',
      maghrib: todayEntry['maghrib'] as String? ?? '--:--',
      isha: todayEntry['isha'] as String? ?? '--:--',
    );
  }

  Future<HijriDateData> _fetchHijriDate(DateTime date) async {
    final dateStr = DateFormat('dd-MM-yyyy').format(date);
    final response = await _aladhanDio.get<Map<String, dynamic>>(
      '/gToH',
      queryParameters: {'date': dateStr},
    );

    final data = response.data?['data'] as Map<String, dynamic>? ?? {};
    final hijri = data['hijri'] as Map<String, dynamic>? ?? {};
    return HijriDateData.fromJson(hijri);
  }

  /// Verilen "HH:mm" formatındaki saatten [minutes] dakika çıkarır.
  String _subtractMinutes(String time, int minutes) {
    final parts = time.split(':');
    if (parts.length < 2) return time;
    final totalMinutes =
        int.parse(parts[0]) * 60 + int.parse(parts[1]) - minutes;
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }
}
