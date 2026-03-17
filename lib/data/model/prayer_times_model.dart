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

  /// Aladhan → Diyanet Hicri tarih eşleştirmesi.
  ///
  /// Aladhan'ın matematiksel takvimi Diyanet'in hilal gözlemine dayalı
  /// takviminden 1 gün ileride. Client-side -1 gün düzeltme uyguluyoruz.
  factory HijriDateData.fromAladhanJson(Map<String, dynamic> json) {
    const monthMapTr = <String, String>{
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

    // Sıralı İngilizce ay listesi (önceki aya gitmek için)
    const monthOrderEn = [
      'Muḥarram', 'Ṣafar', "Rabīʿ al-awwal", "Rabīʿ al-thānī",
      'Jumādá al-ūlá', 'Jumādá al-ākhirah', 'Rajab', "Sha'bān",
      'Ramaḍān', 'Shawwāl', 'Dhū al-Qaʿdah', 'Dhū al-Ḥijjah',
    ];

    final int rawDay = int.tryParse(json['day']?.toString() ?? '') ?? 0;
    final int rawYear = int.tryParse(json['year']?.toString() ?? '') ?? 0;
    final String rawMonthEn =
        (json['month'] as Map<String, dynamic>?)?['en'] as String? ?? '';
    final int monthDays =
        (json['month'] as Map<String, dynamic>?)?['days'] as int? ?? 30;

    // -1 gün düzeltme (Aladhan → Diyanet hizalama)
    int adjustedDay = rawDay - 1;
    String adjustedMonthEn = rawMonthEn;
    int adjustedYear = rawYear;

    if (adjustedDay < 1) {
      // Ay başına denk geldiyse önceki aya geç
      final int currentIdx = monthOrderEn.indexOf(rawMonthEn);
      if (currentIdx > 0) {
        adjustedMonthEn = monthOrderEn[currentIdx - 1];
      } else {
        // Muharrem 1 → önceki yılın Zilhicce'si
        adjustedMonthEn = monthOrderEn.last;
        adjustedYear = rawYear - 1;
      }
      // Önceki ayın gün sayısı (29 veya 30)
      adjustedDay = monthDays > 0 ? 30 : 29;
    }

    final String monthTr = monthMapTr[adjustedMonthEn] ?? adjustedMonthEn;

    return HijriDateData(
      day: adjustedDay,
      monthName: monthTr,
      year: adjustedYear,
      fullDate: '$adjustedDay $monthTr $adjustedYear',
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
