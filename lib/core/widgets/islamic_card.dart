// Переиспользуемая карточка в исламском стиле
// Базовый виджет для карточек по всему приложению

import 'package:flutter/material.dart';
import 'package:noor_muslim/core/theme/app_colors.dart';

/// Стилизованная карточка с исламским дизайном.
/// Поддерживает градиентный фон и декоративный узор.
class IslamicCard extends StatelessWidget {
  final Widget child;
  final LinearGradient? gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool showPattern;

  const IslamicCard({
    super.key,
    required this.child,
    this.gradient,
    this.padding,
    this.margin,
    this.onTap,
    this.showPattern = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: gradient ?? AppColors.prayerCardGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Декоративный узор (опционально)
              if (showPattern) _buildPattern(),
              // Основной контент
              Padding(
                padding: padding ?? const EdgeInsets.all(20),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Декоративный геометрический узор (исламский стиль)
  Widget _buildPattern() {
    return Positioned(
      right: -20,
      top: -20,
      child: Opacity(
        opacity: 0.08,
        child: Icon(
          Icons.star,
          size: 150,
          color: Colors.white,
        ),
      ),
    );
  }
}
