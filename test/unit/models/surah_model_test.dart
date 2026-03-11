// Тесты модели суры Корана
// Проверяем сериализацию/десериализацию JSON

import 'package:flutter_test/flutter_test.dart';
import 'package:noor_muslim/models/surah_model.dart';

void main() {
  group('SurahModel — Модель суры Корана', () {
    test('должна создаваться из JSON', () {
      final json = {
        'number': 1,
        'name_arabic': 'الفاتحة',
        'name_russian': 'Открывающая',
        'name_transliteration': 'Аль-Фатиха',
        'ayah_count': 7,
        'revelation_type': 'meccan',
        'ayahs': [
          {
            'number': 1,
            'text_arabic': 'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَـٰنِ ٱلرَّحِیمِ',
            'text_russian': 'Во имя Аллаха, Милостивого, Милосердного!',
          },
        ],
      };

      final surah = SurahModel.fromJson(json);

      expect(surah.number, equals(1));
      expect(surah.nameArabic, equals('الفاتحة'));
      expect(surah.nameRussian, equals('Открывающая'));
      expect(surah.ayahCount, equals(7));
      expect(surah.revelationType, equals(RevelationType.meccan));
      expect(surah.ayahs.length, equals(1));
    });

    test('должна конвертироваться в JSON', () {
      const surah = SurahModel(
        number: 2,
        nameArabic: 'البقرة',
        nameRussian: 'Корова',
        nameTransliteration: 'Аль-Бакара',
        ayahCount: 286,
        revelationType: RevelationType.medinan,
      );

      final json = surah.toJson();

      expect(json['number'], equals(2));
      expect(json['name_arabic'], equals('البقرة'));
      expect(json['revelation_type'], equals('medinan'));
    });

    test('должна создаваться без аятов', () {
      const surah = SurahModel(
        number: 114,
        nameArabic: 'الناس',
        nameRussian: 'Люди',
        nameTransliteration: 'Ан-Нас',
        ayahCount: 6,
        revelationType: RevelationType.meccan,
      );

      expect(surah.ayahs, isEmpty);
    });
  });

  group('AyahModel — Модель аята Корана', () {
    test('должна создаваться из JSON', () {
      final json = {
        'number': 1,
        'text_arabic': 'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَـٰنِ ٱلرَّحِیمِ',
        'text_russian': 'Во имя Аллаха, Милостивого, Милосердного!',
        'transliteration': 'Бисмилляхи р-Рахмани р-Рахим',
        'juz': 1,
      };

      final ayah = AyahModel.fromJson(json);

      expect(ayah.number, equals(1));
      expect(ayah.textArabic, contains('بِسۡمِ'));
      expect(ayah.textRussian, contains('Аллаха'));
      expect(ayah.juz, equals(1));
    });

    test('должна работать без опциональных полей', () {
      final json = {
        'number': 5,
        'text_arabic': 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
        'text_russian': 'Тебе одному мы поклоняемся и Тебя одного молим о помощи.',
      };

      final ayah = AyahModel.fromJson(json);

      expect(ayah.transliteration, isNull);
      expect(ayah.juz, isNull);
    });
  });
}
