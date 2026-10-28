import 'package:flutter/material.dart';

import 'models/task_repository.dart';
import 'screens/task_list_screen.dart';

void main() {
  runApp(const FitBulkApp());
}

class FitBulkApp extends StatelessWidget {
  const FitBulkApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = TaskRepository();

    return MaterialApp(
      title: 'FitBulk App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
        ),
      ),
      home: TaskListScreen(repository: repository),
    );
  }
}
