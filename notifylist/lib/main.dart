import 'package:flutter/material.dart';
import 'package:notifylist/core/database/app_database.dart';

late AppDatabase database;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  database = AppDatabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NotifyList',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Base creada para NotifyList'),
        ),
      ),
    );

  }
}