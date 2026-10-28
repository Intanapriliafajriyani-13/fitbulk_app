import 'package:flutter/material.dart';

import '../models/task.dart';
import '../models/task_repository.dart';
import '../widgets/fade_in.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';

/// Layar Daftar Target Bulking (Layar 1):
/// Tampilan Modern dengan Nuansa Pink Glossy 3D, Putih, Cokelat, dan Moka.
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
            SnackBar(
              backgroundColor: const Color(0xFF3E2723),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFFFF80AB), size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Target FitBulk berhasil ditambahkan!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              duration: const Duration(seconds: 2),
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
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            'Hapus target bulking?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: scheme.onSurface,
            ),
          ),
          content: Text(
            'Target "${task.title}" akan dihapus dari daftar.',
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                'Batal',
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            ),
            FilledButton.tonal(
              style: FilledButton.styleFrom(
                backgroundColor: scheme.errorContainer,
                foregroundColor: scheme.onErrorContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
        SnackBar(
          backgroundColor: const Color(0xFF3E2723),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: const Text(
            'Target berhasil dihapus',
            style: TextStyle(color: Colors.white),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  Widget _buildDismissible(BulkingTask task) {
    final scheme = Theme.of(context).colorScheme;
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: scheme.errorContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 22),
        child: ExcludeSemantics(
          child: Icon(
            Icons.delete_outline,
            color: scheme.onErrorContainer,
            size: 26,
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
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8D6E63).withValues(alpha: 0.1),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                Icons.fitness_center_outlined,
                size: 64,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Belum ada target bulking',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurface,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tekan tombol + di bawah untuk menambah agenda makan atau latihan bebas laktosa.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.4,
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
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFF4081),
                    Color(0xFFD81B60),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD81B60).withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const ExcludeSemantics(
                child: Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'FitBulk — Nutrition & Workout',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(color: scheme.primary),
            )
          : FadeIn(
              child: Column(
                children: [
                  // Banner Nutrisi 3D Glossy Pink & Mocha
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFF4081), // Glossy Bright Pink
                          Color(0xFFD81B60), // Rose Pink
                          Color(0xFF8D6E63), // Moca Brown
                        ],
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD81B60).withValues(alpha: 0.3),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Glossy Sheen Effect Overlay (Pantulan Cahaya 3D Kaca)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 38,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(22),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withValues(alpha: 0.35),
                                  Colors.white.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Konten Kalori & Protein Masuk
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.local_fire_department,
                                        color: Colors.white70,
                                        size: 15,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Kalori Terpenuhi',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '$totalCalories kcal',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 1.2,
                                height: 40,
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                              Column(
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.bolt,
                                        color: Colors.white70,
                                        size: 15,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Protein Masuk',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '$totalProtein g',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Daftar Tugas dengan Breakpoint Responsif Ruang
                  Expanded(
                    child: _tasks.isEmpty
                        ? _buildEmptyState()
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              final horizontal =
                                  constraints.maxWidth < 600 ? 14.0 : 48.0;
                              return ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  horizontal: horizontal,
                                  vertical: 6,
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
        elevation: 0,
        color: Colors.white,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF4081),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${pending.length} target bulking belum selesai',
                  key: ValueKey(pending.length),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 6,
        backgroundColor: const Color(0xFFD81B60),
        foregroundColor: Colors.white,
        tooltip: 'Tambah target bulking',
        onPressed: _openAddScreen,
        icon: const Icon(Icons.add_rounded, size: 22),
        label: const Text(
          'Tambah Target',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
