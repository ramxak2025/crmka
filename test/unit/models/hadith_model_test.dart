// Тесты модели хадиса
// Проверяем создание, сериализацию и перечисления

import 'package:flutter_test/flutter_test.dart';
import 'package:noor_muslim/models/hadith_model.dart';

void main() {
  group('HadithModel — Модель хадиса', () {
    test('должен создаваться из JSON', () {
      final json = {
        'id': 1,
        'text_arabic': 'إنما الأعمال بالنيات',
        'text_russian': 'Поистине, дела оцениваются по намерениям',
        'narrator': 'Умар ибн аль-Хаттаб',
        'collection': 'bukhari',
        'grade': 'sahih',
        'reference': 'Бухари, 1',
        'topic': 'Намерения',
      };

      final hadith = HadithModel.fromJson(json);

      expect(hadith.id, equals(1));
      expect(hadith.textRussian, contains('намерениям'));
      expect(hadith.narrator, equals('Умар ибн аль-Хаттаб'));
      expect(hadith.collection, equals(HadithCollection.bukhari));
      expect(hadith.grade, equals(HadithGrade.sahih));
    });

    test('должен конвертироваться в JSON', () {
      const hadith = HadithModel(
        id: 2,
        textArabic: 'المسلم من سلم المسلمون من لسانه ويده',
        textRussian: 'Мусульманин — тот, от языка и рук которого мусульмане в безопасности',
        narrator: 'Абдуллах ибн Амр',
        collection: HadithCollection.bukhari,
        grade: HadithGrade.sahih,
        reference: 'Бухари, 10',
      );

      final json = hadith.toJson();

      expect(json['id'], equals(2));
      expect(json['collection'], equals('bukhari'));
      expect(json['grade'], equals('sahih'));
    });
  });

  group('HadithCollection — Сборники хадисов', () {
    test('все сборники должны иметь названия', () {
      for (final collection in HadithCollection.values) {
        expect(collection.nameRussian, isNotEmpty);
        expect(collection.nameArabic, isNotEmpty);
        expect(collection.key, isNotEmpty);
      }
    });

    test('fromString должен корректно парсить', () {
      expect(HadithCollection.fromString('bukhari'), equals(HadithCollection.bukhari));
      expect(HadithCollection.fromString('muslim'), equals(HadithCollection.muslim));
      expect(HadithCollection.fromString('tirmidhi'), equals(HadithCollection.tirmidhi));
    });

    test('fromString возвращает Бухари по умолчанию', () {
      expect(HadithCollection.fromString('unknown'), equals(HadithCollection.bukhari));
    });
  });

  group('HadithGrade — Степень достоверности', () {
    test('все степени должны иметь названия', () {
      for (final grade in HadithGrade.values) {
        expect(grade.nameRussian, isNotEmpty);
        expect(grade.key, isNotEmpty);
      }
    });

    test('fromString должен корректно парсить', () {
      expect(HadithGrade.fromString('sahih'), equals(HadithGrade.sahih));
      expect(HadithGrade.fromString('hasan'), equals(HadithGrade.hasan));
      expect(HadithGrade.fromString('daif'), equals(HadithGrade.daif));
    });
  });
}
