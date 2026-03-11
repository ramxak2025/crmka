// Экран списка уроков уровня и экран конкретного урока
// Поддерживает разные типы: буквы, огласовки, таджвид, практика, тест

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_muslim/core/theme/app_colors.dart';
import 'package:noor_muslim/models/arabic_learning_model.dart';
import 'package:noor_muslim/features/arabic_learning/presentation/providers/arabic_learning_provider.dart';
import 'package:noor_muslim/features/arabic_learning/presentation/screens/letter_detail_screen.dart';
import 'package:noor_muslim/features/arabic_learning/presentation/screens/tajweed_rule_screen.dart';
import 'package:noor_muslim/features/arabic_learning/presentation/screens/diacritics_screen.dart';
import 'package:noor_muslim/features/arabic_learning/presentation/screens/practice_screen.dart';

/// Экран списка уроков конкретного уровня
class LessonListScreen extends ConsumerWidget {
  final LearningLevel level;

  const LessonListScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(arabicLearningProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Уровень ${level.number}: ${level.title}'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: level.lessons.length,
        itemBuilder: (context, index) {
          final lesson = level.lessons[index];
          final isCompleted = state.progress.completedLessons.contains(lesson.id);
          final quizScore = state.progress.quizResults[lesson.id];

          // Иконка по типу урока
          final typeIcons = {
            LessonType.letterIntro: Icons.abc,
            LessonType.letterForms: Icons.format_shapes,
            LessonType.diacritics: Icons.text_format,
            LessonType.connections: Icons.link,
            LessonType.tajweedRule: Icons.record_voice_over,
            LessonType.practice: Icons.play_circle_outline,
            LessonType.quiz: Icons.quiz,
          };

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.primaryGreen.withOpacity(0.1)
                      : AppColors.gold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isCompleted
                      ? Icons.check_circle
                      : typeIcons[lesson.type] ?? Icons.school,
                  color: isCompleted ? AppColors.primaryGreen : AppColors.gold,
                ),
              ),
              title: Text(
                lesson.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.subtleText,
                    ),
                  ),
                  if (quizScore != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Результат: ${(quizScore * 100).toInt()}%',
                      style: TextStyle(
                        color: quizScore >= 0.7
                            ? AppColors.primaryGreen
                            : Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
              trailing: Text(
                lesson.type.nameRussian,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.subtleText,
                  fontSize: 10,
                ),
              ),
              onTap: () => _openLesson(context, ref, lesson),
            ),
          );
        },
      ),
    );
  }

  /// Открыть урок в зависимости от типа
  void _openLesson(BuildContext context, WidgetRef ref, Lesson lesson) {
    ref.read(arabicLearningProvider.notifier).selectLesson(lesson);

    Widget screen;

    switch (lesson.type) {
      case LessonType.letterIntro:
      case LessonType.letterForms:
        // Открываем первую букву из группы урока
        final letterOrder = _getFirstLetterOrder(lesson);
        ref.read(arabicLearningProvider.notifier).showLetter(letterOrder);
        screen = LetterDetailScreen(initialLetterOrder: letterOrder);

      case LessonType.diacritics:
        screen = const DiacriticsScreen();

      case LessonType.tajweedRule:
        screen = TajweedRuleScreen(lessonId: lesson.id);

      case LessonType.connections:
      case LessonType.practice:
        screen = PracticeScreen(lesson: lesson);

      case LessonType.quiz:
        screen = PracticeScreen(lesson: lesson); // Тест использует тот же экран
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  /// Определяем первую букву для урока
  int _getFirstLetterOrder(Lesson lesson) {
    final letterMapping = {
      'l1_01': 1,  // Алиф
      'l1_02': 5,  // Джим
      'l1_03': 8,  // Даль
      'l1_04': 12, // Син
      'l1_05': 16, // Та
      'l1_06': 20, // Фа
      'l1_07': 24, // Мим
      'l1_08': 1,  // Формы — начинаем с Алиф
    };
    return letterMapping[lesson.id] ?? 1;
  }
}
