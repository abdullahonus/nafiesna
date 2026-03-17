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

  // AlAdhan – Hicri tarih dönüşümü için (gToH)
  static final Dio aladhanDio = Dio(
    BaseOptions(
      baseUrl: 'https://api.aladhan.com/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  );

  // HadeethEnc – Türkçe hadis (ücretsiz, kayıtsız, 20+ dil)
  static final Dio hadeethEncDio = Dio(
    BaseOptions(
      baseUrl: 'https://hadeethenc.com/api/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  );
}
