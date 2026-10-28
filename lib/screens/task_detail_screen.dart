import 'package:flutter/material.dart';

import '../models/task.dart';
import '../models/task_repository.dart';
import '../widgets/due_date_label.dart';
import '../widgets/priority_chip.dart';

/// Layar Detail Target Bulking (Layar 2):
/// Tampilan Modern dengan Nuansa Pink Glossy 3D, Putih, Cokelat, dan Moka.
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
            'Target "${_task.title}" akan dihapus dari daftar.',
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

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF8BBD0).withValues(alpha: 0.5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8D6E63).withValues(alpha: 0.07),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.9),
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            color: scheme.onSurface,
            onPressed: () => Navigator.of(context).pop(_changed),
          ),
          title: Text(
            'Detail Target Bulking',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              tooltip: 'Hapus Target',
              color: scheme.error,
              onPressed: _deleteTask,
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // 1. Header Card: Kategori & Judul dengan Aksen Pink 3D
                _buildCard(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFF4081),
                                    Color(0xFFD81B60),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFD81B60)
                                        .withValues(alpha: 0.35),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ExcludeSemantics(
                                child: Icon(
                                  _getCategoryIcon(_task.category),
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _task.category.label,
                                    style:
                                        theme.textTheme.labelMedium?.copyWith(
                                      color: scheme.primary,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
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
                        const SizedBox(height: 16),
                        Divider(
                          height: 1,
                          color: const Color(0xFFD7CCC8).withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _task.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: _task.isCompleted
                                ? scheme.onSurfaceVariant
                                : scheme.onSurface,
                            decoration: _task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: scheme.onSurfaceVariant,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // 2. Toggle Status Penyelesaian
                _buildCard(
                  child: CheckboxListTile(
                    value: _task.isCompleted,
                    onChanged: _toggleStatus,
                    activeColor: scheme.primary,
                    checkColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    title: Text(
                      _task.isCompleted
                          ? 'Target Selesai Tercapai'
                          : 'Target Belum Selesai',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      _task.isCompleted
                          ? 'Ketuk untuk menandai belum selesai'
                          : 'Centang jika sudah mengonsumsi atau menyelesaikan target ini',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _task.isCompleted
                            ? const Color(0xFFFCE4EC)
                            : const Color(0xFFEFEBE9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _task.isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: _task.isCompleted
                            ? scheme.primary
                            : scheme.outline,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // 3. Card Nutrisi 3D Glossy (Kalori Mocha Latte & Protein Pink Gloss)
                if ((_task.calories != null && _task.calories! > 0) ||
                    (_task.protein != null && _task.protein! > 0))
                  _buildCard(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.pie_chart_outline_rounded,
                                  size: 18, color: scheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Informasi Nutrisi FitBulk',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: scheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              if (_task.calories != null && _task.calories! > 0)
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: scheme.secondaryContainer,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF8D6E63)
                                              .withValues(alpha: 0.08),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.local_fire_department,
                                              size: 16,
                                              color: scheme.tertiary,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Kalori',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    scheme.onSecondaryContainer,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${_task.calories} kcal',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            color: scheme.onSecondaryContainer,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if ((_task.calories != null &&
                                      _task.calories! > 0) &&
                                  (_task.protein != null && _task.protein! > 0))
                                const SizedBox(width: 12),
                              if (_task.protein != null && _task.protein! > 0)
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFFFFF0F5),
                                          Color(0xFFFCE4EC),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: scheme.primary
                                              .withValues(alpha: 0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.fitness_center,
                                              size: 16,
                                              color: scheme.primary,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Protein Bersih',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    scheme.onPrimaryContainer,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${_task.protein} g',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
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
                const SizedBox(height: 14),

                // 4. Catatan Bebas Laktosa
                _buildCard(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.notes_rounded,
                                size: 18, color: scheme.secondary),
                            const SizedBox(width: 8),
                            Text(
                              'Catatan & Resep Bebas Laktosa',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: scheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _task.note?.isNotEmpty == true
                              ? _task.note!
                              : 'Tidak ada catatan komposisi tambahan.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 5. Tombol Hapus dengan Outline Halus
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: scheme.error,
                    side: BorderSide(
                      color: scheme.error.withValues(alpha: 0.5),
                      width: 1.2,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: const Text(
                    'Hapus Target Bulking Ini',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: _deleteTask,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
