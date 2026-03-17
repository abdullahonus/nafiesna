import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../product/init/network/network_config.dart';

/// Aladhan gToHCalendar API üzerinden dini günleri çeker.
///
/// Akış:
///   1. Mevcut ay + sonraki 5 ay paralel çekilir (6 istek)
///   2. Her günün `holidays` dizisi + Hicri tarih bazlı eşleştirme yapılır
///   3. Sonuçlar session boyunca cache'lenir
class IslamicCalendarService {
  IslamicCalendarService() : _dio = NetworkConfig.aladhanDio;

  final Dio _dio;

  static List<IslamicEvent>? _cache;

  /// Önümüzdeki ~6 aylık dini günleri döndürür.
  Future<List<IslamicEvent>> getUpcomingEvents() async {
    if (_cache != null) return _filterUpcoming(_cache!);

    final now = DateTime.now();
    final List<Future<List<IslamicEvent>>> futures = [];

    for (int i = 0; i < 6; i++) {
      final targetDate = DateTime(now.year, now.month + i);
      futures.add(_fetchMonth(targetDate.month, targetDate.year));
    }

    final results = await Future.wait(futures);
    final List<IslamicEvent> allEvents = [];
    final Set<String> seen = {};

    for (final monthEvents in results) {
      for (final event in monthEvents) {
        final key = '${event.name}_${event.date.toIso8601String()}';
        if (seen.add(key)) allEvents.add(event);
      }
    }

    allEvents.sort((a, b) => a.date.compareTo(b.date));
    _cache = allEvents;
    return _filterUpcoming(allEvents);
  }

  /// Sadece sonraki ilk olayı döndürür (HijriCalendarCard için).
  Future<IslamicEvent?> getNextEvent() async {
    final events = await getUpcomingEvents();
    return events.isNotEmpty ? events.first : null;
  }

  /// Bir Miladi ayın tüm günlerini Hicri takvimle eşleştirir.
  Future<List<IslamicEvent>> _fetchMonth(int month, int year) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/gToHCalendar/$month/$year',
      );

      final data = response.data?['data'] as List<dynamic>?;
      if (data == null) return [];

      final List<IslamicEvent> events = [];

      for (final dynamic dayEntry in data) {
        final Map<String, dynamic> entry = dayEntry as Map<String, dynamic>;
        final Map<String, dynamic> hijri =
            entry['hijri'] as Map<String, dynamic>;
        final Map<String, dynamic> gregorian =
            entry['gregorian'] as Map<String, dynamic>;

        final String gregDateStr = gregorian['date'] as String? ?? '';
        final DateTime? gregDate = _parseDate(gregDateStr);
        if (gregDate == null) continue;

        final int hijriDay = int.tryParse(hijri['day']?.toString() ?? '') ?? 0;
        final int hijriMonth =
            (hijri['month'] as Map<String, dynamic>?)?['number'] as int? ?? 0;

        // 1) Aladhan'ın holidays dizisinden
        final List<dynamic> holidays =
            hijri['holidays'] as List<dynamic>? ?? [];
        for (final dynamic holiday in holidays) {
          final String name = holiday.toString();
          final String? turkishName = _mapToTurkish(name);
          if (turkishName != null) {
            events.add(IslamicEvent(name: turkishName, date: gregDate));
          }
        }

        // 2) Hicri tarih bazlı Türk dini günleri (Kandiller)
        final String? kandil = _checkKandil(hijriDay, hijriMonth);
        if (kandil != null) {
          events.add(IslamicEvent(name: kandil, date: gregDate));
        }
      }

      return events;
    } catch (_) {
      return [];
    }
  }

  /// Aladhan İngilizce → Türkçe dönüşüm
  String? _mapToTurkish(String englishName) {
    if (englishName.startsWith('Urs ')) return null;

    const Map<String, String> map = {
      'Eid-ul-Fitr': 'Ramazan Bayramı',
      'Eid-ul-Adha': 'Kurban Bayramı',
      'Lailat-ul-Qadr': 'Kadir Gecesi',
      '1st Muharram': 'Hicri Yılbaşı',
      'Ashura': 'Aşure Günü',
      'Mawlid': 'Mevlid Kandili',
      'Shab-e-Meraj': 'Miraç Kandili',
      'Lailat-ul-Bara\'at': 'Berat Kandili',
    };

    return map[englishName];
  }

  /// Hicri gün + ay numarasından Kandil tespiti
  /// Aladhan'ın holidays dizisinde olmayanlar için
  String? _checkKandil(int day, int month) {
    // Receb = 7, Şaban = 8, Ramazan = 9
    if (month == 7 && day == 27) return 'Miraç Kandili';
    if (month == 8 && day == 15) return 'Berat Kandili';
    if (month == 7 && day == 1) return 'Üç Ayların Başlangıcı';
    if (month == 9 && day == 1) return 'Ramazan Başlangıcı';
    if (month == 12 && day == 9) return 'Arefe (Kurban)';
    if (month == 10 && day == 1) return null; // Aladhan zaten veriyor
    if (month == 12 && day == 10) return null; // Aladhan zaten veriyor
    return null;
  }

  DateTime? _parseDate(String dateStr) {
    try {
      return DateFormat('dd-MM-yyyy').parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  List<IslamicEvent> _filterUpcoming(List<IslamicEvent> events) {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    return events
        .where((e) => !e.date.isBefore(todayStart))
        .toList();
  }

  /// Diyanet verisine dayalı statik fallback (API başarısız olursa)
  static List<IslamicEvent> getFallback2026() {
    return [
      IslamicEvent(name: 'Ramazan Bayramı', date: DateTime(2026, 3, 20)),
      IslamicEvent(name: 'Kurban Bayramı', date: DateTime(2026, 5, 27)),
      IslamicEvent(name: 'Hicri Yılbaşı', date: DateTime(2026, 6, 16)),
      IslamicEvent(name: 'Aşure Günü', date: DateTime(2026, 6, 25)),
      IslamicEvent(name: 'Mevlid Kandili', date: DateTime(2026, 8, 24)),
      IslamicEvent(name: 'Regaib Kandili', date: DateTime(2026, 12, 10)),
    ];
  }
}

class IslamicEvent {
  const IslamicEvent({required this.name, required this.date});

  final String name;
  final DateTime date;

  int get daysUntil {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDay = DateTime(date.year, date.month, date.day);
    return eventDay.difference(today).inDays;
  }
}
