import 'package:sqflite/sqflite.dart';

/// Singleton class instantiated through openDB method
class DBWrapper {
  static Database? _db;
  static const appDB = 'appDB.db';

  static Future<Database> get db async => _db ??= await _openDB();

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  static Future<Database> _openDB() async {
    var db = await openDatabase(
      appDB,
      onConfigure: _onConfigure
    );

    return db;
  }
}
