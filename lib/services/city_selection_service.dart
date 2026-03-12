// Сервис сохранения и загрузки выбранного города
// Использует SharedPreferences для хранения выбора пользователя

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noor_muslim/core/constants/city_constants.dart';

/// Сервис управления выбранным городом.
/// Сохраняет выбор в SharedPreferences для использования без GPS.
class CitySelectionService {
  static const String _key = 'selected_city';

  /// Сохранить выбранный город
  static Future<void> saveCity(CityData city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(city.toJson()));
  }

  /// Загрузить сохранённый город (null если не выбран)
  static Future<CityData?> loadCity() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return null;
    return CityData.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  /// Очистить выбранный город (вернуться к GPS)
  static Future<void> clearCity() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  /// Проверить, выбран ли город вручную
  static Future<bool> hasSavedCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_key);
  }
}
