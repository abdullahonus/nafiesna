class PrayerTimingsData {
  const PrayerTimingsData({
    required this.imsak,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  final String imsak;
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
}

class HijriDateData {
  const HijriDateData({
    required this.day,
    required this.monthName,
    required this.year,
  });

  final String day;
  final String monthName;
  final String year;

  String get formatted => '$day $monthName $year';

  factory HijriDateData.fromJson(Map<String, dynamic> json) {
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

    final monthEn = (json['month'] as Map<String, dynamic>?)?['en'] as String? ?? '';
    final monthTr = monthMap[monthEn] ?? monthEn;

    return HijriDateData(
      day: json['day'] as String? ?? '',
      monthName: monthTr,
      year: json['year'] as String? ?? '',
    );
  }
}

class PrayerTimesModel {
  const PrayerTimesModel({
    required this.timings,
    required this.hijriDate,
  });

  final PrayerTimingsData timings;
  final HijriDateData hijriDate;
}
