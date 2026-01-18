import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/add_todos.dart';
import 'todo_event.dart';
import 'todo_state.dart';
import '../../domain/usecases/get_todos.dart';

@injectable
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;
  final AddTodos addTodo;

  TodoBloc({
    required this.getTodos,
    required this.addTodo,
  }) : super(const TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
  }

  Future<void> _onLoadTodos(
      LoadTodos event, Emitter<TodoState> emit) async {
    emit(const TodoLoading());

    final result = await getTodos();

    result.fold(
          (f) => emit(TodoError(f.message)),
          (todos) => emit(TodoLoaded(todos)),
    );
  }

  Future<void> _onAddTodo(
      AddTodoEvent event, Emitter<TodoState> emit) async {
    await addTodo(event.todo);
    add(const LoadTodos());
  }
}
