import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/todo.dart';
import '../blocs/todo_bloc.dart';
import '../blocs/todo_event.dart';
import '../blocs/todo_state.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final todo = Todo(
            userId: 1,
            id: DateTime.now().millisecondsSinceEpoch,
            title: 'New Todo Raj',
            completed: false,
          );
          context.read<TodoBloc>().add(AddTodoEvent(todo));

        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TodoLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TodoBloc>().add(const LoadTodos());
              },
              child: ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (_, i) {
                  final todo = state.todos[i];
                  return ListTile(
                    title: Text(todo.title),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // context
                        //     .read<TodoBloc>()
                        //     .add(DeleteTodoEvent(todo.id));
                      },
                    ),
                  );
                },
              ),
            );
          }

          if (state is TodoError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
