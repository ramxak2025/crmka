// Справочник арабского алфавита
// Показывает все 28 букв с возможностью открыть детальный экран буквы

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_muslim/core/theme/app_colors.dart';
import 'package:noor_muslim/models/arabic_learning_model.dart';
import 'package:noor_muslim/features/arabic_learning/presentation/providers/arabic_learning_provider.dart';
import 'package:noor_muslim/features/arabic_learning/presentation/screens/letter_detail_screen.dart';

/// Экран-справочник арабского алфавита.
/// Показывает сетку из 28 букв с возможностью фильтрации по группам.
class AlphabetScreen extends ConsumerStatefulWidget {
  const AlphabetScreen({super.key});

  @override
  ConsumerState<AlphabetScreen> createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends ConsumerState<AlphabetScreen> {
  LetterGroup? _selectedGroup;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(arabicLearningProvider);
    final theme = Theme.of(context);

    // Фильтрация по группе
    final filteredLetters = _selectedGroup != null
        ? state.alphabet.where((l) => l.group == _selectedGroup).toList()
        : state.alphabet;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Арабский алфавит'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Фильтр по группам
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildFilterChip(null, 'Все', context),
                ...LetterGroup.values.map(
                  (g) => _buildFilterChip(g, g.nameRussian, context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Сетка букв
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: filteredLetters.length,
              itemBuilder: (context, index) {
                return _buildLetterTile(context, ref, filteredLetters[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Чип фильтра
  Widget _buildFilterChip(LetterGroup? group, String label, BuildContext context) {
    final isSelected = _selectedGroup == group;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: TextStyle(fontSize: 12)),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedGroup = group),
        selectedColor: AppColors.primaryGreen,
        labelStyle: TextStyle(color: isSelected ? Colors.white : null),
        checkmarkColor: Colors.white,
      ),
    );
  }

  /// Плитка одной буквы
  Widget _buildLetterTile(BuildContext context, WidgetRef ref, ArabicLetter letter) {
    // Цвет зависит от группы
    final groupColors = {
      LetterGroup.easyFamiliar: AppColors.primaryGreen,
      LetterGroup.guttural: const Color(0xFFE67E22),
      LetterGroup.emphatic: const Color(0xFFE74C3C),
      LetterGroup.solarLunar: const Color(0xFF3498DB),
    };
    final color = groupColors[letter.group] ?? AppColors.primaryGreen;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          ref.read(arabicLearningProvider.notifier).showLetter(letter.order);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => LetterDetailScreen(initialLetterOrder: letter.order),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Арабская буква
            Text(
              letter.isolated,
              style: TextStyle(
                fontSize: 36,
                fontFamily: 'Amiri',
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            // Русское название
            Text(
              letter.nameRussian,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.subtleText,
                    fontSize: 10,
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // Номер
            Text(
              '${letter.order}',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.subtleText.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
