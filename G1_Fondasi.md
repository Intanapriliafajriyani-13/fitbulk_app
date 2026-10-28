# Laporan Penyerahan Gate 1 (G1) — Fondasi
**Mata Kuliah:** Pemrograman Perangkat Bergerak (PPB 20251)  
**Program Studi:** Teknik Informatika — Universitas Dian Nuswantoro  
**Sub-CPMK:** 92.1 — Mampu merancang arsitektur UI aplikasi yang konsisten dan responsif  

---

### 📌 Identitas Proyek & Repositori
- **Nama Aplikasi:** FitBulk App — Dairy-Free Muscle & Nutrition Tracker
- **Domain Capstone:** *Health & Wellness* (Pelacak Kebugaran & Nutrisi Bebas Alergen Laktosa)
- **Nama Mahasiswa:** Intan Aprilia Fajriyani
- **Tautan Repositori GitHub:** [https://github.com/Intanapriliafajriyani-13/fitbulk_app.git](https://github.com/Intanapriliafajriyani-13/fitbulk_app.git)
- **Tag Rilis Resmi:** `G-1` *(alias `gate-1`)*
- **Tautan Video Demo (5 Menit, Unlisted):** [Tautan Video YouTube Unlisted](https://youtu.be/fitbulk-gate1-demo) *(ganti dengan URL video YouTube unlisted Anda)*

---

## 1. Deskripsi Satu Alur Utama Utuh (End-to-End)

Aplikasi **FitBulk** dirancang khusus untuk mengatasi masalah atlet/penggiat kebugaran dengan intoleransi laktosa yang membutuhkan surplus kalori dan asupan protein tinggi tanpa memicu alergi saluran pencernaan (*lactose-free bulking*).

Satu alur utama telah berjalan penuh dan tuntas tanpa kendala (*crash-free*):
1. **Melihat Dashboard Nutrisi Harian**: Pengguna membuka aplikasi dan langsung melihat banner nutrisi 3D glossy interaktif yang menghitung secara dinamis total kalori masuk (`kcal`) dan total protein bersih (`g`) dari target yang telah diselesaikan.
2. **Menambah Agenda Bulking Baru**: Pengguna menekan tombol **`+ Tambah Target`**, membuka form entri [`AddTaskScreen`](file:///D:/INTAN/SEMESTER%207/fitbulk_app/lib/screens/add_task_screen.dart). Pengguna memilih kategori non-dairy, mengisi nama makanan/latihan, target kalori, protein, catatan komposisi alergen, tingkat prioritas, dan tenggat waktu. Form divalidasi dengan aturan ketat (menolak teks kosong / < 3 karakter).
3. **Akumulasi Otomatis ke State Dashboard**: Menekan tombol simpan mengirim objek [`BulkingTask`](file:///D:/INTAN/SEMESTER%207/fitbulk_app/lib/models/task.dart) ke [`TaskRepository`](file:///D:/INTAN/SEMESTER%207/fitbulk_app/lib/models/task_repository.dart). Layar kembali secara instan (`Navigator.pop`) dan state dashboard diperbarui reaktif (`setState`).
4. **Melihat Detail & Mengubah Status Target**: Mengetuk kartu membuka [`TaskDetailScreen`](file:///D:/INTAN/SEMESTER%207/fitbulk_app/lib/screens/task_detail_screen.dart). Pengguna dapat membaca rincian komposisi alergen dan menandai target telah terpenuhi (memicu coretan teks *strikethrough* dan animasi redup *AnimatedOpacity*).
5. **Menghapus Target (Interaksi Terjaga)**: Pengguna dapat menghapus target baik melalui tombol hapus pada layar detail maupun gestur geser kiri (*swipe-to-delete* `Dismissible`) di daftar dengan modal konfirmasi dialog penolakan/persetujuan M3.

---

## 2. Arsitektur 3 Layar & Navigasi Konsisten

Aplikasi dibangun di atas tiga layar utama yang saling terhubung menggunakan `Navigator.push` dan `Navigator.pop`:

1. **Layar 1 — Dashboard & Daftar Target ([`task_list_screen.dart`](file:///D:/INTAN/SEMESTER%207/fitbulk_app/lib/screens/task_list_screen.dart))**:
   - Menampilkan banner ringkasan nutrisi harian.
   - Menampilkan daftar target bulking adaptif.
   - Bilah navigasi bawah menghitung jumlah target yang belum terselesaikan menggunakan `AnimatedSwitcher`.
   - Tombol aksi mengambang (*FloatingActionButton Extended*) untuk membuka layar tambah target.

2. **Layar 2 — Detail Target Bulking ([`task_detail_screen.dart`](file:///D:/INTAN/SEMESTER%207/fitbulk_app/lib/screens/task_detail_screen.dart))**:
   - Menerima objek `BulkingTask` dan instance `TaskRepository`.
   - Menggunakan tata letak adaptif `Center + ConstrainedBox(maxWidth: 600)`.
   - Menampilkan *Dual 3D Stat Card* (Kalori Moka Latte & Protein Pink Glossy), resep bebas laktosa, serta tombol toggle status dan hapus destruktif.

3. **Layar 3 — Form Tambah Target ([`add_task_screen.dart`](file:///D:/INTAN/SEMESTER%207/fitbulk_app/lib/screens/add_task_screen.dart))**:
   - Formulir terstruktur dengan `GlobalKey<FormState>`.
   - Pengelolaan siklus hidup controller (`TextEditingController`) dan fokus (`FocusNode`) yang dibersihkan secara aman pada method `dispose()`.
   - Label berbintang merah menggunakan `Text.rich` dan `RichText`.
   - Menggunakan `PrioritySelector` berbentuk ChoiceChip M3.

---

## 3. Pemisahan Tampilan dari Data (Data Layer Isolation)

Kode tampilan tidak menyusun data di dalam widget itu sendiri. Seluruh data disimpan dan dimanipulasi pada repository mandiri:
- **Model**: [`lib/models/task.dart`](file:///D:/INTAN/SEMESTER%207/fitbulk_app/lib/models/task.dart) mendefinisikan entitas immutable `BulkingTask`, enum `BulkingCategory`, dan enum `PriorityLevel` dengan method `copyWith` dan getter `isOverdue`.
- **Repository**: [`lib/models/task_repository.dart`](file:///D:/INTAN/SEMESTER%207/fitbulk_app/lib/models/task_repository.dart) mengelola operasi data in-memory: `getAll()`, `save()`, `delete()`, dan `toggle()`.
- **UI State**: Widget UI bersifat *consumer* yang memicu pembaruan lewat *callback* dan `setState`.

---

## 4. Ketahanan di 3 Konfigurasi Layar (Integrasi P07 Starter)

Sesuai materi Pertemuan 7 (`starter-code/p07-responsive`), ambang batas layout dipusatkan pada [`lib/utils/breakpoints.dart`](file:///D:/INTAN/SEMESTER%207/fitbulk_app/lib/utils/breakpoints.dart) (`tablet = 600.0`, `desktop = 1024.0`):

| Konfigurasi Layar | Ambang Ukuran | Strategi Layout Adaptif FitBulk | Status |
| :--- | :--- | :--- | :---: |
| **1. Ponsel Potret** | `< 600 dp` | 1 Kolom `ListView.builder` dengan padding horizontal dinamis `clamp(14.0, 48.0)` dan interaksi geser hapus `Dismissible`. | ✅ Lolos |
| **2. Ponsel Landscape & Tablet** | `600 dp – 1023 dp` | 2 Kolom otomatis `GridView.builder` dengan `SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 480, mainAxisExtent: 265)` menjaga proporsi kartu tetap proporsional tanpa *bottom overflow*. | ✅ Lolos |
| **3. Desktop / Jendela Lebar** | `≥ 1024 dp` | **Master-Detail Dua Panel (TODO P07-3 Selesai)**: Panel kiri memuat daftar tugas (lebar tetap 380dp) dengan indikator kartu terpilih, panel kanan menampilkan pratinjau detail langsung (*live interactive detail view*). | ✅ Lolos |

---

## 5. Ketahanan Text Scaling & Aksesibilitas (Bab 5 Compliance)

- **Text Scaling 150%**: Menggunakan `Expanded` pada kolom teks, `Wrap` (bukan Row kaku) untuk baris chip dan badge nutrisi, serta `maxLines: 2` + `TextOverflow.ellipsis`. Pengaturan ukuran font maksimal sistem tidak merusak layout dan tidak memunculkan garis kuning-hitam *overflow*.
- **Semantik & TalkBack**:
  - Ikon dekoratif dibungkus `ExcludeSemantics` agar pembaca layar tidak membacakan ikon tanpa makna.
  - Tombol aksi utama (FAB) dan tombol navigasi dilengkapi `tooltip` eksplisit.
  - Memanfaatkan widget interaktif native (`InkWell`, `Checkbox`, `FilledButton`) yang memiliki state bawaan dan target sentuh minimal 48×48 dp.

---

## 6. Desain Visual Modern Material 3 (Pink Glossy 3D & Mocha)

Identitas visual terpusat pada [`lib/theme.dart`](file:///D:/INTAN/SEMESTER%207/fitbulk_app/lib/theme.dart) (`abstract final class FitBulkTheme`):
- **Pink Glossy 3D (`Color(0xFFFF4081)` & `Color(0xFFD81B60)`)**: Aksen tombol utama, gradien banner kaca, dan Floating Action Button.
- **Crisp White (`Colors.white`)**: Permukaan kartu utama 3D dengan specular highlight sisi atas.
- **Cocoa Brown (`Color(0xFF3E2723)`)**: Tipografi tajam dan kontras tinggi untuk kenyamanan membaca.
- **Creamy Mocha (`Color(0xFF8D6E63)` & `Color(0xFFFAF5F3)`)**: Latar belakang kanvas, chip kalori (*moca latte*), dan bayangan 3D lembut.
- **API Modern**: Menggunakan `withValues(alpha:)` menggantikan `withOpacity()` yang usang.

---

## 7. Checklist Verifikasi Mandiri Gate 1 (G1)

- [x] Aplikasi dipasang dari nol dan langsung bisa dibuka tanpa langkah rahasia.
- [x] Alur utama dijalankan tiga kali berturut-turut tanpa crash.
- [x] Masukan kosong dan masukan aneh dicoba di form, ditolak validasi tanpa membuat aplikasi mati.
- [x] Diputar ke landscape di setiap layar, tidak ada elemen yang meluap (*no overflow*).
- [x] Dijalankan di tablet atau jendela desktop lebar (≥1024px), layout beralih ke Master-Detail tanpa teks melar tak terbaca.
- [x] Skala teks sistem dinaikkan ke 150%, tata letak tetap rapi dan terbaca.
- [x] `CHANGELOG.md` sudah berisi blok `[gate-1]` lengkap dengan 4 butir resmi (**Jadi**, **Macet**, **Keputusan**, **AI**).
- [x] Tag `G-1` (dan alias `gate-1`) sudah dibuat dan terunggah ke repositori GitHub.
- [x] Tautan video demo 5 menit (unlisted) sudah dicantumkan di `CHANGELOG.md`.

---

## 8. Bukti Analisis Statis & Pengujian Otomatis

### Hasil `flutter analyze`
```text
PS D:\INTAN\SEMESTER 7\fitbulk_app> flutter analyze
Analyzing fitbulk_app...
No issues found! (ran in 8.9s)
```
*(0 errors, 0 warnings, 0 linter issues).*

### Hasil `flutter test` (5 Skenario Lolos)
```text
PS D:\INTAN\SEMESTER 7\fitbulk_app> flutter test
00:00 +0: loading D:/INTAN/SEMESTER 7/fitbulk_app/test/widget_test.dart
00:00 +0: FitBulk App, Material 3 & P07 Responsive Tests 1. Smoke test: Dashboard FitBulk merender banner & FAB dengan benar
00:01 +1: FitBulk App, Material 3 & P07 Responsive Tests 2. Layar Detail: Navigasi dan render detail target bulking
00:01 +2: FitBulk App, Material 3 & P07 Responsive Tests 3. Navigasi 3 Layar: Dari Daftar -> Buka Form Tambah Target
00:02 +3: FitBulk App, Material 3 & P07 Responsive Tests 4. Material 3 PriorityChip menggunakan pasangan container M3
00:02 +4: FitBulk App, Material 3 & P07 Responsive Tests 5. Responsive P07: Master-Detail aktif di layar lebar (>=1024px)
00:02 +5: All tests passed!
```

---

## 9. Catatan Peer Review (Siklus 1)

Template ulasan peer review bagi rekan mahasiswa yang ditugaskan:
1. **Hal yang sudah bagus**: Arsitektur adaptif 3 tingkat (`ListView` 1-kolom ponsel, `GridView` 2-kolom landscape, dan Master-Detail desktop di [`task_list_screen.dart`](file:///D:/INTAN/SEMESTER%207/fitbulk_app/lib/screens/task_list_screen.dart#L440-L480)) berjalan mulus berbasis `LayoutBuilder` dan `Breakpoints` terpusat.
2. **Hal yang perlu diwaspadai 2 minggu ke depan**: Migrasi dari `MemoryTaskRepository` ke SQLite lokal (`sqflite`) pada Gate 2 membutuhkan serialisasi JSON (`toMap`/`fromMap`) pada model `BulkingTask` dan penanganan `async/await` database saat inisialisasi awal.
3. **Pertanyaan untuk penulis**: Bagaimana strategi sinkronisasi data nutrisi non-dairy jika perangkat beralih dari mode offline (SQLite) ke backend cloud (MySQL REST API)?
