import 'package:flutter/material.dart';

/// Lume app theme - Butler-esque minimalist dark theme
/// 
/// Color palette:
/// - Background: Deep space blue (#0A0E27)
/// - Primary: Gold (#D4AF37)
/// - Secondary: Soft blue (#6B9BD1)
/// - Surface: Dark blue-gray (#1A1F3A)
class LumeTheme {
  // Color constants
  static const Color _backgroundDark = Color(0xFF0A0E27);
  static const Color _surfaceDark = Color(0xFF1A1F3A);
  static const Color _primaryGold = Color(0xFFD4AF37);
  static const Color _secondaryBlue = Color(0xFF6B9BD1);
  static const Color _accentGold = Color(0xFFFFD700);
  static const Color _textPrimary = Color(0xFFE8E8E8);
  static const Color _textSecondary = Color(0xFFB0B0B0);
  
  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color scheme
      colorScheme: const ColorScheme.dark(
        surface: _backgroundDark,
        surfaceContainerHighest: _surfaceDark,
        primary: _primaryGold,
        secondary: _secondaryBlue,
        onSurface: _textPrimary,
        onPrimary: _backgroundDark,
        onSecondary: _backgroundDark,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: _backgroundDark,
      
      // App bar
      appBarTheme: const AppBarTheme(
        backgroundColor: _backgroundDark,
        foregroundColor: _textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      
      // Card
      cardTheme: CardThemeData(
        color: _surfaceDark,
        elevation: 4,
        shadowColor: _primaryGold.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _surfaceDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryGold, width: 2),
        ),
        labelStyle: const TextStyle(color: _textSecondary),
        hintStyle: TextStyle(color: _textSecondary.withOpacity(0.6)),
      ),
      
      // Elevated button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryGold,
          foregroundColor: _backgroundDark,
          elevation: 4,
          shadowColor: _primaryGold.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      // Text button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryGold,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w300,
          color: _textPrimary,
          letterSpacing: -1.5,
        ),
        displayMedium: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w300,
          color: _textPrimary,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: _textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: _textPrimary,
          letterSpacing: 0.25,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: _textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
          letterSpacing: 0.15,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _textPrimary,
          letterSpacing: 0.15,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _textPrimary,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _textPrimary,
          letterSpacing: 0.25,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
          letterSpacing: 1.25,
        ),
      ),
      
      // Icon theme
      iconTheme: const IconThemeData(
        color: _primaryGold,
        size: 24,
      ),
    );
  }
  
  // Additional custom colors
  static const Color primaryGold = _primaryGold;
  static const Color accentGold = _accentGold;
  static const Color softBlue = _secondaryBlue;
  static const Color backgroundDark = _backgroundDark;
  static const Color surfaceDark = _surfaceDark;
  
  // Gradient definitions
  static const LinearGradient goldGradient = LinearGradient(
    colors: [_accentGold, _primaryGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient blueGradient = LinearGradient(
    colors: [_secondaryBlue, Color(0xFF4A7BA7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Shadow definitions
  static List<BoxShadow> get glowShadow => [
    BoxShadow(
      color: _primaryGold.withOpacity(0.3),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];
  
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
}
