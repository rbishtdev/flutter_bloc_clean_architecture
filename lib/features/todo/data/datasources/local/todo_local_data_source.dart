import 'package:injectable/injectable.dart';
import 'package:proj/core/data/local/local_db_client.dart';

import '../../models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getTodos();
  Future<void> insertTodo(TodoModel todo);
  Future<void> deleteTodo(int id);
  Future<void> updateTodo(TodoModel todo);
  Future<void> markSynced(int id);
  Future<List<TodoModel>> getPendingTodos();
  Future<List<TodoModel>> getDeletedTodos();
}

@LazySingleton(as: TodoLocalDataSource)
class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final LocalDbClient db;

  TodoLocalDataSourceImpl(this.db);

  @override
  Future<List<TodoModel>> getTodos() async {
    final rows = await db.getAll('todos', 'is_deleted = 0');
    return rows.map(TodoModel.fromJson).toList();
  }

  @override
  Future<void> insertTodo(TodoModel todo) async {
    await db.insert('todos', todo.toJson());
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    await db.update(
      'todos',
      todo.toJson(),
      'id = ?',
      [todo.id],
    );
  }

  @override
  Future<void> deleteTodo(int id) async {
    await db.update(
      'todos',
      {
        'is_deleted': 0,
        'is_synced': 0,
      },
      'id = ?',
      [id],
    );
  }

  @override
  Future<void> markSynced(int id) async {
    await db.update('todos', {'is_synced': 1},
        'id = ?', [id]);
  }

  @override
  Future<List<TodoModel>> getPendingTodos() async {
    final rows = await db.getAll('todos', 'is_synced = 0');
    return rows.map(TodoModel.fromJson).toList();
  }

  @override
  Future<List<TodoModel>> getDeletedTodos() async {
    final rows = await db.getAll('todos', 'isDeleted = 1');
    return rows.map(TodoModel.fromJson).toList();
  }
}

