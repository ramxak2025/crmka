// Виджет карточки времени намаза
// Отображает название молитвы, время и статус (активная/следующая)

import 'package:flutter/material.dart';
import 'package:noor_muslim/core/theme/app_colors.dart';

/// Карточка одной молитвы в списке времён намаза.
/// Выделяет текущую и следующую молитву визуально.
class PrayerTimeCard extends StatelessWidget {
  /// Название молитвы на русском
  final String prayerName;

  /// Название молитвы на арабском
  final String prayerNameArabic;

  /// Форматированное время (HH:mm)
  final String time;

  /// Текущая ли это молитва
  final bool isActive;

  /// Следующая ли это молитва
  final bool isNext;

  const PrayerTimeCard({
    super.key,
    required this.prayerName,
    required this.prayerNameArabic,
    required this.time,
    required this.isActive,
    required this.isNext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        // Активная молитва — зелёный градиент, следующая — золотой контур
        gradient: isNext ? AppColors.prayerCardGradient : null,
        color: isNext ? null : (isActive ? AppColors.primaryGreen.withOpacity(0.1) : null),
        borderRadius: BorderRadius.circular(16),
        border: isActive && !isNext
            ? Border.all(color: AppColors.gold, width: 1.5)
            : null,
        boxShadow: isNext
            ? [
                BoxShadow(
                  color: AppColors.primaryGreen.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // Иконка статуса
            _buildStatusIcon(),
            const SizedBox(width: 16),

            // Название молитвы
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prayerName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isNext ? Colors.white : null,
                      fontWeight: (isActive || isNext) ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    prayerNameArabic,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isNext
                          ? Colors.white70
                          : AppColors.subtleText,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Время
            Text(
              time,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: isNext ? Colors.white : AppColors.primaryGreen,
                fontWeight: FontWeight.w700,
                fontSize: isNext ? 24 : 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Иконка статуса молитвы
  Widget _buildStatusIcon() {
    if (isNext) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.notifications_active,
          color: Colors.white,
          size: 20,
        ),
      );
    }

    if (isActive) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.gold.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.check_circle,
          color: AppColors.gold,
          size: 20,
        ),
      );
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.subtleText.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.access_time,
        color: AppColors.subtleText.withOpacity(0.5),
        size: 20,
      ),
    );
  }
}
