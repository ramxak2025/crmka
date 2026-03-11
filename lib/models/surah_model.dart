// Модель суры Корана
// Хранит информацию о суре и её аятах

import 'package:equatable/equatable.dart';

/// Модель суры (главы) Корана.
class SurahModel extends Equatable {
  /// Номер суры (1-114)
  final int number;

  /// Название на арабском
  final String nameArabic;

  /// Название на русском
  final String nameRussian;

  /// Транслитерация названия
  final String nameTransliteration;

  /// Количество аятов (стихов)
  final int ayahCount;

  /// Место ниспослания: Мекка или Медина
  final RevelationType revelationType;

  /// Список аятов (может быть пустым до загрузки)
  final List<AyahModel> ayahs;

  const SurahModel({
    required this.number,
    required this.nameArabic,
    required this.nameRussian,
    required this.nameTransliteration,
    required this.ayahCount,
    required this.revelationType,
    this.ayahs = const [],
  });

  /// Создание из JSON ответа API
  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'] as int,
      nameArabic: json['name_arabic'] as String,
      nameRussian: json['name_russian'] as String,
      nameTransliteration: json['name_transliteration'] as String,
      ayahCount: json['ayah_count'] as int,
      revelationType: json['revelation_type'] == 'meccan'
          ? RevelationType.meccan
          : RevelationType.medinan,
      ayahs: (json['ayahs'] as List<dynamic>?)
              ?.map((a) => AyahModel.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Конвертация в JSON
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name_arabic': nameArabic,
      'name_russian': nameRussian,
      'name_transliteration': nameTransliteration,
      'ayah_count': ayahCount,
      'revelation_type': revelationType == RevelationType.meccan ? 'meccan' : 'medinan',
    };
  }

  @override
  List<Object?> get props => [number, nameArabic, nameRussian];
}

/// Место ниспослания суры
enum RevelationType {
  /// Мекканская сура
  meccan,

  /// Мединская сура
  medinan,
}

/// Модель аята (стиха) Корана
class AyahModel extends Equatable {
  /// Номер аята в суре
  final int number;

  /// Текст на арабском языке
  final String textArabic;

  /// Перевод на русский язык
  final String textRussian;

  /// Транслитерация
  final String? transliteration;

  /// Номер джуза (части Корана)
  final int? juz;

  const AyahModel({
    required this.number,
    required this.textArabic,
    required this.textRussian,
    this.transliteration,
    this.juz,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      number: json['number'] as int,
      textArabic: json['text_arabic'] as String,
      textRussian: json['text_russian'] as String,
      transliteration: json['transliteration'] as String?,
      juz: json['juz'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'text_arabic': textArabic,
      'text_russian': textRussian,
      'transliteration': transliteration,
      'juz': juz,
    };
  }

  @override
  List<Object?> get props => [number, textArabic, textRussian];
}
