// Детальный экран буквы
// Показывает произношение, формы, махрадж, примеры и советы

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_muslim/core/theme/app_colors.dart';
import 'package:noor_muslim/models/arabic_learning_model.dart';
import 'package:noor_muslim/features/arabic_learning/presentation/providers/arabic_learning_provider.dart';

/// Экран детального изучения одной буквы.
/// Показывает все 4 формы, произношение, махрадж, примеры.
/// Поддерживает свайпы для навигации между буквами.
class LetterDetailScreen extends ConsumerWidget {
  final int initialLetterOrder;

  const LetterDetailScreen({super.key, required this.initialLetterOrder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(arabicLearningProvider);
    final letter = state.currentLetter ?? state.alphabet.first;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${letter.nameRussian} (${letter.nameArabic})'),
        actions: [
          // Номер буквы
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${letter.order}/28',
                style: TextStyle(color: AppColors.subtleText),
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        // Свайп для навигации
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! < 0) {
              // Свайп влево — следующая буква
              ref.read(arabicLearningProvider.notifier).nextLetter();
            } else if (details.primaryVelocity! > 0) {
              // Свайп вправо — предыдущая буква
              ref.read(arabicLearningProvider.notifier).previousLetter();
            }
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Большая буква в центре
              _buildLetterHero(context, letter),
              const SizedBox(height: 24),

              // 4 формы буквы
              _buildFormsSection(context, letter),
              const SizedBox(height: 20),

              // Произношение
              _buildPronunciationSection(context, letter),
              const SizedBox(height: 20),

              // Махрадж (точка артикуляции)
              _buildArticulationSection(context, letter),
              const SizedBox(height: 20),

              // Примеры
              _buildExamplesSection(context, letter),
              const SizedBox(height: 20),

              // Совет
              _buildTipSection(context, letter),
              const SizedBox(height: 24),

              // Кнопки навигации
              _buildNavigationButtons(context, ref, letter),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Большая буква-герой
  Widget _buildLetterHero(BuildContext context, ArabicLetter letter) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: AppColors.prayerCardGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            letter.isolated,
            style: const TextStyle(
              fontSize: 96,
              fontFamily: 'Amiri',
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            letter.nameRussian,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Фонетика: ${letter.phonetic}',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// Секция с 4 формами буквы
  Widget _buildFormsSection(BuildContext context, ArabicLetter letter) {
    final forms = [
      ('Отдельная', letter.forms.isolated),
      ('Начальная', letter.forms.initial),
      ('Серединная', letter.forms.medial),
      ('Конечная', letter.forms.final_),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Формы буквы',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: forms.map((form) {
            return Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Text(
                        form.$2,
                        style: const TextStyle(
                          fontSize: 32,
                          fontFamily: 'Amiri',
                          color: AppColors.gold,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        form.$1,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.subtleText,
                              fontSize: 10,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Секция произношения
  Widget _buildPronunciationSection(BuildContext context, ArabicLetter letter) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.volume_up, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                Text(
                  'Произношение',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              letter.pronunciation,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// Секция точки артикуляции (махрадж)
  Widget _buildArticulationSection(BuildContext context, ArabicLetter letter) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.mic, color: AppColors.gold),
                const SizedBox(width: 8),
                Text(
                  'Махрадж (точка артикуляции)',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    letter.articulationPoint.nameArabic,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Amiri',
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      letter.articulationPoint.nameRussian,
                      style: Theme.of(context).textTheme.bodyMedium,
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

  /// Секция примеров
  Widget _buildExamplesSection(BuildContext context, ArabicLetter letter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Примеры',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ...letter.examples.map((example) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Арабское слово
                  Text(
                    example.arabic,
                    style: const TextStyle(
                      fontSize: 28,
                      fontFamily: 'Amiri',
                      color: AppColors.gold,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(width: 16),
                  // Перевод и транслитерация
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          example.transliteration,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          example.russian,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.subtleText,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  /// Совет по произношению
  Widget _buildTipSection(BuildContext context, ArabicLetter letter) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb, color: AppColors.gold, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              letter.tip,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  /// Кнопки навигации
  Widget _buildNavigationButtons(
    BuildContext context,
    WidgetRef ref,
    ArabicLetter letter,
  ) {
    return Row(
      children: [
        if (letter.order > 1)
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('Предыдущая'),
              onPressed: () {
                ref.read(arabicLearningProvider.notifier).previousLetter();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        if (letter.order > 1 && letter.order < 28) const SizedBox(width: 12),
        if (letter.order < 28)
          Expanded(
            child: FilledButton.icon(
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Следующая'),
              onPressed: () {
                ref.read(arabicLearningProvider.notifier).nextLetter();
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
