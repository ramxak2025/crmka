// Калькулятор направления Киблы
// Использует формулу большого круга для расчёта азимута к Мекке

import 'dart:math';
import 'package:noor_muslim/core/constants/api_constants.dart';

/// Рассчитывает направление к Каабе (Кибла) из любой точки мира.
/// Использует формулу сферической тригонометрии.
class QiblaCalculator {
  QiblaCalculator._();

  /// Рассчитать азимут Киблы в градусах от севера (по часовой стрелке).
  ///
  /// [latitude] — широта пользователя
  /// [longitude] — долгота пользователя
  ///
  /// Возвращает угол в градусах (0° = Север, 90° = Восток, 180° = Юг, 270° = Запад)
  static double calculate({
    required double latitude,
    required double longitude,
  }) {
    // Координаты Мекки (Кааба)
    final meccaLat = _degToRad(ApiConstants.meccaLatitude);
    final meccaLon = _degToRad(ApiConstants.meccaLongitude);

    // Координаты пользователя
    final lat = _degToRad(latitude);
    final lon = _degToRad(longitude);

    // Разница долгот
    final deltaLon = meccaLon - lon;

    // Формула большого круга для расчёта азимута
    final y = sin(deltaLon);
    final x = cos(lat) * tan(meccaLat) - sin(lat) * cos(deltaLon);

    // Азимут в градусах
    var qibla = _radToDeg(atan2(y, x));

    // Нормализуем в диапазон 0°-360°
    qibla = (qibla + 360) % 360;

    return qibla;
  }

  /// Рассчитать расстояние до Мекки в километрах
  /// Используется формула Гаверсинуса
  static double distanceToMecca({
    required double latitude,
    required double longitude,
  }) {
    const earthRadius = 6371.0; // Радиус Земли в км

    final lat1 = _degToRad(latitude);
    final lon1 = _degToRad(longitude);
    final lat2 = _degToRad(ApiConstants.meccaLatitude);
    final lon2 = _degToRad(ApiConstants.meccaLongitude);

    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double _degToRad(double deg) => deg * pi / 180.0;
  static double _radToDeg(double rad) => rad * 180.0 / pi;
}
