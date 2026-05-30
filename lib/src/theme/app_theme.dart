import 'package:flutter/material.dart';

class AppTheme {
  static const Color bg = Color(0xFF0B1220);
  static const Color surface = Color(0xFF141D2C);
  static const Color surfaceAlt = Color(0xFF1C2740);
  static const Color accent = Color(0xFF7F9CF5);
  static const Color accentSoft = Color(0xFF93C5FD);
  static const Color calm = Color(0xFF34D399);
  static const Color warning = Color(0xFFF59E0B);
  static const Color text = Color(0xFFE5E7EB);
  static const Color muted = Color(0xFF94A3B8);

  static ThemeData get darkTheme {
    const base = ColorScheme.dark(
      primary: accent,
      secondary: accentSoft,
      surface: surface,
      error: warning,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: text,
      onError: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: base,
      scaffoldBackgroundColor: bg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: text,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: accent,
        inactiveTrackColor: surfaceAlt,
        thumbColor: accentSoft,
        overlayColor: Color(0x337F9CF5),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontWeight: FontWeight.w700, color: text),
        headlineMedium: TextStyle(fontWeight: FontWeight.w700, color: text),
        titleLarge: TextStyle(fontWeight: FontWeight.w600, color: text),
        titleMedium: TextStyle(fontWeight: FontWeight.w600, color: text),
        bodyLarge: TextStyle(color: text),
        bodyMedium: TextStyle(color: muted),
        labelLarge: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
