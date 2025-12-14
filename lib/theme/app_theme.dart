import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class AppTheme {
  static ThemeData light() {
    const bg = Color(0xFFD6E8DA); // darker green background
    const primary = Color(0xFF2F8F5B);
    const secondary = Color(0xFF3AAFA9);
    const accent = Color(0xFFF2C94C);
    const text = Color(0xFF1E2D2A);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bg,

      // 🌸 Aesthetic but clean font
      textTheme: GoogleFonts.nunitoTextTheme(
        ThemeData.light().textTheme,
      ).apply(
        bodyColor: text,
        displayColor: text,
      ),

      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ).copyWith(
        primary: primary,
        secondary: secondary,
        tertiary: accent,
        surface: Colors.white,
        onSurface: text,
        onPrimary: Colors.white,
      ),

      cardTheme: const CardThemeData(
        elevation: 2.5,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: text,
        centerTitle: true,
      ),
    );
  }
}
