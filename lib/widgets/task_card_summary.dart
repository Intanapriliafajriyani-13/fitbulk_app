import 'package:flutter/material.dart';

import '../models/task.dart';
import 'due_date_label.dart';
import 'priority_chip.dart';

/// Kolom isi kartu tugas FitBulk modern:
/// Desain pink glossy 3D, putih, cokelat, dan moka.
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
        // Category Pill dengan nuansa Pink Glossy & Mocha
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    scheme.primaryContainer,
                    scheme.secondaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: scheme.primary.withValues(alpha: 0.2),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      _getCategoryIcon(task.category),
                      size: 13,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    task.category.label,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: scheme.onPrimaryContainer,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Judul Tugas dengan Warna Chocolate Brown
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: task.isCompleted ? 0.45 : 1.0,
          child: Text(
            task.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color:
                  task.isCompleted ? scheme.onSurfaceVariant : scheme.onSurface,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              decorationColor: scheme.onSurfaceVariant,
              height: 1.25,
            ),
          ),
        ),

        // Potongan Catatan dalam Nuansa Moca
        if (task.note != null && task.note!.isNotEmpty) ...[
          const SizedBox(height: 3),
          Text(
            task.note!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        const SizedBox(height: 8),

        // Badges Nutrisi 3D Glossy (Kalori Mocha & Protein Pink) + PriorityChip & DueDate
        Wrap(
          spacing: 8,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            PriorityChip(priority: task.priority),
            if (task.calories != null && task.calories! > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: scheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.onSecondaryContainer.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 1.5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ExcludeSemantics(
                      child: Icon(
                        Icons.local_fire_department,
                        size: 13,
                        color: scheme.tertiary,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${task.calories} kcal',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            if (task.protein != null && task.protein! > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFCE4EC),
                      Color(0xFFF8BBD0),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white,
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.12),
                      blurRadius: 4,
                      offset: const Offset(0, 1.5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ExcludeSemantics(
                      child: Icon(
                        Icons.fitness_center,
                        size: 13,
                        color: scheme.primary,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${task.protein}g protein',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                  ],
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
