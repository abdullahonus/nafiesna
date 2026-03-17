class PrayerTimingsData {
  const PrayerTimingsData({
    required this.imsak,
    required this.gunes,
    required this.ogle,
    required this.ikindi,
    required this.aksam,
    required this.yatsi,
  });

  final String imsak;
  final String gunes;
  final String ogle;
  final String ikindi;
  final String aksam;
  final String yatsi;

  /// Aladhan API response → Diyanet vakitlerine mapping
  /// Diyanet İmsak = Aladhan Fajr (sahur bitiş saati)
  /// Aladhan'ın "Imsak" alanı Fajr - 10dk'dır, Diyanet ile eşleşmez.
  factory PrayerTimingsData.fromAladhanJson(Map<String, dynamic> json) {
    String trim(String? v) => v?.substring(0, 5) ?? '--:--';
    return PrayerTimingsData(
      imsak: trim(json['Fajr'] as String?),
      gunes: trim(json['Sunrise'] as String?),
      ogle: trim(json['Dhuhr'] as String?),
      ikindi: trim(json['Asr'] as String?),
      aksam: trim(json['Maghrib'] as String?),
      yatsi: trim(json['Isha'] as String?),
    );
  }
}

class HijriDateData {
  const HijriDateData({
    required this.day,
    required this.monthName,
    required this.year,
    required this.fullDate,
  });

  final int day;
  final String monthName;
  final int year;
  final String fullDate;

  String get formatted => fullDate.isNotEmpty ? fullDate : '$day $monthName $year';

  factory HijriDateData.fromJson(Map<String, dynamic> json) {
    return HijriDateData(
      day: json['day'] as int? ?? 0,
      monthName: json['month_name'] as String? ?? '',
      year: json['year'] as int? ?? 0,
      fullDate: json['full_date'] as String? ?? '',
    );
  }

  factory HijriDateData.fromAladhanJson(Map<String, dynamic> json) {
    const monthMap = <String, String>{
      'Muḥarram': 'Muharrem',
      'Ṣafar': 'Safer',
      "Rabīʿ al-awwal": 'Rebiülevvel',
      "Rabīʿ al-thānī": 'Rebiülahir',
      'Jumādá al-ūlá': 'Cemaziyelevvel',
      'Jumādá al-ākhirah': 'Cemaziyelahir',
      'Rajab': 'Recep',
      "Sha'bān": 'Şaban',
      'Ramaḍān': 'Ramazan',
      'Shawwāl': 'Şevval',
      'Dhū al-Qaʿdah': 'Zilkade',
      'Dhū al-Ḥijjah': 'Zilhicce',
    };

    final dayStr = json['day'] as String? ?? '0';
    final yearStr = json['year'] as String? ?? '0';
    final monthEn =
        (json['month'] as Map<String, dynamic>?)?['en'] as String? ?? '';
    final monthTr = monthMap[monthEn] ?? monthEn;
    final day = int.tryParse(dayStr) ?? 0;
    final year = int.tryParse(yearStr) ?? 0;

    return HijriDateData(
      day: day,
      monthName: monthTr,
      year: year,
      fullDate: '$dayStr $monthTr $yearStr',
    );
  }

  static const HijriDateData empty = HijriDateData(
    day: 0,
    monthName: '',
    year: 0,
    fullDate: '',
  );
}

class PrayerTimesModel {
  const PrayerTimesModel({
    required this.timings,
    required this.hijriDate,
  });

  final PrayerTimingsData timings;
  final HijriDateData hijriDate;
}
