import 'package:flutter/material.dart';
import 'core/di/injection.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(); // injectable setup
  runApp(const MyApp());
}
