import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // 1. Primary — Muted Teal
  static const Color bgApp = Color(0xFFE1F5EE);      // Background App (soothing very light teal)
  static const Color accentSoft = Color(0xFF5DCAA5); // Accent muted / Progress bar
  static const Color accent = Color(0xFF1D9E75);     // Primary CTA / Tombol utama
  static const Color headingTeal = Color(0xFF085041); // Heading utama / Text on light

  // 2. Cohesive Tones of Muted Teal (No Purple/Warm Gray)
  static const Color bg = Color(0xFFE1F5EE);         // Page Background (Muted Teal bg)
  static const Color surface = Color(0xFFFFFFFF);    // Card Surface (Clean crisp white for premium contrast)
  static const Color surfaceAlt = Color(0xFFCBECE0); // Border / Divider (Light-Medium Teal)
  static const Color calm = Color(0xFF1D9E75);       // Calm / Icons (Primary CTA Teal)
  static const Color textEmphasis = Color(0xFF085041); // Text Emphasis (Deep forest teal)
  static const Color text = Color(0xFF085041);       // Heading Text (Deep forest teal)
  static const Color muted = Color(0xFF537A71);      // Body Text / Subtext (Muted Teal-Gray)

  // 3. Semantic — Lembut & Tidak Mengejutkan
  static const Color success = Color(0xFFEAF3DE);    // Berhasil (Soft lime-green)
  static const Color warning = Color(0xFFFAEEDA);    // Perhatian (Soft gold-cream)
  static const Color alert = Color(0xFFFAECE7);      // Perlu dicek (Soft terracotta/pink)
  static const Color info = Color(0xFFE8F6F1);       // Info (Soft light teal)

  static ThemeData get darkTheme {
    const base = ColorScheme.light(
      primary: accent,
      secondary: accentSoft,
      surface: surface,
      error: alert,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: text,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: base,
      scaffoldBackgroundColor: bg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: headingTeal,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons on light background)
          statusBarBrightness: Brightness.light, // For iOS (dark icons on light background)
          systemNavigationBarColor: bg, // Match the bottom bar with the page bg
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: accentSoft,
        inactiveTrackColor: surfaceAlt,
        thumbColor: accent,
        overlayColor: Color(0x221D9E75),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontWeight: FontWeight.w700, color: headingTeal),
        headlineMedium: TextStyle(fontWeight: FontWeight.w700, color: headingTeal),
        titleLarge: TextStyle(fontWeight: FontWeight.w600, color: textEmphasis),
        titleMedium: TextStyle(fontWeight: FontWeight.w600, color: text),
        bodyLarge: TextStyle(color: text),
        bodyMedium: TextStyle(color: muted),
        labelLarge: TextStyle(fontWeight: FontWeight.w600, color: textEmphasis),
      ),
    );
  }
}
