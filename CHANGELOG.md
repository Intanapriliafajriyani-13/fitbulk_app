# Changelog Proyek Capstone — FitBulk

Semua pencapaian setiap Gate dicatat dalam format resmi yang ditentukan:
- **Jadi:** apa yang berfungsi
- **Macet:** kendala yang dihadapi + dugaan penyebab
- **Keputusan:** keputusan teknis + alternatif yang ditolak
- **AI:** deklarasi bantuan AI yang digunakan

---

## [gate-1] — Fondasi (Minggu P07 / Capstone Gate 1)
- **Tautan Video Demo (5 Menit, Unlisted):** [Tautan Video Demo FitBulk Gate 1](https://youtu.be/fitbulk-gate1-demo) *(ganti dengan URL video YouTube unlisted Anda)*
- **Jadi:**
  1. **Satu Alur Utama Utuh (End-to-End):** Pengguna dapat membuka dashboard FitBulk, menekan tombol `Tambah Target`, mengisi agenda nutrisi/workout bebas laktosa (nama, kategori, target kalori, target protein, catatan komposisi, prioritas, dan tenggat waktu), melihat data langsung terakumulasi pada banner nutrisi harian, membuka layar detail, menandai target selesai (dengan efek strikethrough & animated opacity), serta menghapus target dengan konfirmasi dialog modal M3. Alur ini teruji lancar dijalankan berulang kali tanpa crash.
  2. **Navigasi 3 Layar Konsisten:** Terdiri dari 3 layar lengkap yang terhubung dengan `Navigator.push` dan `Navigator.pop`:
     - `TaskListScreen`: Layar utama dashboard & daftar target bulking.
     - `TaskDetailScreen`: Layar rincian informasi nutrisi, resep bebas laktosa, dan aksi status.
     - `AddTaskScreen`: Layar formulir lengkap dengan validasi form, auto-focus, siklus hidup controller, dan RichText header allergen guard.
  3. **Pemisahan Tampilan dari Data:** Seluruh data dikelola secara terpisah dalam `TaskRepository` in-memory dengan data awal bertema *dairy-free bulking*. UI widget bersifat stateless/consumer yang membaca dan mengalirkan aksi lewat callback ke state management `setState`.
  4. **Adaptif di 3 Konfigurasi Layar (Integrasi P07 Starter):**
     - *Ponsel Potret (< 600dp):* Tampilan 1 kolom ListView dengan interaksi geser hapus (`Dismissible`) dan padding horizontal dinamis (`clamp(14.0, 48.0)`).
     - *Ponsel Landscape & Tablet (600dp - 1023dp):* Tampilan 2 kolom otomatis menggunakan `GridView.builder` dengan `SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 480, mainAxisExtent: 265)` menjaga proporsi kartu tetap rapi tanpa overflow.
     - *Desktop / Jendela Lebar (>= 1024dp):* Master-Detail dua panel (panel kiri daftar tugas 380dp dengan indikator kartu aktif, panel kanan live detail view interaktif).
  5. **Ketahanan Text Scaling & Aksesibilitas:** Seluruh komponen visual menggunakan `Wrap`, `Expanded`, `maxLines` dengan `TextOverflow.ellipsis`. Skala font sistem hingga 150% tetap terbaca tanpa garis kuning-hitam overflow. Ikon dekoratif dilindungi dengan `ExcludeSemantics`, FAB dilengkapi `tooltip`, dan target sentuh memenuhi standar minimum M3 (48x48dp).
  6. **Sistem Desain Material 3 Modern:** Terpusat di `lib/theme.dart` (`FitBulkTheme`) dengan palet warna modern **Pink Glossy 3D, Crisp White, Cocoa Brown, dan Creamy Mocha**.
- **Macet:**
  1. Pada pengujian GridView tablet, kartu tugas sempat mengalami overflow vertikal kecil (8.4px) ketika label kategori dan badge nutrisi membungkus beberapa baris. Kendala ini diatasi dengan memberikan batas `mainAxisExtent: 265` serta membungkus teks kategori dengan `Flexible` dan `TextOverflow.ellipsis`.
  2. Scaffold `floatingActionButtonLocation` sempat terhitung di luar batas viewport pada saat pengujian tes responsif; diselesaikan dengan membungkus bilah navigasi bawah ke dalam komponen standar `BottomAppBar`.
- **Keputusan:**
  1. Menggunakan breakpoint terpusat `Breakpoints.tablet = 600.0` dan `Breakpoints.desktop = 1024.0` di `lib/utils/breakpoints.dart` sesuai pedoman window size class Material 3, alih-alih mengecek jenis perangkat fisik atau manipulasi font manual.
  2. Mempertahankan prinsip dependensi minimal (zero external third-party dependencies) pada Gate 1 untuk memastikan stabilitas fondasi dan kebersihan arsitektur kode.
  3. Menggunakan `withValues(alpha:)` sebagai standar resmi Flutter 3.27+ untuk menggantikan fungsi `withOpacity()` yang usang.
- **AI:**
  1. AI digunakan untuk merancang arsitektur adaptif 3 level (ponsel, landscape/tablet, desktop master-detail), memetakan harmoni warna Material 3 Pink Glossy 3D & Mocha, serta menyusun suite pengujian otomatis 5 skenario di `test/widget_test.dart`.

---

## [P04] — Deklarasi Proyek (Inisiasi Capstone)
- **Jadi:** Inisialisasi proyek Flutter `fitbulk_app` dengan platform Android & Web. Struktur folder arsitektur P04 (`models`, `services`, `screens`, `widgets`, `utils`) berhasil disiapkan. Repositori resmi GitHub telah aktif dan terhubung. Dokumen Deklarasi Proyek 1 halaman telah rampung.
- **Macet:** Penamaan awal proyek `capstone-fitbulk` ditolak oleh Flutter CLI karena mengandung tanda hubung (`-`), diselesaikan dengan mengganti nama package menjadi `fitbulk_app`. Lingkungan server lokal dikonfigurasi menggunakan Laragon (menggantikan XAMPP) dan teruji normal melayani port 80 & 3306.
- **Keputusan:** Memilih domain *Health & Wellness* spesifik untuk program bulking bebas laktosa. Menggunakan arsitektur *hybrid persistence*: **SQLite (`sqflite`)** untuk penyimpanan lokal cepat tanpa internet di perangkat HP, serta **REST API dengan MySQL (Laragon)** untuk sinkronisasi data cloud/server.
- **AI:** Bantuan AI digunakan untuk menyusun draf proposal deklarasi sesuai rubrik P04, mengonfigurasi struktur folder standar industri, dan menyelesaikan setup repositori Git.
