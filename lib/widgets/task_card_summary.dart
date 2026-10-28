import 'package:flutter/material.dart';

import '../models/task.dart';
import 'due_date_label.dart';
import 'priority_chip.dart';

/// Kolom isi kartu tugas (bab 6): judul, potongan catatan, dan baris
/// chip prioritas + tenggat. Diekstrak dari TaskCard supaya cangkang
/// kartu (Card + InkWell + baris checkbox) dan isi kartu bisa berevolusi
/// terpisah.
class TaskCardSummary extends StatelessWidget {
  const TaskCardSummary({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: task.done ? 0.45 : 1.0,
          child: Text(
            task.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: task.done ? scheme.onSurfaceVariant : scheme.onSurface,
              decoration: task.done ? TextDecoration.lineThrough : null,
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
            if (task.dueDate != null)
              DueDateLabel(date: task.dueDate!, overdue: task.isOverdue),
          ],
        ),
      ],
    );
  }
}
