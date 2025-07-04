import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/session_model.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pomodoro.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE sessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            start_time TEXT,
            duration INTEGER,
            type TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertSession(Session session) async {
    final db = await database;
    await db.insert('sessions', session.toMap());
  }

  static Future<List<Session>> getSessions() async {
    final db = await database;
    final data = await db.query('sessions', orderBy: 'start_time DESC');
    return data.map((e) => Session.fromMap(e)).toList();
  }
}
