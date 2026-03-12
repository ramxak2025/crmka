// Провайдер времени намаза (Riverpod)
// Управляет состоянием расчёта и отображения времён молитв

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_muslim/core/constants/city_constants.dart';
import 'package:noor_muslim/core/constants/prayer_constants.dart';
import 'package:noor_muslim/core/utils/prayer_time_calculator.dart';
import 'package:noor_muslim/models/prayer_times_model.dart';
import 'package:noor_muslim/services/city_selection_service.dart';
import 'package:noor_muslim/services/location_service.dart';

/// Состояние экрана времени намаза
class PrayerTimesState {
  final PrayerTimesModel? prayerTimes;
  final String? currentPrayer;
  final MapEntry<String, DateTime>? nextPrayer;
  final Duration? timeUntilNext;
  final bool isLoading;
  final String? error;
  final String cityName;
  final CityData? selectedCity;

  const PrayerTimesState({
    this.prayerTimes,
    this.currentPrayer,
    this.nextPrayer,
    this.timeUntilNext,
    this.isLoading = false,
    this.error,
    this.cityName = '',
    this.selectedCity,
  });

  /// Создание копии с обновлёнными полями
  PrayerTimesState copyWith({
    PrayerTimesModel? prayerTimes,
    String? currentPrayer,
    MapEntry<String, DateTime>? nextPrayer,
    Duration? timeUntilNext,
    bool? isLoading,
    String? error,
    String? cityName,
    CityData? selectedCity,
    bool clearSelectedCity = false,
  }) {
    return PrayerTimesState(
      prayerTimes: prayerTimes ?? this.prayerTimes,
      currentPrayer: currentPrayer ?? this.currentPrayer,
      nextPrayer: nextPrayer ?? this.nextPrayer,
      timeUntilNext: timeUntilNext ?? this.timeUntilNext,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      cityName: cityName ?? this.cityName,
      selectedCity: clearSelectedCity ? null : (selectedCity ?? this.selectedCity),
    );
  }
}

/// Управление состоянием времени намаза
class PrayerTimesNotifier extends StateNotifier<PrayerTimesState> {
  final LocationService _locationService;
  final PrayerTimeCalculator _calculator;
  Timer? _timer;

  PrayerTimesNotifier({
    LocationService? locationService,
    PrayerTimeCalculator? calculator,
  })  : _locationService = locationService ?? LocationService(),
        _calculator = calculator ?? PrayerTimeCalculator(),
        super(const PrayerTimesState(isLoading: true)) {
    _loadPrayerTimes();
  }

  /// Загрузить время намаза — сначала проверяем сохранённый город
  Future<void> _loadPrayerTimes() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Проверяем сохранённый город
      final savedCity = await CitySelectionService.loadCity();
      if (savedCity != null) {
        _calculateForCoordinates(
          savedCity.latitude,
          savedCity.longitude,
          savedCity.name,
          savedCity,
        );
        return;
      }

      // Пробуем GPS
      final hasPermission = await _locationService.requestPermission();
      if (!hasPermission) {
        // Если нет разрешения — используем координаты Москвы по умолчанию
        _calculateForCoordinates(55.7558, 37.6173, 'Москва', null);
        return;
      }

      final position = await _locationService.getCurrentPosition();
      _calculateForCoordinates(
        position.latitude,
        position.longitude,
        'Текущее местоположение',
        null,
      );
    } catch (e) {
      // При ошибке GPS — пробуем сохранённый город или Москву
      final savedCity = await CitySelectionService.loadCity();
      if (savedCity != null) {
        _calculateForCoordinates(
          savedCity.latitude,
          savedCity.longitude,
          savedCity.name,
          savedCity,
        );
      } else {
        _calculateForCoordinates(55.7558, 37.6173, 'Москва', null);
      }
    }
  }

  /// Рассчитать времена для конкретных координат
  void _calculateForCoordinates(
    double lat,
    double lon,
    String city,
    CityData? cityData,
  ) {
    final now = DateTime.now();
    final prayerTimes = _calculator.calculate(
      latitude: lat,
      longitude: lon,
      date: now,
    );

    final currentPrayer = prayerTimes.getCurrentPrayer(now);
    final nextPrayer = prayerTimes.getNextPrayer(now);
    final timeUntilNext = nextPrayer != null
        ? nextPrayer.value.difference(now)
        : null;

    state = PrayerTimesState(
      prayerTimes: prayerTimes,
      currentPrayer: currentPrayer,
      nextPrayer: nextPrayer,
      timeUntilNext: timeUntilNext,
      isLoading: false,
      cityName: city,
      selectedCity: cityData,
    );

    // Запускаем таймер для обновления обратного отсчёта
    _startCountdownTimer();
  }

  /// Таймер обратного отсчёта до следующей молитвы
  void _startCountdownTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.prayerTimes == null) return;

      final now = DateTime.now();
      final nextPrayer = state.prayerTimes!.getNextPrayer(now);

      if (nextPrayer != null) {
        state = state.copyWith(
          nextPrayer: nextPrayer,
          timeUntilNext: nextPrayer.value.difference(now),
          currentPrayer: state.prayerTimes!.getCurrentPrayer(now),
        );
      }
    });
  }

  /// Выбрать город вручную
  Future<void> selectCity(CityData city) async {
    await CitySelectionService.saveCity(city);
    _calculateForCoordinates(
      city.latitude,
      city.longitude,
      city.name,
      city,
    );
  }

  /// Изменить метод расчёта
  void changeMethod(CalculationMethod method) {
    if (state.prayerTimes != null) {
      final calc = PrayerTimeCalculator(method: method);
      final newTimes = calc.calculate(
        latitude: state.prayerTimes!.latitude,
        longitude: state.prayerTimes!.longitude,
        date: DateTime.now(),
      );

      final now = DateTime.now();
      state = state.copyWith(
        prayerTimes: newTimes,
        currentPrayer: newTimes.getCurrentPrayer(now),
        nextPrayer: newTimes.getNextPrayer(now),
      );
    }
  }

  /// Обновить данные
  Future<void> refresh() async {
    await _loadPrayerTimes();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Riverpod провайдер для времени намаза
final prayerTimesProvider =
    StateNotifierProvider<PrayerTimesNotifier, PrayerTimesState>(
  (ref) => PrayerTimesNotifier(),
);
