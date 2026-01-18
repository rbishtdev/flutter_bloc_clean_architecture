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

class UpdateTodoEvent extends TodoEvent {
  final Todo todo;
  const UpdateTodoEvent(this.todo);
}

class DeleteTodoEvent extends TodoEvent {
  final int id;
  const DeleteTodoEvent(this.id);
}

class SyncTodosEvent extends TodoEvent {
  const SyncTodosEvent();
}

