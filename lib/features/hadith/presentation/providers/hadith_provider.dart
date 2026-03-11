// Провайдер хадисов (Riverpod)
// Управляет загрузкой и отображением хадисов

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_muslim/models/hadith_model.dart';
import 'package:noor_muslim/services/api_service.dart';

/// Состояние экрана хадисов
class HadithState {
  /// Текущий список хадисов
  final List<HadithModel> hadiths;

  /// Хадис дня (случайный)
  final HadithModel? hadithOfTheDay;

  /// Выбранный сборник
  final HadithCollection? selectedCollection;

  /// Результаты поиска
  final List<HadithModel> searchResults;

  /// Текущая страница (для пагинации)
  final int currentPage;

  /// Есть ли ещё хадисы для подгрузки
  final bool hasMore;

  /// Загружается ли
  final bool isLoading;

  /// Ошибка
  final String? error;

  const HadithState({
    this.hadiths = const [],
    this.hadithOfTheDay,
    this.selectedCollection,
    this.searchResults = const [],
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoading = false,
    this.error,
  });

  HadithState copyWith({
    List<HadithModel>? hadiths,
    HadithModel? hadithOfTheDay,
    HadithCollection? selectedCollection,
    List<HadithModel>? searchResults,
    int? currentPage,
    bool? hasMore,
    bool? isLoading,
    String? error,
  }) {
    return HadithState(
      hadiths: hadiths ?? this.hadiths,
      hadithOfTheDay: hadithOfTheDay ?? this.hadithOfTheDay,
      selectedCollection: selectedCollection ?? this.selectedCollection,
      searchResults: searchResults ?? this.searchResults,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Управление состоянием хадисов
class HadithNotifier extends StateNotifier<HadithState> {
  final ApiService _apiService;

  HadithNotifier({ApiService? apiService})
      : _apiService = apiService ?? ApiService(),
        super(const HadithState(isLoading: true)) {
    _initialize();
  }

  /// Инициализация: загрузить хадис дня
  Future<void> _initialize() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final hadithOfDay = await _apiService.getRandomHadith();
      state = state.copyWith(
        hadithOfTheDay: hadithOfDay,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Не удалось загрузить хадис дня: $e',
      );
    }
  }

  /// Выбрать сборник и загрузить хадисы
  Future<void> selectCollection(HadithCollection collection) async {
    try {
      state = state.copyWith(
        isLoading: true,
        selectedCollection: collection,
        currentPage: 1,
        hadiths: [],
        error: null,
      );

      final hadiths = await _apiService.getHadithsByCollection(
        collection.key,
        page: 1,
      );

      state = state.copyWith(
        hadiths: hadiths,
        isLoading: false,
        hasMore: hadiths.length >= 20,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Не удалось загрузить хадисы: $e',
      );
    }
  }

  /// Подгрузить следующую страницу хадисов
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore || state.selectedCollection == null) return;

    try {
      state = state.copyWith(isLoading: true);
      final nextPage = state.currentPage + 1;

      final moreHadiths = await _apiService.getHadithsByCollection(
        state.selectedCollection!.key,
        page: nextPage,
      );

      state = state.copyWith(
        hadiths: [...state.hadiths, ...moreHadiths],
        currentPage: nextPage,
        hasMore: moreHadiths.length >= 20,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Ошибка загрузки: $e',
      );
    }
  }

  /// Поиск хадисов
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(searchResults: []);
      return;
    }

    try {
      state = state.copyWith(isLoading: true);
      final results = await _apiService.searchHadith(query);
      state = state.copyWith(searchResults: results, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Ошибка поиска: $e',
      );
    }
  }
}

/// Riverpod провайдер для хадисов
final hadithProvider = StateNotifierProvider<HadithNotifier, HadithState>(
  (ref) => HadithNotifier(),
);
