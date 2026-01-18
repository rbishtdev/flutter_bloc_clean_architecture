import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/todo.dart';
import '../blocs/todo_bloc.dart';
import '../blocs/todo_event.dart';

class AddTodoDialog extends StatelessWidget {
  final BuildContext parentContext;
  const AddTodoDialog({super.key, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return AlertDialog(
      title: const Text('Add Todo'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Enter todo title',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final title = controller.text.trim();
            if (title.isEmpty) return;

            final todo = Todo(
              userId: 1,
              id: DateTime.now().millisecondsSinceEpoch,
              title: title,
              completed: false,
            );

            parentContext.read<TodoBloc>().add(AddTodoEvent(todo));
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
