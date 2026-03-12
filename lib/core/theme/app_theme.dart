// Главная тема приложения Noor Muslim
// Используем Material 3 с исламской цветовой палитрой

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Класс для управления темами приложения.
/// Поддерживает светлую и тёмную тему с исламскими цветами.
class AppTheme {
  AppTheme._(); // Приватный конструктор — нельзя создать экземпляр

  /// Светлая тема
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        brightness: Brightness.light,
        primary: AppColors.primaryGreen,
        secondary: AppColors.gold,
        tertiary: AppColors.deepTeal,
        surface: AppColors.lightSurface,
        onSurface: AppColors.darkText,
      ),
      // Типографика
      textTheme: _buildTextTheme(Brightness.light),
      // Карточки
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: AppColors.primaryGreen.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      // AppBar
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.darkText,
        titleTextStyle: GoogleFonts.rubik(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
      ),
      // Нижняя навигация
      navigationBarTheme: NavigationBarThemeData(
        elevation: 8,
        height: 70,
        indicatorColor: AppColors.primaryGreen.withOpacity(0.15),
        labelTextStyle: WidgetStatePropertyAll(
          GoogleFonts.rubik(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
      // Кнопки
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  /// Тёмная тема — основная для исламского приложения
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        brightness: Brightness.dark,
        primary: AppColors.primaryGreen,
        secondary: AppColors.gold,
        tertiary: AppColors.deepTeal,
        surface: AppColors.darkSurface,
        onSurface: AppColors.lightText,
      ),
      textTheme: _buildTextTheme(Brightness.dark),
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: Colors.black26,
        color: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.lightText,
        titleTextStyle: GoogleFonts.rubik(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.lightText,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 8,
        height: 70,
        backgroundColor: AppColors.darkCard,
        indicatorColor: AppColors.primaryGreen.withOpacity(0.2),
        labelTextStyle: WidgetStatePropertyAll(
          GoogleFonts.rubik(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
    );
  }

  /// Построение типографики с учётом темы
  static TextTheme _buildTextTheme(Brightness brightness) {
    final color = brightness == Brightness.dark
        ? AppColors.lightText
        : AppColors.darkText;

    return TextTheme(
      displayLarge: GoogleFonts.rubik(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      displayMedium: GoogleFonts.rubik(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      headlineLarge: GoogleFonts.rubik(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      headlineMedium: GoogleFonts.rubik(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      titleLarge: GoogleFonts.rubik(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      titleMedium: GoogleFonts.rubik(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      bodyLarge: GoogleFonts.rubik(
        fontSize: 16,
        color: color,
      ),
      bodyMedium: GoogleFonts.rubik(
        fontSize: 14,
        color: color,
      ),
      labelLarge: GoogleFonts.rubik(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }
}
