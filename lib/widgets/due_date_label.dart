import 'package:flutter/material.dart';

/// Label tenggat dengan ikon dekoratif (ExcludeSemantics) dan gaya tipografi modern.
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: overdue
            ? theme.colorScheme.errorContainer.withValues(alpha: 0.5)
            : theme.colorScheme.secondaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: ExcludeSemantics(
                child: Icon(Icons.event_outlined, size: 14, color: color),
              ),
            ),
            const WidgetSpan(child: SizedBox(width: 4)),
            TextSpan(text: 'Tenggat ${date.day}/${date.month}/${date.year}'),
          ],
        ),
        style: theme.textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: overdue ? FontWeight.bold : FontWeight.w600,
        ),
      ),
    );
  }
}
