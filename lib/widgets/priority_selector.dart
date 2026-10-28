import 'package:flutter/material.dart';

import '../models/task.dart';

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
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final priority in PriorityLevel.values)
          ChoiceChip(
            label: Text(priority.label),
            selected: selected == priority,
            onSelected: onSelected == null ? null : (_) => onSelected!(priority),
          ),
      ],
    );
  }
}
