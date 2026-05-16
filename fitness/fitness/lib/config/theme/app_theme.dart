import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primary = Color(0xFF00FF88); // Neon Green
  static const Color secondary = Color(0xFF3B82F6); // Electric Blue
  static const Color accent = Color(0xFF8B5CF6); // Purple Accent
  
  // Dark Mode Palette
  static const Color darkSurface = Color(0xFF0B0F14);
  static const Color darkCard = Color(0xFF1E2630);
  static const Color darkText = Colors.white;
  static const Color darkTextSecondary = Colors.white60;

  // Light Mode Palette
  static const Color lightSurface = Color(0xFFF8FAFC);
  static const Color lightCard = Colors.white;
  static const Color lightText = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  static ThemeData get darkTheme {
    return _buildTheme(Brightness.dark);
  }

  static ThemeData get lightTheme {
    return _buildTheme(Brightness.light);
  }

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final surface = isDark ? darkSurface : lightSurface;
    final card = isDark ? darkCard : lightCard;
    final text = isDark ? darkText : lightText;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: brightness,
        primary: primary,
        secondary: secondary,
        surface: surface,
        onSurface: text,
      ),
      scaffoldBackgroundColor: surface,
      textTheme: GoogleFonts.outfitTextTheme(
        (isDark ? ThemeData.dark() : ThemeData.light()).textTheme,
      ),
      cardTheme: CardThemeData(
        color: card.withOpacity(isDark ? 0.5 : 0.8),
        elevation: isDark ? 0 : 2,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: text),
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
