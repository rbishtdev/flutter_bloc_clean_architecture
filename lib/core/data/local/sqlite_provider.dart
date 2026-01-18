import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class SqliteClient {
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;

    final path = join(await getDatabasesPath(), 'app.db');

    _db = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE todos(
        id INTEGER PRIMARY KEY,
        userId INTEGER,
        title TEXT,
        completed INTEGER,
        is_synced INTEGER,
        is_deleted INTEGER
      )
    ''');
      },
      onUpgrade: (db, oldV, newV) async {
        await db.execute('DROP TABLE IF EXISTS todos');
        await db.execute('''
      CREATE TABLE todos(
        id INTEGER PRIMARY KEY,
        userId INTEGER,
        title TEXT,
        completed INTEGER,
        is_synced INTEGER,
        is_deleted INTEGER
      )
    ''');
      },
    );

    return _db!;
  }
}
