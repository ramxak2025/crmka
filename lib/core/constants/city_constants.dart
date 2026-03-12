// База городов с координатами для ручного выбора местоположения
// Используется для расчёта времени намаза и Киблы без GPS

/// Модель города с координатами
class CityData {
  final String name;
  final String country;
  final double latitude;
  final double longitude;

  const CityData({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  String get displayName => '$name, $country';

  /// Сериализация для сохранения в SharedPreferences
  Map<String, dynamic> toJson() => {
        'name': name,
        'country': country,
        'latitude': latitude,
        'longitude': longitude,
      };

  factory CityData.fromJson(Map<String, dynamic> json) => CityData(
        name: json['name'] as String,
        country: json['country'] as String,
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
      );
}

/// Список городов, сгруппированных по странам
class CityDatabase {
  CityDatabase._();

  static const List<CityData> cities = [
    // === Россия ===
    CityData(name: 'Москва', country: 'Россия', latitude: 55.7558, longitude: 37.6173),
    CityData(name: 'Санкт-Петербург', country: 'Россия', latitude: 59.9343, longitude: 30.3351),
    CityData(name: 'Казань', country: 'Россия', latitude: 55.7961, longitude: 49.1064),
    CityData(name: 'Уфа', country: 'Россия', latitude: 54.7388, longitude: 55.9721),
    CityData(name: 'Грозный', country: 'Россия', latitude: 43.3177, longitude: 45.6947),
    CityData(name: 'Махачкала', country: 'Россия', latitude: 42.9849, longitude: 47.5047),
    CityData(name: 'Нижний Новгород', country: 'Россия', latitude: 56.2965, longitude: 43.9361),
    CityData(name: 'Екатеринбург', country: 'Россия', latitude: 56.8389, longitude: 60.6057),
    CityData(name: 'Новосибирск', country: 'Россия', latitude: 55.0084, longitude: 82.9357),
    CityData(name: 'Красноярск', country: 'Россия', latitude: 56.0153, longitude: 92.8932),
    CityData(name: 'Набережные Челны', country: 'Россия', latitude: 55.7437, longitude: 52.3959),
    CityData(name: 'Самара', country: 'Россия', latitude: 53.1959, longitude: 50.1002),
    CityData(name: 'Ростов-на-Дону', country: 'Россия', latitude: 47.2357, longitude: 39.7015),
    CityData(name: 'Нальчик', country: 'Россия', latitude: 43.4846, longitude: 43.6069),
    CityData(name: 'Владикавказ', country: 'Россия', latitude: 43.0248, longitude: 44.6818),
    CityData(name: 'Дербент', country: 'Россия', latitude: 42.0579, longitude: 48.2900),
    CityData(name: 'Хасавюрт', country: 'Россия', latitude: 43.2509, longitude: 46.5871),
    CityData(name: 'Ингушетия (Магас)', country: 'Россия', latitude: 43.1700, longitude: 44.8131),
    CityData(name: 'Тюмень', country: 'Россия', latitude: 57.1522, longitude: 65.5272),
    CityData(name: 'Омск', country: 'Россия', latitude: 54.9885, longitude: 73.3242),
    CityData(name: 'Челябинск', country: 'Россия', latitude: 55.1644, longitude: 61.4368),
    CityData(name: 'Пермь', country: 'Россия', latitude: 58.0105, longitude: 56.2502),
    CityData(name: 'Краснодар', country: 'Россия', latitude: 45.0353, longitude: 38.9753),
    CityData(name: 'Воронеж', country: 'Россия', latitude: 51.6720, longitude: 39.1843),
    CityData(name: 'Волгоград', country: 'Россия', latitude: 48.7080, longitude: 44.5133),
    CityData(name: 'Саратов', country: 'Россия', latitude: 51.5336, longitude: 46.0344),
    CityData(name: 'Оренбург', country: 'Россия', latitude: 51.7686, longitude: 55.0968),
    CityData(name: 'Иркутск', country: 'Россия', latitude: 52.2978, longitude: 104.2964),
    CityData(name: 'Владивосток', country: 'Россия', latitude: 43.1332, longitude: 131.9113),
    CityData(name: 'Хабаровск', country: 'Россия', latitude: 48.4802, longitude: 135.0719),

    // === Центральная Азия ===
    CityData(name: 'Ташкент', country: 'Узбекистан', latitude: 41.2995, longitude: 69.2401),
    CityData(name: 'Самарканд', country: 'Узбекистан', latitude: 39.6542, longitude: 66.9597),
    CityData(name: 'Бухара', country: 'Узбекистан', latitude: 39.7745, longitude: 64.4286),
    CityData(name: 'Наманган', country: 'Узбекистан', latitude: 40.9983, longitude: 71.6726),
    CityData(name: 'Фергана', country: 'Узбекистан', latitude: 40.3834, longitude: 71.7870),
    CityData(name: 'Алматы', country: 'Казахстан', latitude: 43.2220, longitude: 76.8512),
    CityData(name: 'Астана', country: 'Казахстан', latitude: 51.1694, longitude: 71.4491),
    CityData(name: 'Шымкент', country: 'Казахстан', latitude: 42.3417, longitude: 69.5901),
    CityData(name: 'Бишкек', country: 'Кыргызстан', latitude: 42.8746, longitude: 74.5698),
    CityData(name: 'Ош', country: 'Кыргызстан', latitude: 40.5283, longitude: 72.7985),
    CityData(name: 'Душанбе', country: 'Таджикистан', latitude: 38.5598, longitude: 68.7740),
    CityData(name: 'Ашхабад', country: 'Туркменистан', latitude: 37.9601, longitude: 58.3261),

    // === Кавказ и СНГ ===
    CityData(name: 'Баку', country: 'Азербайджан', latitude: 40.4093, longitude: 49.8671),
    CityData(name: 'Минск', country: 'Беларусь', latitude: 53.9045, longitude: 27.5615),
    CityData(name: 'Киев', country: 'Украина', latitude: 50.4501, longitude: 30.5234),

    // === Ближний Восток ===
    CityData(name: 'Мекка', country: 'Саудовская Аравия', latitude: 21.4225, longitude: 39.8262),
    CityData(name: 'Медина', country: 'Саудовская Аравия', latitude: 24.4686, longitude: 39.6142),
    CityData(name: 'Эр-Рияд', country: 'Саудовская Аравия', latitude: 24.7136, longitude: 46.6753),
    CityData(name: 'Джидда', country: 'Саудовская Аравия', latitude: 21.5433, longitude: 39.1728),
    CityData(name: 'Дубай', country: 'ОАЭ', latitude: 25.2048, longitude: 55.2708),
    CityData(name: 'Абу-Даби', country: 'ОАЭ', latitude: 24.4539, longitude: 54.3773),
    CityData(name: 'Стамбул', country: 'Турция', latitude: 41.0082, longitude: 28.9784),
    CityData(name: 'Анкара', country: 'Турция', latitude: 39.9334, longitude: 32.8597),
    CityData(name: 'Каир', country: 'Египет', latitude: 30.0444, longitude: 31.2357),
    CityData(name: 'Тегеран', country: 'Иран', latitude: 35.6892, longitude: 51.3890),
    CityData(name: 'Багдад', country: 'Ирак', latitude: 33.3152, longitude: 44.3661),
    CityData(name: 'Амман', country: 'Иордания', latitude: 31.9454, longitude: 35.9284),
    CityData(name: 'Бейрут', country: 'Ливан', latitude: 33.8938, longitude: 35.5018),
    CityData(name: 'Доха', country: 'Катар', latitude: 25.2854, longitude: 51.5310),
    CityData(name: 'Кувейт', country: 'Кувейт', latitude: 29.3759, longitude: 47.9774),

    // === Юго-Восточная Азия ===
    CityData(name: 'Джакарта', country: 'Индонезия', latitude: -6.2088, longitude: 106.8456),
    CityData(name: 'Куала-Лумпур', country: 'Малайзия', latitude: 3.1390, longitude: 101.6869),
    CityData(name: 'Исламабад', country: 'Пакистан', latitude: 33.6844, longitude: 73.0479),
    CityData(name: 'Карачи', country: 'Пакистан', latitude: 24.8607, longitude: 67.0011),
    CityData(name: 'Дакка', country: 'Бангладеш', latitude: 23.8103, longitude: 90.4125),

    // === Европа ===
    CityData(name: 'Лондон', country: 'Великобритания', latitude: 51.5074, longitude: -0.1278),
    CityData(name: 'Берлин', country: 'Германия', latitude: 52.5200, longitude: 13.4050),
    CityData(name: 'Париж', country: 'Франция', latitude: 48.8566, longitude: 2.3522),
  ];

  /// Поиск городов по названию
  static List<CityData> search(String query) {
    if (query.isEmpty) return cities;
    final lower = query.toLowerCase();
    return cities
        .where((c) =>
            c.name.toLowerCase().contains(lower) ||
            c.country.toLowerCase().contains(lower))
        .toList();
  }

  /// Получить уникальные страны
  static List<String> get countries {
    final set = <String>{};
    for (final city in cities) {
      set.add(city.country);
    }
    return set.toList();
  }
}
