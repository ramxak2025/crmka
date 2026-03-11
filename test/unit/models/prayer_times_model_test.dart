// Тесты модели времени намаза
// Проверяем методы поиска текущей и следующей молитвы

import 'package:flutter_test/flutter_test.dart';
import 'package:noor_muslim/core/constants/prayer_constants.dart';
import 'package:noor_muslim/models/prayer_times_model.dart';

void main() {
  group('PrayerTimesModel — Модель времени намаза', () {
    late PrayerTimesModel prayerTimes;

    setUp(() {
      // Создаём тестовые данные с фиксированными временами
      prayerTimes = PrayerTimesModel(
        fajr: DateTime(2024, 3, 15, 5, 30),
        sunrise: DateTime(2024, 3, 15, 7, 0),
        dhuhr: DateTime(2024, 3, 15, 12, 30),
        asr: DateTime(2024, 3, 15, 15, 45),
        maghrib: DateTime(2024, 3, 15, 18, 30),
        isha: DateTime(2024, 3, 15, 20, 0),
        date: DateTime(2024, 3, 15),
        method: CalculationMethod.russia,
        latitude: 55.7558,
        longitude: 37.6173,
      );
    });

    test('должен корректно хранить все времена молитв', () {
      expect(prayerTimes.fajr.hour, equals(5));
      expect(prayerTimes.fajr.minute, equals(30));
      expect(prayerTimes.dhuhr.hour, equals(12));
      expect(prayerTimes.maghrib.hour, equals(18));
    });

    test('getTimeByKey должен возвращать правильное время', () {
      expect(prayerTimes.getTimeByKey('fajr'), equals(prayerTimes.fajr));
      expect(prayerTimes.getTimeByKey('dhuhr'), equals(prayerTimes.dhuhr));
      expect(prayerTimes.getTimeByKey('isha'), equals(prayerTimes.isha));
    });

    test('getTimeByKey должен бросать исключение для неизвестного ключа', () {
      expect(
        () => prayerTimes.getTimeByKey('unknown'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('getNextPrayer должен находить следующую молитву', () {
      // В 6:00 утра следующая молитва — Восход
      final next = prayerTimes.getNextPrayer(DateTime(2024, 3, 15, 6, 0));
      expect(next, isNotNull);
      expect(next!.key, equals('sunrise'));

      // В 13:00 следующая — Аср
      final nextAfterDhuhr = prayerTimes.getNextPrayer(DateTime(2024, 3, 15, 13, 0));
      expect(nextAfterDhuhr, isNotNull);
      expect(nextAfterDhuhr!.key, equals('asr'));
    });

    test('getNextPrayer возвращает null когда все молитвы прошли', () {
      // В 21:00 все молитвы дня прошли
      final next = prayerTimes.getNextPrayer(DateTime(2024, 3, 15, 21, 0));
      expect(next, isNull);
    });

    test('getCurrentPrayer должен определять текущую молитву', () {
      // В 6:00 текущая — Фаджр
      expect(prayerTimes.getCurrentPrayer(DateTime(2024, 3, 15, 6, 0)), equals('fajr'));

      // В 13:00 текущая — Зухр
      expect(prayerTimes.getCurrentPrayer(DateTime(2024, 3, 15, 13, 0)), equals('dhuhr'));

      // В 19:00 текущая — Магриб
      expect(prayerTimes.getCurrentPrayer(DateTime(2024, 3, 15, 19, 0)), equals('maghrib'));
    });

    test('getCurrentPrayer возвращает null до Фаджра', () {
      // В 3:00 утра — ни одна молитва ещё не наступила
      expect(prayerTimes.getCurrentPrayer(DateTime(2024, 3, 15, 3, 0)), isNull);
    });

    test('allPrayers возвращает все 6 молитв в правильном порядке', () {
      final all = prayerTimes.allPrayers;
      expect(all.length, equals(6));
      expect(all[0].key, equals('fajr'));
      expect(all[1].key, equals('sunrise'));
      expect(all[2].key, equals('dhuhr'));
      expect(all[3].key, equals('asr'));
      expect(all[4].key, equals('maghrib'));
      expect(all[5].key, equals('isha'));
    });

    test('два объекта с одинаковыми данными должны быть равны (Equatable)', () {
      final same = PrayerTimesModel(
        fajr: DateTime(2024, 3, 15, 5, 30),
        sunrise: DateTime(2024, 3, 15, 7, 0),
        dhuhr: DateTime(2024, 3, 15, 12, 30),
        asr: DateTime(2024, 3, 15, 15, 45),
        maghrib: DateTime(2024, 3, 15, 18, 30),
        isha: DateTime(2024, 3, 15, 20, 0),
        date: DateTime(2024, 3, 15),
        method: CalculationMethod.russia,
        latitude: 55.7558,
        longitude: 37.6173,
      );

      expect(prayerTimes, equals(same));
    });
  });
}
