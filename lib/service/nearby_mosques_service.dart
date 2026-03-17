import 'dart:math';
import 'package:dio/dio.dart';

/// Overpass API (OpenStreetMap) ile yakındaki camileri bulur.
///
/// Akış:
///   1. GPS'ten kullanıcı koordinatlarını al
///   2. Overpass API'ye amenity=place_of_worship + religion=muslim sorgusu gönder
///   3. Sonuçları mesafeye göre sırala
class NearbyMosquesService {
  NearbyMosquesService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://overpass-api.de/api',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ));

  final Dio _dio;

  /// Yakınlardaki camileri döndürür (max [radiusMeters] metre içinde).
  Future<List<Mosque>> getNearbyMosques({
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

    try {
      final Response<Map<String, dynamic>> response =
          await _dio.get<Map<String, dynamic>>(
        '/interpreter',
        queryParameters: {'data': query},
      );

      final List<dynamic> elements =
          response.data?['elements'] as List<dynamic>? ?? [];

      final List<Mosque> mosques = [];

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

        final String name =
            tags['name'] as String? ?? tags['name:tr'] as String? ?? 'Cami';

        final double distance =
            _calculateDistance(latitude, longitude, lat, lng);

        mosques.add(Mosque(
          name: name,
          latitude: lat,
          longitude: lng,
          distanceMeters: distance,
          address: tags['addr:street'] as String?,
        ));
      }

      mosques.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
      return mosques;
    } catch (_) {
      return [];
    }
  }

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

class Mosque {
  const Mosque({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
    this.address,
  });

  final String name;
  final double latitude;
  final double longitude;
  final double distanceMeters;
  final String? address;

  String get formattedDistance {
    if (distanceMeters < 1000) {
      return '${distanceMeters.toInt()} m';
    }
    return '${(distanceMeters / 1000).toStringAsFixed(1)} km';
  }
}
