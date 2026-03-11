// Провайдер компаса Киблы (Riverpod)
// Управляет данными компаса и направления к Мекке

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:noor_muslim/core/utils/qibla_calculator.dart';
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

  const QiblaState({
    this.qiblaDirection = 0,
    this.compassHeading = 0,
    this.distanceToMecca = 0,
    this.isLoading = true,
    this.error,
    this.latitude = 0,
    this.longitude = 0,
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
  }) {
    return QiblaState(
      qiblaDirection: qiblaDirection ?? this.qiblaDirection,
      compassHeading: compassHeading ?? this.compassHeading,
      distanceToMecca: distanceToMecca ?? this.distanceToMecca,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
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

      final hasPermission = await _locationService.requestPermission();
      if (!hasPermission) {
        state = state.copyWith(
          isLoading: false,
          error: 'Для определения Киблы нужен доступ к геолокации',
        );
        return;
      }

      final position = await _locationService.getCurrentPosition();
      final qiblaDirection = QiblaCalculator.calculate(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      final distance = QiblaCalculator.distanceToMecca(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      state = state.copyWith(
        qiblaDirection: qiblaDirection,
        distanceToMecca: distance,
        latitude: position.latitude,
        longitude: position.longitude,
        isLoading: false,
      );

      // Подписываемся на обновления компаса
      _startCompass();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Ошибка инициализации компаса: $e',
      );
    }
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
        state = state.copyWith(error: 'Компас недоступен на этом устройстве');
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
