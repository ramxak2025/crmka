// Тесты калькулятора времени намаза
// Проверяем точность расчётов для разных городов

import 'package:flutter_test/flutter_test.dart';
import 'package:noor_muslim/core/constants/prayer_constants.dart';
import 'package:noor_muslim/core/utils/prayer_time_calculator.dart';

void main() {
  group('PrayerTimeCalculator — Калькулятор времени намаза', () {
    late PrayerTimeCalculator calculator;

    setUp(() {
      calculator = PrayerTimeCalculator(
        method: CalculationMethod.russia,
        asrJuristic: AsrJuristic.standard,
      );
    });

    test('должен создаваться с параметрами по умолчанию', () {
      final calc = PrayerTimeCalculator();
      expect(calc.method, equals(CalculationMethod.russia));
      expect(calc.asrJuristic, equals(AsrJuristic.standard));
    });

    test('должен рассчитывать время намаза для Москвы', () {
      // Москва: 55.7558° с.ш., 37.6173° в.д.
      final result = calculator.calculate(
        latitude: 55.7558,
        longitude: 37.6173,
        date: DateTime(2024, 3, 15),
      );

      // Проверяем что все времена присутствуют
      expect(result.fajr, isNotNull);
      expect(result.sunrise, isNotNull);
      expect(result.dhuhr, isNotNull);
      expect(result.asr, isNotNull);
      expect(result.maghrib, isNotNull);
      expect(result.isha, isNotNull);

      // Фаджр должен быть до восхода
      expect(result.fajr.isBefore(result.sunrise), isTrue);

      // Восход до Зухра
      expect(result.sunrise.isBefore(result.dhuhr), isTrue);

      // Зухр до Аср
      expect(result.dhuhr.isBefore(result.asr), isTrue);

      // Аср до Магриба
      expect(result.asr.isBefore(result.maghrib), isTrue);

      // Магриб до Иша
      expect(result.maghrib.isBefore(result.isha), isTrue);
    });

    test('должен рассчитывать время для Мекки', () {
      // Мекка: 21.4225° с.ш., 39.8262° в.д.
      final result = calculator.calculate(
        latitude: 21.4225,
        longitude: 39.8262,
        date: DateTime(2024, 6, 15),
      );

      // Порядок молитв должен быть правильным
      expect(result.fajr.isBefore(result.sunrise), isTrue);
      expect(result.sunrise.isBefore(result.dhuhr), isTrue);
      expect(result.dhuhr.isBefore(result.asr), isTrue);
      expect(result.asr.isBefore(result.maghrib), isTrue);

      // Зухр в Мекке должен быть около полудня (11-13 часов)
      expect(result.dhuhr.hour, greaterThanOrEqualTo(11));
      expect(result.dhuhr.hour, lessThanOrEqualTo(13));
    });

    test('должен правильно работать с методом Ханафи для Аср', () {
      final hanafiCalc = PrayerTimeCalculator(
        method: CalculationMethod.russia,
        asrJuristic: AsrJuristic.hanafi,
      );

      final standardResult = calculator.calculate(
        latitude: 55.7558,
        longitude: 37.6173,
        date: DateTime(2024, 6, 15),
      );

      final hanafiResult = hanafiCalc.calculate(
        latitude: 55.7558,
        longitude: 37.6173,
        date: DateTime(2024, 6, 15),
      );

      // Аср по Ханафи позже чем по стандартному методу
      expect(hanafiResult.asr.isAfter(standardResult.asr), isTrue);
    });

    test('должен рассчитывать для разных методов расчёта', () {
      for (final method in CalculationMethod.values) {
        final calc = PrayerTimeCalculator(method: method);
        final result = calc.calculate(
          latitude: 55.7558,
          longitude: 37.6173,
          date: DateTime(2024, 3, 15),
        );

        // Базовый порядок должен соблюдаться для всех методов
        expect(result.fajr.isBefore(result.sunrise), isTrue,
            reason: 'Ошибка для метода ${method.name}');
        expect(result.sunrise.isBefore(result.dhuhr), isTrue,
            reason: 'Ошибка для метода ${method.name}');
      }
    });

    test('должен сохранять координаты и метод в результате', () {
      final result = calculator.calculate(
        latitude: 55.7558,
        longitude: 37.6173,
        date: DateTime(2024, 3, 15),
      );

      expect(result.latitude, equals(55.7558));
      expect(result.longitude, equals(37.6173));
      expect(result.method, equals(CalculationMethod.russia));
    });
  });
}
