// Тесты модели тафсира
// Проверяем создание из JSON и доступные тафсиры

import 'package:flutter_test/flutter_test.dart';
import 'package:noor_muslim/models/tafsir_model.dart';

void main() {
  group('TafsirModel — Модель тафсира', () {
    test('должен создаваться из JSON', () {
      final json = {
        'surah_number': 1,
        'ayah_number': 1,
        'source': 'saadi',
        'text_russian': 'Толкование аята "Во имя Аллаха..."',
      };

      final tafsir = TafsirModel.fromJson(json);

      expect(tafsir.surahNumber, equals(1));
      expect(tafsir.ayahNumber, equals(1));
      expect(tafsir.source, equals(TafsirSource.saadi));
      expect(tafsir.textRussian, contains('Толкование'));
    });

    test('должен конвертироваться в JSON', () {
      const tafsir = TafsirModel(
        surahNumber: 2,
        ayahNumber: 255,
        source: TafsirSource.ibnKathir,
        textRussian: 'Аят аль-Курси — величайший аят Корана',
      );

      final json = tafsir.toJson();

      expect(json['surah_number'], equals(2));
      expect(json['ayah_number'], equals(255));
      expect(json['source'], equals('ibn_kathir'));
    });
  });

  group('TafsirSource — Источники тафсира', () {
    test('все источники должны иметь описания', () {
      for (final source in TafsirSource.values) {
        expect(source.nameRussian, isNotEmpty);
        expect(source.nameArabic, isNotEmpty);
        expect(source.description, isNotEmpty);
      }
    });

    test('fromString должен находить правильный источник', () {
      expect(TafsirSource.fromString('saadi'), equals(TafsirSource.saadi));
      expect(TafsirSource.fromString('ibn_kathir'), equals(TafsirSource.ibnKathir));
      expect(TafsirSource.fromString('muntakhab'), equals(TafsirSource.muntakhab));
    });

    test('fromString возвращает ас-Саади по умолчанию', () {
      expect(TafsirSource.fromString('unknown'), equals(TafsirSource.saadi));
    });
  });
}
