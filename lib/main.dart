import 'package:flutter/material.dart';

import 'models/task_repository.dart';
import 'screens/task_list_screen.dart';
import 'theme.dart';

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
      theme: FitBulkTheme.light(),
      home: TaskListScreen(repository: repository),
    );
  }
}
