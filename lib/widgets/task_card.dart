import 'package:flutter/material.dart';

import '../models/task.dart';
import 'task_card_summary.dart';

/// Kartu tugas kanonik FitBulk dengan gaya modern 3D Glossy:
/// Permukaan putih halus, bayangan 3D lembut warna moka, dan border halus pink rose.
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
  });

  final BulkingTask task;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF8BBD0).withValues(alpha: 0.5), // Pink glossy rim
          width: 1.2,
        ),
        boxShadow: [
          // 3D Soft Mocha Shadow
          BoxShadow(
            color: const Color(0xFF8D6E63).withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
          // Top Specular Highlight
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
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          splashColor: scheme.primaryContainer.withValues(alpha: 0.4),
          highlightColor: scheme.primaryContainer.withValues(alpha: 0.2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Checkbox(
                    value: task.isCompleted,
                    onChanged: onToggle,
                    activeColor: scheme.primary,
                    checkColor: Colors.white,
                    side: BorderSide(
                      color: scheme.outline,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: TaskCardSummary(task: task)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
