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
  List<Task> _tasks = [];
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

  Future<void> _toggle(Task task, bool? value) async {
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
            content: Text('Tugas baru berhasil disimpan!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showTaskDetail(Task task) {
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
            Text(
              task.note?.isNotEmpty == true
                  ? task.note!
                  : 'Tidak ada catatan tambahan untuk tugas ini.',
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
    final pending = _tasks.where((t) => !t.done).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyTracker — Bab 6'),
      ),
      // FadeIn (animasi eksplisit): memudarkan isi saat pertama muncul
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : FadeIn(
              child: _tasks.isEmpty
                  ? const Center(
                      child: Text('Belum ada tugas. Tekan + untuk menambah.'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
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
      // Implisit: AnimatedSwitcher pada penghitung tugas belum selesai
      bottomNavigationBar: BottomAppBar(
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              '${pending.length} tugas belum selesai',
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
        icon: const Icon(Icons.add),
        label: const Text('Tugas baru'),
      ),
    );
  }
}
