import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proj/core/utils/constant.dart';

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
      title: const Text(AppStringConstants.addToDoText),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: AppStringConstants.enterTodoText,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStringConstants.cancelText),
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
          child: const Text(AppStringConstants.cancelText),
        ),
      ],
    );
  }
}
