// Тесты калькулятора направления Киблы
// Проверяем точность расчёта азимута к Мекке

import 'package:flutter_test/flutter_test.dart';
import 'package:noor_muslim/core/utils/qibla_calculator.dart';

void main() {
  group('QiblaCalculator — Калькулятор направления Киблы', () {
    test('из Москвы Кибла должна быть примерно на юг-юго-восток (~168°)', () {
      // Москва: 55.7558° с.ш., 37.6173° в.д.
      final qibla = QiblaCalculator.calculate(
        latitude: 55.7558,
        longitude: 37.6173,
      );

      // Направление Киблы из Москвы ~168° (юго-юго-восток)
      expect(qibla, greaterThan(150));
      expect(qibla, lessThan(185));
    });

    test('из Нью-Йорка Кибла должна быть на северо-восток (~58°)', () {
      // Нью-Йорк: 40.7128° с.ш., -74.0060° з.д.
      final qibla = QiblaCalculator.calculate(
        latitude: 40.7128,
        longitude: -74.0060,
      );

      expect(qibla, greaterThan(45));
      expect(qibla, lessThan(75));
    });

    test('из Токио Кибла должна быть на запад-юго-запад (~293°)', () {
      // Токио: 35.6762° с.ш., 139.6503° в.д.
      final qibla = QiblaCalculator.calculate(
        latitude: 35.6762,
        longitude: 139.6503,
      );

      expect(qibla, greaterThan(280));
      expect(qibla, lessThan(310));
    });

    test('из Мекки направление должно быть ~0° (мы уже там)', () {
      final qibla = QiblaCalculator.calculate(
        latitude: 21.4225,
        longitude: 39.8262,
      );

      // Когда мы в Мекке, направление не определено чётко,
      // но значение должно быть валидным числом
      expect(qibla, greaterThanOrEqualTo(0));
      expect(qibla, lessThan(360));
    });

    test('расстояние до Мекки из Москвы ~3600 км', () {
      final distance = QiblaCalculator.distanceToMecca(
        latitude: 55.7558,
        longitude: 37.6173,
      );

      // Расстояние ~3600 км (допускаем погрешность ±200 км)
      expect(distance, greaterThan(3400));
      expect(distance, lessThan(3900));
    });

    test('расстояние из Мекки должно быть ~0 км', () {
      final distance = QiblaCalculator.distanceToMecca(
        latitude: 21.4225,
        longitude: 39.8262,
      );

      expect(distance, lessThan(1)); // Меньше 1 км
    });

    test('азимут всегда в диапазоне 0°-360°', () {
      // Проверяем для разных точек мира
      final testPoints = [
        [0.0, 0.0],       // Экватор, Гринвич
        [-33.8688, 151.2093],  // Сидней
        [64.1466, -21.9426],   // Рейкьявик
        [-22.9068, -43.1729],  // Рио-де-Жанейро
      ];

      for (final point in testPoints) {
        final qibla = QiblaCalculator.calculate(
          latitude: point[0],
          longitude: point[1],
        );

        expect(qibla, greaterThanOrEqualTo(0),
            reason: 'Негативный угол для точки $point');
        expect(qibla, lessThan(360),
            reason: 'Угол >= 360° для точки $point');
      }
    });
  });
}
