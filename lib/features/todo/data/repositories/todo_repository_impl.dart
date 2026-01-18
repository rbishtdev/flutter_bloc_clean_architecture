import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/local/todo_local_data_source.dart';
import '../datasources/remote/todo_remote_datasource.dart';
import '../models/todo_model.dart';

@LazySingleton(as: TodoRepository)
class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource local;
  final TodoRemoteDataSource remote;
  final NetworkInfo network;

  TodoRepositoryImpl(this.local, this.remote, this.network);

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    try {
      final localTodos = await local.getTodos();

      if (await network.isConnected) {
        try {
          final remoteTodos = await remote.getTodos();
          for (final todo in remoteTodos) {
            await local.insertTodo(todo.copyWith(isSynced: true));
          }
        } catch (_) {
        }
      }
      return Right(localTodos.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure('Local cache error'));
    }
  }

  @override
  Future<Either<Failure, void>> addTodo(Todo todo) async {
    try {
      final model = TodoModel.fromEntity(todo, isSynced: false);

      await local.insertTodo(model);

      if (await network.isConnected) {
        try {
          await remote.addTodo(model);
        } catch (_) {
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to add todo locally'));
    }
  }
}
