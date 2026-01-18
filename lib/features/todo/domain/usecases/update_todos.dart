import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

@lazySingleton
class UpdateTodos {
  final TodoRepository repository;

  UpdateTodos(this.repository);

  Future<Either<Failure, void>> call(Todo todo) {
    return repository.updateTodo(todo);
  }
}
