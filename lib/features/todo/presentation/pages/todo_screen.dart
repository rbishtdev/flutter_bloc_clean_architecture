import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proj/features/todo/presentation/widgets/add_todo_dialog.dart';
import 'package:proj/features/todo/presentation/widgets/update_todo_dialog.dart';

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
          showDialog(
            context: context,
            builder: (_) => AddTodoDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TodoLoaded) {
            if (state.todos.isEmpty) {
              return const Center(child: Text('No todos yet'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TodoBloc>().add(const LoadTodos());
              },
              child: ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, index) {
                  final todo = state.todos[index];

                  return Column(
                    key: ValueKey(todo.id),
                    children: [
                      ListTile(
                        title: Text(todo.title),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => UpdateTodoDialog(todo: todo),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                context.read<TodoBloc>().add(DeleteTodoEvent(todo.id));
                              },
                            ),
                          ],
                        ),
                      ),

                      if (index != state.todos.length - 1)
                        const Divider(height: 1),
                    ],
                  );
                },
              )
            );
          }

          if (state is TodoError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
