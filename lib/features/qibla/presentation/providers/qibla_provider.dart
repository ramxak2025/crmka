// Провайдер компаса Киблы (Riverpod)
// Управляет данными компаса и направления к Мекке

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:noor_muslim/core/constants/city_constants.dart';
import 'package:noor_muslim/core/utils/qibla_calculator.dart';
import 'package:noor_muslim/services/city_selection_service.dart';
import 'package:noor_muslim/services/location_service.dart';

/// Состояние компаса Киблы
class QiblaState {
  /// Азимут Киблы (в градусах от севера)
  final double qiblaDirection;

  /// Текущее направление компаса (в градусах)
  final double compassHeading;

  /// Расстояние до Мекки (км)
  final double distanceToMecca;

  /// Загружается ли
  final bool isLoading;

  /// Ошибка
  final String? error;

  /// Широта пользователя
  final double latitude;

  /// Долгота пользователя
  final double longitude;

  /// Название города
  final String cityName;

  /// Выбранный город
  final CityData? selectedCity;

  const QiblaState({
    this.qiblaDirection = 0,
    this.compassHeading = 0,
    this.distanceToMecca = 0,
    this.isLoading = true,
    this.error,
    this.latitude = 0,
    this.longitude = 0,
    this.cityName = '',
    this.selectedCity,
  });

  /// Угол поворота стрелки Киблы на компасе
  /// Учитывает текущее направление устройства
  double get qiblaAngleOnCompass => qiblaDirection - compassHeading;

  QiblaState copyWith({
    double? qiblaDirection,
    double? compassHeading,
    double? distanceToMecca,
    bool? isLoading,
    String? error,
    double? latitude,
    double? longitude,
    String? cityName,
    CityData? selectedCity,
  }) {
    return QiblaState(
      qiblaDirection: qiblaDirection ?? this.qiblaDirection,
      compassHeading: compassHeading ?? this.compassHeading,
      distanceToMecca: distanceToMecca ?? this.distanceToMecca,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cityName: cityName ?? this.cityName,
      selectedCity: selectedCity ?? this.selectedCity,
    );
  }
}

/// Управление состоянием компаса Киблы
class QiblaNotifier extends StateNotifier<QiblaState> {
  final LocationService _locationService;
  StreamSubscription? _compassSubscription;

  QiblaNotifier({LocationService? locationService})
      : _locationService = locationService ?? LocationService(),
        super(const QiblaState()) {
    _initialize();
  }

  /// Инициализация: получить местоположение и запустить компас
  Future<void> _initialize() async {
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
        _startCompass();
        return;
      }

      // Пробуем GPS
      final hasPermission = await _locationService.requestPermission();
      if (!hasPermission) {
        // Без GPS — используем Москву, но показываем подсказку
        _calculateForCoordinates(55.7558, 37.6173, 'Москва', null);
        _startCompass();
        return;
      }

      final position = await _locationService.getCurrentPosition();
      _calculateForCoordinates(
        position.latitude,
        position.longitude,
        'Текущее местоположение',
        null,
      );
      _startCompass();
    } catch (e) {
      // При ошибке GPS — используем сохранённый город или Москву
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
      _startCompass();
    }
  }

  /// Рассчитать направление Киблы для координат
  void _calculateForCoordinates(
    double lat,
    double lon,
    String city,
    CityData? cityData,
  ) {
    final qiblaDirection = QiblaCalculator.calculate(
      latitude: lat,
      longitude: lon,
    );
    final distance = QiblaCalculator.distanceToMecca(
      latitude: lat,
      longitude: lon,
    );

    state = state.copyWith(
      qiblaDirection: qiblaDirection,
      distanceToMecca: distance,
      latitude: lat,
      longitude: lon,
      cityName: city,
      selectedCity: cityData,
      isLoading: false,
    );
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

  /// Запустить слушатель компаса
  void _startCompass() {
    _compassSubscription = FlutterCompass.events?.listen(
      (event) {
        if (event.heading != null) {
          state = state.copyWith(compassHeading: event.heading!);
        }
      },
      onError: (error) {
        // Компас недоступен — не критичная ошибка, направление всё равно показываем
      },
    );
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    super.dispose();
  }
}

/// Riverpod провайдер для компаса Киблы
final qiblaProvider = StateNotifierProvider<QiblaNotifier, QiblaState>(
  (ref) => QiblaNotifier(),
);
