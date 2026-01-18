import 'package:injectable/injectable.dart';

import '../../../../../core/data/remote/api_client.dart';
import '../../models/todo_model.dart';

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodos();
  Future<void> addTodo(TodoModel todo);
  Future<void> deleteTodo(int id);
  Future<void> updateTodo(TodoModel todo);
}

@LazySingleton(as: TodoRemoteDataSource)
class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final ApiClient api;
  TodoRemoteDataSourceImpl(this.api);

  @override
  Future<List<TodoModel>> getTodos() {
    return api.get(
      '/todos',
      parser: (d) =>
          (d as List).map((e) => TodoModel.fromJson(e)).toList(),
    );
  }

  @override
  Future<void> addTodo(TodoModel todo) {
    return api.post('/todos', body: todo.toJson());
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    await api.patch(
      '/todos/${todo.id}',
      body: todo.toJson(),
    );
  }

  @override
  Future<void> deleteTodo(int id) async {
    await api.delete('/todos/$id');
  }
}
