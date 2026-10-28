import 'package:flutter/material.dart';

/// Tema FitBulk Modern (Material 3):
/// Palet warna: Pink Glossy 3D, Crisp White, Warm Chocolate Brown, dan Creamy Mocha.
abstract final class FitBulkTheme {
  // Aksen Benih & Identitas Visual
  static const seedColor = Color(0xFFE91E63); // Pink Glossy Primer
  static const pinkGloss = Color(0xFFFF4081); // Bright Pink 3D Gloss
  static const pinkLight = Color(0xFFFCE4EC); // Soft Pearl Pink
  static const brownDark = Color(0xFF3E2723); // Dark Cocoa / Brown
  static const brownWarm = Color(0xFF5D4037); // Warm Chocolate
  static const moca = Color(0xFF8D6E63); // Rich Mocha
  static const mocaLight = Color(0xFFD7CCC8); // Moca Latte
  static const mocaCream = Color(0xFFFAF5F3); // Warm Creamy Mocha Canvas

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
      primary: const Color(0xFFD81B60), // Glossy Vibrant Pink
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFFCE4EC), // Pearl Pink
      onPrimaryContainer: const Color(0xFF880E4F), // Deep Rose Brown
      secondary: const Color(0xFF8D6E63), // Moca
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFEFEBE9), // Creamy Moca
      onSecondaryContainer: const Color(0xFF4E342E), // Deep Espresso Brown
      tertiary: const Color(0xFF6D4C41), // Rich Chocolate Brown
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFFD7CCC8), // Moca Latte Container
      onTertiaryContainer: const Color(0xFF3E2723), // Cocoa Text
      surface: Colors.white,
      onSurface: const Color(0xFF3E2723), // Deep Brown Reading Text
      onSurfaceVariant: const Color(0xFF6D4C41), // Moca Secondary Text
      outline: const Color(0xFFD7CCC8), // Moca Latte Border
      error: const Color(0xFFC2185B), // Deep Ruby Rose
      errorContainer: const Color(0xFFF8BBD0), // Soft Pink Gloss
      onErrorContainer: const Color(0xFF880E4F),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: mocaCream,
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(
            color: Color(0x33F8BBD0), // Pink Glossy Subtle Outline
            width: 1.2,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF3E2723),
        centerTitle: false,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD7CCC8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE7DCD6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE91E63), width: 1.8),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 6,
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
