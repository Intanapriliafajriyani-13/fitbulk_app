enum BulkingCategory {
  meal('Dairy-Free Meal / Nutrisi'),
  workout('Latihan Angkat Beban'),
  supplement('Suplemen Non-Dairy'),
  recovery('Istirahat & Recovery');

  final String label;
  const BulkingCategory(this.label);
}

enum PriorityLevel {
  low('Rendah'),
  medium('Sedang'),
  high('Tinggi (Wajib)');

  final String label;
  const PriorityLevel(this.label);
}

class BulkingTask {
  final String id;
  final String title;
  final String? note;
  final BulkingCategory category;
  final PriorityLevel priority;
  final int? calories; // Fitur khas FitBulk
  final int? protein; // Gram protein
  final DateTime? dueDate;
  final bool isCompleted;

  const BulkingTask({
    required this.id,
    required this.title,
    this.note,
    this.category = BulkingCategory.meal,
    this.priority = PriorityLevel.medium,
    this.calories,
    this.protein,
    this.dueDate,
    this.isCompleted = false,
  });

  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    return due.isBefore(today);
  }

  BulkingTask copyWith({
    String? id,
    String? title,
    String? note,
    BulkingCategory? category,
    PriorityLevel? priority,
    int? calories,
    int? protein,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return BulkingTask(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
