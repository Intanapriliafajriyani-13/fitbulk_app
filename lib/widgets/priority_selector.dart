import 'package:flutter/material.dart';

import '../models/task.dart';

/// Pemilih tingkat prioritas tugas dengan gaya modern Pink & Moka.
class PrioritySelector extends StatelessWidget {
  const PrioritySelector({
    super.key,
    required this.selected,
    this.onSelected,
  });

  final PriorityLevel selected;
  final ValueChanged<PriorityLevel>? onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [
        for (final priority in PriorityLevel.values)
          ChoiceChip(
            label: Text(
              priority.label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
                color: selected == priority
                    ? Colors.white
                    : scheme.onSurfaceVariant,
              ),
            ),
            selected: selected == priority,
            selectedColor: const Color(0xFFD81B60),
            backgroundColor: Colors.white,
            side: BorderSide(
              color: selected == priority
                  ? const Color(0xFFFF80AB)
                  : const Color(0xFFD7CCC8),
              width: 1.2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: selected == priority ? 3 : 0,
            shadowColor: const Color(0xFFD81B60).withValues(alpha: 0.3),
            onSelected:
                onSelected == null ? null : (_) => onSelected!(priority),
          ),
      ],
    );
  }
}
