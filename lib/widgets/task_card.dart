import 'package:flutter/material.dart';

import '../models/task.dart';
import 'task_card_summary.dart';

/// Kartu tugas kanonik (bab 5, delta bab 6).
///
/// Kontrak yang dipertahankan lintas bab:
/// - menampilkan satu [Task]: judul, prioritas, tenggat, status selesai;
/// - [onToggle] dipanggil checkbox berubah, [onTap] saat kartu ditekan;
/// - stateless: tidak memegang state dan tidak tahu cara memperoleh data.
///
/// Delta bab 6: isi kartu diekstrak ke [TaskCardSummary] dan label
/// tenggat dipromosikan menjadi widget publik DueDateLabel: cangkang
/// kartu kini murni komposisi, bukan tumpukan kode.
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
  });

  final Task task;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: task.done,
                onChanged: onToggle,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(child: TaskCardSummary(task: task)),
            ],
          ),
        ),
      ),
    );
  }
}
