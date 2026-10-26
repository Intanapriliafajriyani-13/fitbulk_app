# Changelog Proyek Capstone — FitBulk

Semua pencapaian setiap Gate dicatat dalam format resmi yang ditentukan:
- **Jadi:** apa yang berfungsi
- **Macet:** kendala yang dihadapi + dugaan penyebab
- **Keputusan:** keputusan teknis + alternatif yang ditolak
- **AI:** deklarasi bantuan AI yang digunakan

---

## [P04] — Deklarasi Proyek (Inisiasi Capstone)
- **Jadi:** Inisialisasi proyek Flutter `fitbulk_app` dengan platform Android & Web. Struktur folder arsitektur P04 (`models`, `services`, `screens`, `widgets`, `utils`) berhasil disiapkan. Repositori resmi GitHub telah aktif dan terhubung. Dokumen Deklarasi Proyek 1 halaman telah rampung.
- **Macet:** Penamaan awal proyek `capstone-fitbulk` ditolak oleh Flutter CLI karena mengandung tanda hubung (`-`), diselesaikan dengan mengganti nama package menjadi `fitbulk_app`. Lingkungan server lokal dikonfigurasi menggunakan Laragon (menggantikan XAMPP) dan teruji normal melayani port 80 & 3306.
- **Keputusan:** Memilih domain *Health & Wellness* spesifik untuk program bulking bebas laktosa. Menggunakan arsitektur *hybrid persistence*: **SQLite (`sqflite`)** untuk penyimpanan lokal cepat tanpa internet di perangkat HP, serta **REST API dengan MySQL (Laragon)** untuk sinkronisasi data cloud/server.
- **AI:** Bantuan AI digunakan untuk menyusun draf proposal deklarasi sesuai rubrik P04, mengonfigurasi struktur folder standar industri, dan menyelesaikan setup repositori Git.
