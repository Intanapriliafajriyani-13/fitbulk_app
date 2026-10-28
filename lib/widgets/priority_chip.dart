import 'package:flutter/material.dart';

import '../models/task.dart';

class PriorityChip extends StatelessWidget {
  const PriorityChip({super.key, required this.priority});

  final PriorityLevel priority;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (Color bg, Color text) = switch (priority) {
      PriorityLevel.high => (
          Colors.red.shade100,
          Colors.red.shade900,
        ),
      PriorityLevel.medium => (
          Colors.orange.shade100,
          Colors.orange.shade900,
        ),
      PriorityLevel.low => (
          theme.colorScheme.surfaceContainerHighest,
          theme.colorScheme.onSurfaceVariant,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        priority.label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: text,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
