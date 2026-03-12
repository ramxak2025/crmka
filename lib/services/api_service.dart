// Сервис для работы с публичными API
// Коран — api.alquran.cloud, Хадисы — встроенные данные

import 'package:dio/dio.dart';
import 'package:noor_muslim/core/constants/api_constants.dart';
import 'package:noor_muslim/models/surah_model.dart';
import 'package:noor_muslim/models/hadith_model.dart';
import 'package:noor_muslim/models/tafsir_model.dart';
import 'package:noor_muslim/data/hadith_data.dart';

/// Сервис для получения данных Корана и Хадисов.
class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.quranBaseUrl,
        connectTimeout: const Duration(milliseconds: ApiConstants.connectionTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    assert(() {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: false,
      ));
      return true;
    }());
  }

  // === Коран (api.alquran.cloud) ===

  /// Получить список всех 114 сур
  Future<List<SurahModel>> getSurahs() async {
    final response = await _dio.get(ApiConstants.quranSurahs);
    final data = response.data['data'] as List;

    return data.map((json) {
      final j = json as Map<String, dynamic>;
      return SurahModel(
        number: j['number'] as int,
        nameArabic: j['name'] as String,
        nameRussian: _surahNamesRussian[j['number'] as int] ?? j['englishName'] as String,
        nameTransliteration: j['englishName'] as String,
        ayahCount: j['numberOfAyahs'] as int,
        revelationType: (j['revelationType'] as String).toLowerCase() == 'meccan'
            ? RevelationType.meccan
            : RevelationType.medinan,
      );
    }).toList();
  }

  /// Получить суру с аятами (арабский + русский перевод)
  Future<SurahModel> getSurahWithAyahs(int surahNumber) async {
    // Параллельно запрашиваем арабский текст и русский перевод
    final results = await Future.wait([
      _dio.get('/surah/$surahNumber/quran-uthmani'),
      _dio.get('/surah/$surahNumber/ru.kuliev'),
    ]);

    final arabicData = results[0].data['data'];
    final russianData = results[1].data['data'];

    final arabicAyahs = arabicData['ayahs'] as List;
    final russianAyahs = russianData['ayahs'] as List;

    final ayahs = <AyahModel>[];
    for (int i = 0; i < arabicAyahs.length; i++) {
      final ar = arabicAyahs[i] as Map<String, dynamic>;
      final ru = i < russianAyahs.length
          ? russianAyahs[i] as Map<String, dynamic>
          : null;

      ayahs.add(AyahModel(
        number: ar['numberInSurah'] as int,
        textArabic: ar['text'] as String,
        textRussian: ru?['text'] as String? ?? '',
        juz: ar['juz'] as int?,
      ));
    }

    return SurahModel(
      number: arabicData['number'] as int,
      nameArabic: arabicData['name'] as String,
      nameRussian: _surahNamesRussian[arabicData['number'] as int] ??
          arabicData['englishName'] as String,
      nameTransliteration: arabicData['englishName'] as String,
      ayahCount: ayahs.length,
      revelationType:
          (arabicData['revelationType'] as String).toLowerCase() == 'meccan'
              ? RevelationType.meccan
              : RevelationType.medinan,
      ayahs: ayahs,
    );
  }

  /// Поиск по Корану — ищем по русскому тексту локально через API
  Future<List<AyahModel>> searchQuran(String query) async {
    try {
      final response = await _dio.get('/search/$query/all/ru.kuliev');
      final data = response.data['data'];
      if (data == null) return [];

      final matches = data['matches'] as List;
      return matches.map((m) {
        final j = m as Map<String, dynamic>;
        return AyahModel(
          number: j['numberInSurah'] as int,
          textArabic: '',
          textRussian: j['text'] as String,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  // === Хадисы (встроенные данные) ===

  /// Получить случайный хадис дня
  Future<HadithModel> getRandomHadith() async {
    return HadithOfflineData.getRandomHadith();
  }

  /// Получить хадисы из сборника
  Future<List<HadithModel>> getHadithsByCollection(
    String collectionId, {
    int page = 1,
    int limit = 20,
  }) async {
    return HadithOfflineData.getByCollection(collectionId, page: page, limit: limit);
  }

  /// Поиск хадисов
  Future<List<HadithModel>> searchHadith(String query) async {
    return HadithOfflineData.search(query);
  }

  // === Тафсиры (пока без внешнего API — заглушка) ===

  Future<List<TafsirModel>> getTafsir(int surahNumber, int ayahNumber) async {
    // Тафсиры пока недоступны без бэкенда
    return [
      TafsirModel(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        source: TafsirSource.saadi,
        textRussian: 'Тафсир для этого аята будет доступен в следующем обновлении.',
      ),
    ];
  }

  /// Русские названия сур
  static const Map<int, String> _surahNamesRussian = {
    1: 'Аль-Фатиха',
    2: 'Аль-Бакара',
    3: 'Аль Имран',
    4: 'Ан-Ниса',
    5: 'Аль-Маида',
    6: 'Аль-Анам',
    7: 'Аль-Араф',
    8: 'Аль-Анфаль',
    9: 'Ат-Тауба',
    10: 'Юнус',
    11: 'Худ',
    12: 'Юсуф',
    13: 'Ар-Раад',
    14: 'Ибрахим',
    15: 'Аль-Хиджр',
    16: 'Ан-Нахль',
    17: 'Аль-Исра',
    18: 'Аль-Кахф',
    19: 'Марьям',
    20: 'Та-Ха',
    21: 'Аль-Анбия',
    22: 'Аль-Хадж',
    23: 'Аль-Муминун',
    24: 'Ан-Нур',
    25: 'Аль-Фуркан',
    26: 'Аш-Шуара',
    27: 'Ан-Намль',
    28: 'Аль-Касас',
    29: 'Аль-Анкабут',
    30: 'Ар-Рум',
    31: 'Лукман',
    32: 'Ас-Саджда',
    33: 'Аль-Ахзаб',
    34: 'Саба',
    35: 'Фатыр',
    36: 'Ясин',
    37: 'Ас-Саффат',
    38: 'Сад',
    39: 'Аз-Зумар',
    40: 'Гафир',
    41: 'Фуссылят',
    42: 'Аш-Шура',
    43: 'Аз-Зухруф',
    44: 'Ад-Духан',
    45: 'Аль-Джасия',
    46: 'Аль-Ахкаф',
    47: 'Мухаммад',
    48: 'Аль-Фатх',
    49: 'Аль-Худжурат',
    50: 'Каф',
    51: 'Аз-Зарият',
    52: 'Ат-Тур',
    53: 'Ан-Наджм',
    54: 'Аль-Камар',
    55: 'Ар-Рахман',
    56: 'Аль-Вакиа',
    57: 'Аль-Хадид',
    58: 'Аль-Муджадала',
    59: 'Аль-Хашр',
    60: 'Аль-Мумтахана',
    61: 'Ас-Сафф',
    62: 'Аль-Джумуа',
    63: 'Аль-Мунафикун',
    64: 'Ат-Тагабун',
    65: 'Ат-Талак',
    66: 'Ат-Тахрим',
    67: 'Аль-Мульк',
    68: 'Аль-Калям',
    69: 'Аль-Хакка',
    70: 'Аль-Мааридж',
    71: 'Нух',
    72: 'Аль-Джинн',
    73: 'Аль-Муззаммиль',
    74: 'Аль-Муддассир',
    75: 'Аль-Кияма',
    76: 'Аль-Инсан',
    77: 'Аль-Мурсалят',
    78: 'Ан-Наба',
    79: 'Ан-Назиат',
    80: 'Абаса',
    81: 'Ат-Таквир',
    82: 'Аль-Инфитар',
    83: 'Аль-Мутаффифин',
    84: 'Аль-Иншикак',
    85: 'Аль-Бурудж',
    86: 'Ат-Тарик',
    87: 'Аль-Аля',
    88: 'Аль-Гашия',
    89: 'Аль-Фаджр',
    90: 'Аль-Баляд',
    91: 'Аш-Шамс',
    92: 'Аль-Лейль',
    93: 'Ад-Духа',
    94: 'Аш-Шарх',
    95: 'Ат-Тин',
    96: 'Аль-Алак',
    97: 'Аль-Кадр',
    98: 'Аль-Баййина',
    99: 'Аз-Зальзаля',
    100: 'Аль-Адият',
    101: 'Аль-Кариа',
    102: 'Ат-Такасур',
    103: 'Аль-Аср',
    104: 'Аль-Хумаза',
    105: 'Аль-Филь',
    106: 'Курайш',
    107: 'Аль-Маун',
    108: 'Аль-Каусар',
    109: 'Аль-Кафирун',
    110: 'Ан-Наср',
    111: 'Аль-Масад',
    112: 'Аль-Ихлас',
    113: 'Аль-Фалак',
    114: 'Ан-Нас',
  };
}
