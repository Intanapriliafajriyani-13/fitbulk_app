import 'task.dart';

class TaskRepository {
  final List<Task> _tasks = [
    Task(
      id: 't-1',
      title: 'Baca modul bab 6 Advanced UI',
      note: 'Fokus pada komposisi widget, siklus hidup controller, dan animasi.',
      category: 'Belajar',
      priority: Priority.high,
      dueDate: DateTime.now().add(const Duration(days: 1)),
      done: false,
    ),
    Task(
      id: 't-2',
      title: 'Rancang TaskCard kanonik',
      note: 'Pecah menjadi DueDateLabel dan TaskCardSummary.',
      category: 'Proyek',
      priority: Priority.medium,
      dueDate: DateTime.now().add(const Duration(days: 3)),
      done: true,
    ),
    Task(
      id: 't-3',
      title: 'Latihan Form Add Task dengan RichText',
      note: 'Tambahkan validasi title min 3 karakter dan FocusNode.',
      category: 'Praktikum',
      priority: Priority.low,
      dueDate: DateTime.now().subtract(const Duration(days: 1)), // Overdue demo
      done: false,
    ),
  ];

  Future<List<Task>> getAll() async {
    // Simulasi delay pembacaan asinkron
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_tasks);
  }

  Future<void> save(Task task) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    } else {
      _tasks.insert(0, task);
    }
  }

  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _tasks.removeWhere((t) => t.id == id);
  }

  Future<void> toggle(String id, bool done) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(done: done);
    }
  }
}
