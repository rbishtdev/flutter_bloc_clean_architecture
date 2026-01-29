import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'features/todo/presentation/blocs/todo_bloc.dart';
import 'features/todo/presentation/blocs/todo_event.dart';
import 'features/todo/presentation/pages/todo_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter BLoC Clean Architecture',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<TodoBloc>(
            create: (_) => getIt<TodoBloc>()..add(const LoadTodos()),
          ),
        ],
        child: const TodoScreen(),
      ),
    );
  }
}
