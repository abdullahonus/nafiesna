import 'package:shared_preferences/shared_preferences.dart';

/// Kaza namazları sayacı — SharedPreferences ile kalıcı depolama.
class MissedPrayerService {
  static const String _prefix = 'missed_prayer_';
  static const String _lastUpdatedKey = 'missed_prayer_last_updated';

  static const List<String> prayerKeys = [
    'sabah',
    'ogle',
    'ikindi',
    'aksam',
    'yatsi',
    'vitr',
    'oruc',
  ];

  static const Map<String, String> prayerLabels = {
    'sabah': 'Sabah',
    'ogle': 'Öğle',
    'ikindi': 'İkindi',
    'aksam': 'Akşam',
    'yatsi': 'Yatsı',
    'vitr': 'Vitr',
    'oruc': 'Oruç',
  };

  static const Map<String, String> prayerIcons = {
    'sabah': '🌅',
    'ogle': '☀️',
    'ikindi': '🌤️',
    'aksam': '🌇',
    'yatsi': '🌙',
    'vitr': '🌙',
    'oruc': '🍽️',
  };

  Future<Map<String, int>> getAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, int> result = {};
    for (final String key in prayerKeys) {
      result[key] = prefs.getInt('$_prefix$key') ?? 0;
    }
    return result;
  }

  Future<int> get(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_prefix$key') ?? 0;
  }

  Future<void> increment(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int current = prefs.getInt('$_prefix$key') ?? 0;
    await prefs.setInt('$_prefix$key', current + 1);
    await prefs.setString(_lastUpdatedKey, DateTime.now().toIso8601String());
  }

  Future<void> decrement(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int current = prefs.getInt('$_prefix$key') ?? 0;
    if (current > 0) {
      await prefs.setInt('$_prefix$key', current - 1);
      await prefs.setString(_lastUpdatedKey, DateTime.now().toIso8601String());
    }
  }

  Future<void> set(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_prefix$key', value >= 0 ? value : 0);
    await prefs.setString(_lastUpdatedKey, DateTime.now().toIso8601String());
  }

  Future<String?> getLastUpdated() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastUpdatedKey);
  }

  Future<void> resetAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (final String key in prayerKeys) {
      await prefs.remove('$_prefix$key');
    }
    await prefs.remove(_lastUpdatedKey);
  }
}
