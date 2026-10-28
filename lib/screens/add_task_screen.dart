import 'package:flutter/material.dart';

import '../models/task.dart';
import '../models/task_repository.dart';
import '../widgets/priority_selector.dart';

/// Layar Tambah Target Bulking (Layar ke-3 dari 3 screen utama).
///
/// Menerapkan:
/// - Layout adaptif: `Center + ConstrainedBox(maxWidth: 600)`
/// - Form dengan validasi, state error, text scaling tahan (RichText)
/// - Siklus hidup FocusNode dan TextEditingController yang dibersihkan di `dispose()`
/// - State dikelola dengan `setState`
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
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();

  final _titleFocus = FocusNode();
  final _caloriesFocus = FocusNode();
  final _proteinFocus = FocusNode();
  final _noteFocus = FocusNode();

  BulkingCategory _category = BulkingCategory.meal;
  PriorityLevel _priority = PriorityLevel.medium;
  DateTime? _dueDate;
  var _saving = false;

  @override
  void dispose() {
    _noteFocus.dispose();
    _proteinFocus.dispose();
    _caloriesFocus.dispose();
    _titleFocus.dispose();
    _proteinController.dispose();
    _caloriesController.dispose();
    _noteController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  static String? _validateTitle(String? value) {
    final title = value?.trim() ?? '';
    if (title.isEmpty) return 'Nama agenda / makanan wajib diisi';
    if (title.length < 3) return 'Nama minimal 3 karakter';
    return null;
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null && mounted) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    setState(() => _saving = true);

    final calories = int.tryParse(_caloriesController.text.trim());
    final protein = int.tryParse(_proteinController.text.trim());

    final task = BulkingTask(
      id: 'fb-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      category: _category,
      priority: _priority,
      calories: calories,
      protein: protein,
      dueDate: _dueDate,
    );

    await widget.repository.save(task);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Agenda Bulking'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. Header Banner Menggunakan RichText Khas FitBulk
                Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: scheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      ExcludeSemantics(
                        child: Icon(Icons.eco, color: scheme.primary, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 13.5,
                              color: scheme.onSurface,
                              height: 1.4,
                            ),
                            children: [
                              TextSpan(
                                text: 'FitBulk Allergen & Muscle Guard\n',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: scheme.primary,
                                ),
                              ),
                              const TextSpan(
                                text:
                                    'Pastikan asupan nutrisi bebas laktosa dan target surplus kalori tercatat dengan disiplin.',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Kategori Bulking Dropdown dengan RichText Label
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text.rich(
                    TextSpan(
                      text: 'Kategori Agenda ',
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
                DropdownButtonFormField<BulkingCategory>(
                  initialValue: _category,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: BulkingCategory.values.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat.label),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _category = val);
                  },
                ),
                const SizedBox(height: 16),

                // 3. Nama Agenda / Menu Makanan dengan RichText Label
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text.rich(
                    TextSpan(
                      text: 'Nama Tugas / Menu / Latihan ',
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
                  onFieldSubmitted: (_) => _caloriesFocus.requestFocus(),
                  validator: _validateTitle,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    hintText: 'Misal: Dada Ayam 200g + Nasi Merah',
                    helperText: 'Minimal 3 karakter',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Baris Kalori & Protein (Fitur Khusus FitBulk)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text.rich(
                              TextSpan(
                                text: 'Target Kalori ',
                                style: theme.textTheme.titleSmall,
                                children: [
                                  TextSpan(
                                    text: '(kcal)',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: _caloriesController,
                            focusNode: _caloriesFocus,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                _proteinFocus.requestFocus(),
                            decoration: const InputDecoration(
                              hintText: 'Misal: 550',
                              prefixIcon: Icon(Icons.local_fire_department),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text.rich(
                              TextSpan(
                                text: 'Protein ',
                                style: theme.textTheme.titleSmall,
                                children: [
                                  TextSpan(
                                    text: '(gram)',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: _proteinController,
                            focusNode: _proteinFocus,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) => _noteFocus.requestFocus(),
                            decoration: const InputDecoration(
                              hintText: 'Misal: 35',
                              prefixIcon: Icon(Icons.fitness_center),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 5. Catatan / Rincian Bebas Laktosa dengan RichText Label
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text.rich(
                    TextSpan(
                      text: 'Catatan Komposisi / Allergen Guard ',
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
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText:
                        'Tuliskan bahan pengganti non-dairy atau beban angkatan...',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.notes),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                // 6. Pemilih Prioritas
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text.rich(
                    TextSpan(
                      text: 'Tingkat Prioritas ',
                      style: theme.textTheme.titleSmall,
                      children: [
                        TextSpan(
                          text: '— tentukan urgensi target harian',
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
                  onSelected: (p) => setState(() => _priority = p),
                ),
                const SizedBox(height: 24),

                // 7. Tenggat Target Waktu
                InkWell(
                  onTap: _pickDueDate,
                  borderRadius: BorderRadius.circular(4),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Tenggat Target (opsional)',
                      prefixIcon: Icon(Icons.event),
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _dueDate == null
                          ? 'Pilih tanggal target'
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
                      : const Icon(Icons.check_circle_outline),
                  label: Text(_saving ? 'Menyimpan…' : 'Simpan ke FitBulk Tracker'),
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
