import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proj/core/extensions/snackbar_extension.dart';

import '../../domain/entities/todo.dart';
import '../blocs/todo_bloc.dart';
import '../blocs/todo_event.dart';
import '../blocs/todo_state.dart';
import '../widgets/add_todo_dialog.dart';
import '../widgets/todo_list_tile.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      floatingActionButton: const _AddButton(),
      body: BlocListener<TodoBloc, TodoState>(
        listener: _listener,
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: _builder,
        ),
      ),
    );
  }

  void _listener(BuildContext context, TodoState state) {
    switch (state) {
      case TodoSuccess(:final message):
        context.showSuccess(message);

      case TodoError(:final message):
        context.showError(message);

      default:
        break;
    }
  }


  Widget _builder(BuildContext context, TodoState state) {
    return switch (state) {
      TodoInitial() || TodoLoading() =>
      const Center(child: CircularProgressIndicator()),

      TodoLoaded(:final todos) => _TodoList(todos: todos),

      TodoError(:final message) => Center(child: Text(message)),

      TodoSuccess() => const SizedBox.shrink(),
    };
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AddTodoDialog(parentContext: context),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}

class _TodoList extends StatelessWidget {
  final List<Todo> todos;

  const _TodoList({required this.todos});

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return const Center(child: Text('No todos yet'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<TodoBloc>().add(const SyncTodosEvent());
        context.read<TodoBloc>().add(const LoadTodos());
      },
      child: ListView.separated(
        itemCount: todos.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, index) => TodoTile(todo: todos[index]),
      ),
    );
  }
}