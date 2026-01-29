import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proj/features/todo/presentation/widgets/update_todo_dialog.dart';

import '../../domain/entities/todo.dart';
import '../blocs/todo_bloc.dart';
import '../blocs/todo_event.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;

  const TodoTile({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(todo.id),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration:
          todo.completed ? TextDecoration.lineThrough : null,
          color: todo.completed ? Colors.green : null,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              context.read<TodoBloc>().add(
                UpdateTodoEvent(todo.copyWith(completed: true)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => UpdateTodoDialog(
                  todo: todo,
                  parentContext: context,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              context.read<TodoBloc>().add(DeleteTodoEvent(todo.id));
            },
          ),
        ],
      ),
    );
  }
}
