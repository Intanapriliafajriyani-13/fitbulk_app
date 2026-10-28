import 'package:flutter/material.dart';

import '../models/task.dart';
import '../models/task_repository.dart';
import '../widgets/fade_in.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key, required this.repository});

  final TaskRepository repository;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<BulkingTask> _tasks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final tasks = await widget.repository.getAll();
    if (!mounted) return;
    setState(() {
      _tasks = tasks;
      _loading = false;
    });
  }

  Future<void> _toggle(BulkingTask task, bool? value) async {
    final newValue = value ?? false;
    await widget.repository.toggle(task.id, newValue);
    await _load();
  }

  Future<void> _openAddScreen() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(repository: widget.repository),
      ),
    );
    if (saved == true && mounted) {
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Agenda FitBulk berhasil disimpan!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showTaskDetail(BulkingTask task) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () async {
                    Navigator.pop(context);
                    await widget.repository.delete(task.id);
                    await _load();
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Kategori: ${task.category.label}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (task.calories != null || task.protein != null) ...[
              Text(
                'Nutrisi: ${task.calories ?? 0} kcal | ${task.protein ?? 0}g protein',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              task.note?.isNotEmpty == true
                  ? task.note!
                  : 'Tidak ada catatan komposisi tambahan.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pending = _tasks.where((t) => !t.isCompleted).toList();
    final totalCalories = _tasks
        .where((t) => t.isCompleted && t.calories != null)
        .fold<int>(0, (sum, t) => sum + t.calories!);
    final totalProtein = _tasks
        .where((t) => t.isCompleted && t.protein != null)
        .fold<int>(0, (sum, t) => sum + t.protein!);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.fitness_center, color: Colors.green),
            SizedBox(width: 10),
            Text('FitBulk — Nutrition & Workout'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : FadeIn(
              child: Column(
                children: [
                  // Banner Progres Kalori & Protein Hari ini
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade700, Colors.teal.shade800],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Kalori Terpenuhi',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$totalCalories kcal',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Container(width: 1, height: 35, color: Colors.white30),
                        Column(
                          children: [
                            const Text(
                              'Protein Masuk',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$totalProtein g',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Daftar Tugas
                  Expanded(
                    child: _tasks.isEmpty
                        ? const Center(
                            child: Text('Belum ada target. Tekan + untuk menambah.'),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            itemCount: _tasks.length,
                            itemBuilder: (context, index) {
                              final task = _tasks[index];
                              return TaskCard(
                                task: task,
                                onToggle: (v) => _toggle(task, v),
                                onTap: () => _showTaskDetail(task),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              '${pending.length} target bulking belum selesai',
              key: ValueKey(pending.length),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddScreen,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Target'),
      ),
    );
  }
}
