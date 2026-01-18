import 'package:injectable/injectable.dart';
import 'package:proj/core/data/local/sqlite_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'local_status_mapper.dart';

@LazySingleton()
class LocalDbClient {
  final SqliteClient _client;

  LocalDbClient(this._client);

  Future<int> insert(String table, Map<String, dynamic> data) async {
    try {
      final db = await _client.database;
      return await db.insert(table, data,
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw LocalStatusMapper.map(e);
    }
  }

  Future<List<Map<String, dynamic>>> getAll(String table, String where) async {
    try {
      final db = await _client.database;
      return await db.query(table);
    } catch (e) {
      throw LocalStatusMapper.map(e);
    }
  }

  Future<int> update(
      String table, Map<String, dynamic> data, String where, List args) async {
    try {
      final db = await _client.database;
      return await db.update(table, data, where: where, whereArgs: args);
    } catch (e) {
      throw LocalStatusMapper.map(e);
    }
  }

  Future<int> delete(String table, String where, List args) async {
    try {
      final db = await _client.database;
      return await db.delete(table, where: where, whereArgs: args);
    } catch (e) {
      throw LocalStatusMapper.map(e);
    }
  }
}
