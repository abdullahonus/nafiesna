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

  // ── Diyanet ID bazlı ──────────────────────────────────────────────────────

  /// Diyanet konum ID'siyle bugünün namaz vakitlerini getirir.
  /// Varsayılan: 9541 = İstanbul merkez
  Future<PrayerTimesModel> getTodayTimings({int locationId = 9541}) async {
    final today = DateTime.now();
    final timings = await _fetchDiyanetTimings(locationId, today);
    final hijriDate = await _fetchHijriDate(today);
    return PrayerTimesModel(timings: timings, hijriDate: hijriDate);
  }

  // ── Koordinat bazlı (GPS) ─────────────────────────────────────────────────

  /// GPS koordinatlarıyla namaz vakitlerini getirir.
  ///
  /// Önce [locationId] ile Diyanet API'si denenir.
  /// [locationId] null ise AlAdhan koordinat API'si (Diyanet metodu) kullanılır.
  Future<PrayerTimesModel> getTodayTimingsByCoordinates({
    required double latitude,
    required double longitude,
    int? locationId,
  }) async {
    final today = DateTime.now();

    if (locationId != null) {
      // Türkiye içi: direkt Diyanet verisi
      final timings = await _fetchDiyanetTimings(locationId, today);
      final hijriDate = await _fetchHijriDate(today);
      return PrayerTimesModel(timings: timings, hijriDate: hijriDate);
    }

    // Türkiye dışı / ID bulunamadı: AlAdhan ile koordinat bazlı hesaplama
    return _getTodayTimingsFromAlAdhan(latitude, longitude, today);
  }

  // ── Private: Diyanet ──────────────────────────────────────────────────────

  Future<PrayerTimingsData> _fetchDiyanetTimings(
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
      imsak: _subtractMinutes(fajr, 10),
      fajr: fajr,
      dhuhr: todayEntry['dhuhr'] as String? ?? '--:--',
      asr: todayEntry['asr'] as String? ?? '--:--',
      maghrib: todayEntry['maghrib'] as String? ?? '--:--',
      isha: todayEntry['isha'] as String? ?? '--:--',
    );
  }

  // ── Private: AlAdhan koordinat yedek ─────────────────────────────────────

  Future<PrayerTimesModel> _getTodayTimingsFromAlAdhan(
    double lat,
    double lng,
    DateTime date,
  ) async {
    final timestamp = date.millisecondsSinceEpoch ~/ 1000;
    final response = await _aladhanDio.get<Map<String, dynamic>>(
      '/timings/$timestamp',
      queryParameters: {
        'latitude': lat,
        'longitude': lng,
        'method': 13, // Diyanet İşleri Başkanlığı hesap metodu
      },
    );

    final data = response.data?['data'] as Map<String, dynamic>?;
    if (data == null) throw Exception('AlAdhan yanıtı boş');

    final timingsJson = data['timings'] as Map<String, dynamic>;
    final hijriJson =
        (data['date'] as Map<String, dynamic>?)?['hijri'] as Map<String, dynamic>? ?? {};

    final fajr = (timingsJson['Fajr'] as String?)?.substring(0, 5) ?? '--:--';

    return PrayerTimesModel(
      timings: PrayerTimingsData(
        imsak: (timingsJson['Imsak'] as String?)?.substring(0, 5) ?? _subtractMinutes(fajr, 10),
        fajr: fajr,
        dhuhr: (timingsJson['Dhuhr'] as String?)?.substring(0, 5) ?? '--:--',
        asr: (timingsJson['Asr'] as String?)?.substring(0, 5) ?? '--:--',
        maghrib: (timingsJson['Maghrib'] as String?)?.substring(0, 5) ?? '--:--',
        isha: (timingsJson['Isha'] as String?)?.substring(0, 5) ?? '--:--',
      ),
      hijriDate: HijriDateData.fromJson(hijriJson),
    );
  }

  // ── Private: Hicri tarih ─────────────────────────────────────────────────

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

  // ── Yardımcı ─────────────────────────────────────────────────────────────

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
