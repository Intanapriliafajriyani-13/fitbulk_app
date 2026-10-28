import 'package:flutter/material.dart';

import '../models/task.dart';

/// Chip prioritas tugas: memetakan prioritas ke pasangan peran warna
/// container/onContainer yang kontrasnya dijamin sistem M3, bukan warna
/// hardcode (Langkah 1.2 Bab 5).
class PriorityChip extends StatelessWidget {
  const PriorityChip({super.key, required this.priority});

  final PriorityLevel priority;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (background, foreground) = switch (priority) {
      PriorityLevel.high => (scheme.errorContainer, scheme.onErrorContainer),
      PriorityLevel.medium => (
          scheme.tertiaryContainer,
          scheme.onTertiaryContainer,
        ),
      PriorityLevel.low => (
          scheme.secondaryContainer,
          scheme.onSecondaryContainer,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        priority.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
