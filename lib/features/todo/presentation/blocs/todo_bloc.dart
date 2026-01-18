import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/add_todos.dart';
import '../../domain/usecases/delete_todos.dart';
import '../../domain/usecases/update_todos.dart';
import 'todo_event.dart';
import 'todo_state.dart';
import '../../domain/usecases/get_todos.dart';

@injectable
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;
  final AddTodos addTodos;
  final DeleteTodos deleteTodos;
  final UpdateTodos updateTodos;

  TodoBloc({
    required this.getTodos,
    required this.addTodos,
    required this.deleteTodos,
    required this.updateTodos,
  }) : super(const TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(const TodoLoading());

    final result = await getTodos();

    result.fold(
      (f) => emit(TodoError(f.message)),
      (todos) => emit(TodoLoaded(todos)),
    );
  }

  Future<void> _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    await addTodos(event.todo);
    add(const LoadTodos());
  }

  Future<void> _onUpdateTodo(
      UpdateTodoEvent event, Emitter<TodoState> emit) async {
    await updateTodos(event.todo);
    add(const LoadTodos());
  }

  Future<void> _onDeleteTodo(
      DeleteTodoEvent event, Emitter<TodoState> emit) async {
    await deleteTodos(event.id);
    add(const LoadTodos());
  }
}
