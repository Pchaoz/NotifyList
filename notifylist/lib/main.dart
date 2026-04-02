import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifylist/core/database/app_database.dart';
import 'package:notifylist/core/theme/app_theme.dart';
import 'package:notifylist/features/tasks/screens/tasks_screen.dart';

late AppDatabase database;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  database = AppDatabase();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NotifyList',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const TasksScreen(),
    );

  }
}