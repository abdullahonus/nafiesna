import 'package:dio/dio.dart';
import '../data/model/hadith_model.dart';
import '../product/init/network/network_config.dart';

/// HadeethEnc.com API – Türkçe hadisler
/// Kategori 5: Faziletler ve Adaplar (701 hadis, 35 tam sayfa × 20)
///
/// Performans: Sayfa bazlı in-memory cache ile
/// ilk yüklemeden sonra aynı 20-günlük döngüde tek API çağrısı (detay).
class HadithService {
  HadithService() : _dio = NetworkConfig.hadeethEncDio;

  final Dio _dio;

  static const int _categoryId = 5;
  static const int _perPage = 20;
  static const int _totalFullPages = 35;

  /// Sayfa numarası → hadis ID listesi (session boyunca geçerli)
  static final Map<int, List<String>> _pageCache = {};

  Future<HadithModel> getHadithOfTheDay() async {
    final dayIndex = _dayOfYear;

    final page = (dayIndex % _totalFullPages) + 1;
    final itemIndex = dayIndex % _perPage;

    final hadithId = await _resolveHadithId(page, itemIndex);

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

  /// Cache'den ID döndürür; yoksa sayfayı çekip cache'e atar.
  Future<String> _resolveHadithId(int page, int itemIndex) async {
    final cached = _pageCache[page];
    if (cached != null && cached.isNotEmpty) {
      return cached[itemIndex.clamp(0, cached.length - 1)];
    }

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

    final ids = hadiths
        .map((dynamic h) => (h as Map<String, dynamic>)['id'] as String)
        .toList();

    _pageCache[page] = ids;

    return ids[itemIndex.clamp(0, ids.length - 1)];
  }

  int get _dayOfYear {
    final now = DateTime.now();
    return now.difference(DateTime(now.year)).inDays;
  }
}
