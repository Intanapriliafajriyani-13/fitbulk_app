import 'package:flutter/material.dart';

import '../models/task.dart';

/// Pemilih prioritas untuk form (bab 6): deretan ChoiceChip dalam Wrap.
///
/// Custom widget kecil dengan API minimal: satu data masuk ([selected]),
/// satu event keluar ([onSelected]). Callback opsional: widget tetap
/// bisa menampilkan pilihan tanpa handler (mis. mode baca).
class PrioritySelector extends StatelessWidget {
  const PrioritySelector({
    super.key,
    required this.selected,
    this.onSelected,
  });

  final Priority selected;
  final ValueChanged<Priority>? onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final priority in Priority.values)
          ChoiceChip(
            label: Text(priority.label),
            selected: selected == priority,
            onSelected: onSelected == null ? null : (_) => onSelected!(priority),
          ),
      ],
    );
  }
}
