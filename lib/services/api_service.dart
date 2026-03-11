// Сервис для работы с REST API бекенда
// Отвечает за получение данных Корана, Хадисов и Тафсиров

import 'package:dio/dio.dart';
import 'package:noor_muslim/core/constants/api_constants.dart';
import 'package:noor_muslim/models/surah_model.dart';
import 'package:noor_muslim/models/hadith_model.dart';
import 'package:noor_muslim/models/tafsir_model.dart';

/// Сервис для общения с FastAPI бекендом.
/// Использует Dio для HTTP запросов с настройками таймаутов.
class ApiService {
  late final Dio _dio;

  ApiService({String? baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConstants.connectionTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Добавляем перехватчик для логирования (только в дебаг-режиме)
    assert(() {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
      return true;
    }());
  }

  // === Коран ===

  /// Получить список всех 114 сур
  Future<List<SurahModel>> getSurahs() async {
    final response = await _dio.get(ApiConstants.quranSurahs);
    return parseSurahList(response.data as List);
  }

  /// Получить аяты конкретной суры
  Future<SurahModel> getSurahWithAyahs(int surahNumber) async {
    final url = ApiConstants.quranAyahs.replaceFirst('{surahId}', '$surahNumber');
    final response = await _dio.get(url);
    return SurahModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Поиск по тексту Корана
  Future<List<AyahModel>> searchQuran(String query) async {
    final response = await _dio.get(
      ApiConstants.quranSearch,
      queryParameters: {'q': query},
    );
    return (response.data as List)
        .map((a) => AyahModel.fromJson(a as Map<String, dynamic>))
        .toList();
  }

  // === Хадисы ===

  /// Получить список сборников хадисов
  Future<List<Map<String, dynamic>>> getHadithCollections() async {
    final response = await _dio.get(ApiConstants.hadithCollections);
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  /// Получить хадисы из конкретного сборника
  Future<List<HadithModel>> getHadithsByCollection(
    String collectionId, {
    int page = 1,
    int limit = 20,
  }) async {
    final url = ApiConstants.hadithList.replaceFirst('{collectionId}', collectionId);
    final response = await _dio.get(url, queryParameters: {
      'page': page,
      'limit': limit,
    });
    return parseHadithList(response.data as List);
  }

  /// Получить случайный хадис дня
  Future<HadithModel> getRandomHadith() async {
    final response = await _dio.get(ApiConstants.hadithRandom);
    return HadithModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Поиск хадисов по тексту
  Future<List<HadithModel>> searchHadith(String query) async {
    final response = await _dio.get(
      ApiConstants.hadithSearch,
      queryParameters: {'q': query},
    );
    return parseHadithList(response.data as List);
  }

  // === Тафсиры ===

  /// Получить тафсир для конкретного аята
  Future<List<TafsirModel>> getTafsir(int surahNumber, int ayahNumber) async {
    final url = ApiConstants.quranTafsir
        .replaceFirst('{surahId}', '$surahNumber')
        .replaceFirst('{ayahId}', '$ayahNumber');
    final response = await _dio.get(url);
    return (response.data as List)
        .map((t) => TafsirModel.fromJson(t as Map<String, dynamic>))
        .toList();
  }

  // === Вспомогательные методы для парсинга ===

  /// Парсинг списка сур из JSON массива
  static List<SurahModel> parseSurahList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => SurahModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Парсинг списка хадисов из JSON массива
  static List<HadithModel> parseHadithList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => HadithModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
