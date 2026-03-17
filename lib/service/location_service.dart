import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import '../product/init/network/network_config.dart';

/// GPS konumu + ters coğrafi kodlama servisi.
///
/// Akış:
///   1. [checkAndRequestPermission] → izin kontrolü / isteme
///   2. [getCurrentPosition]        → enlem/boylam
///   3. [getCityName]               → Nominatim (OSM) ile şehir adı
class LocationService {
  LocationService() : _nominatimDio = NetworkConfig.nominatimDio;

  final Dio _nominatimDio;

  // ── İzin ──────────────────────────────────────────────────────────────────

  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  Future<LocationPermission> checkPermission() =>
      Geolocator.checkPermission();

  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();

  /// İzin zaten varsa direkt döner.
  /// Yoksa ister. Reddedilirse [LocationPermission.denied] döner.
  /// Kalıcı reddedilmişse [LocationPermission.deniedForever] döner.
  Future<LocationPermission> checkAndRequestPermission() async {
    var permission = await checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
    }
    return permission;
  }

  // ── Konum ─────────────────────────────────────────────────────────────────

  /// Anlık GPS konumunu alır. Düşük pil tüketimi için [LocationAccuracy.low].
  Future<Position> getCurrentPosition() => Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 20),
        ),
      );

  // ── Ters Coğrafi Kodlama ──────────────────────────────────────────────────

  /// Enlem/boylam → şehir adı (Nominatim/OSM, Türkçe).
  ///
  /// Dönen değer null ise şehir tespit edilememiştir.
  Future<String?> getCityName(double lat, double lng) async {
    try {
      final response = await _nominatimDio.get<Map<String, dynamic>>(
        '/reverse',
        queryParameters: {
          'lat': lat,
          'lon': lng,
          'format': 'json',
          'accept-language': 'tr',
          'zoom': 10, // şehir seviyesi
        },
      );

      final address = response.data?['address'] as Map<String, dynamic>?;
      if (address == null) return null;

      // OSM alanları öncelik sırası: şehir > ilçe > kasaba > köy > il > ilçe adı
      return address['city'] as String? ??
          address['town'] as String? ??
          address['municipality'] as String? ??
          address['village'] as String? ??
          address['county'] as String? ??
          address['state'] as String?;
    } catch (_) {
      return null;
    }
  }

  /// Diyanet API konum araması: şehir adından location_id bulur.
  /// Türkiye dışındaki şehirler için null döner.
  Future<int?> searchDiyanetLocationId(String cityName) async {
    try {
      final dio = NetworkConfig.diyanetDio;
      final response = await dio.get<List<dynamic>>(
        '/search',
        queryParameters: {'q': cityName},
      );

      final results = response.data ?? [];
      if (results.isEmpty) return null;

      // İlk sonucun ID'sini al (Diyanet en yakın eşleşmeyi döner)
      final first = results.first as Map<String, dynamic>;
      return first['id'] as int?;
    } catch (_) {
      return null;
    }
  }

  // ── Ayarlar ───────────────────────────────────────────────────────────────

  Future<void> openAppSettings() => Geolocator.openAppSettings();
  Future<void> openLocationSettings() => Geolocator.openLocationSettings();
}
