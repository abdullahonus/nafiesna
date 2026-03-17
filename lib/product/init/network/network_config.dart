import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NetworkConfig {
  NetworkConfig._();

  static final Dio aladhanDio = _createDio(
    'https://api.aladhan.com/v1',
  );

  static final Dio hadeethEncDio = _createDio(
    'https://hadeethenc.com/api/v1',
  );

  static final Dio nominatimDio = _createDio(
    'https://nominatim.openstreetmap.org',
    extraHeaders: {'User-Agent': 'NafieSnaApp/1.0'},
  );

  static Dio _createDio(
    String baseUrl, {
    Map<String, String>? extraHeaders,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          if (extraHeaders != null) ...extraHeaders,
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(ChuckerDioInterceptor());
    }

    return dio;
  }
}
