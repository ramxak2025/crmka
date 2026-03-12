// Диалог выбора города для расчёта времени намаза
// Поддерживает поиск по названию города и страны

import 'package:flutter/material.dart';
import 'package:noor_muslim/core/constants/city_constants.dart';
import 'package:noor_muslim/core/theme/app_colors.dart';

/// Диалог выбора города.
/// Возвращает выбранный [CityData] или null если пользователь закрыл.
class CitySelectionDialog extends StatefulWidget {
  final CityData? currentCity;

  const CitySelectionDialog({super.key, this.currentCity});

  /// Показать диалог и вернуть выбранный город
  static Future<CityData?> show(BuildContext context, {CityData? currentCity}) {
    return showModalBottomSheet<CityData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CitySelectionDialog(currentCity: currentCity),
    );
  }

  @override
  State<CitySelectionDialog> createState() => _CitySelectionDialogState();
}

class _CitySelectionDialogState extends State<CitySelectionDialog> {
  final _searchController = TextEditingController();
  List<CityData> _filteredCities = CityDatabase.cities;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _filteredCities = CityDatabase.search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Ручка
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.subtleText.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Заголовок
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Выберите город',
              style: theme.textTheme.titleLarge,
            ),
          ),

          // Поиск
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Поиск города...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Список городов
          Expanded(
            child: _filteredCities.isEmpty
                ? Center(
                    child: Text(
                      'Город не найден',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.subtleText,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredCities.length,
                    itemBuilder: (context, index) {
                      final city = _filteredCities[index];
                      final isSelected = widget.currentCity != null &&
                          widget.currentCity!.name == city.name &&
                          widget.currentCity!.country == city.country;

                      return ListTile(
                        leading: Icon(
                          Icons.location_city,
                          color: isSelected
                              ? AppColors.primaryGreen
                              : AppColors.subtleText,
                        ),
                        title: Text(
                          city.name,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? AppColors.primaryGreen
                                : null,
                          ),
                        ),
                        subtitle: Text(city.country),
                        trailing: isSelected
                            ? const Icon(
                                Icons.check_circle,
                                color: AppColors.primaryGreen,
                              )
                            : null,
                        onTap: () => Navigator.of(context).pop(city),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
