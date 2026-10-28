import 'package:flutter/material.dart';

import '../models/task.dart';
import '../models/task_repository.dart';
import '../utils/breakpoints.dart';
import '../widgets/due_date_label.dart';
import '../widgets/fade_in.dart';
import '../widgets/priority_chip.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';

/// Layar Daftar Target Bulking (Layar 1):
/// Mendukung arsitektur responsif terpusat (P07 & Bab 5):
/// - Ponsel Potret (< 600dp): 1 Kolom ListView + Dismissible
/// - Tablet / Landscape (600dp - 1023dp): 2 Kolom GridView dengan AspectRatio
/// - Desktop (>= 1024dp): Master-Detail Dua Panel (Left List, Right Live Detail)
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key, required this.repository});

  final TaskRepository repository;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<BulkingTask> _tasks = [];
  bool _loading = true;
  String? _selectedTaskId;

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
      if (_selectedTaskId == null && tasks.isNotEmpty) {
        _selectedTaskId = tasks.first.id;
      }
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
    if (_selectedTaskId == task.id) {
      _selectedTaskId = null;
    }
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
        margin: const EdgeInsets.only(bottom: 10),
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
        isSelected: _selectedTaskId == task.id,
        onToggle: (v) => _toggle(task, v),
        onTap: () {
          setState(() => _selectedTaskId = task.id);
          _openDetail(task);
        },
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

  Widget _buildNutritionBanner(int totalCalories, int totalProtein) {
    return Container(
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
          // Glossy Sheen Effect Overlay (Pantulan Kaca 3D)
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
    );
  }

  /// Master-Detail Dua Panel untuk Desktop / Layar Lebar (>= 1024dp)
  Widget _buildMasterDetail(double horizontalPadding) {
    final scheme = Theme.of(context).colorScheme;
    final selectedTask = _tasks.firstWhere(
      (t) => t.id == _selectedTaskId,
      orElse: () => _tasks.first,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Panel Kiri: Daftar Tugas FitBulk dengan lebar 380dp
        SizedBox(
          width: 380,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 6,
            ),
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              final task = _tasks[index];
              return TaskCard(
                task: task,
                isSelected: _selectedTaskId == task.id,
                onToggle: (v) => _toggle(task, v),
                onTap: () => setState(() => _selectedTaskId = task.id),
              );
            },
          ),
        ),
        VerticalDivider(
          width: 1,
          thickness: 1,
          color: const Color(0xFFD7CCC8).withValues(alpha: 0.4),
        ),
        // Panel Kanan: Live Detail View dari Task yang dipilih
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFFF8BBD0).withValues(alpha: 0.5),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8D6E63).withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedTask.category.label,
                        style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.open_in_new_rounded),
                        tooltip: 'Buka di Layar Penuh',
                        onPressed: () => _openDetail(selectedTask),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    selectedTask.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: selectedTask.isCompleted
                              ? scheme.onSurfaceVariant
                              : scheme.onSurface,
                          decoration: selectedTask.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      PriorityChip(priority: selectedTask.priority),
                      if (selectedTask.dueDate != null)
                        DueDateLabel(
                          date: selectedTask.dueDate!,
                          overdue: selectedTask.isOverdue,
                        ),
                    ],
                  ),
                  const Divider(height: 32),
                  // Nutrisi Khas FitBulk
                  if ((selectedTask.calories != null &&
                          selectedTask.calories! > 0) ||
                      (selectedTask.protein != null &&
                          selectedTask.protein! > 0))
                    Row(
                      children: [
                        if (selectedTask.calories != null)
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: scheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kalori',
                                    style: TextStyle(
                                      color: scheme.onSecondaryContainer,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${selectedTask.calories} kcal',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: scheme.onSecondaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(width: 12),
                        if (selectedTask.protein != null)
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: scheme.primaryContainer,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Protein Bersih',
                                    style: TextStyle(
                                      color: scheme.onPrimaryContainer,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${selectedTask.protein} g',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: scheme.onPrimaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  Text(
                    'Catatan / Resep Bebas Laktosa',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    selectedTask.note?.isNotEmpty == true
                        ? selectedTask.note!
                        : 'Tidak ada catatan komposisi tambahan.',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: scheme.error,
                            side: BorderSide(color: scheme.error),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => _delete(selectedTask),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Hapus Target'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () =>
                              _toggle(selectedTask, !selectedTask.isCompleted),
                          icon: Icon(
                            selectedTask.isCompleted
                                ? Icons.replay
                                : Icons.check_circle_outline,
                          ),
                          label: Text(
                            selectedTask.isCompleted
                                ? 'Tandai Belum'
                                : 'Tandai Selesai',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 2 Kolom Grid untuk Tablet / Phone Landscape (600dp - 1023dp)
  Widget _buildTwoColumnGrid(double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 480,
          mainAxisExtent: 265,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: _tasks.length,
        itemBuilder: (context, i) {
          final task = _tasks[i];
          return TaskCard(
            task: task,
            isSelected: _selectedTaskId == task.id,
            onToggle: (v) => _toggle(task, v),
            onTap: () => _openDetail(task),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final media = MediaQuery.of(context);

    // Dynamic padding dari P07: ikut lebar layar tapi dibatasi (clamp 14.0 - 48.0)
    final horizontalPadding = (media.size.width * 0.04).clamp(14.0, 48.0);

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
                  // Banner Nutrisi Progres Terpenuhi Hari Ini
                  _buildNutritionBanner(totalCalories, totalProtein),

                  // Layout Adaptif Berdasarkan Breakpoints (P07 & Bab 5):
                  Expanded(
                    child: _tasks.isEmpty
                        ? _buildEmptyState()
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              final width = constraints.maxWidth;

                              // 1. Desktop / Layar Lebar: Master-Detail 2 Panel
                              if (width >= Breakpoints.desktop) {
                                return _buildMasterDetail(horizontalPadding);
                              }

                              // 2. Tablet / Landscape: 2 Kolom Grid
                              if (width >= Breakpoints.tablet) {
                                return _buildTwoColumnGrid(horizontalPadding);
                              }

                              // 3. Ponsel Potret: 1 Kolom ListView + Dismissible
                              return ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding,
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
