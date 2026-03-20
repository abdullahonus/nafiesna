import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Kaza namazları sayacı — SharedPreferences ve Firestore ile kalıcı depolama.
class MissedPrayerService {
  MissedPrayerService(this._userPrefix);
  final String _userPrefix;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _prefix => '${_userPrefix}_missed_prayer_';
  String get _lastUpdatedKey => '${_userPrefix}_missed_prayer_last_updated';

  bool get _isAuthorized => _userPrefix.startsWith('auth_');
  String? get _uid => _isAuthorized ? _userPrefix.replaceFirst('auth_', '') : null;

  DocumentReference<Map<String, dynamic>>? get _userPrayersDoc {
    final uid = _uid;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid).collection('prayers').doc('counters');
  }

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

  /// Firestore'dan verileri çekip lokale eşitler
  Future<Map<String, int>> syncFromFirestore() async {
    if (!_isAuthorized) return getAll();

    try {
      final snapshot = await _userPrayersDoc?.get();
      if (snapshot != null && snapshot.exists) {
        final data = snapshot.data();
        if (data != null) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final Map<String, int> result = {};
          
          for (final String key in prayerKeys) {
            final int value = (data[key] ?? 0) as int;
            result[key] = value;
            await prefs.setInt('$_prefix$key', value);
          }
          
          if (data['last_updated'] != null) {
             await prefs.setString(_lastUpdatedKey, data['last_updated'] as String);
          }
          
          return result;
        }
      }
    } catch (e) {
      print('MissedPrayer Firestore sync error: $e');
    }
    return getAll();
  }

  Future<int> get(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_prefix$key') ?? 0;
  }

  Future<void> increment(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int current = prefs.getInt('$_prefix$key') ?? 0;
    final int newValue = current + 1;
    final String now = DateTime.now().toIso8601String();

    await prefs.setInt('$_prefix$key', newValue);
    await prefs.setString(_lastUpdatedKey, now);

    if (_isAuthorized) {
      try {
        await _userPrayersDoc?.set({
          key: newValue,
          'last_updated': now,
        }, SetOptions(merge: true));
      } catch (e) {
        print('MissedPrayer increment Firestore error: $e');
      }
    }
  }

  Future<void> decrement(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int current = prefs.getInt('$_prefix$key') ?? 0;
    if (current > 0) {
      final int newValue = current - 1;
      final String now = DateTime.now().toIso8601String();

      await prefs.setInt('$_prefix$key', newValue);
      await prefs.setString(_lastUpdatedKey, now);

      if (_isAuthorized) {
        try {
          await _userPrayersDoc?.set({
            key: newValue,
            'last_updated': now,
          }, SetOptions(merge: true));
        } catch (e) {
          print('MissedPrayer decrement Firestore error: $e');
        }
      }
    }
  }

  Future<void> set(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int newValue = value >= 0 ? value : 0;
    final String now = DateTime.now().toIso8601String();

    await prefs.setInt('$_prefix$key', newValue);
    await prefs.setString(_lastUpdatedKey, now);

    if (_isAuthorized) {
      try {
        await _userPrayersDoc?.set({
          key: newValue,
          'last_updated': now,
        }, SetOptions(merge: true));
      } catch (e) {
        print('MissedPrayer set Firestore error: $e');
      }
    }
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

    if (_isAuthorized) {
      await _userPrayersDoc?.delete();
    }
  }
}
