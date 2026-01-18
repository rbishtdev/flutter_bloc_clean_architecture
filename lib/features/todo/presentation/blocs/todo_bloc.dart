import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/add_todos.dart';
import '../../domain/usecases/delete_todos.dart';
import '../../domain/usecases/sync_pending_todos.dart';
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
  final SyncPendingTodos syncPendingTodos;
  final Connectivity connectivity;

  TodoBloc({
    required this.getTodos,
    required this.addTodos,
    required this.deleteTodos,
    required this.updateTodos,
    required this.syncPendingTodos,
    required this.connectivity,
  }) : super(const TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
    on<SyncTodosEvent>(_onSyncTodo);

    connectivity.onConnectivityChanged.listen((results) {
      if (!results.contains(ConnectivityResult.none)) {
        add(const SyncTodosEvent());
      }
    });
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
    if (state is! TodoLoaded) return;

    final currentState = state as TodoLoaded;

    final updatedTodos = [event.todo, ...currentState.todos];

    emit(TodoLoaded(updatedTodos));

    final result = await addTodos(event.todo);
    result.fold((f) => emit(TodoError(f.message)), (_) {});
  }

  Future<void> _onUpdateTodo(
      UpdateTodoEvent event, Emitter<TodoState> emit) async {
    if (state is! TodoLoaded) return;

    final currentState = state as TodoLoaded;

    final updatedTodos = currentState.todos.map((todo) {
      return todo.id == event.todo.id ? event.todo : todo;
    }).toList();

    emit(TodoLoaded(updatedTodos));

    final result = await updateTodos(event.todo);

    result.fold(
          (f) => emit(TodoError(f.message)),
          (_) {},
    );
  }

  Future<void> _onDeleteTodo(
      DeleteTodoEvent event, Emitter<TodoState> emit) async {
    if (state is! TodoLoaded) return;

    final currentState = state as TodoLoaded;

    final updatedTodos =
    currentState.todos.where((t) => t.id != event.id).toList();

    emit(TodoLoaded(updatedTodos));

    final result = await deleteTodos(event.id);

    result.fold(
          (f) => emit(TodoError(f.message)),
          (_) {},
    );
  }

  Future<void> _onSyncTodo(
      SyncTodosEvent event,
      Emitter<TodoState> emit,
      ) async {
    await syncPendingTodos();
  }
}
