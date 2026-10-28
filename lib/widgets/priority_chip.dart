import 'package:flutter/material.dart';

import '../models/task.dart';

/// Chip prioritas tugas: memetakan prioritas ke pasangan peran warna
/// container/onContainer Material 3 dengan gaya modern 3D Glossy capsule.
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.65),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: foreground.withValues(alpha: 0.12),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        priority.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
      ),
    );
  }
}
