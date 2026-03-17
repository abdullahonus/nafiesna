import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Rüya defteri — SharedPreferences (JSON) ile CRUD.
class DreamJournalService {
  static const String _storageKey = 'dream_journal_entries';
  static int _nextId = 0;

  Future<List<DreamEntry>> getAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];

    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    final List<DreamEntry> entries = decoded
        .map((dynamic e) => DreamEntry.fromJson(e as Map<String, dynamic>))
        .toList();

    entries.sort(
        (DreamEntry a, DreamEntry b) => b.createdAt.compareTo(a.createdAt));

    if (entries.isNotEmpty) {
      _nextId = entries
              .map((DreamEntry e) => e.id)
              .reduce((int a, int b) => a > b ? a : b) +
          1;
    }

    return entries;
  }

  Future<int> insert(String title, String content) async {
    final List<DreamEntry> entries = await getAll();
    final int id = _nextId++;
    final String now = DateTime.now().toIso8601String();

    entries.add(DreamEntry(
      id: id,
      title: title,
      content: content,
      createdAt: DateTime.parse(now),
      updatedAt: DateTime.parse(now),
    ));

    await _save(entries);
    return id;
  }

  Future<void> update(int id, String title, String content) async {
    final List<DreamEntry> entries = await getAll();
    final int index = entries.indexWhere((DreamEntry e) => e.id == id);
    if (index == -1) return;

    entries[index] = DreamEntry(
      id: id,
      title: title,
      content: content,
      createdAt: entries[index].createdAt,
      updatedAt: DateTime.now(),
    );

    await _save(entries);
  }

  Future<void> delete(int id) async {
    final List<DreamEntry> entries = await getAll();
    entries.removeWhere((DreamEntry e) => e.id == id);
    await _save(entries);
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
