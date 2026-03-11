// Экран Корана
// Список сур с возможностью чтения аятов и тафсиров

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_muslim/core/theme/app_colors.dart';
import 'package:noor_muslim/core/widgets/shimmer_loading.dart';
import 'package:noor_muslim/features/quran/presentation/providers/quran_provider.dart';
import 'package:noor_muslim/features/quran/presentation/screens/surah_detail_screen.dart';
import 'package:noor_muslim/models/surah_model.dart';

/// Экран Корана — список всех 114 сур.
/// Поддерживает поиск и фильтрацию по месту ниспослания.
class QuranScreen extends ConsumerStatefulWidget {
  const QuranScreen({super.key});

  @override
  ConsumerState<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends ConsumerState<QuranScreen> {
  RevelationType? _filter;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quranProvider);
    final theme = Theme.of(context);

    // Фильтрация сур
    var filteredSurahs = state.surahs;
    if (_filter != null) {
      filteredSurahs = filteredSurahs.where((s) => s.revelationType == _filter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      filteredSurahs = filteredSurahs
          .where((s) =>
              s.nameRussian.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.nameTransliteration.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.number.toString() == _searchQuery)
          .toList();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Коран', style: theme.textTheme.displayMedium),
            ),

            // Строка «Бисмиллях»
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَـٰنِ ٱلرَّحِیمِ',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Amiri',
                  color: AppColors.gold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),

            // Поиск
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Поиск суры...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            const SizedBox(height: 8),

            // Фильтры: Мекканские / Мединские
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip('Все', null),
                  const SizedBox(width: 8),
                  _buildFilterChip('Мекканские', RevelationType.meccan),
                  const SizedBox(width: 8),
                  _buildFilterChip('Мединские', RevelationType.medinan),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Список сур
            Expanded(
              child: state.isLoading
                  ? ShimmerLoading.listSkeleton(itemCount: 10)
                  : ListView.builder(
                      itemCount: filteredSurahs.length,
                      itemBuilder: (context, index) {
                        return _buildSurahTile(context, filteredSurahs[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Чип фильтрации
  Widget _buildFilterChip(String label, RevelationType? type) {
    final isSelected = _filter == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => setState(() => _filter = selected ? type : null),
      selectedColor: AppColors.primaryGreen,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
        fontSize: 12,
      ),
    );
  }

  /// Плитка одной суры
  Widget _buildSurahTile(BuildContext context, SurahModel surah) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            '${surah.number}',
            style: TextStyle(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      title: Text(
        surah.nameRussian,
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Text(
        '${surah.nameTransliteration} · ${surah.ayahCount} аятов · '
        '${surah.revelationType == RevelationType.meccan ? "Мекканская" : "Мединская"}',
        style: theme.textTheme.bodySmall?.copyWith(color: AppColors.subtleText),
      ),
      trailing: Text(
        surah.nameArabic,
        style: const TextStyle(
          fontSize: 22,
          fontFamily: 'Amiri',
          color: AppColors.gold,
        ),
      ),
      onTap: () {
        ref.read(quranProvider.notifier).openSurah(surah.number);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SurahDetailScreen(surahNumber: surah.number),
          ),
        );
      },
    );
  }
}
