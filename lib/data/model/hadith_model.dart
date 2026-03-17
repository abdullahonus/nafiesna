/// HadeethEnc.com API – Türkçe hadis modeli
class HadithModel {
  const HadithModel({
    required this.id,
    required this.title,
    required this.text,
    required this.arabicText,
    required this.attribution,
    required this.grade,
  });

  final String id;
  final String title;

  /// Türkçe tam metin
  final String text;

  /// Arapça orijinal metin
  final String arabicText;

  /// Kaynak kitap bilgisi (Türkçe)
  final String attribution;

  /// Hadis derecesi (Sahih, Hasen vb.)
  final String grade;

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      text: json['hadeeth'] as String? ?? '',
      arabicText: json['hadeeth_ar'] as String? ?? '',
      attribution: json['attribution'] as String? ?? '',
      grade: json['grade'] as String? ?? '',
    );
  }
}
