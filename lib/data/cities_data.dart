// Список городов для выбора местоположения
// Города России, СНГ и популярные исламские города

class CityModel {
  final String name;
  final String country;
  final double latitude;
  final double longitude;

  const CityModel({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  String get displayName => '$name, $country';
}

class CitiesData {
  CitiesData._();

  /// Поиск города по названию
  static List<CityModel> search(String query) {
    if (query.trim().isEmpty) return allCities;
    final q = query.toLowerCase();
    return allCities.where((c) =>
      c.name.toLowerCase().contains(q) ||
      c.country.toLowerCase().contains(q)
    ).toList();
  }

  static const List<CityModel> allCities = [
    // === Россия ===
    CityModel(name: 'Москва', country: 'Россия', latitude: 55.7558, longitude: 37.6173),
    CityModel(name: 'Санкт-Петербург', country: 'Россия', latitude: 59.9343, longitude: 30.3351),
    CityModel(name: 'Казань', country: 'Россия', latitude: 55.7887, longitude: 49.1221),
    CityModel(name: 'Уфа', country: 'Россия', latitude: 54.7388, longitude: 55.9721),
    CityModel(name: 'Грозный', country: 'Россия', latitude: 43.3179, longitude: 45.6981),
    CityModel(name: 'Махачкала', country: 'Россия', latitude: 42.9849, longitude: 47.5047),
    CityModel(name: 'Нижний Новгород', country: 'Россия', latitude: 56.2965, longitude: 43.9361),
    CityModel(name: 'Екатеринбург', country: 'Россия', latitude: 56.8389, longitude: 60.6057),
    CityModel(name: 'Новосибирск', country: 'Россия', latitude: 55.0084, longitude: 82.9357),
    CityModel(name: 'Челябинск', country: 'Россия', latitude: 55.1644, longitude: 61.4368),
    CityModel(name: 'Самара', country: 'Россия', latitude: 53.1959, longitude: 50.1002),
    CityModel(name: 'Ростов-на-Дону', country: 'Россия', latitude: 47.2357, longitude: 39.7015),
    CityModel(name: 'Краснодар', country: 'Россия', latitude: 45.0353, longitude: 38.9753),
    CityModel(name: 'Пермь', country: 'Россия', latitude: 58.0105, longitude: 56.2502),
    CityModel(name: 'Тюмень', country: 'Россия', latitude: 57.1522, longitude: 65.5272),
    CityModel(name: 'Набережные Челны', country: 'Россия', latitude: 55.7436, longitude: 52.3959),
    CityModel(name: 'Нальчик', country: 'Россия', latitude: 43.4981, longitude: 43.6189),
    CityModel(name: 'Владикавказ', country: 'Россия', latitude: 43.0367, longitude: 44.6678),
    CityModel(name: 'Дербент', country: 'Россия', latitude: 42.0575, longitude: 48.2901),
    CityModel(name: 'Хасавюрт', country: 'Россия', latitude: 43.2479, longitude: 46.5862),
    CityModel(name: 'Сургут', country: 'Россия', latitude: 61.2500, longitude: 73.3833),
    CityModel(name: 'Оренбург', country: 'Россия', latitude: 51.7682, longitude: 55.0969),
    CityModel(name: 'Омск', country: 'Россия', latitude: 54.9885, longitude: 73.3242),
    CityModel(name: 'Воронеж', country: 'Россия', latitude: 51.6720, longitude: 39.1843),
    CityModel(name: 'Волгоград', country: 'Россия', latitude: 48.7080, longitude: 44.5133),
    CityModel(name: 'Красноярск', country: 'Россия', latitude: 56.0153, longitude: 92.8932),
    CityModel(name: 'Астрахань', country: 'Россия', latitude: 46.3497, longitude: 48.0408),
    CityModel(name: 'Назрань', country: 'Россия', latitude: 43.2262, longitude: 44.7727),
    CityModel(name: 'Магас', country: 'Россия', latitude: 43.1681, longitude: 44.8131),

    // === Узбекистан ===
    CityModel(name: 'Ташкент', country: 'Узбекистан', latitude: 41.2995, longitude: 69.2401),
    CityModel(name: 'Самарканд', country: 'Узбекистан', latitude: 39.6542, longitude: 66.9597),
    CityModel(name: 'Бухара', country: 'Узбекистан', latitude: 39.7745, longitude: 64.4227),
    CityModel(name: 'Наманган', country: 'Узбекистан', latitude: 40.9983, longitude: 71.6726),
    CityModel(name: 'Андижан', country: 'Узбекистан', latitude: 40.7821, longitude: 72.3442),
    CityModel(name: 'Фергана', country: 'Узбекистан', latitude: 40.3842, longitude: 71.7893),

    // === Казахстан ===
    CityModel(name: 'Астана', country: 'Казахстан', latitude: 51.1694, longitude: 71.4491),
    CityModel(name: 'Алматы', country: 'Казахстан', latitude: 43.2220, longitude: 76.8512),
    CityModel(name: 'Шымкент', country: 'Казахстан', latitude: 42.3417, longitude: 69.5901),
    CityModel(name: 'Караганда', country: 'Казахстан', latitude: 49.8047, longitude: 73.1094),
    CityModel(name: 'Актобе', country: 'Казахстан', latitude: 50.2839, longitude: 57.1670),

    // === Кыргызстан ===
    CityModel(name: 'Бишкек', country: 'Кыргызстан', latitude: 42.8746, longitude: 74.5698),
    CityModel(name: 'Ош', country: 'Кыргызстан', latitude: 40.5283, longitude: 72.7985),

    // === Таджикистан ===
    CityModel(name: 'Душанбе', country: 'Таджикистан', latitude: 38.5598, longitude: 68.7738),
    CityModel(name: 'Худжанд', country: 'Таджикистан', latitude: 40.2833, longitude: 69.6333),

    // === Туркменистан ===
    CityModel(name: 'Ашхабад', country: 'Туркменистан', latitude: 37.9601, longitude: 58.3261),

    // === Азербайджан ===
    CityModel(name: 'Баку', country: 'Азербайджан', latitude: 40.4093, longitude: 49.8671),

    // === Турция ===
    CityModel(name: 'Стамбул', country: 'Турция', latitude: 41.0082, longitude: 28.9784),
    CityModel(name: 'Анкара', country: 'Турция', latitude: 39.9334, longitude: 32.8597),

    // === Священные города ===
    CityModel(name: 'Мекка', country: 'Саудовская Аравия', latitude: 21.4225, longitude: 39.8262),
    CityModel(name: 'Медина', country: 'Саудовская Аравия', latitude: 24.4539, longitude: 39.6142),

    // === ОАЭ ===
    CityModel(name: 'Дубай', country: 'ОАЭ', latitude: 25.2048, longitude: 55.2708),
    CityModel(name: 'Абу-Даби', country: 'ОАЭ', latitude: 24.4539, longitude: 54.3773),

    // === Египет ===
    CityModel(name: 'Каир', country: 'Египет', latitude: 30.0444, longitude: 31.2357),

    // === Малайзия ===
    CityModel(name: 'Куала-Лумпур', country: 'Малайзия', latitude: 3.1390, longitude: 101.6869),

    // === Германия ===
    CityModel(name: 'Берлин', country: 'Германия', latitude: 52.5200, longitude: 13.4050),

    // === Украина ===
    CityModel(name: 'Киев', country: 'Украина', latitude: 50.4501, longitude: 30.5234),

    // === Беларусь ===
    CityModel(name: 'Минск', country: 'Беларусь', latitude: 53.9006, longitude: 27.5590),
  ];
}
