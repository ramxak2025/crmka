// Калькулятор времени намаза
// Использует астрономические формулы для точного расчёта

import 'dart:math';
import 'package:noor_muslim/core/constants/prayer_constants.dart';
import 'package:noor_muslim/models/prayer_times_model.dart';

/// Рассчитывает время намаза по координатам и дате.
/// Алгоритм основан на положении солнца относительно горизонта.
class PrayerTimeCalculator {
  final CalculationMethod method;
  final AsrJuristic asrJuristic;

  PrayerTimeCalculator({
    this.method = CalculationMethod.russia,
    this.asrJuristic = AsrJuristic.standard,
  });

  /// Главный метод: рассчитать все времена намаза
  PrayerTimesModel calculate({
    required double latitude,
    required double longitude,
    required DateTime date,
    double elevation = 0,
  }) {
    // Юлианская дата для астрономических расчётов
    final julianDate = _gregorianToJulian(date);

    // Уравнение времени и склонение солнца
    final sunPosition = _sunPosition(julianDate);
    final eqTime = sunPosition['equation']!;
    final declination = sunPosition['declination']!;

    // Полдень (Зухр)
    final dhuhr = _computeMidDay(eqTime, longitude);

    // Фаджр — утренняя молитва (до восхода)
    final fajr = dhuhr - _hourAngle(method.fajrAngle, latitude, declination) / 15.0;

    // Восход солнца
    final sunrise = dhuhr - _hourAngle(0.833 + 0.0347 * sqrt(elevation), latitude, declination) / 15.0;

    // Аср — послеполуденная молитва
    final asr = dhuhr + _asrTime(latitude, declination) / 15.0;

    // Магриб — вечерняя молитва (после заката)
    final sunset = dhuhr + _hourAngle(0.833 + 0.0347 * sqrt(elevation), latitude, declination) / 15.0;
    final maghrib = sunset;

    // Иша — ночная молитва
    double isha;
    if (method == CalculationMethod.ummAlQura) {
      // Умм Аль-Кура: 90 минут после Магриба
      isha = maghrib + 90.0 / 60.0;
    } else {
      isha = dhuhr + _hourAngle(method.ishaAngle, latitude, declination) / 15.0;
    }

    return PrayerTimesModel(
      fajr: _hoursToDateTime(date, fajr),
      sunrise: _hoursToDateTime(date, sunrise),
      dhuhr: _hoursToDateTime(date, dhuhr),
      asr: _hoursToDateTime(date, asr),
      maghrib: _hoursToDateTime(date, maghrib),
      isha: _hoursToDateTime(date, isha),
      date: date,
      method: method,
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Конвертация григорианской даты в юлианскую
  double _gregorianToJulian(DateTime date) {
    int y = date.year;
    int m = date.month;
    final d = date.day;

    if (m <= 2) {
      y -= 1;
      m += 12;
    }

    final a = (y / 100).floor();
    final b = 2 - a + (a / 4).floor();

    return (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        d +
        b -
        1524.5;
  }

  /// Расчёт позиции солнца (уравнение времени и склонение)
  Map<String, double> _sunPosition(double julianDate) {
    final d = julianDate - 2451545.0; // Дни с J2000.0

    // Средняя аномалия солнца
    final g = _fixAngle(357.529 + 0.98560028 * d);
    // Средняя долгота солнца
    final q = _fixAngle(280.459 + 0.98564736 * d);
    // Эклиптическая долгота
    final l = _fixAngle(q + 1.915 * _sin(g) + 0.020 * _sin(2 * g));

    // Наклон эклиптики
    final e = 23.439 - 0.00000036 * d;

    // Склонение солнца
    final declination = _arcsin(_sin(e) * _sin(l));

    // Прямое восхождение
    var ra = _arctan2(_cos(e) * _sin(l), _cos(l)) / 15.0;
    ra = _fixHour(ra);

    // Уравнение времени
    final equation = q / 15.0 - ra;

    return {
      'equation': equation,
      'declination': declination,
    };
  }

  /// Полдень — солнце в зените
  double _computeMidDay(double equationOfTime, double longitude) {
    final t = _fixHour(12 - equationOfTime);
    return t - longitude / 15.0;
  }

  /// Часовой угол солнца для заданного угла
  double _hourAngle(double angle, double latitude, double declination) {
    final cosHA = (-_sin(angle) - _sin(latitude) * _sin(declination)) /
        (_cos(latitude) * _cos(declination));

    // Clamp для высоких широт, где солнце не достигает нужного угла
    return _arccos(cosHA.clamp(-1.0, 1.0));
  }

  /// Время Аср в зависимости от мазхаба
  double _asrTime(double latitude, double declination) {
    final a = _arctan(1.0 / (asrJuristic.factor + _tan((latitude - declination).abs())));
    return _hourAngle(90 - a, latitude, declination);
  }

  /// Конвертация часов в DateTime
  DateTime _hoursToDateTime(DateTime date, double hours) {
    final h = _fixHour(hours + date.timeZoneOffset.inHours);
    final totalMinutes = (h * 60).round();
    final hour = totalMinutes ~/ 60;
    final minute = totalMinutes % 60;

    return DateTime(date.year, date.month, date.day, hour.clamp(0, 23), minute.clamp(0, 59));
  }

  // === Математические хелперы ===

  double _sin(double deg) => sin(_degToRad(deg));
  double _cos(double deg) => cos(_degToRad(deg));
  double _tan(double deg) => tan(_degToRad(deg));
  double _arcsin(double x) => _radToDeg(asin(x));
  double _arccos(double x) => _radToDeg(acos(x));
  double _arctan(double x) => _radToDeg(atan(x));
  double _arctan2(double y, double x) => _radToDeg(atan2(y, x));

  double _degToRad(double deg) => deg * pi / 180.0;
  double _radToDeg(double rad) => rad * 180.0 / pi;

  double _fixAngle(double a) => a - 360.0 * (a / 360.0).floor();
  double _fixHour(double h) {
    if (h.isNaN || h.isInfinite) return 0.0;
    return h - 24.0 * (h / 24.0).floor();
  }
}
