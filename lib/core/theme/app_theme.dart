import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Original Emerald Health Palette
  static const Color primaryGreen = Color(0xFF00A676); // Emerald Green
  static const Color primaryGreenDark = Color(0xFF007A58);
  static const Color accentGreen = Color(0xFF00C853);
  static const Color backgroundLight = Color(0xFFF5F9F7);
  static const Color surfaceWhite = Colors.white;
  static const Color textDark = Color(0xFF1B2D2A);
  static const Color textGrey = Color(0xFF6B7C79);

  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.alexandriaTextTheme();
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: accentGreen,
        surface: surfaceWhite,
        onPrimary: Colors.white,
        onSurface: textDark,
      ),
      scaffoldBackgroundColor: Colors.transparent, // Required for the Mesh Gradient behind screens
      textTheme: textTheme.copyWith(
        headlineMedium: GoogleFonts.alexandria(
          textStyle: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700, 
            fontSize: 32, 
            letterSpacing: -1.0, 
            color: textDark
          ),
        ),
        titleLarge: GoogleFonts.alexandria(
          textStyle: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600, 
            fontSize: 20, 
            letterSpacing: -0.5, 
            color: textDark
          ),
        ),
        titleMedium: GoogleFonts.alexandria(
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600, 
            fontSize: 17, 
            letterSpacing: -0.3, 
            color: textDark
          ),
        ),
        bodyLarge: GoogleFonts.alexandria(
          textStyle: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w400, 
            fontSize: 17, 
            color: textDark, 
            letterSpacing: -0.1
          ),
        ),
        bodyMedium: GoogleFonts.alexandria(
          textStyle: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w400, 
            fontSize: 15, 
            color: textGrey
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: textDark),
        titleTextStyle: GoogleFonts.alexandria(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          textStyle: GoogleFonts.alexandria(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        labelStyle: GoogleFonts.alexandria(color: textGrey),
        hintStyle: GoogleFonts.alexandria(color: textGrey.withOpacity(0.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryGreen.withOpacity(0.1), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
      ),
    );
  }

  static const Gradient healthGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, Color(0xFF008960)],
  );

  // Mesh Gradient for background
  static const Gradient meshBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE8F5E9), // Light Mint
      Color(0xFFF1F8E9), // Slightly different green
      Color(0xFFE3F2FD), // Soft blue tint
    ],
    stops: [0.0, 0.5, 1.0],
  );
}
