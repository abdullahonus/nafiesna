import 'package:dio/dio.dart';

class NetworkConfig {
  NetworkConfig._();

  // Diyanet İşleri Başkanlığı – namaz vakitleri (ücretsiz, kayıtsız)
  static final Dio diyanetDio = Dio(
    BaseOptions(
      baseUrl: 'https://prayertimes.api.abdus.dev/api/diyanet',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  );

  // AlAdhan – Hicri tarih dönüşümü + koordinat bazlı yedek
  static final Dio aladhanDio = Dio(
    BaseOptions(
      baseUrl: 'https://api.aladhan.com/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  );

  // HadeethEnc – Türkçe hadisler (ücretsiz, kayıtsız)
  static final Dio hadeethEncDio = Dio(
    BaseOptions(
      baseUrl: 'https://hadeethenc.com/api/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  );

  // Nominatim (OpenStreetMap) – ücretsiz, sınırsız ters coğrafi kodlama
  // Politika gereği User-Agent zorunludur.
  static final Dio nominatimDio = Dio(
    BaseOptions(
      baseUrl: 'https://nominatim.openstreetmap.org',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'NafieSnaApp/1.0',
      },
    ),
  );
}
