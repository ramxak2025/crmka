// Экран детального просмотра суры
// Показывает все аяты с арабским текстом, переводом и тафсиром

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_muslim/core/theme/app_colors.dart';
import 'package:noor_muslim/core/widgets/shimmer_loading.dart';
import 'package:noor_muslim/features/quran/presentation/providers/quran_provider.dart';
import 'package:noor_muslim/models/surah_model.dart';
import 'package:noor_muslim/models/tafsir_model.dart';

/// Экран детального просмотра суры с аятами.
/// Каждый аят показывает арабский текст, перевод на русский.
/// При нажатии на аят открывается тафсир.
class SurahDetailScreen extends ConsumerWidget {
  final int surahNumber;

  const SurahDetailScreen({super.key, required this.surahNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quranProvider);
    final theme = Theme.of(context);
    final surah = state.currentSurah;

    return Scaffold(
      appBar: AppBar(
        title: Text(surah?.nameRussian ?? 'Загрузка...'),
        actions: [
          if (surah != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                surah.nameArabic,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Amiri',
                  color: AppColors.gold,
                ),
              ),
            ),
        ],
      ),
      body: state.isLoading
          ? ShimmerLoading.listSkeleton(itemCount: 5)
          : surah == null
              ? const Center(child: Text('Сура не найдена'))
              : _buildAyahList(context, ref, surah, state),
    );
  }

  /// Список аятов суры
  Widget _buildAyahList(
    BuildContext context,
    WidgetRef ref,
    SurahModel surah,
    QuranState state,
  ) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: surah.ayahs.length + 1, // +1 для заголовка
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildSurahHeader(theme, surah);
        }

        final ayah = surah.ayahs[index - 1];
        return _buildAyahCard(context, ref, theme, surah, ayah, state);
      },
    );
  }

  /// Заголовок суры
  Widget _buildSurahHeader(ThemeData theme, SurahModel surah) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.prayerCardGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            surah.nameArabic,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontFamily: 'Amiri',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${surah.nameRussian} (${surah.nameTransliteration})',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            '${surah.ayahCount} аятов · ${surah.revelationType == RevelationType.meccan ? "Мекканская" : "Мединская"}',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          // Бисмиллях (кроме суры Ат-Тауба)
          if (surah.number != 9) ...[
            const SizedBox(height: 16),
            const Divider(color: Colors.white24),
            const SizedBox(height: 8),
            const Text(
              'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَـٰنِ ٱلرَّحِیمِ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Amiri',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Карточка одного аята
  Widget _buildAyahCard(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    SurahModel surah,
    AyahModel ayah,
    QuranState state,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showTafsirDialog(context, ref, surah.number, ayah),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Номер аята
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${ayah.number}',
                        style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Кнопка тафсира
                  IconButton(
                    icon: const Icon(Icons.menu_book, size: 20),
                    color: AppColors.gold,
                    onPressed: () => _showTafsirDialog(context, ref, surah.number, ayah),
                    tooltip: 'Тафсир',
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Арабский текст
              Text(
                ayah.textArabic,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Amiri',
                  height: 2.0,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 12),

              // Перевод на русский
              Text(
                ayah.textRussian,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: AppColors.subtleText,
                ),
              ),

              // Транслитерация (если есть)
              if (ayah.transliteration != null) ...[
                const SizedBox(height: 8),
                Text(
                  ayah.transliteration!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: AppColors.primaryGreen.withOpacity(0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Диалог с тафсиром аята
  void _showTafsirDialog(
    BuildContext context,
    WidgetRef ref,
    int surahNumber,
    AyahModel ayah,
  ) {
    ref.read(quranProvider.notifier).loadTafsir(surahNumber, ayah.number);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(quranProvider);

            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 0.95,
              minChildSize: 0.3,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      // Ручка для перетаскивания
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(top: 12),
                        decoration: BoxDecoration(
                          color: AppColors.subtleText,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // Заголовок
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Тафсир — Аят ${ayah.number}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      // Выбор тафсира
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: TafsirSource.values.map((source) {
                            final isSelected = state.selectedTafsirSource == source;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(source.nameRussian),
                                selected: isSelected,
                                onSelected: (_) => ref
                                    .read(quranProvider.notifier)
                                    .changeTafsirSource(source),
                                selectedColor: AppColors.primaryGreen,
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : null,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Текст тафсира
                      Expanded(
                        child: state.currentTafsirs.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : ListView(
                                controller: scrollController,
                                padding: const EdgeInsets.all(16),
                                children: state.currentTafsirs
                                    .where((t) => t.source == state.selectedTafsirSource)
                                    .map((tafsir) => Text(
                                          tafsir.textRussian,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(height: 1.8),
                                        ))
                                    .toList(),
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
