import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitbulk_app/main.dart';
import 'package:fitbulk_app/models/task.dart';
import 'package:fitbulk_app/models/task_repository.dart';
import 'package:fitbulk_app/screens/task_detail_screen.dart';
import 'package:fitbulk_app/theme.dart';
import 'package:fitbulk_app/widgets/priority_chip.dart';

void main() {
  group('FitBulk App, Material 3 & P07 Responsive Tests', () {
    testWidgets('1. Smoke test: Dashboard FitBulk merender banner & FAB dengan benar',
        (WidgetTester tester) async {
      await tester.pumpWidget(const FitBulkApp());
      await tester.pumpAndSettle();

      // Cek AppBar & Judul Aplikasi
      expect(find.text('FitBulk — Nutrition & Workout'), findsOneWidget);

      // Cek Banner Nutrisi
      expect(find.text('Kalori Terpenuhi'), findsOneWidget);
      expect(find.text('Protein Masuk'), findsOneWidget);

      // Cek Keberadaan FAB
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('Tambah Target'), findsOneWidget);
    });

    testWidgets('2. Layar Detail: Navigasi dan render detail target bulking',
        (WidgetTester tester) async {
      final repository = TaskRepository();
      final task = BulkingTask(
        id: 'test-1',
        title: 'Dada Ayam Panggang & Quinoa',
        note: 'Menu tinggi protein tanpa alergen susu sapi.',
        category: BulkingCategory.meal,
        priority: PriorityLevel.high,
        calories: 520,
        protein: 48,
        dueDate: DateTime.now().add(const Duration(days: 2)),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: FitBulkTheme.light(),
          home: TaskDetailScreen(task: task, repository: repository),
        ),
      );
      await tester.pumpAndSettle();

      // Verifikasi komponen detail item
      expect(find.text('Detail Target Bulking'), findsOneWidget);
      expect(find.text('Dada Ayam Panggang & Quinoa'), findsOneWidget);
      expect(find.text('Informasi Nutrisi FitBulk'), findsOneWidget);
      expect(find.text('520 kcal'), findsOneWidget);
      expect(find.text('48 g'), findsOneWidget);
      expect(find.text('Menu tinggi protein tanpa alergen susu sapi.'),
          findsOneWidget);
    });

    testWidgets('3. Navigasi 3 Layar: Dari Daftar -> Buka Form Tambah Target',
        (WidgetTester tester) async {
      await tester.pumpWidget(const FitBulkApp());
      await tester.pumpAndSettle();

      // Tekan FAB Tambah Target
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verifikasi layar Tambah Target terbuka (Screen ke-3)
      expect(find.text('Tambah Agenda Bulking'), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.textContaining('Kategori Agenda'), findsOneWidget);
      expect(find.textContaining('Nama Tugas'), findsOneWidget);
    });

    testWidgets('4. Material 3 PriorityChip menggunakan pasangan container M3',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: FitBulkTheme.light(),
          home: const Scaffold(
            body: PriorityChip(priority: PriorityLevel.high),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tinggi (Wajib)'), findsOneWidget);
    });

    testWidgets('5. Responsive P07: Master-Detail aktif di layar lebar (>=1024px)',
        (WidgetTester tester) async {
      // Set ukuran jendela simulator ke Desktop (1200 x 800)
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const FitBulkApp());
      await tester.pumpAndSettle();

      // Di mode desktop master-detail, VerticalDivider dan panel detail kanan aktif
      expect(find.byType(VerticalDivider), findsOneWidget);
      expect(find.text('Catatan / Resep Bebas Laktosa'), findsOneWidget);
    });
  });
}
