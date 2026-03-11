// Провайдер модуля изучения арабского языка (Riverpod)
// Управляет прогрессом обучения, навигацией по урокам и тестами

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_muslim/models/arabic_learning_model.dart';
import 'package:noor_muslim/features/arabic_learning/data/arabic_data.dart';

/// Состояние модуля обучения
class ArabicLearningState {
  /// Список уровней обучения
  final List<LearningLevel> levels;

  /// Текущий выбранный уровень
  final LearningLevel? selectedLevel;

  /// Текущий выбранный урок
  final Lesson? selectedLesson;

  /// Текущая отображаемая буква (для экрана буквы)
  final ArabicLetter? currentLetter;

  /// Текущее правило таджвида
  final TajweedRule? currentTajweedRule;

  /// Список всех букв алфавита
  final List<ArabicLetter> alphabet;

  /// Список огласовок
  final List<Diacritical> diacritics;

  /// Список правил таджвида
  final List<TajweedRule> tajweedRules;

  /// Прогресс пользователя
  final LearningProgress progress;

  /// Загружается ли
  final bool isLoading;

  /// Ошибка
  final String? error;

  /// Текущий индекс вопроса в тесте
  final int quizCurrentIndex;

  /// Правильные ответы в тесте
  final int quizCorrectAnswers;

  const ArabicLearningState({
    this.levels = const [],
    this.selectedLevel,
    this.selectedLesson,
    this.currentLetter,
    this.currentTajweedRule,
    this.alphabet = const [],
    this.diacritics = const [],
    this.tajweedRules = const [],
    this.progress = const LearningProgress(),
    this.isLoading = false,
    this.error,
    this.quizCurrentIndex = 0,
    this.quizCorrectAnswers = 0,
  });

  ArabicLearningState copyWith({
    List<LearningLevel>? levels,
    LearningLevel? selectedLevel,
    Lesson? selectedLesson,
    ArabicLetter? currentLetter,
    TajweedRule? currentTajweedRule,
    List<ArabicLetter>? alphabet,
    List<Diacritical>? diacritics,
    List<TajweedRule>? tajweedRules,
    LearningProgress? progress,
    bool? isLoading,
    String? error,
    int? quizCurrentIndex,
    int? quizCorrectAnswers,
  }) {
    return ArabicLearningState(
      levels: levels ?? this.levels,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      selectedLesson: selectedLesson ?? this.selectedLesson,
      currentLetter: currentLetter ?? this.currentLetter,
      currentTajweedRule: currentTajweedRule ?? this.currentTajweedRule,
      alphabet: alphabet ?? this.alphabet,
      diacritics: diacritics ?? this.diacritics,
      tajweedRules: tajweedRules ?? this.tajweedRules,
      progress: progress ?? this.progress,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      quizCurrentIndex: quizCurrentIndex ?? this.quizCurrentIndex,
      quizCorrectAnswers: quizCorrectAnswers ?? this.quizCorrectAnswers,
    );
  }
}

/// Управление состоянием модуля обучения арабскому языку
class ArabicLearningNotifier extends StateNotifier<ArabicLearningState> {
  ArabicLearningNotifier() : super(const ArabicLearningState(isLoading: true)) {
    _initialize();
  }

  /// Инициализация: загрузить все данные
  void _initialize() {
    final data = ArabicData();

    state = state.copyWith(
      alphabet: data.getAlphabet(),
      diacritics: data.getDiacritics(),
      tajweedRules: data.getTajweedRules(),
      levels: data.getCurriculum(),
      isLoading: false,
    );
  }

  /// Выбрать уровень обучения
  void selectLevel(LearningLevel level) {
    state = state.copyWith(selectedLevel: level);
  }

  /// Выбрать урок
  void selectLesson(Lesson lesson) {
    state = state.copyWith(selectedLesson: lesson);
  }

  /// Показать букву по номеру
  void showLetter(int order) {
    final letter = state.alphabet.firstWhere(
      (l) => l.order == order,
      orElse: () => state.alphabet.first,
    );
    state = state.copyWith(currentLetter: letter);
  }

  /// Перейти к следующей букве
  void nextLetter() {
    if (state.currentLetter == null) return;
    final nextOrder = state.currentLetter!.order + 1;
    if (nextOrder <= 28) {
      showLetter(nextOrder);
    }
  }

  /// Перейти к предыдущей букве
  void previousLetter() {
    if (state.currentLetter == null) return;
    final prevOrder = state.currentLetter!.order - 1;
    if (prevOrder >= 1) {
      showLetter(prevOrder);
    }
  }

  /// Показать правило таджвида
  void showTajweedRule(String ruleId) {
    final rule = state.tajweedRules.firstWhere(
      (r) => r.id == ruleId,
      orElse: () => state.tajweedRules.first,
    );
    state = state.copyWith(currentTajweedRule: rule);
  }

  /// Отметить урок как пройденный
  void completeLesson(String lessonId) {
    final newCompleted = {...state.progress.completedLessons, lessonId};

    // Подсчитываем общий прогресс
    int totalLessons = 0;
    for (final level in state.levels) {
      totalLessons += level.totalLessons;
    }
    final overallProgress =
        totalLessons > 0 ? newCompleted.length / totalLessons : 0.0;

    state = state.copyWith(
      progress: state.progress.copyWith(
        completedLessons: newCompleted,
        overallProgress: overallProgress,
      ),
    );
  }

  /// Проверить, пройден ли урок
  bool isLessonCompleted(String lessonId) {
    return state.progress.completedLessons.contains(lessonId);
  }

  /// Сохранить результат теста
  void saveQuizResult(String lessonId, double score) {
    final newResults = {...state.progress.quizResults, lessonId: score};
    state = state.copyWith(
      progress: state.progress.copyWith(quizResults: newResults),
    );
    // Если тест пройден на 70%+, отмечаем урок как завершённый
    if (score >= 0.7) {
      completeLesson(lessonId);
    }
  }
}

/// Riverpod провайдер для модуля обучения
final arabicLearningProvider =
    StateNotifierProvider<ArabicLearningNotifier, ArabicLearningState>(
  (ref) => ArabicLearningNotifier(),
);
