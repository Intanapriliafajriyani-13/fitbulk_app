enum Priority {
  low('Rendah'),
  medium('Sedang'),
  high('Tinggi');

  final String label;
  const Priority(this.label);
}

class Task {
  final String id;
  final String title;
  final String? note;
  final String category;
  final Priority priority;
  final DateTime? dueDate;
  final bool done;

  const Task({
    required this.id,
    required this.title,
    this.note,
    this.category = 'Belajar',
    this.priority = Priority.medium,
    this.dueDate,
    this.done = false,
  });

  bool get isOverdue {
    if (dueDate == null || done) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    return due.isBefore(today);
  }

  Task copyWith({
    String? id,
    String? title,
    String? note,
    String? category,
    Priority? priority,
    DateTime? dueDate,
    bool? done,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      done: done ?? this.done,
    );
  }
}
