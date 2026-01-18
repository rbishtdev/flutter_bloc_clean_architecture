import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class GetTodos {
  final TodoRepository repository;

  GetTodos(this.repository);

  Future<Either<Failure, List<Todo>>> call() {
    return repository.getTodos();
  }
}
