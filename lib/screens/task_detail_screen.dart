import 'package:flutter/material.dart';

import '../models/task.dart';
import '../models/task_repository.dart';
import '../widgets/due_date_label.dart';
import '../widgets/priority_chip.dart';

/// Layar Detail Target Bulking (Layar ke-2 dari 3 screen utama).
///
/// Menggunakan layout adaptif berbasis ruang:
/// `Center + ConstrainedBox(maxWidth: 600)` sehingga di ponsel potret
/// mengisi layar penuh, sedangkan di tablet/layar lebar berhenti di 600dp.
/// State lokal dikelola dengan `setState`.
class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.repository,
  });

  final BulkingTask task;
  final TaskRepository repository;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late BulkingTask _task;
  bool _changed = false;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  Future<void> _toggleStatus(bool? value) async {
    final newValue = value ?? false;
    await widget.repository.toggle(_task.id, newValue);
    if (!mounted) return;
    setState(() {
      _task = _task.copyWith(isCompleted: newValue);
      _changed = true;
    });
  }

  Future<void> _deleteTask() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final scheme = Theme.of(dialogContext).colorScheme;
        return AlertDialog(
          title: const Text('Hapus target bulking?'),
          content: Text('Target "${_task.title}" akan dihapus dari daftar.'),
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

    if (confirmed == true && mounted) {
      await widget.repository.delete(_task.id);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    }
  }

  IconData _getCategoryIcon(BulkingCategory cat) {
    switch (cat) {
      case BulkingCategory.meal:
        return Icons.restaurant;
      case BulkingCategory.workout:
        return Icons.fitness_center;
      case BulkingCategory.supplement:
        return Icons.local_drink;
      case BulkingCategory.recovery:
        return Icons.bedtime;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        // Did pop automatically
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(_changed),
          ),
          title: const Text('Detail Target Bulking'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Hapus Target',
              onPressed: _deleteTask,
            ),
          ],
        ),
        body: Center(
          // Breakpoint berbasis ruang: di ponsel potret Center + maxWidth 600
          // tidak berpengaruh (konten mengisi layar), di tablet/landscape
          // konten berhenti di 600 dp dan tetap rapi di tengah.
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header Card: Kategori & Status
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ExcludeSemantics(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: scheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  _getCategoryIcon(_task.category),
                                  color: scheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _task.category.label,
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      color: scheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      PriorityChip(priority: _task.priority),
                                      if (_task.dueDate != null)
                                        DueDateLabel(
                                          date: _task.dueDate!,
                                          overdue: _task.isOverdue,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Text(
                          _task.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: _task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: _task.isCompleted
                                ? scheme.onSurfaceVariant
                                : scheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Card Toggle Status Penyelesaian
                Card(
                  child: CheckboxListTile(
                    value: _task.isCompleted,
                    onChanged: _toggleStatus,
                    title: Text(
                      _task.isCompleted
                          ? 'Target Selesai Tercapai'
                          : 'Target Belum Selesai',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      _task.isCompleted
                          ? 'Ketuk untuk menandai belum selesai'
                          : 'Centang jika sudah mengonsumsi/menyelesaikan sesi ini',
                    ),
                    secondary: Icon(
                      _task.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: _task.isCompleted ? scheme.primary : scheme.outline,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Card Nutrisi Khas FitBulk
                if ((_task.calories != null && _task.calories! > 0) ||
                    (_task.protein != null && _task.protein! > 0))
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informasi Nutrisi FitBulk',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              if (_task.calories != null && _task.calories! > 0)
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: scheme.secondaryContainer,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Kalori',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: scheme.onSecondaryContainer,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${_task.calories} kcal',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: scheme.onSecondaryContainer,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if ((_task.calories != null && _task.calories! > 0) &&
                                  (_task.protein != null && _task.protein! > 0))
                                const SizedBox(width: 12),
                              if (_task.protein != null && _task.protein! > 0)
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: scheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Protein Bersih',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: scheme.onPrimaryContainer,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${_task.protein} g',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: scheme.onPrimaryContainer,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 12),

                // Card Catatan & Komposisi Bebas Laktosa
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Catatan & Resep Bebas Laktosa',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _task.note?.isNotEmpty == true
                              ? _task.note!
                              : 'Tidak ada catatan komposisi tambahan.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol Hapus Destruktif
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: scheme.error,
                    side: BorderSide(color: scheme.error),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Hapus Target Bulking Ini'),
                  onPressed: _deleteTask,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
