import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../product/init/network/network_config.dart';

/// Dini günler servisi.
///
/// Birincil kaynak: Diyanet İşleri Başkanlığı resmi takvimi.
/// İkincil kaynak: Aladhan gToHCalendar API (supplement + gelecek yıllar).
///
/// Diyanet verileri: https://vakithesaplama.diyanet.gov.tr/dinigunler.php
class IslamicCalendarService {
  IslamicCalendarService() : _dio = NetworkConfig.aladhanDio;

  final Dio _dio;

  static List<IslamicEvent>? _cache;

  /// Önümüzdeki dini günleri döndürür.
  Future<List<IslamicEvent>> getUpcomingEvents() async {
    if (_cache != null) return _filterUpcoming(_cache!);

    final int currentYear = DateTime.now().year;
    List<IslamicEvent> events = _getDiyanetEvents(currentYear);

    // Eğer Diyanet verisi yoksa (gelecek yıl vs) API'ye düş
    if (events.isEmpty) {
      events = await _fetchFromApi(currentYear);
    }

    // Sonraki yılın başı için de ekle (Aralık sonrası)
    final List<IslamicEvent> nextYearEvents = _getDiyanetEvents(currentYear + 1);
    if (nextYearEvents.isNotEmpty) {
      events.addAll(nextYearEvents);
    }

    events.sort((IslamicEvent a, IslamicEvent b) => a.date.compareTo(b.date));
    _cache = events;
    return _filterUpcoming(events);
  }

  /// Sadece sonraki ilk olayı döndürür (HijriCalendarCard için).
  Future<IslamicEvent?> getNextEvent() async {
    final List<IslamicEvent> events = await getUpcomingEvents();
    return events.isNotEmpty ? events.first : null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Diyanet Resmi Takvimi
  // ═══════════════════════════════════════════════════════════════════════════

  /// Diyanet İşleri Başkanlığı resmi dini günler takvimi.
  /// Kaynak: vakithesaplama.diyanet.gov.tr/dinigunler.php
  List<IslamicEvent> _getDiyanetEvents(int year) {
    final Map<int, List<IslamicEvent>>? yearData = _diyanetData[year];
    if (yearData == null) return [];

    final List<IslamicEvent> events = [];
    for (final List<IslamicEvent> monthEvents in yearData.values) {
      events.addAll(monthEvents);
    }
    return events;
  }

  static final Map<int, Map<int, List<IslamicEvent>>> _diyanetData = {
    2026: {
      1: [
        IslamicEvent(
          name: 'Miraç Kandili',
          date: DateTime(2026, 1, 15),
          hijriDate: '26 Receb 1447',
        ),
      ],
      2: [
        IslamicEvent(
          name: 'Berat Kandili',
          date: DateTime(2026, 2, 2),
          hijriDate: '14 Şaban 1447',
        ),
        IslamicEvent(
          name: 'Ramazan Başlangıcı',
          date: DateTime(2026, 2, 19),
          hijriDate: '1 Ramazan 1447',
        ),
      ],
      3: [
        IslamicEvent(
          name: 'Kadir Gecesi',
          date: DateTime(2026, 3, 16),
          hijriDate: '26 Ramazan 1447',
        ),
        IslamicEvent(
          name: 'Arefe (Ramazan)',
          date: DateTime(2026, 3, 19),
          hijriDate: '29 Ramazan 1447',
        ),
        IslamicEvent(
          name: 'Ramazan Bayramı',
          date: DateTime(2026, 3, 20),
          hijriDate: '1 Şevval 1447',
        ),
      ],
      5: [
        IslamicEvent(
          name: 'Arefe (Kurban)',
          date: DateTime(2026, 5, 26),
          hijriDate: '9 Zilhicce 1447',
        ),
        IslamicEvent(
          name: 'Kurban Bayramı',
          date: DateTime(2026, 5, 27),
          hijriDate: '10 Zilhicce 1447',
        ),
      ],
      6: [
        IslamicEvent(
          name: 'Hicri Yılbaşı',
          date: DateTime(2026, 6, 16),
          hijriDate: '1 Muharrem 1448',
        ),
        IslamicEvent(
          name: 'Aşure Günü',
          date: DateTime(2026, 6, 25),
          hijriDate: '10 Muharrem 1448',
        ),
      ],
      8: [
        IslamicEvent(
          name: 'Mevlid Kandili',
          date: DateTime(2026, 8, 24),
          hijriDate: '11 Rebiülevvel 1448',
        ),
      ],
      12: [
        IslamicEvent(
          name: 'Üç Ayların Başlangıcı',
          date: DateTime(2026, 12, 10),
          hijriDate: '1 Receb 1448',
        ),
        IslamicEvent(
          name: 'Regaib Kandili',
          date: DateTime(2026, 12, 10),
          hijriDate: '1 Receb 1448',
        ),
      ],
    },
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Aladhan API (fallback & future years)
  // ═══════════════════════════════════════════════════════════════════════════

  Future<List<IslamicEvent>> _fetchFromApi(int year) async {
    try {
      final DateTime now = DateTime(year);
      final List<Future<List<IslamicEvent>>> futures = [];

      for (int i = 0; i < 12; i++) {
        final DateTime target = DateTime(now.year, now.month + i);
        futures.add(_fetchMonth(target.month, target.year));
      }

      final List<List<IslamicEvent>> results = await Future.wait(futures);
      final List<IslamicEvent> allEvents = [];
      final Set<String> seen = {};

      for (final List<IslamicEvent> monthEvents in results) {
        for (final IslamicEvent event in monthEvents) {
          final String key = '${event.name}_${event.date.toIso8601String()}';
          if (seen.add(key)) allEvents.add(event);
        }
      }

      return allEvents;
    } catch (e) {
      debugPrint('IslamicCalendarService API error: $e');
      return getFallback2026();
    }
  }

  Future<List<IslamicEvent>> _fetchMonth(int month, int year) async {
    try {
      final Response<Map<String, dynamic>> response =
          await _dio.get<Map<String, dynamic>>('/gToHCalendar/$month/$year');

      final List<dynamic>? data =
          response.data?['data'] as List<dynamic>?;
      if (data == null) return [];

      final List<IslamicEvent> events = [];

      for (final dynamic dayEntry in data) {
        final Map<String, dynamic> entry = dayEntry as Map<String, dynamic>;
        final Map<String, dynamic> hijri =
            entry['hijri'] as Map<String, dynamic>;
        final Map<String, dynamic> gregorian =
            entry['gregorian'] as Map<String, dynamic>;

        final String gregDateStr = gregorian['date'] as String? ?? '';
        final DateTime? gregDate = _parseGregorianDate(gregDateStr);
        if (gregDate == null) continue;

        final int rawHijriDay =
            int.tryParse(hijri['day']?.toString() ?? '') ?? 0;
        final Map<String, dynamic> hijriMonthMap =
            hijri['month'] as Map<String, dynamic>? ?? {};
        final int hijriMonth = hijriMonthMap['number'] as int? ?? 0;
        final String hijriMonthEn = hijriMonthMap['en'] as String? ?? '';
        final int hijriYear =
            int.tryParse(hijri['year']?.toString() ?? '') ?? 0;

        final String hijriMonthTr =
            _hijriMonthsTr[hijriMonthEn] ?? hijriMonthEn;

        // Holidays dizisinden etkinlikler
        final List<dynamic> holidays =
            hijri['holidays'] as List<dynamic>? ?? [];
        for (final dynamic holiday in holidays) {
          final String name = holiday.toString();
          final _MappedEvent? mapped =
              _mapHoliday(name, rawHijriDay, hijriMonth);
          if (mapped != null) {
            events.add(IslamicEvent(
              name: mapped.turkishName,
              date: gregDate,
              hijriDate: mapped.hijriDate.isNotEmpty
                  ? '${mapped.hijriDate} $hijriYear'
                  : '$rawHijriDay $hijriMonthTr $hijriYear',
            ));
          }
        }

        // Hicri tarih bazlı tespit (API'de holiday olarak gelmeyen günler)
        final _MappedEvent? extra =
            _checkHijriDate(rawHijriDay, hijriMonth, hijriYear);
        if (extra != null) {
          events.add(IslamicEvent(
            name: extra.turkishName,
            date: gregDate,
            hijriDate: extra.hijriDate,
          ));
        }
      }

      return events;
    } catch (_) {
      return [];
    }
  }

  /// Aladhan holiday adından Türkçe eşleştirme.
  /// Filtreli: Qadr sadece 27 Ramazan, Urs'ler hariç.
  _MappedEvent? _mapHoliday(String englishName, int hijriDay, int hijriMonth) {
    if (englishName.startsWith('Urs ') || englishName.startsWith('Birth of')) {
      return null;
    }

    // Lailat-ul-Qadr: Aladhan tüm tek gecelere koyuyor, sadece 27 Ramazan'ı al
    if (englishName == 'Lailat-ul-Qadr') {
      if (hijriMonth == 9 && hijriDay == 27) {
        return const _MappedEvent('Kadir Gecesi', '26 Ramazan');
      }
      return null;
    }

    const Map<String, _MappedEvent> map = {
      'Eid-ul-Fitr': _MappedEvent('Ramazan Bayramı', '1 Şevval'),
      'Eid-ul-Adha': _MappedEvent('Kurban Bayramı', '10 Zilhicce'),
      'Ashura': _MappedEvent('Aşure Günü', '10 Muharrem'),
      'Mawlid': _MappedEvent('Mevlid Kandili', '12 Rebiülevvel'),
      'Lailat-ul-Miraj': _MappedEvent('Miraç Kandili', '27 Receb'),
      "Lailat-ul-Bara'at": _MappedEvent('Berat Kandili', '15 Şaban'),
      '1st Day of Ramadan': _MappedEvent('Ramazan Başlangıcı', '1 Ramazan'),
      'Arafa': _MappedEvent('Arefe (Kurban)', '9 Zilhicce'),
    };

    // Hajj gibi tanınmayan/gereksiz etiketleri atla
    if (englishName == 'Hajj') return null;
    if (englishName.contains('1st Muharram')) {
      return const _MappedEvent('Hicri Yılbaşı', '1 Muharrem');
    }

    return map[englishName];
  }

  /// Hicri gün/ay bazlı ek tespit (API holidays'da olmayanlar).
  _MappedEvent? _checkHijriDate(int day, int month, int year) {
    // 1 Muharrem → Hicri Yılbaşı
    if (month == 1 && day == 1) {
      return _MappedEvent('Hicri Yılbaşı', '1 Muharrem $year');
    }
    // 1 Receb → Üç Aylar + Regaib
    if (month == 7 && day == 1) {
      return _MappedEvent('Regaib Kandili', '1 Receb $year');
    }
    return null;
  }

  DateTime? _parseGregorianDate(String dateStr) {
    try {
      final List<String> parts = dateStr.split('-');
      if (parts.length != 3) return null;
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (_) {
      return null;
    }
  }

  List<IslamicEvent> _filterUpcoming(List<IslamicEvent> events) {
    final DateTime today = DateTime.now();
    final DateTime todayStart = DateTime(today.year, today.month, today.day);
    return events
        .where((IslamicEvent e) => !e.date.isBefore(todayStart))
        .toList();
  }

  static const Map<String, String> _hijriMonthsTr = {
    'Muḥarram': 'Muharrem',
    'Ṣafar': 'Safer',
    'Rabīʿ al-Awwal': 'Rebiülevvel',
    'Rabīʿ al-Thānī': 'Rebiülahir',
    'Jumādá al-Ūlá': 'Cemaziyelevvel',
    'Jumādá al-Ākhirah': 'Cemaziyelahir',
    'Rajab': 'Receb',
    'Shaʿbān': 'Şaban',
    'Ramaḍān': 'Ramazan',
    'Shawwāl': 'Şevval',
    'Dhū al-Qaʿdah': 'Zilkade',
    'Dhū al-Ḥijjah': 'Zilhicce',
  };

  /// Diyanet verisine dayalı statik fallback (API başarısız olursa)
  static List<IslamicEvent> getFallback2026() {
    return [
      IslamicEvent(
          name: 'Kadir Gecesi',
          date: DateTime(2026, 3, 16),
          hijriDate: '26 Ramazan 1447'),
      IslamicEvent(
          name: 'Ramazan Bayramı',
          date: DateTime(2026, 3, 20),
          hijriDate: '1 Şevval 1447'),
      IslamicEvent(
          name: 'Kurban Bayramı',
          date: DateTime(2026, 5, 27),
          hijriDate: '10 Zilhicce 1447'),
      IslamicEvent(
          name: 'Hicri Yılbaşı',
          date: DateTime(2026, 6, 16),
          hijriDate: '1 Muharrem 1448'),
      IslamicEvent(
          name: 'Aşure Günü',
          date: DateTime(2026, 6, 25),
          hijriDate: '10 Muharrem 1448'),
      IslamicEvent(
          name: 'Mevlid Kandili',
          date: DateTime(2026, 8, 24),
          hijriDate: '11 Rebiülevvel 1448'),
      IslamicEvent(
          name: 'Regaib Kandili',
          date: DateTime(2026, 12, 10),
          hijriDate: '1 Receb 1448'),
    ];
  }
}

class _MappedEvent {
  const _MappedEvent(this.turkishName, this.hijriDate);
  final String turkishName;
  final String hijriDate;
}

class IslamicEvent {
  const IslamicEvent({
    required this.name,
    required this.date,
    this.hijriDate = '',
  });

  final String name;
  final DateTime date;
  final String hijriDate;

  int get daysUntil {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime eventDay = DateTime(date.year, date.month, date.day);
    return eventDay.difference(today).inDays;
  }
}
