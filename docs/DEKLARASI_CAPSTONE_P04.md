# DEKLARASI PROYEK CAPSTONE (P04)

**Mata Kuliah:** Pemrograman Perangkat Bergerak (PPB)  
**Nama Mahasiswa:** Intan Aprilia Fajriyani  
**Nama Aplikasi:** FitBulk — Dairy-Free Muscle & Nutrition Tracker  

---

### 1. Domain & Alasan Pemilihan
* **Domain:** Health & Wellness (Pelacak Kebugaran, Nutrisi, dan Kesehatan Khusus).
* **Alasan Pemilihan:** Mayoritas aplikasi pelacak kebugaran di pasar (seperti MyFitnessPal atau Hevy) bersifat generik dan selalu merekomendasikan diet tinggi susu sapi, keju, dan suplemen whey hewani untuk menaikkan massa otot (*bulking*). Individu dengan intoleransi laktosa atau alergi kasein susu sapi kesulitan menemukan panduan nutrisi yang aman dan terstruktur tanpa memicu gangguan pencernaan parah. FitBulk hadir untuk mengisi kekosongan tersebut.

### 2. Masalah Pengguna
Pengguna yang ingin menaikkan massa otot namun mengalami intoleransi laktosa sering menghadapi tiga masalah utama:
1. **Ketidaktahuan Kandungan Laktosa Tersembunyi:** Banyak makanan olahan berprotein tinggi mengandung turunan susu sapi tanpa disadari, memicu kembung, diare, dan jerawat.
2. **Kesulitan Mencapai Surplus Kalori:** Menghindari produk susu sering kali membuat asupan kalori dan protein harian menurun drastis, sehingga program bulking gagal.
3. **Pencatatan yang Terfragmentasi:** Pengguna harus memakai aplikasi terpisah untuk mencatat menu makanan, aplikasi lain untuk mencatat beban angkatan gym, dan galeri foto bawaan untuk progres fisik.

### 3. 3–5 Fitur Inti
1. **Dairy-Free Meal Logger & Allergen Guard:** Pencatatan makanan harian dengan sistem validasi otomatis yang menolak/memperingatkan jika resep mengandung susu sapi atau turunannya, serta menghitung target surplus kalori (karbohidrat, protein, lemak sehat).
2. **Gym Hypertrophy & Progressive Overload Tracker:** Panduan jadwal latihan angkat beban 7 hari (Push, Pull, Legs, Upper, Lower, Rest Day) dengan pencatatan beban (kg), set, dan repetisi.
3. **Visual Progress Gallery (Kamera Perangkat):** Fitur dokumentasi visual berkala untuk membandingkan foto fisik dan lingkar tubuh dari waktu ke waktu secara terintegrasi.
4. **Offline-First Dashboard & Analytics:** Dasbor visual interaktif yang menampilkan grafik tren asupan kalori dan konsistensi latihan yang tetap dapat diakses tanpa koneksi internet.

### 4. Stack Teknologi & Alasan
* **Stack:** **Flutter SDK (Dart)** untuk antarmuka multiplatform/Android, **SQLite (sqflite)** untuk penyimpanan database lokal offline di perangkat mobile, **REST API & MySQL (Laragon)** untuk sinkronisasi server, serta **Provider** untuk manajemen state.
* **Alasan:** Flutter menghasilkan aplikasi native Android yang sangat mulus dan responsif dengan arsitektur UI deklaratif; SQLite menjamin privasi data dan pencatatan latihan di gym tetap lancar tanpa ketergantungan sinyal internet (*offline-first*); sementara MySQL pada Laragon mempermudah pengembangan backend REST API yang cepat dan stabil.

### 5. Repositori Git
* **Tautan Repositori:** https://github.com/Intanapriliafajriyani-13/fitbulk_app
* **Branch Utama:** `main`
