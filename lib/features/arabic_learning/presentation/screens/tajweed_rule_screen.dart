// Экран правила таджвида
// Показывает подробное описание, шаги, примеры из Корана

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_muslim/core/theme/app_colors.dart';
import 'package:noor_muslim/models/arabic_learning_model.dart';
import 'package:noor_muslim/features/arabic_learning/presentation/providers/arabic_learning_provider.dart';

/// Экран изучения конкретного правила таджвида.
/// Показывает описание, пошаговую инструкцию и примеры из Корана.
class TajweedRuleScreen extends ConsumerWidget {
  final String lessonId;

  const TajweedRuleScreen({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(arabicLearningProvider);
    final theme = Theme.of(context);

    // Маппинг уроков на правила таджвида
    final ruleMapping = {
      'l4_01': null, // Введение — показываем общую информацию
      'l4_02': 'lam_shamsiyya',
      'l4_03': 'izhar',
      'l4_04': 'idgham_ghunna',
      'l4_05': 'ikhfa',
      'l4_06': 'iqlab',
      'l4_07': null, // Правила мим — показываем несколько
      'l5_01': 'madd_tabii',
      'l5_02': null,
      'l5_03': null,
      'l5_04': 'qalqala',
      'l5_05': 'ghunna',
      'l5_06': null,
    };

    final ruleId = ruleMapping[lessonId];

    if (ruleId != null) {
      final rule = state.tajweedRules.where((r) => r.id == ruleId).firstOrNull;
      if (rule != null) {
        return _buildRuleScreen(context, ref, rule);
      }
    }

    // Показываем список всех правил таджвида
    return _buildAllRulesScreen(context, ref, state);
  }

  /// Экран одного правила таджвида
  Widget _buildRuleScreen(BuildContext context, WidgetRef ref, TajweedRule rule) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(rule.nameRussian),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Заголовок с арабским названием
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.prayerCardGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    rule.nameArabic,
                    style: const TextStyle(
                      fontSize: 36,
                      fontFamily: 'Amiri',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rule.nameRussian,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Сложность
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      return Icon(
                        i < rule.difficulty ? Icons.star : Icons.star_border,
                        color: AppColors.gold,
                        size: 18,
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Описание правила
            Text(
              'Описание',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              rule.description,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
            const SizedBox(height: 20),

            // Пошаговая инструкция
            Text(
              'Как применять',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...rule.steps.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),

            // Примеры из Корана
            Text(
              'Примеры из Корана',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...rule.examples.map((example) => _buildExampleCard(context, example)),
            const SizedBox(height: 24),

            // Кнопка «Урок пройден»
            FilledButton.icon(
              icon: const Icon(Icons.check_circle),
              label: const Text('Урок пройден'),
              onPressed: () {
                ref.read(arabicLearningProvider.notifier).completeLesson(lessonId);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Урок отмечен как пройденный!'),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
                Navigator.of(context).pop();
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Карточка примера из Корана
  Widget _buildExampleCard(BuildContext context, TajweedExample example) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Арабский текст
            Text(
              example.arabic,
              style: const TextStyle(
                fontSize: 28,
                fontFamily: 'Amiri',
                color: AppColors.gold,
                height: 1.8,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 8),

            // Транслитерация
            Text(
              example.transliteration,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: AppColors.primaryGreen,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),

            // Источник
            Text(
              example.source,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.subtleText,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Объяснение
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                example.explanation,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      height: 1.4,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Экран со списком всех правил таджвида
  Widget _buildAllRulesScreen(
    BuildContext context,
    WidgetRef ref,
    ArabicLearningState state,
  ) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Правила таджвида')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: TajweedCategory.values.map((category) {
          final rulesInCategory =
              state.tajweedRules.where((r) => r.category == category).toList();
          if (rulesInCategory.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Категория
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Text(
                      category.nameArabic,
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 18,
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category.nameRussian,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Правила
              ...rulesInCategory.map((rule) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(rule.nameRussian),
                    subtitle: Text(
                      rule.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: AppColors.subtleText, fontSize: 12),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (i) {
                        return Icon(
                          i < rule.difficulty ? Icons.star : Icons.star_border,
                          color: AppColors.gold,
                          size: 14,
                        );
                      }),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => _buildRuleScreen(context, ref, rule),
                        ),
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
      ),
    );
  }
}
