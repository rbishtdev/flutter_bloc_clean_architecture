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
      var localTodos = await local.getTodos();

      if (await network.isConnected) {
        try {
          final remoteTodos = await remote.getTodos();
          for (final todo in remoteTodos) {
            await local.insertTodo(todo.copyWith(isSynced: true));
          }

          localTodos = await local.getTodos();
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
      final model = TodoModel.fromEntity(todo);

      await local.insertTodo(model);

      if (await network.isConnected) {
        try {
          await remote.addTodo(model);
          await local.markSynced(model.id);
        } catch (_) {
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to add todo locally'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(int id) async {
    try {
      await local.deleteTodo(id);

      if (await network.isConnected) {
        try {
          await remote.deleteTodo(id);
        } catch (_) {
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to delete todo'));
    }
  }


  @override
  Future<Either<Failure, void>> updateTodo(Todo todo) async {
    try {
      final model = TodoModel.fromEntity(todo, isSynced: false);

      await local.updateTodo(model);

      if (await network.isConnected) {
        try {
          await remote.updateTodo(model);
          await local.markSynced(model.id);
        } catch (_) {
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to update todo'));
    }
  }

  @override
  Future<Either<Failure, void>> syncPendingTodos() async {
    if (!await network.isConnected) {
      return const Right(null);
    }

    try {
      final pending = await local.getPendingTodos();

      for (final todo in pending) {
        try {
          await remote.addTodo(todo);
          await local.markSynced(todo.id);
        } catch (_) {

        }
      }

      final deleted = await local.getDeletedTodos();

      for (final todo in deleted) {
        try {
          await remote.deleteTodo(todo.id);
          await local.deleteTodo(todo.id);
        } catch (_) {
        }
      }

      return const Right(null);
    } catch (_) {
      return const Right(null); // never break UI for sync
    }
  }


}
