import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../repositories/todo_repository.dart';

@lazySingleton
class DeleteTodos {
  final TodoRepository repository;

  DeleteTodos(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deleteTodo(id);
  }
}
