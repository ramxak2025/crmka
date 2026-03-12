// Константы API для работы с бекендом и внешними сервисами

/// URL-адреса API и ключи конфигурации
class ApiConstants {
  ApiConstants._();

  /// Таймаут для сетевых запросов (в миллисекундах)
  static const int connectionTimeout = 15000;
  static const int receiveTimeout = 15000;

  // === Публичный API Корана (alquran.cloud) ===
  static const String quranBaseUrl = 'https://api.alquran.cloud/v1';
  static const String quranSurahs = '/surah';
  static const String quranSurahArabic = '/surah/{surahId}/ar.alafasy';
  static const String quranSurahRussian = '/surah/{surahId}/ru.kuliev';

  // === Координаты Мекки (Кааба) ===
  static const double meccaLatitude = 21.4225;
  static const double meccaLongitude = 39.8262;
}
