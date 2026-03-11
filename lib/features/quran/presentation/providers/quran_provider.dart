// Провайдер Корана (Riverpod)
// Управляет загрузкой сур, аятов и тафсиров

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_muslim/models/surah_model.dart';
import 'package:noor_muslim/models/tafsir_model.dart';
import 'package:noor_muslim/services/api_service.dart';

/// Состояние экрана Корана
class QuranState {
  /// Список всех 114 сур
  final List<SurahModel> surahs;

  /// Текущая открытая сура с аятами
  final SurahModel? currentSurah;

  /// Тафсиры для выбранного аята
  final List<TafsirModel> currentTafsirs;

  /// Выбранный источник тафсира
  final TafsirSource selectedTafsirSource;

  /// Результаты поиска
  final List<AyahModel> searchResults;

  /// Строка поиска
  final String searchQuery;

  /// Загружается ли
  final bool isLoading;

  /// Ошибка
  final String? error;

  const QuranState({
    this.surahs = const [],
    this.currentSurah,
    this.currentTafsirs = const [],
    this.selectedTafsirSource = TafsirSource.saadi,
    this.searchResults = const [],
    this.searchQuery = '',
    this.isLoading = false,
    this.error,
  });

  QuranState copyWith({
    List<SurahModel>? surahs,
    SurahModel? currentSurah,
    List<TafsirModel>? currentTafsirs,
    TafsirSource? selectedTafsirSource,
    List<AyahModel>? searchResults,
    String? searchQuery,
    bool? isLoading,
    String? error,
  }) {
    return QuranState(
      surahs: surahs ?? this.surahs,
      currentSurah: currentSurah ?? this.currentSurah,
      currentTafsirs: currentTafsirs ?? this.currentTafsirs,
      selectedTafsirSource: selectedTafsirSource ?? this.selectedTafsirSource,
      searchResults: searchResults ?? this.searchResults,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Управление состоянием Корана
class QuranNotifier extends StateNotifier<QuranState> {
  final ApiService _apiService;

  QuranNotifier({ApiService? apiService})
      : _apiService = apiService ?? ApiService(),
        super(const QuranState(isLoading: true)) {
    loadSurahs();
  }

  /// Загрузить список сур
  Future<void> loadSurahs() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final surahs = await _apiService.getSurahs();
      state = state.copyWith(surahs: surahs, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Не удалось загрузить список сур: $e',
      );
    }
  }

  /// Открыть суру с аятами
  Future<void> openSurah(int surahNumber) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final surah = await _apiService.getSurahWithAyahs(surahNumber);
      state = state.copyWith(currentSurah: surah, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Не удалось загрузить суру: $e',
      );
    }
  }

  /// Загрузить тафсир для аята
  Future<void> loadTafsir(int surahNumber, int ayahNumber) async {
    try {
      final tafsirs = await _apiService.getTafsir(surahNumber, ayahNumber);
      state = state.copyWith(currentTafsirs: tafsirs);
    } catch (e) {
      state = state.copyWith(error: 'Не удалось загрузить тафсир: $e');
    }
  }

  /// Изменить источник тафсира
  void changeTafsirSource(TafsirSource source) {
    state = state.copyWith(selectedTafsirSource: source);
  }

  /// Поиск в Коране
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(searchResults: [], searchQuery: '');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, searchQuery: query);
      final results = await _apiService.searchQuran(query);
      state = state.copyWith(searchResults: results, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Ошибка поиска: $e',
      );
    }
  }

  /// Вернуться к списку сур
  void goBack() {
    state = state.copyWith(
      currentSurah: null,
      currentTafsirs: [],
    );
  }
}

/// Riverpod провайдер для Корана
final quranProvider = StateNotifierProvider<QuranNotifier, QuranState>(
  (ref) => QuranNotifier(),
);
