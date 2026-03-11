// Главный экран модуля изучения арабского языка
// Показывает уровни обучения и прогресс

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_muslim/core/theme/app_colors.dart';
import 'package:noor_muslim/models/arabic_learning_model.dart';
import 'package:noor_muslim/features/arabic_learning/presentation/providers/arabic_learning_provider.dart';
import 'package:noor_muslim/features/arabic_learning/presentation/screens/alphabet_screen.dart';
import 'package:noor_muslim/features/arabic_learning/presentation/screens/lesson_screen.dart';

/// Главный экран обучения арабскому языку.
/// Показывает 6 уровней от алфавита до чтения Корана.
class ArabicLearningScreen extends ConsumerWidget {
  const ArabicLearningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(arabicLearningProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Красивый заголовок с прогрессом
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Изучение арабского'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.prayerCardGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // Прогресс-бар
                        Row(
                          children: [
                            const Icon(Icons.school, color: AppColors.gold, size: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Прогресс: ${(state.progress.overallProgress * 100).toInt()}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: state.progress.overallProgress,
                                      backgroundColor: Colors.white24,
                                      valueColor: const AlwaysStoppedAnimation<Color>(
                                        AppColors.gold,
                                      ),
                                      minHeight: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              // Кнопка открытия алфавита-справочника
              IconButton(
                icon: const Icon(Icons.translate),
                tooltip: 'Справочник алфавита',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AlphabetScreen(),
                    ),
                  );
                },
              ),
            ],
          ),

          // Список уровней
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= state.levels.length) return null;
                  final level = state.levels[index];
                  return _buildLevelCard(context, ref, level, state, index);
                },
                childCount: state.levels.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Карточка уровня обучения
  Widget _buildLevelCard(
    BuildContext context,
    WidgetRef ref,
    LearningLevel level,
    ArabicLearningState state,
    int index,
  ) {
    // Считаем прогресс по уровню
    int completedInLevel = 0;
    for (final lesson in level.lessons) {
      if (state.progress.completedLessons.contains(lesson.id)) {
        completedInLevel++;
      }
    }
    final levelProgress = level.totalLessons > 0
        ? completedInLevel / level.totalLessons
        : 0.0;

    // Проверяем доступность уровня
    final isLocked = index > 0 && _previousLevelNotCompleted(state, index);

    // Иконка уровня
    final levelIcons = {
      'alphabet': Icons.abc,
      'diacritics': Icons.text_format,
      'connections': Icons.link,
      'tajweed_basics': Icons.record_voice_over,
      'tajweed_advanced': Icons.auto_awesome,
      'reading': Icons.menu_book,
    };

    final icon = levelIcons[level.icon] ?? Icons.school;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isLocked
            ? null
            : () {
                ref.read(arabicLearningProvider.notifier).selectLevel(level);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LessonListScreen(level: level),
                  ),
                );
              },
        child: Opacity(
          opacity: isLocked ? 0.5 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Номер и иконка уровня
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isLocked
                        ? Colors.grey.withOpacity(0.2)
                        : AppColors.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: isLocked
                      ? const Icon(Icons.lock, color: Colors.grey)
                      : Icon(icon, color: AppColors.primaryGreen, size: 28),
                ),
                const SizedBox(width: 16),

                // Описание уровня
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Уровень ${level.number}',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        level.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        level.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.subtleText,
                            ),
                      ),
                      const SizedBox(height: 8),

                      // Прогресс-бар уровня
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: levelProgress,
                                backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryGreen,
                                ),
                                minHeight: 4,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$completedInLevel/${level.totalLessons}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.subtleText,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Стрелка
                if (!isLocked)
                  const Icon(Icons.chevron_right, color: AppColors.subtleText),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Проверяем, завершён ли предыдущий уровень
  bool _previousLevelNotCompleted(ArabicLearningState state, int index) {
    if (index == 0) return false;
    final previousLevel = state.levels[index - 1];
    for (final lesson in previousLevel.lessons) {
      if (lesson.type == LessonType.quiz &&
          !state.progress.completedLessons.contains(lesson.id)) {
        return true;
      }
    }
    return false;
  }
}
