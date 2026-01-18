import '../../domain/entities/todo.dart';

abstract class TodoEvent {
  const TodoEvent();
}

class LoadTodos extends TodoEvent {
  const LoadTodos();
}

class AddTodoEvent extends TodoEvent {
  final Todo todo;
  const AddTodoEvent(this.todo);
}
