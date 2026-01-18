import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/todo.dart';
import '../blocs/todo_bloc.dart';
import '../blocs/todo_event.dart';

class UpdateTodoDialog extends StatelessWidget {
  final Todo todo;
  final BuildContext parentContext;
  const UpdateTodoDialog({super.key, required this.todo, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: todo.title);

    return AlertDialog(
      title: const Text('Update Todo'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Update todo title',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedTitle = controller.text.trim();
            if (updatedTitle.isEmpty) return;

            if( todo.title == updatedTitle) {
              Navigator.pop(context);
              return;
            }

            parentContext.read<TodoBloc>().add(
              UpdateTodoEvent(
                todo.copyWith(title: updatedTitle),
              ),
            );

            Navigator.pop(context);
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
