# FitBulk — Dairy-Free Muscle & Nutrition Tracker

**Kategori Domain:** Health & Wellness  
**Mata Kuliah:** Pemrograman Perangkat Bergerak (PPB)  
**Pengembang:** Intan Aprilia Fajriyani  
**Framework:** Flutter (Android & Web)  
**Repositori GitHub:** [https://github.com/Intanapriliafajriyani-13/fitbulk_app](https://github.com/Intanapriliafajriyani-13/fitbulk_app)  

---

## 1. Masalah & Solusi
Banyak mahasiswa dan pegiat kebugaran yang ingin menaikkan massa otot (*bulking*) menghadapi kendala intoleransi laktosa atau alergi susu sapi. Suplemen dan program makanan gym komersial umumnya didominasi susu sapi, keju, dan whey hewani yang memicu gangguan pencernaan parah. 

**FitBulk** hadir sebagai aplikasi mobile terintegrasi untuk:
- Memastikan menu surplus kalori harian **100% bebas susu sapi & laktosa**.
- Memantau program latihan angkat beban mingguan (*Push, Pull, Legs, Upper, Lower, Rest Day*).
- Menyimpan data secara *offline-first* di perangkat menggunakan **SQLite**, serta mendukung sinkronisasi ke server **REST API & MySQL (Laragon)**.
- Mendokumentasikan kenaikan berat badan dan massa otot secara visual.

---

## 2. Arsitektur Teknologi (P04 Standard)
- **Frontend / Client:** Flutter SDK (Dart) — UI deklaratif, performa native Android.
- **State Management:** Provider / Local State.
- **Database Lokal (Offline-First):** SQLite via `sqflite` (berjalan langsung di dalam memori smartphone).
- **Backend / Database Server:** REST API dengan MySQL menggunakan lingkungan server **Laragon**.

```text
lib/
├── main.dart        # Entry point & theme configuration
├── app_routes.dart  # Pusat konstanta rute navigasi
├── models/          # Entitas domain (Athlete, MealPlan, Workout, Schedule)
├── services/        # Penyedia data lokal (SQLite) & API service
├── screens/         # Layar tampilan UI
├── widgets/         # Komponen UI reusable
└── utils/           # Konstanta tema, warna, dan dimensi
```
