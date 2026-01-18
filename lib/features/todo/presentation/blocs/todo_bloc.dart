import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'todo_event.dart';
import 'todo_state.dart';
import '../../domain/usecases/get_todos.dart';

@lazySingleton
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;

  TodoBloc({
    required this.getTodos,
  }) : super(const TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
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
}
