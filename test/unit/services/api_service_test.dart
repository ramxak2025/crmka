// Тесты API сервиса
// Проверяем работу с бекендом (Коран, Хадисы)

import 'package:flutter_test/flutter_test.dart';
import 'package:noor_muslim/services/api_service.dart';
import 'package:noor_muslim/models/surah_model.dart';
import 'package:noor_muslim/models/hadith_model.dart';

void main() {
  group('ApiService — Сервис работы с API', () {
    late ApiService apiService;

    setUp(() {
      apiService = ApiService(baseUrl: 'http://localhost:8000/api/v1');
    });

    test('должен создаваться с базовым URL', () {
      expect(apiService, isNotNull);
    });

    test('parseSurahList должен парсить список сур', () {
      final jsonList = [
        {
          'number': 1,
          'name_arabic': 'الفاتحة',
          'name_russian': 'Открывающая',
          'name_transliteration': 'Аль-Фатиха',
          'ayah_count': 7,
          'revelation_type': 'meccan',
        },
        {
          'number': 2,
          'name_arabic': 'البقرة',
          'name_russian': 'Корова',
          'name_transliteration': 'Аль-Бакара',
          'ayah_count': 286,
          'revelation_type': 'medinan',
        },
      ];

      final surahs = ApiService.parseSurahList(jsonList);

      expect(surahs.length, equals(2));
      expect(surahs[0].nameRussian, equals('Открывающая'));
      expect(surahs[1].ayahCount, equals(286));
    });

    test('parseHadithList должен парсить список хадисов', () {
      final jsonList = [
        {
          'id': 1,
          'text_arabic': 'إنما الأعمال بالنيات',
          'text_russian': 'Поистине, дела оцениваются по намерениям',
          'narrator': 'Умар ибн аль-Хаттаб',
          'collection': 'bukhari',
          'grade': 'sahih',
          'reference': 'Бухари, 1',
        },
      ];

      final hadiths = ApiService.parseHadithList(jsonList);

      expect(hadiths.length, equals(1));
      expect(hadiths[0].collection, equals(HadithCollection.bukhari));
    });
  });
}
