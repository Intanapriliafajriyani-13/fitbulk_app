import 'package:flutter/material.dart';

import '../models/task.dart';
import 'due_date_label.dart';
import 'priority_chip.dart';

/// Kolom isi kartu tugas FitBulk: judul, potongan catatan, badge nutrisi kalori/protein,
/// serta baris chip prioritas & tenggat.
class TaskCardSummary extends StatelessWidget {
  const TaskCardSummary({super.key, required this.task});

  final BulkingTask task;

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(_getCategoryIcon(task.category), size: 16, color: scheme.primary),
            const SizedBox(width: 6),
            Text(
              task.category.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: scheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: task.isCompleted ? 0.45 : 1.0,
          child: Text(
            task.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: task.isCompleted ? scheme.onSurfaceVariant : scheme.onSurface,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              decorationColor: scheme.onSurfaceVariant,
            ),
          ),
        ),
        if (task.note != null && task.note!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            task.note!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            PriorityChip(priority: task.priority),
            if (task.calories != null && task.calories! > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${task.calories} kcal',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
              ),
            if (task.protein != null && task.protein! > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${task.protein}g protein',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
              ),
            if (task.dueDate != null)
              DueDateLabel(date: task.dueDate!, overdue: task.isOverdue),
          ],
        ),
      ],
    );
  }
}
