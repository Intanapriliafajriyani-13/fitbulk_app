import 'package:flutter/material.dart';

import '../models/task.dart';
import '../models/task_repository.dart';
import '../widgets/priority_selector.dart';

/// Layar tambah tugas (bab 6): form dengan validasi, siklus hidup
/// controller dan focus node, state error, layout adaptif,
/// serta penggunaan RichText pada label form.
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key, required this.repository});

  final TaskRepository repository;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _titleFocus = FocusNode();
  final _noteFocus = FocusNode();

  Priority _priority = Priority.medium;
  DateTime? _dueDate;
  var _saving = false;

  @override
  void dispose() {
    // Semua resource yang dibuat di State wajib dibuang dengan urutan
    // bebas, tetapi sebelum super.dispose().
    _noteFocus.dispose();
    _titleFocus.dispose();
    _noteController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  static String? _validateTitle(String? value) {
    final title = value?.trim() ?? '';
    if (title.isEmpty) return 'Judul wajib diisi';
    if (title.length < 3) return 'Judul minimal 3 karakter';
    return null;
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now.add(const Duration(days: 1)),
      firstDate: now, // tidak bisa memilih tanggal yang sudah lewat
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null && mounted) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus(); // tutup keyboard sebelum simpan
    setState(() => _saving = true);

    final task = Task(
      id: 't-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      priority: _priority,
      dueDate: _dueDate,
    );

    await widget.repository.save(task);
    if (!mounted) return;
    Navigator.of(context).pop(true); // true: daftar perlu dimuat ulang
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Tugas baru')),
      body: Center(
        // Adaptif: di ponsel potret transparan, di layar lebar berhenti di 600 dp
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Banner Informasi Form menggunakan RichText
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer.withAlpha(50),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: scheme.primary.withAlpha(60)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.assignment_add, color: scheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            style: theme.textTheme.bodyMedium,
                            children: [
                              const TextSpan(text: 'Tambah tugas ke '),
                              TextSpan(
                                text: 'StudyTracker',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: scheme.primary,
                                ),
                              ),
                              const TextSpan(
                                text:
                                    '. Pastikan judul dan tenggat terisi dengan benar.',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Label Judul dengan RichText (Wajib *)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text.rich(
                    TextSpan(
                      text: 'Judul Tugas ',
                      style: theme.textTheme.titleSmall,
                      children: [
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: scheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextFormField(
                  controller: _titleController,
                  focusNode: _titleFocus,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _noteFocus.requestFocus(),
                  textCapitalization: TextCapitalization.sentences,
                  validator: _validateTitle,
                  // Error tampil setelah interaksi pertama, bukan sebelum
                  // pengguna sempat mengetik.
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Rancang TaskCard kanonik',
                    helperText: 'Minimal 3 karakter',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Label Catatan dengan RichText (Opsional)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text.rich(
                    TextSpan(
                      text: 'Catatan ',
                      style: theme.textTheme.titleSmall,
                      children: [
                        TextSpan(
                          text: '(opsional)',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextFormField(
                  controller: _noteController,
                  focusNode: _noteFocus,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Tuliskan catatan rincian tugas...',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.notes),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                // Label Prioritas dengan RichText
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text.rich(
                    TextSpan(
                      text: 'Tingkat Prioritas ',
                      style: theme.textTheme.titleSmall,
                      children: [
                        TextSpan(
                          text: '— pilih satu',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PrioritySelector(
                  selected: _priority,
                  onSelected: (priority) => setState(() => _priority = priority),
                ),
                const SizedBox(height: 24),

                // Picker Tanggal Tenggat
                InkWell(
                  onTap: _pickDueDate,
                  borderRadius: BorderRadius.circular(4),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Tenggat (opsional)',
                      prefixIcon: Icon(Icons.event),
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _dueDate == null
                          ? 'Pilih tanggal tenggat'
                          : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                      style: TextStyle(
                        color: _dueDate == null
                            ? scheme.onSurfaceVariant
                            : scheme.onSurface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                FilledButton.icon(
                  onPressed: _saving ? null : _submit,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(_saving ? 'Menyimpan…' : 'Simpan Tugas'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
