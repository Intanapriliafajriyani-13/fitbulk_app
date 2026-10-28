import 'task.dart';

class TaskRepository {
  final List<BulkingTask> _tasks = [
    BulkingTask(
      id: 'fb-1',
      title: 'Sarapan Tinggi Kalori Bebas Laktosa',
      note: 'Oatmeal 100g + Susu Kedelai/Almond + 2 Pisang + Selai Kacang.',
      category: BulkingCategory.meal,
      priority: PriorityLevel.high,
      calories: 680,
      protein: 28,
      dueDate: DateTime.now().add(const Duration(days: 1)),
      isCompleted: false,
    ),
    BulkingTask(
      id: 'fb-2',
      title: 'Latihan Push Day: Bench Press & Shoulder Press',
      note: 'Fokus progressive overload: Bench Press 4 set x 8-10 reps (60kg).',
      category: BulkingCategory.workout,
      priority: PriorityLevel.high,
      dueDate: DateTime.now().add(const Duration(days: 1)),
      isCompleted: true,
    ),
    BulkingTask(
      id: 'fb-3',
      title: 'Konsumsi Pea Protein Isolate (Plant-Based)',
      note: 'Shake 1 scoop pea protein setelah gym untuk pemulihan otot tanpa kembung.',
      category: BulkingCategory.supplement,
      priority: PriorityLevel.medium,
      calories: 140,
      protein: 25,
      dueDate: DateTime.now(),
      isCompleted: false,
    ),
    BulkingTask(
      id: 'fb-4',
      title: 'Cek Label Makanan Bebas Whey/Kasein',
      note: 'Pastikan camilan bebas turunan susu sapi tersembunyi (allergen guard).',
      category: BulkingCategory.meal,
      priority: PriorityLevel.low,
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      isCompleted: false,
    ),
  ];

  Future<List<BulkingTask>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_tasks);
  }

  Future<void> save(BulkingTask task) async {
    await Future.delayed(const Duration(milliseconds: 120));
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    } else {
      _tasks.insert(0, task);
    }
  }

  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 80));
    _tasks.removeWhere((t) => t.id == id);
  }

  Future<void> toggle(String id, bool isCompleted) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(isCompleted: isCompleted);
    }
  }
}
