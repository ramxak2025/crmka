// Модель хадиса
// Хранит текст хадиса, источник и степень достоверности

import 'package:equatable/equatable.dart';

/// Модель хадиса (изречение пророка Мухаммада, мир ему).
class HadithModel extends Equatable {
  /// Уникальный идентификатор
  final int id;

  /// Текст хадиса на арабском
  final String textArabic;

  /// Перевод на русский язык
  final String textRussian;

  /// Цепочка передатчиков (иснад) — кто передал хадис
  final String narrator;

  /// Источник (сборник)
  final HadithCollection collection;

  /// Степень достоверности
  final HadithGrade grade;

  /// Номер хадиса в сборнике
  final String reference;

  /// Тема / раздел
  final String? topic;

  const HadithModel({
    required this.id,
    required this.textArabic,
    required this.textRussian,
    required this.narrator,
    required this.collection,
    required this.grade,
    required this.reference,
    this.topic,
  });

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(
      id: json['id'] as int,
      textArabic: json['text_arabic'] as String,
      textRussian: json['text_russian'] as String,
      narrator: json['narrator'] as String,
      collection: HadithCollection.fromString(json['collection'] as String),
      grade: HadithGrade.fromString(json['grade'] as String),
      reference: json['reference'] as String,
      topic: json['topic'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text_arabic': textArabic,
      'text_russian': textRussian,
      'narrator': narrator,
      'collection': collection.key,
      'grade': grade.key,
      'reference': reference,
      'topic': topic,
    };
  }

  @override
  List<Object?> get props => [id, textArabic, collection, reference];
}

/// Сборники достоверных хадисов
enum HadithCollection {
  /// Сахих аль-Бухари — самый достоверный сборник
  bukhari(key: 'bukhari', nameRussian: 'Сахих аль-Бухари', nameArabic: 'صحيح البخاري'),

  /// Сахих Муслим — второй по достоверности
  muslim(key: 'muslim', nameRussian: 'Сахих Муслим', nameArabic: 'صحيح مسلم'),

  /// Сунан Абу Дауд
  abuDawud(key: 'abu_dawud', nameRussian: 'Сунан Абу Дауд', nameArabic: 'سنن أبي داود'),

  /// Джами ат-Тирмизи
  tirmidhi(key: 'tirmidhi', nameRussian: 'Джами ат-Тирмизи', nameArabic: 'جامع الترمذي'),

  /// Сунан ан-Насаи
  nasai(key: 'nasai', nameRussian: 'Сунан ан-Насаи', nameArabic: 'سنن النسائي'),

  /// Сунан Ибн Маджа
  ibnMajah(key: 'ibn_majah', nameRussian: 'Сунан Ибн Маджа', nameArabic: 'سنن ابن ماجه');

  const HadithCollection({
    required this.key,
    required this.nameRussian,
    required this.nameArabic,
  });

  final String key;
  final String nameRussian;
  final String nameArabic;

  /// Создание из строки
  static HadithCollection fromString(String value) {
    return HadithCollection.values.firstWhere(
      (c) => c.key == value,
      orElse: () => HadithCollection.bukhari,
    );
  }
}

/// Степень достоверности хадиса
enum HadithGrade {
  /// Достоверный (самая высокая степень)
  sahih(key: 'sahih', nameRussian: 'Достоверный (Сахих)'),

  /// Хороший
  hasan(key: 'hasan', nameRussian: 'Хороший (Хасан)'),

  /// Слабый (не используется для извлечения правовых норм)
  daif(key: 'daif', nameRussian: 'Слабый (Даиф)');

  const HadithGrade({required this.key, required this.nameRussian});

  final String key;
  final String nameRussian;

  static HadithGrade fromString(String value) {
    return HadithGrade.values.firstWhere(
      (g) => g.key == value,
      orElse: () => HadithGrade.sahih,
    );
  }
}
