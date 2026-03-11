// Экран изучения огласовок (ташкиль)
// Фатха, касра, дамма, сукун, шадда, танвин, мадд

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_muslim/core/theme/app_colors.dart';
import 'package:noor_muslim/models/arabic_learning_model.dart';
import 'package:noor_muslim/features/arabic_learning/presentation/providers/arabic_learning_provider.dart';

/// Экран изучения огласовок.
/// Показывает все виды огласовок с примерами на букве «ба».
class DiacriticsScreen extends ConsumerWidget {
  const DiacriticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(arabicLearningProvider);
    final theme = Theme.of(context);

    // Группируем по категориям
    final categories = DiacriticalCategory.values;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Огласовки (Ташкиль)'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Вступление
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.prayerCardGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Text(
                  'ташكيل',
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'Amiri',
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Огласовки — знаки, которые ставятся над или под буквой '
                  'и определяют, какой гласный звук произносится. '
                  'Без огласовок арабские буквы — только согласные.',
                  style: TextStyle(color: Colors.white70, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Категории огласовок
          ...categories.map((category) {
            final diacriticsInCategory =
                state.diacritics.where((d) => d.category == category).toList();

            if (diacriticsInCategory.isEmpty) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Название категории
                Text(
                  category.nameRussian,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.gold,
                  ),
                ),
                const SizedBox(height: 8),

                // Карточки огласовок
                ...diacriticsInCategory.map((d) => _buildDiacriticCard(context, d)),
                const SizedBox(height: 20),
              ],
            );
          }),
        ],
      ),
    );
  }

  /// Карточка одной огласовки
  Widget _buildDiacriticCard(BuildContext context, Diacritical diacritic) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Пример с буквой «ба»
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  diacritic.exampleWithBa,
                  style: const TextStyle(
                    fontSize: 36,
                    fontFamily: 'Amiri',
                    color: AppColors.primaryGreen,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Описание
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        diacritic.nameRussian,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        diacritic.nameArabic,
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          color: AppColors.gold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    diacritic.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.subtleText,
                          height: 1.4,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Произношение: ${diacritic.examplePronunciation}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.gold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
