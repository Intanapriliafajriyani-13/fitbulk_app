import 'package:flutter/material.dart';

import '../models/task.dart';
import '../models/task_repository.dart';
import '../widgets/fade_in.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';

/// Layar Daftar Target Bulking (Layar ke-1 dari 3 screen utama).
///
/// Menerapkan:
/// - Breakpoint adaptif ruang (LayoutBuilder: horizontal padding 12dp < 600dp, 48dp >= 600dp)
/// - Interaksi geser-hapus `Dismissible` dengan `confirmDismiss` dialog tonal M3
/// - Navigasi ke `TaskDetailScreen` dan `AddTaskScreen` via Navigator
/// - State lokal dikelola dengan `setState`
/// - Fondasi aksesibilitas (ExcludeSemantics, Tooltip)
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
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Target FitBulk berhasil ditambahkan!'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
      }
    }
  }

  Future<void> _openDetail(BulkingTask task) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(
          task: task,
          repository: widget.repository,
        ),
      ),
    );
    if (changed == true && mounted) {
      await _load();
    }
  }

  Future<bool> _confirmDelete(BulkingTask task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final scheme = Theme.of(dialogContext).colorScheme;
        return AlertDialog(
          title: const Text('Hapus target bulking?'),
          content: Text('Target "${task.title}" akan dihapus dari daftar.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            FilledButton.tonal(
              style: FilledButton.styleFrom(
                backgroundColor: scheme.errorContainer,
                foregroundColor: scheme.onErrorContainer,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
    return confirmed ?? false;
  }

  Future<void> _delete(BulkingTask task) async {
    await widget.repository.delete(task.id);
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Target berhasil dihapus'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Widget _buildDismissible(BulkingTask task) {
    final scheme = Theme.of(context).colorScheme;
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.errorContainer,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ExcludeSemantics(
              child: Icon(
                Icons.delete_outline,
                color: scheme.onErrorContainer,
              ),
            ),
          ),
        ),
      ),
      confirmDismiss: (_) => _confirmDelete(task),
      onDismissed: (_) => _delete(task),
      child: TaskCard(
        task: task,
        onToggle: (v) => _toggle(task, v),
        onTap: () => _openDetail(task),
      ),
    );
  }

  Widget _buildEmptyState() {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center_outlined,
              size: 72,
              color: scheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada target bulking',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tekan tombol + di bawah untuk menambah agenda makan atau latihan bebas laktosa.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final pending = _tasks.where((t) => !t.isCompleted).toList();
    final totalCalories = _tasks
        .where((t) => t.isCompleted && t.calories != null)
        .fold<int>(0, (sum, t) => sum + t.calories!);
    final totalProtein = _tasks
        .where((t) => t.isCompleted && t.protein != null)
        .fold<int>(0, (sum, t) => sum + t.protein!);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ExcludeSemantics(
              child: Icon(Icons.fitness_center, color: scheme.primary),
            ),
            const SizedBox(width: 10),
            const Text('FitBulk — Nutrition & Workout'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : FadeIn(
              child: Column(
                children: [
                  // Banner Nutrisi Progres Terpenuhi Hari Ini
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          scheme.primary,
                          scheme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Kalori Terpenuhi',
                              style: TextStyle(
                                color: scheme.onPrimary.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$totalCalories kcal',
                              style: TextStyle(
                                color: scheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 1,
                          height: 35,
                          color: scheme.onPrimary.withValues(alpha: 0.3),
                        ),
                        Column(
                          children: [
                            Text(
                              'Protein Masuk',
                              style: TextStyle(
                                color: scheme.onPrimary.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$totalProtein g',
                              style: TextStyle(
                                color: scheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Daftar Tugas dengan Breakpoint Responsif Ruang Tersedia
                  Expanded(
                    child: _tasks.isEmpty
                        ? _buildEmptyState()
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              // Breakpoint berbasis ruang tersedia, bukan jenis perangkat:
                              // margin sempit di ponsel potret (< 600dp), lebar di tablet/landscape (>= 600dp)
                              final horizontal =
                                  constraints.maxWidth < 600 ? 12.0 : 48.0;
                              return ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  horizontal: horizontal,
                                  vertical: 4,
                                ),
                                itemCount: _tasks.length,
                                itemBuilder: (context, index) =>
                                    _buildDismissible(_tasks[index]),
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
        tooltip: 'Tambah target bulking',
        onPressed: _openAddScreen,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Target'),
      ),
    );
  }
}
