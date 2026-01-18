import 'package:injectable/injectable.dart';
import 'package:proj/core/data/local/local_db_client.dart';

import '../../models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getTodos();
  Future<void> insertTodo(TodoModel todo);
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
}

