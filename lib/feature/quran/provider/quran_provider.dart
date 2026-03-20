import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/quran_verse_model.dart';
import '../model/quran_page_model.dart';
import '../service/quran_service.dart';

final quranServiceProvider = Provider((ref) => QuranService());

final surahDetailProvider = FutureProvider.autoDispose.family<List<QuranVerse>, int>((ref, surahId) async {
  final service = ref.watch(quranServiceProvider);
  return await service.fetchSurah(surahId);
});

final pageDetailProvider = FutureProvider.autoDispose.family<List<QuranPageVerse>, int>((ref, pageNumber) async {
  final service = ref.watch(quranServiceProvider);
  return await service.fetchPage(pageNumber);
});

// A provider to manage specific display preferences like hiding transliteration
class QuranPreferencesNotifier extends StateNotifier<bool> {
  // true means Transliteration is visible
  QuranPreferencesNotifier() : super(true);

  void toggleTransliteration() {
    state = !state;
  }
}

final quranPreferencesProvider = StateNotifierProvider<QuranPreferencesNotifier, bool>((ref) {
  return QuranPreferencesNotifier();
});
