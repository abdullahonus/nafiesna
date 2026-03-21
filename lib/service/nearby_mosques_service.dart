import 'dart:math';
import 'package:dio/dio.dart';

/// Mekân türü — cami veya türbe.
enum PlaceType { mosque, turbe }

/// Overpass API (OpenStreetMap) ile yakındaki cami ve türbeleri bulur.
///
/// Cami sorgusu  : amenity=place_of_worship + religion=muslim
/// Türbe sorgusu : historic=tomb (tomb=turbe veya tomb=mausoleum önce, fallback generic)
class NearbyMosquesService {
  NearbyMosquesService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://overpass-api.de/api',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ));

  final Dio _dio;

  // ── Camiler ─────────────────────────────────────────────────────────────────

  /// Yakınlardaki camileri döndürür (max [radiusMeters] metre içinde).
  Future<List<NearbyPlace>> getNearbyMosques({
    required double latitude,
    required double longitude,
    int radiusMeters = 3000,
  }) async {
    final String query = '''
[out:json][timeout:10];
(
  node["amenity"="place_of_worship"]["religion"="muslim"](around:$radiusMeters,$latitude,$longitude);
  way["amenity"="place_of_worship"]["religion"="muslim"](around:$radiusMeters,$latitude,$longitude);
);
out center;
''';
    return _fetch(
      query: query,
      latitude: latitude,
      longitude: longitude,
      type: PlaceType.mosque,
      defaultName: 'Cami',
    );
  }

  // ── Türbeler ─────────────────────────────────────────────────────────────────

  /// Yakınlardaki türbeleri döndürür (max [radiusMeters] metre içinde).
  /// OSM tag'leri: tomb=turbe (Osmanlı türbesi), tomb=mausoleum, ya da genel historic=tomb.
  Future<List<NearbyPlace>> getNearbyTurbes({
    required double latitude,
    required double longitude,
    int radiusMeters = 5000,
  }) async {
    final String query = '''
[out:json][timeout:10];
(
  node["historic"="tomb"]["tomb"="turbe"](around:$radiusMeters,$latitude,$longitude);
  way["historic"="tomb"]["tomb"="turbe"](around:$radiusMeters,$latitude,$longitude);
  node["historic"="tomb"]["tomb"="mausoleum"](around:$radiusMeters,$latitude,$longitude);
  way["historic"="tomb"]["tomb"="mausoleum"](around:$radiusMeters,$latitude,$longitude);
  node["historic"="tomb"](around:$radiusMeters,$latitude,$longitude);
  way["historic"="tomb"](around:$radiusMeters,$latitude,$longitude);
);
out center;
''';
    return _fetch(
      query: query,
      latitude: latitude,
      longitude: longitude,
      type: PlaceType.turbe,
      defaultName: 'Türbe',
    );
  }

  // ── Türkiye Geneli Türbeler ───────────────────────────────────────────────────

  /// Türkiye sınırları içindeki **tüm** türbeleri döndürür.
  ///
  /// Bounding box: (36.0, 26.0, 42.5, 45.0) — güney-batı / kuzey-doğu
  /// Sonuç sayısı sınırsız olabilir; [maxResults] ile kırpılır.
  Future<List<NearbyPlace>> getTurkeyTurbes({
    int maxResults = 500,
  }) async {
    const String bbox = '36.0,26.0,42.5,45.0';
    const String query = '''
[out:json][timeout:60];
(
  node["historic"="tomb"]["tomb"="turbe"]($bbox);
  way["historic"="tomb"]["tomb"="turbe"]($bbox);
  node["historic"="tomb"]["tomb"="mausoleum"]($bbox);
  way["historic"="tomb"]["tomb"="mausoleum"]($bbox);
  node["historic"="tomb"]($bbox);
  way["historic"="tomb"]($bbox);
);
out center;
''';
    final List<NearbyPlace> all = await _fetch(
      query: query,
      latitude: 0,
      longitude: 0,
      type: PlaceType.turbe,
      defaultName: 'Türbe',
    );
    // En fazla maxResults kadar al (koordinat unique zaten _fetch içinde)
    return all.take(maxResults).toList();
  }

  Future<List<NearbyPlace>> _fetch({
    required String query,
    required double latitude,
    required double longitude,
    required PlaceType type,
    required String defaultName,
  }) async {
    try {
      final Response<Map<String, dynamic>> response =
          await _dio.get<Map<String, dynamic>>(
        '/interpreter',
        queryParameters: {'data': query},
      );

      final List<dynamic> elements =
          response.data?['elements'] as List<dynamic>? ?? [];

      final List<NearbyPlace> places = [];

      for (final dynamic element in elements) {
        final Map<String, dynamic> el = element as Map<String, dynamic>;
        final Map<String, dynamic> tags =
            el['tags'] as Map<String, dynamic>? ?? {};

        double? lat;
        double? lng;

        if (el['type'] == 'node') {
          lat = (el['lat'] as num?)?.toDouble();
          lng = (el['lon'] as num?)?.toDouble();
        } else if (el['center'] != null) {
          final Map<String, dynamic> center =
              el['center'] as Map<String, dynamic>;
          lat = (center['lat'] as num?)?.toDouble();
          lng = (center['lon'] as num?)?.toDouble();
        }

        if (lat == null || lng == null) continue;

        final String name = tags['name'] as String? ??
            tags['name:tr'] as String? ??
            defaultName;

        final double distance =
            _calculateDistance(latitude, longitude, lat, lng);

        places.add(NearbyPlace(
          name: name,
          latitude: lat,
          longitude: lng,
          distanceMeters: distance,
          address: tags['addr:street'] as String?,
          type: type,
        ));
      }

      // Mesafeye göre sırala + yineleri kaldır (aynı isim + koordinat)
      final Set<String> seen = {};
      final List<NearbyPlace> unique = places.where((p) {
        final String key =
            '${p.latitude.toStringAsFixed(5)}_${p.longitude.toStringAsFixed(5)}';
        return seen.add(key);
      }).toList()
        ..sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));

      return unique;
    } catch (_) {
      return [];
    }
  }

  // ── Yardımcı ─────────────────────────────────────────────────────────────────

  /// Haversine formülü ile iki koordinat arası mesafe (metre).
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000;
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) => degree * (pi / 180);
}

// ── Model ─────────────────────────────────────────────────────────────────────

class NearbyPlace {
  const NearbyPlace({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
    required this.type,
    this.address,
  });

  final String name;
  final double latitude;
  final double longitude;
  final double distanceMeters;
  final PlaceType type;
  final String? address;

  String get formattedDistance {
    if (distanceMeters < 1000) {
      return '${distanceMeters.toInt()} m';
    }
    return '${(distanceMeters / 1000).toStringAsFixed(1)} km';
  }
}

// Backward-compat alias — mevcut kodu kırmamak için.
typedef Mosque = NearbyPlace;
