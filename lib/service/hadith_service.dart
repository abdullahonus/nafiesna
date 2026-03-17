import 'package:dio/dio.dart';
import '../data/model/hadith_model.dart';
import '../product/init/network/network_config.dart';

/// HadeethEnc.com API – Türkçe hadisler
/// Kategori 5: Faziletler ve Adaplar (701 hadis, 35 tam sayfa × 20)
class HadithService {
  HadithService() : _dio = NetworkConfig.hadeethEncDio;

  final Dio _dio;

  static const int _categoryId = 5;
  static const int _perPage = 20;
  static const int _totalFullPages = 35; // 35 × 20 = 700 hadis

  Future<HadithModel> getHadithOfTheDay() async {
    final dayIndex = _dayOfYear;

    // Sayfa ve sıra hesapla (701 hadis içinde sonsuz döngü)
    final page = (dayIndex % _totalFullPages) + 1;
    final itemIndex = dayIndex % _perPage;

    // Adım 1: Listenin ilgili sayfasından bugünün hadis ID'sini al
    final listResponse = await _dio.get<Map<String, dynamic>>(
      '/hadeeths/list/',
      queryParameters: {
        'language': 'tr',
        'category_id': _categoryId,
        'page': page,
        'per_page': _perPage,
      },
    );

    final hadiths = listResponse.data?['data'] as List<dynamic>? ?? [];
    if (hadiths.isEmpty) throw Exception('Hadis listesi boş geldi');

    final safeIndex = itemIndex.clamp(0, hadiths.length - 1);
    final hadithId = (hadiths[safeIndex] as Map<String, dynamic>)['id'];

    // Adım 2: Tam hadis metnini (Türkçe + Arapça + kaynak) getir
    final detailResponse = await _dio.get<Map<String, dynamic>>(
      '/hadeeths/one/',
      queryParameters: {
        'language': 'tr',
        'id': hadithId,
      },
    );

    final data = detailResponse.data;
    if (data == null) throw Exception('Hadis detayı alınamadı');

    return HadithModel.fromJson(data);
  }

  int get _dayOfYear {
    final now = DateTime.now();
    return now.difference(DateTime(now.year)).inDays;
  }
}
