// Цветовая палитра приложения Noor Muslim
// Исламские цвета: зелёный, золотой, бирюзовый

import 'package:flutter/material.dart';

/// Константы цветов приложения.
/// Палитра вдохновлена исламским искусством и архитектурой.
class AppColors {
  AppColors._();

  // === Основные цвета ===
  /// Исламский зелёный — главный цвет
  static const Color primaryGreen = Color(0xFF1B8A6B);

  /// Золотой — акцентный цвет (как в куполах мечетей)
  static const Color gold = Color(0xFFD4A843);

  /// Глубокий бирюзовый — дополнительный
  static const Color deepTeal = Color(0xFF0D5C63);

  // === Тёмная тема ===
  static const Color darkBackground = Color(0xFF0A1628);
  static const Color darkSurface = Color(0xFF111D35);
  static const Color darkCard = Color(0xFF162240);

  // === Светлая тема ===
  static const Color lightSurface = Color(0xFFF5F5F0);
  static const Color lightCard = Color(0xFFFFFFFF);

  // === Текст ===
  static const Color darkText = Color(0xFF1A1A2E);
  static const Color lightText = Color(0xFFE8E8E8);
  static const Color subtleText = Color(0xFF8B8FA3);

  // === Градиенты для карточек намаза ===
  static const LinearGradient prayerCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1B8A6B),
      Color(0xFF0D5C63),
    ],
  );

  /// Градиент для заголовков
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0A1628),
      Color(0xFF162240),
    ],
  );

  /// Градиент золотого оттенка для акцентов
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFD4A843),
      Color(0xFFE8C776),
    ],
  );
}
