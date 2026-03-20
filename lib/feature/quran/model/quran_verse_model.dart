class QuranVerse {
  final int number; // Verse number in Surah
  final String arabicText;
  final String translation;
  final String transliteration;

  QuranVerse({
    required this.number,
    required this.arabicText,
    required this.translation,
    required this.transliteration,
  });

  factory QuranVerse.fromEditions({
    required Map<String, dynamic> arabic,
    required Map<String, dynamic> tr,
    required Map<String, dynamic> lat,
  }) {
    return QuranVerse(
      number: arabic['numberInSurah'] as int,
      arabicText: arabic['text'] as String,
      translation: tr['text'] as String,
      transliteration: lat['text'] as String,
    );
  }
}
