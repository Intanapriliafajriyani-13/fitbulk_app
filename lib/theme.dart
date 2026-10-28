import 'package:flutter/material.dart';

/// Tema FitBulk (kanonik bab 5): satu sumber kebenaran untuk warna
/// dan elevasi seluruh aplikasi. Seluruh widget membaca peran warna
/// dari sini, bukan warna hardcode.
abstract final class FitBulkTheme {
  /// Warna benih merek FitBulk (hijau botol/nutrisi sehat);
  /// seluruh tonal palette diturunkan dari warna ini oleh ColorScheme.fromSeed.
  static const seedColor = Color(0xFF2E7D32);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      cardTheme: const CardThemeData(elevation: 1),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
    );
  }
}
