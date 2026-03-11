// Экран хадисов
// Показывает хадис дня, сборники и поиск

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_muslim/core/theme/app_colors.dart';
import 'package:noor_muslim/core/widgets/islamic_card.dart';
import 'package:noor_muslim/core/widgets/shimmer_loading.dart';
import 'package:noor_muslim/features/hadith/presentation/providers/hadith_provider.dart';
import 'package:noor_muslim/models/hadith_model.dart';

/// Экран хадисов — изречений Пророка (мир ему).
/// Включает хадис дня, выбор сборника и поиск.
class HadithScreen extends ConsumerWidget {
  const HadithScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(hadithProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Заголовок
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Хадисы',
                  style: theme.textTheme.displayMedium,
                ),
              ),
            ),

            // Поиск
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Поиск хадиса...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                  ),
                  onSubmitted: (query) {
                    ref.read(hadithProvider.notifier).search(query);
                  },
                ),
              ),
            ),

            // Хадис дня
            if (state.hadithOfTheDay != null)
              SliverToBoxAdapter(
                child: _buildHadithOfTheDay(context, state.hadithOfTheDay!),
              ),

            // Сборники хадисов
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'Сборники',
                  style: theme.textTheme.headlineMedium,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: HadithCollection.values.length,
                  itemBuilder: (context, index) {
                    final collection = HadithCollection.values[index];
                    final isSelected = state.selectedCollection == collection;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _buildCollectionChip(
                        context,
                        collection,
                        isSelected,
                        () => ref.read(hadithProvider.notifier).selectCollection(collection),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Список хадисов
            if (state.isLoading && state.hadiths.isEmpty)
              SliverToBoxAdapter(
                child: ShimmerLoading.listSkeleton(itemCount: 3),
              )
            else if (state.searchResults.isNotEmpty)
              _buildHadithList(state.searchResults)
            else if (state.hadiths.isNotEmpty)
              _buildHadithList(state.hadiths),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  /// Карточка «Хадис дня»
  Widget _buildHadithOfTheDay(BuildContext context, HadithModel hadith) {
    return IslamicCard(
      showPattern: true,
      gradient: AppColors.goldGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Хадис дня',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Арабский текст
          Text(
            hadith.textArabic,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Amiri',
              height: 2,
            ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 12),

          // Русский перевод
          Text(
            hadith.textRussian,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),

          // Источник
          Text(
            '${hadith.narrator} | ${hadith.reference}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),

          // Степень достоверности
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              hadith.grade.nameRussian,
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  /// Чип выбора сборника
  Widget _buildCollectionChip(
    BuildContext context,
    HadithCollection collection,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 140,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? null : Border.all(color: AppColors.subtleText.withOpacity(0.2)),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              collection.nameArabic,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.subtleText,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              collection.nameRussian,
              style: TextStyle(
                color: isSelected ? Colors.white : null,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Список хадисов
  SliverList _buildHadithList(List<HadithModel> hadiths) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final hadith = hadiths[index];
          return _buildHadithTile(context, hadith);
        },
        childCount: hadiths.length,
      ),
    );
  }

  /// Плитка одного хадиса
  Widget _buildHadithTile(BuildContext context, HadithModel hadith) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Text(
          hadith.textRussian,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium,
        ),
        subtitle: Text(
          '${hadith.collection.nameRussian} | ${hadith.reference}',
          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.subtleText),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Арабский текст
                Text(
                  hadith.textArabic,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Amiri',
                    height: 2,
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 12),
                // Полный русский перевод
                Text(
                  hadith.textRussian,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                ),
                const SizedBox(height: 12),
                // Передатчик
                Text(
                  'Передал: ${hadith.narrator}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Степень достоверности
                const SizedBox(height: 4),
                Text(
                  hadith.grade.nameRussian,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.gold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
