# FitBulk — Dairy-Free Muscle & Nutrition Tracker

**Kategori Domain:** Health & Wellness  
**Mata Kuliah:** Pemrograman Perangkat Bergerak (PPB)  
**Pengembang:** Intan  
**Framework:** Flutter (Android & Web)  

---

## 1. Masalah & Solusi
Banyak mahasiswa dan pegiat kebugaran yang ingin menaikkan massa otot (*bulking*) menghadapi kendala intoleransi laktosa atau alergi susu sapi. Suplemen dan program makanan gym komersial umumnya didominasi susu sapi, keju, dan whey hewani yang memicu gangguan pencernaan parah. 

**FitBulk** hadir sebagai aplikasi mobile terintegrasi untuk:
- Memastikan menu surplus kalori harian **100% bebas susu sapi & laktosa**.
- Memantau program latihan angkat beban mingguan (*Push, Pull, Legs, Upper, Lower, Rest Day*).
- Mendokumentasikan kenaikan berat badan dan massa otot secara visual.

---

## 2. Struktur Arsitektur (P04 Standard)
```text
lib/
├── main.dart        # Entry point & theme configuration
├── app_routes.dart  # Pusat konstanta rute navigasi
├── models/          # Entitas domain (Athlete, MealPlan, Workout, Schedule)
├── services/        # Penyedia data lokal / API
├── screens/         # Layar tampilan UI
├── widgets/         # Komponen UI reusable
└── utils/           # Konstanta tema, warna, dan dimensi
```
