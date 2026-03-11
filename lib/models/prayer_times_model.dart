// Модель времени намаза
// Хранит все 6 времён молитвы на определённую дату

import 'package:equatable/equatable.dart';
import 'package:noor_muslim/core/constants/prayer_constants.dart';

/// Модель данных времён намаза на один день.
/// Наследует Equatable для удобного сравнения объектов.
class PrayerTimesModel extends Equatable {
  /// Фаджр — предрассветная молитва
  final DateTime fajr;

  /// Восход солнца (не молитва, но важное время)
  final DateTime sunrise;

  /// Зухр — полуденная молитва
  final DateTime dhuhr;

  /// Аср — послеполуденная молитва
  final DateTime asr;

  /// Магриб — вечерняя молитва (на закате)
  final DateTime maghrib;

  /// Иша — ночная молитва
  final DateTime isha;

  /// Дата расчёта
  final DateTime date;

  /// Метод расчёта
  final CalculationMethod method;

  /// Широта места
  final double latitude;

  /// Долгота места
  final double longitude;

  const PrayerTimesModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.date,
    required this.method,
    required this.latitude,
    required this.longitude,
  });

  /// Получить время молитвы по ключу
  DateTime getTimeByKey(String key) {
    switch (key) {
      case 'fajr':
        return fajr;
      case 'sunrise':
        return sunrise;
      case 'dhuhr':
        return dhuhr;
      case 'asr':
        return asr;
      case 'maghrib':
        return maghrib;
      case 'isha':
        return isha;
      default:
        throw ArgumentError('Неизвестный ключ молитвы: $key');
    }
  }

  /// Получить следующую молитву относительно текущего времени
  MapEntry<String, DateTime>? getNextPrayer(DateTime now) {
    final prayers = {
      'fajr': fajr,
      'sunrise': sunrise,
      'dhuhr': dhuhr,
      'asr': asr,
      'maghrib': maghrib,
      'isha': isha,
    };

    for (final entry in prayers.entries) {
      if (entry.value.isAfter(now)) {
        return entry;
      }
    }

    // Все молитвы прошли — следующая будет Фаджр завтра
    return null;
  }

  /// Получить текущую молитву (последняя наступившая)
  String? getCurrentPrayer(DateTime now) {
    final prayers = ['fajr', 'sunrise', 'dhuhr', 'asr', 'maghrib', 'isha'];
    final times = [fajr, sunrise, dhuhr, asr, maghrib, isha];

    String? current;
    for (int i = 0; i < times.length; i++) {
      if (now.isAfter(times[i]) || now.isAtSameMomentAs(times[i])) {
        current = prayers[i];
      }
    }
    return current;
  }

  /// Список всех молитв в порядке следования
  List<MapEntry<String, DateTime>> get allPrayers => [
        MapEntry('fajr', fajr),
        MapEntry('sunrise', sunrise),
        MapEntry('dhuhr', dhuhr),
        MapEntry('asr', asr),
        MapEntry('maghrib', maghrib),
        MapEntry('isha', isha),
      ];

  @override
  List<Object?> get props => [fajr, sunrise, dhuhr, asr, maghrib, isha, date, method];
}
