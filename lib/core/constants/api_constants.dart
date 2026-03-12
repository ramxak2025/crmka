// Константы API для работы с бекендом и внешними сервисами

/// URL-адреса API и ключи конфигурации
class ApiConstants {
  ApiConstants._();

  /// Базовый URL нашего FastAPI бекенда (локально на MacBook)
  static const String baseUrl = 'http://localhost:8000/api/v1';

  /// Таймаут для сетевых запросов (в миллисекундах)
  static const int connectionTimeout = 15000;
  static const int receiveTimeout = 15000;

  // === Эндпоинты Корана ===
  static const String quranSurahs = '/quran/surahs';
  static const String quranAyahs = '/quran/surahs/{surahId}/ayahs';
  static const String quranTafsir = '/quran/tafsir/{surahId}/{ayahId}';
  static const String quranSearch = '/quran/search';

  // === Эндпоинты Хадисов ===
  static const String hadithCollections = '/hadith/collections';
  static const String hadithList = '/hadith/collections/{collectionId}';
  static const String hadithDetail = '/hadith/{hadithId}';
  static const String hadithRandom = '/hadith/random';
  static const String hadithSearch = '/hadith/search';

  // === Эндпоинты обучения арабскому ===
  static const String arabicAlphabet = '/arabic/alphabet';
  static const String arabicLetter = '/arabic/alphabet/{order}';
  static const String arabicDiacritics = '/arabic/diacritics';
  static const String arabicTajweed = '/arabic/tajweed';
  static const String arabicTajweedRule = '/arabic/tajweed/{ruleId}';
  static const String arabicCurriculum = '/arabic/curriculum';

  // === Координаты Мекки (Кааба) ===
  static const double meccaLatitude = 21.4225;
  static const double meccaLongitude = 39.8262;
}
