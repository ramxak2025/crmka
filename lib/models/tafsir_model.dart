// Модель тафсира (толкования Корана)
// Поддерживает несколько известных тафсиров на русском языке

import 'package:equatable/equatable.dart';

/// Модель тафсира — толкования аята Корана.
class TafsirModel extends Equatable {
  /// Номер суры
  final int surahNumber;

  /// Номер аята
  final int ayahNumber;

  /// Автор тафсира
  final TafsirSource source;

  /// Текст толкования на русском языке
  final String textRussian;

  const TafsirModel({
    required this.surahNumber,
    required this.ayahNumber,
    required this.source,
    required this.textRussian,
  });

  factory TafsirModel.fromJson(Map<String, dynamic> json) {
    return TafsirModel(
      surahNumber: json['surah_number'] as int,
      ayahNumber: json['ayah_number'] as int,
      source: TafsirSource.fromString(json['source'] as String),
      textRussian: json['text_russian'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surah_number': surahNumber,
      'ayah_number': ayahNumber,
      'source': source.key,
      'text_russian': textRussian,
    };
  }

  @override
  List<Object?> get props => [surahNumber, ayahNumber, source];
}

/// Доступные тафсиры (толкования)
enum TafsirSource {
  /// Тафсир ас-Саади — один из самых популярных
  saadi(
    key: 'saadi',
    nameRussian: 'Тафсир ас-Саади',
    nameArabic: 'تفسير السعدي',
    description: 'Абдуррахман ибн Насир ас-Саади. Облегчение от Великодушного и Милостивого.',
  ),

  /// Тафсир Ибн Касир — классический тафсир
  ibnKathir(
    key: 'ibn_kathir',
    nameRussian: 'Тафсир Ибн Касир',
    nameArabic: 'تفسير ابن كثير',
    description: 'Исмаил ибн Умар ибн Касир. Толкование Великого Корана.',
  ),

  /// Тафсир аль-Мунтахаб
  muntakhab(
    key: 'muntakhab',
    nameRussian: 'Аль-Мунтахаб',
    nameArabic: 'المنتخب',
    description: 'Коллективный тафсир учёных Аль-Азхара.',
  );

  const TafsirSource({
    required this.key,
    required this.nameRussian,
    required this.nameArabic,
    required this.description,
  });

  final String key;
  final String nameRussian;
  final String nameArabic;
  final String description;

  static TafsirSource fromString(String value) {
    return TafsirSource.values.firstWhere(
      (s) => s.key == value,
      orElse: () => TafsirSource.saadi,
    );
  }
}
