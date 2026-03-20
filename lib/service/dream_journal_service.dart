import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Rüya defteri — SharedPreferences (JSON) ve Firestore ile CRUD.
class DreamJournalService {
  DreamJournalService(this._prefix);
  final String _prefix;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _storageKey => '${_prefix}_dream_journal_entries';
  static int _nextId = 0;

  bool get _isAuthorized => _prefix.startsWith('auth_');
  String? get _uid => _isAuthorized ? _prefix.replaceFirst('auth_', '') : null;

  CollectionReference<Map<String, dynamic>>? get _userDreamsCollection {
    final uid = _uid;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid).collection('dreams');
  }

  Future<List<DreamEntry>> getAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_storageKey);
    
    // If we have local data, use it as a base
    List<DreamEntry> entries = [];
    if (raw != null && raw.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      entries = decoded
          .map((dynamic e) => DreamEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (entries.isNotEmpty) {
      _nextId = entries
              .map((DreamEntry e) => e.id)
              .reduce((int a, int b) => a > b ? a : b) +
          1;
    }

    return entries..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Firestore'dan verileri çekip lokale eşitler
  Future<List<DreamEntry>> syncFromFirestore() async {
    if (!_isAuthorized) return getAll();

    try {
      final snapshot = await _userDreamsCollection?.get();
      if (snapshot == null) return getAll();

      final List<DreamEntry> firestoreEntries = snapshot.docs.map((doc) {
        final data = doc.data();
        return DreamEntry.fromJson(data);
      }).toList();

      if (firestoreEntries.isNotEmpty) {
        await _save(firestoreEntries);
        return firestoreEntries..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
    } catch (e) {
      print('Firestore sync error: $e');
    }
    return getAll();
  }

  Future<int> insert(String title, String content) async {
    final List<DreamEntry> entries = await getAll();
    final int id = _nextId++;
    final String nowStr = DateTime.now().toIso8601String();
    final now = DateTime.parse(nowStr);

    final entry = DreamEntry(
      id: id,
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
    );

    entries.add(entry);
    await _save(entries);

    // Sync to Firestore if authorized (with try-catch to prevent crashes)
    if (_isAuthorized) {
      try {
        await _userDreamsCollection?.doc(id.toString()).set(entry.toJson());
      } catch (e) {
        print('Firestore insert error: $e');
      }
    }

    return id;
  }

  Future<void> update(int id, String title, String content) async {
    final List<DreamEntry> entries = await getAll();
    final int index = entries.indexWhere((DreamEntry e) => e.id == id);
    if (index == -1) return;

    final updatedEntry = DreamEntry(
      id: id,
      title: title,
      content: content,
      createdAt: entries[index].createdAt,
      updatedAt: DateTime.now(),
    );

    entries[index] = updatedEntry;
    await _save(entries);

    // Sync to Firestore if authorized
    if (_isAuthorized) {
      try {
        await _userDreamsCollection?.doc(id.toString()).set(updatedEntry.toJson());
      } catch (e) {
        print('Firestore update error: $e');
      }
    }
  }

  Future<void> delete(int id) async {
    final List<DreamEntry> entries = await getAll();
    entries.removeWhere((DreamEntry e) => e.id == id);
    await _save(entries);

    // Sync to Firestore if authorized
    if (_isAuthorized) {
      try {
        await _userDreamsCollection?.doc(id.toString()).delete();
      } catch (e) {
        print('Firestore delete error: $e');
      }
    }
  }

  Future<void> _save(List<DreamEntry> entries) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encoded =
        jsonEncode(entries.map((DreamEntry e) => e.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }
}

class DreamEntry {
  const DreamEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DreamEntry.fromJson(Map<String, dynamic> json) {
    return DreamEntry(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // sqflite uyumluluğu için eski fromMap korunuyor
  factory DreamEntry.fromMap(Map<String, dynamic> map) =>
      DreamEntry.fromJson(map);

  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
