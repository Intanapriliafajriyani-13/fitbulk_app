import 'package:flutter/material.dart';

/// Label tenggat dengan ikon dekoratif (bab 6: dipromosikan dari
/// `_DueDateLabel` privat di task_card.dart menjadi widget publik).
///
/// Ikon kalender disembunyikan dari pembaca layar (ExcludeSemantics)
/// karena teks "Tenggat ..." sudah menyampaikan maknanya.
class DueDateLabel extends StatelessWidget {
  const DueDateLabel({
    super.key,
    required this.date,
    required this.overdue,
  });

  final DateTime date;
  final bool overdue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        overdue ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant;

    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: ExcludeSemantics(
              child: Icon(Icons.event, size: 14, color: color),
            ),
          ),
          const WidgetSpan(child: SizedBox(width: 4)),
          TextSpan(text: 'Tenggat ${date.day}/${date.month}/${date.year}'),
        ],
      ),
      style: theme.textTheme.labelMedium?.copyWith(
        color: color,
        fontWeight: overdue ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
