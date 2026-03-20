import 'package:dio/dio.dart';
import '../model/quran_verse_model.dart';
import '../model/quran_page_model.dart';

class QuranService {
  final Dio _dio = Dio();

  Future<List<QuranVerse>> fetchSurah(int surahId) async {
    try {
      final response = await _dio.get(
        'https://api.alquran.cloud/v1/surah/$surahId/editions/quran-uthmani,tr.diyanet,tr.transliteration',
      );
      
      final data = response.data['data'] as List;
      final arabicEdition = data[0]['ayahs'] as List;
      final trEdition = data[1]['ayahs'] as List;
      final latEdition = data[2]['ayahs'] as List;

      final length = arabicEdition.length;
      final List<QuranVerse> verses = [];

      for (int i = 0; i < length; i++) {
        verses.add(
          QuranVerse.fromEditions(
            arabic: arabicEdition[i] as Map<String, dynamic>,
            tr: trEdition[i] as Map<String, dynamic>,
            lat: latEdition[i] as Map<String, dynamic>,
          )
        );
      }
      return verses;
    } catch (e) {
      throw Exception('Sure yüklenirken bir hata oluştu: $e');
    }
  }

  Future<List<QuranPageVerse>> fetchPage(int pageNumber) async {
    try {
      final responses = await Future.wait([
        _dio.get('https://api.alquran.cloud/v1/page/$pageNumber/quran-uthmani'),
        _dio.get('https://api.alquran.cloud/v1/page/$pageNumber/tr.diyanet'),
      ]);

      final arabicData = responses[0].data['data']['ayahs'] as List;
      final trData = responses[1].data['data']['ayahs'] as List;

      final List<QuranPageVerse> verses = [];
      for (int i = 0; i < arabicData.length; i++) {
        verses.add(QuranPageVerse(
          numberInSurah: arabicData[i]['numberInSurah'],
          arabicText: arabicData[i]['text'],
          translationText: trData[i]['text'],
          surahId: arabicData[i]['surah']['number'],
          surahName: arabicData[i]['surah']['name'],
        ));
      }
      return verses;
    } catch (e) {
      throw Exception('Sayfa yüklenirken bir hata oluştu: $e');
    }
  }
}
