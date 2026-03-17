import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Rüya defteri — sqflite ile CRUD.
class DreamJournalService {
  static Database? _db;
  static const String _tableName = 'dreams';

  Future<Database> get _database async {
    if (_db != null) return _db!;
    final String dbPath = join(await getDatabasesPath(), 'nafiesna_dreams.db');
    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
      },
    );
    return _db!;
  }

  Future<List<DreamEntry>> getAll() async {
    final Database db = await _database;
    final List<Map<String, dynamic>> rows = await db.query(
      _tableName,
      orderBy: 'created_at DESC',
    );
    return rows.map(DreamEntry.fromMap).toList();
  }

  Future<DreamEntry?> getById(int id) async {
    final Database db = await _database;
    final List<Map<String, dynamic>> rows = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (rows.isEmpty) return null;
    return DreamEntry.fromMap(rows.first);
  }

  Future<int> insert(String title, String content) async {
    final Database db = await _database;
    final String now = DateTime.now().toIso8601String();
    return db.insert(_tableName, {
      'title': title,
      'content': content,
      'created_at': now,
      'updated_at': now,
    });
  }

  Future<void> update(int id, String title, String content) async {
    final Database db = await _database;
    await db.update(
      _tableName,
      {
        'title': title,
        'content': content,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    final Database db = await _database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
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

  factory DreamEntry.fromMap(Map<String, dynamic> map) {
    return DreamEntry(
      id: map['id'] as int,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
}
