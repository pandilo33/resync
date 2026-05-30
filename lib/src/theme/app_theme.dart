import 'package:flutter/material.dart';

class AppTheme {
  static const Color bg = Color(0xFF111816);         // Deep forest sage-dark (very low-stimulation)
  static const Color surface = Color(0xFF1A2220);    // Soothing sage surface
  static const Color surfaceAlt = Color(0xFF25312D); // Medium sage-slate
  static const Color accent = Color(0xFF8AA399);     // Calming pale green/sage
  static const Color accentSoft = Color(0xFFAEC2B6); // Soothing pale willow green
  static const Color calm = Color(0xFF8FA7BF);       // Cool mist blue / soft ocean blue
  static const Color warning = Color(0xFFD5C3A6);    // Warm neutral taupe / cream
  static const Color text = Color(0xFFEDE9E2);       // Soft cozy ivory cream
  static const Color muted = Color(0xFFADA9A2);      // Earthy muted taupe

  static ThemeData get darkTheme {
    const base = ColorScheme.dark(
      primary: accent,
      secondary: accentSoft,
      surface: surface,
      error: warning,
      onPrimary: bg,
      onSecondary: bg,
      onSurface: text,
      onError: bg,
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
