// Провайдер времени намаза (Riverpod)
// Управляет состоянием расчёта и отображения времён молитв

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_muslim/core/constants/prayer_constants.dart';
import 'package:noor_muslim/core/utils/prayer_time_calculator.dart';
import 'package:noor_muslim/models/prayer_times_model.dart';
import 'package:geolocator/geolocator.dart';
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

  const PrayerTimesState({
    this.prayerTimes,
    this.currentPrayer,
    this.nextPrayer,
    this.timeUntilNext,
    this.isLoading = false,
    this.error,
    this.cityName = '',
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
  }) {
    return PrayerTimesState(
      prayerTimes: prayerTimes ?? this.prayerTimes,
      currentPrayer: currentPrayer ?? this.currentPrayer,
      nextPrayer: nextPrayer ?? this.nextPrayer,
      timeUntilNext: timeUntilNext ?? this.timeUntilNext,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      cityName: cityName ?? this.cityName,
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

  /// Загрузить время намаза на основе текущего местоположения
  Future<void> _loadPrayerTimes() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Общий таймаут 8 секунд на получение геолокации
      final position = await Future.any([
        _getPositionIfAllowed(),
        Future.delayed(const Duration(seconds: 8), () => null),
      ]);

      if (position != null) {
        _calculateForCoordinates(
          position.latitude,
          position.longitude,
          'Текущее местоположение',
        );
      } else {
        // Таймаут или нет разрешения — фоллбэк на Москву
        _calculateForCoordinates(55.7558, 37.6173, 'Москва');
      }
    } catch (e) {
      // При ошибке GPS — фоллбэк на Москву
      _calculateForCoordinates(55.7558, 37.6173, 'Москва');
    }
  }

  /// Попытка получить позицию с проверкой разрешений
  Future<Position?> _getPositionIfAllowed() async {
    try {
      final hasPermission = await _locationService.requestPermission();
      if (!hasPermission) return null;
      return await _locationService.getCurrentPosition();
    } catch (_) {
      return null;
    }
  }

  /// Установить город вручную (как в Sajda)
  void setCity(String cityName, double latitude, double longitude) {
    _calculateForCoordinates(latitude, longitude, cityName);
  }

  /// Рассчитать времена для конкретных координат
  void _calculateForCoordinates(double lat, double lon, String city) {
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
