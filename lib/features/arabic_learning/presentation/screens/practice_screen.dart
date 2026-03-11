// Экран практики и тестов
// Практика чтения слов и аятов, тесты на распознавание букв и правил

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_muslim/core/theme/app_colors.dart';
import 'package:noor_muslim/models/arabic_learning_model.dart';
import 'package:noor_muslim/features/arabic_learning/presentation/providers/arabic_learning_provider.dart';

/// Экран практики чтения и тестов.
/// Показывает слова/аяты для чтения с возможностью проверки.
class PracticeScreen extends ConsumerStatefulWidget {
  final Lesson lesson;

  const PracticeScreen({super.key, required this.lesson});

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;
  int _correctAnswers = 0;
  int _totalAnswered = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(arabicLearningProvider);
    final isQuiz = widget.lesson.type == LessonType.quiz;
    final theme = Theme.of(context);

    // Получаем практические карточки
    final cards = _getPracticeCards(state);

    if (cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.lesson.title)),
        body: const Center(child: Text('Загрузка материалов...')),
      );
    }

    final currentCard = cards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_currentIndex + 1}/${cards.length}',
                style: TextStyle(color: AppColors.subtleText),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Прогресс-бар
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_currentIndex + 1) / cards.length,
                backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
                valueColor: const AlwaysStoppedAnimation(AppColors.primaryGreen),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 24),

            // Карточка
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Задание/инструкция
                      Text(
                        isQuiz ? 'Что это за буква/правило?' : 'Прочитайте вслух:',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.subtleText,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Арабский текст
                      Text(
                        currentCard.arabic,
                        style: const TextStyle(
                          fontSize: 48,
                          fontFamily: 'Amiri',
                          color: AppColors.gold,
                          height: 1.8,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 24),

                      // Ответ (показать/скрыть)
                      if (_showAnswer) ...[
                        const Divider(),
                        const SizedBox(height: 16),
                        Text(
                          currentCard.transliteration,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentCard.explanation,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (currentCard.source.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            currentCard.source,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.subtleText,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Кнопки
            if (!_showAnswer) ...[
              FilledButton(
                onPressed: () => setState(() => _showAnswer = true),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Показать ответ', style: TextStyle(fontSize: 16)),
              ),
            ] else ...[
              if (isQuiz)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _nextCard(cards.length, false),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                        child: const Text('Не знаю'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => _nextCard(cards.length, true),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          minimumSize: const Size(0, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Знаю!'),
                      ),
                    ),
                  ],
                )
              else
                FilledButton(
                  onPressed: () => _nextCard(cards.length, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _currentIndex < cards.length - 1 ? 'Далее' : 'Завершить',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  /// Переход к следующей карточке
  void _nextCard(int totalCards, bool wasCorrect) {
    _totalAnswered++;
    if (wasCorrect) _correctAnswers++;

    if (_currentIndex < totalCards - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    } else {
      // Завершение
      final score = _totalAnswered > 0 ? _correctAnswers / _totalAnswered : 0.0;

      if (widget.lesson.type == LessonType.quiz) {
        ref
            .read(arabicLearningProvider.notifier)
            .saveQuizResult(widget.lesson.id, score);
      } else {
        ref
            .read(arabicLearningProvider.notifier)
            .completeLesson(widget.lesson.id);
      }

      // Показываем результат
      _showResultDialog(score);
    }
  }

  /// Диалог результата
  void _showResultDialog(double score) {
    final isQuiz = widget.lesson.type == LessonType.quiz;
    final passed = score >= 0.7;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isQuiz
              ? (passed ? 'Отлично!' : 'Попробуйте ещё раз')
              : 'Урок завершён!',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              passed ? Icons.emoji_events : Icons.replay,
              size: 64,
              color: passed ? AppColors.gold : Colors.orange,
            ),
            const SizedBox(height: 16),
            if (isQuiz)
              Text(
                'Результат: ${(score * 100).toInt()}%\n'
                'Правильно: $_correctAnswers из $_totalAnswered',
                textAlign: TextAlign.center,
              )
            else
              const Text(
                'Продолжайте практиковаться для закрепления!',
                textAlign: TextAlign.center,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('К урокам'),
          ),
        ],
      ),
    );
  }

  /// Формируем набор практических карточек для урока
  List<_PracticeCard> _getPracticeCards(ArabicLearningState state) {
    final cards = <_PracticeCard>[];

    // Карточки из букв
    if (widget.lesson.type == LessonType.letterIntro ||
        widget.lesson.type == LessonType.letterForms ||
        widget.lesson.type == LessonType.quiz && widget.lesson.id.startsWith('l1')) {
      for (final letter in state.alphabet) {
        cards.add(_PracticeCard(
          arabic: letter.isolated,
          transliteration: '${letter.nameRussian} [${letter.phonetic}]',
          explanation: letter.pronunciation,
          source: '',
        ));
      }
    }

    // Карточки из огласовок
    if (widget.lesson.type == LessonType.diacritics ||
        widget.lesson.type == LessonType.quiz && widget.lesson.id.startsWith('l2')) {
      for (final d in state.diacritics) {
        cards.add(_PracticeCard(
          arabic: d.exampleWithBa,
          transliteration: d.examplePronunciation,
          explanation: '${d.nameRussian}: ${d.description}',
          source: '',
        ));
      }
    }

    // Карточки из правил таджвида
    if (widget.lesson.type == LessonType.tajweedRule ||
        widget.lesson.type == LessonType.quiz && widget.lesson.id.startsWith('l4') ||
        widget.lesson.type == LessonType.quiz && widget.lesson.id.startsWith('l5')) {
      for (final rule in state.tajweedRules) {
        for (final example in rule.examples) {
          cards.add(_PracticeCard(
            arabic: example.arabic,
            transliteration: example.transliteration,
            explanation: '${rule.nameRussian}: ${example.explanation}',
            source: example.source,
          ));
        }
      }
    }

    // Практика чтения — аяты из Корана
    if (widget.lesson.type == LessonType.practice) {
      cards.addAll(_getReadingPracticeCards());
    }

    // Если карточек мало — добавляем из букв
    if (cards.isEmpty) {
      for (final letter in state.alphabet.take(10)) {
        cards.add(_PracticeCard(
          arabic: letter.isolated,
          transliteration: letter.nameRussian,
          explanation: letter.pronunciation,
          source: '',
        ));
      }
    }

    return cards;
  }

  /// Карточки для практики чтения
  List<_PracticeCard> _getReadingPracticeCards() {
    return [
      const _PracticeCard(
        arabic: 'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَـٰنِ ٱلرَّحِیمِ',
        transliteration: 'Бисмилляхи р-Рахмани р-Рахим',
        explanation: 'Во имя Аллаха, Милостивого, Милосердного!',
        source: 'Аль-Фатиха, 1:1',
      ),
      const _PracticeCard(
        arabic: 'ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَـٰلَمِینَ',
        transliteration: 'Аль-хамду лилляхи Раббиль-алямин',
        explanation: 'Хвала Аллаху, Господу миров,',
        source: 'Аль-Фатиха, 1:2',
      ),
      const _PracticeCard(
        arabic: 'قُلۡ هُوَ ٱللَّهُ أَحَدٌ',
        transliteration: 'Куль хуваллаху ахад',
        explanation: 'Скажи: «Он — Аллах Единый,',
        source: 'Аль-Ихлас, 112:1',
      ),
      const _PracticeCard(
        arabic: 'ٱللَّهُ ٱلصَّمَدُ',
        transliteration: 'Аллаху с-самад',
        explanation: 'Аллах Самодостаточный.',
        source: 'Аль-Ихлас, 112:2',
      ),
      const _PracticeCard(
        arabic: 'قُلۡ أَعُوذُ بِرَبِّ ٱلۡفَلَقِ',
        transliteration: "Куль а'узу бираббиль-фалак",
        explanation: 'Скажи: «Прибегаю к Господу рассвета',
        source: 'Аль-Фалак, 113:1',
      ),
      const _PracticeCard(
        arabic: 'قُلۡ أَعُوذُ بِرَبِّ ٱلنَّاسِ',
        transliteration: "Куль а'узу бираббин-наас",
        explanation: 'Скажи: «Прибегаю к Господу людей,',
        source: 'Ан-Нас, 114:1',
      ),
    ];
  }
}

/// Карточка для практики
class _PracticeCard {
  final String arabic;
  final String transliteration;
  final String explanation;
  final String source;

  const _PracticeCard({
    required this.arabic,
    required this.transliteration,
    required this.explanation,
    required this.source,
  });
}
