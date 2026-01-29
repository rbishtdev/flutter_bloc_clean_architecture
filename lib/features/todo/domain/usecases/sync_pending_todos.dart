import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../repositories/todo_repository.dart';

@lazySingleton
class SyncPendingTodos {
  final TodoRepository repository;

  SyncPendingTodos(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.syncPendingTodos();
  }
}
