// Константы для расчёта времени намаза
// Используются астрономические формулы

/// Методы расчёта времени намаза.
/// Различные исламские организации используют разные углы.
enum CalculationMethod {
  /// Российский муфтият (часто используется)
  russia(fajrAngle: 15.0, ishaAngle: 15.0, name: 'Россия'),

  /// Мусульманская Мировая Лига
  mwl(fajrAngle: 18.0, ishaAngle: 17.0, name: 'MWL'),

  /// Египетское Управление Обследований
  egyptian(fajrAngle: 19.5, ishaAngle: 17.5, name: 'Египетский'),

  /// Университет Умм Аль-Кура (Мекка)
  ummAlQura(fajrAngle: 18.5, ishaAngle: 90.0, name: 'Умм Аль-Кура'),

  /// Исламское Общество Северной Америки
  isna(fajrAngle: 15.0, ishaAngle: 15.0, name: 'ISNA'),

  /// Духовное Управление Мусульман России
  dumr(fajrAngle: 16.0, ishaAngle: 15.0, name: 'ДУМР');

  const CalculationMethod({
    required this.fajrAngle,
    required this.ishaAngle,
    required this.name,
  });

  /// Угол солнца для Фаджр (утренней молитвы)
  final double fajrAngle;

  /// Угол солнца для Иша (ночной молитвы)
  final double ishaAngle;

  /// Отображаемое имя метода
  final String name;
}

/// Юридическая школа для расчёта Аср
enum AsrJuristic {
  /// Стандартный (Шафии, Малики, Ханбали) — тень = длина предмета
  standard(factor: 1, name: 'Шафии'),

  /// Ханафи — тень = 2 × длина предмета
  hanafi(factor: 2, name: 'Ханафи');

  const AsrJuristic({required this.factor, required this.name});

  final int factor;
  final String name;
}

/// Названия молитв на русском и арабском
class PrayerNames {
  PrayerNames._();

  static const Map<String, String> russian = {
    'fajr': 'Фаджр',
    'sunrise': 'Восход',
    'dhuhr': 'Зухр',
    'asr': 'Аср',
    'maghrib': 'Магриб',
    'isha': 'Иша',
  };

  static const Map<String, String> arabic = {
    'fajr': 'الفجر',
    'sunrise': 'الشروق',
    'dhuhr': 'الظهر',
    'asr': 'العصر',
    'maghrib': 'المغرب',
    'isha': 'العشاء',
  };
}
