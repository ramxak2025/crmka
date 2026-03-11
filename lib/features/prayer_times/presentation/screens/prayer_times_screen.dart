// Экран времени намаза
// Главный экран с расписанием всех молитв на день

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noor_muslim/core/constants/prayer_constants.dart';
import 'package:noor_muslim/core/theme/app_colors.dart';
import 'package:noor_muslim/core/widgets/islamic_card.dart';
import 'package:noor_muslim/core/widgets/prayer_time_card.dart';
import 'package:noor_muslim/core/widgets/shimmer_loading.dart';
import 'package:noor_muslim/features/prayer_times/presentation/providers/prayer_times_provider.dart';

/// Экран расписания намаза.
/// Показывает все 6 времён молитв с обратным отсчётом до следующей.
class PrayerTimesScreen extends ConsumerWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prayerTimesProvider);

    return Scaffold(
      body: SafeArea(
        child: state.isLoading
            ? _buildLoading()
            : state.error != null
                ? _buildError(context, state.error!, ref)
                : _buildContent(context, state),
      ),
    );
  }

  /// Контент экрана с данными
  Widget _buildContent(BuildContext context, PrayerTimesState state) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('HH:mm');

    return CustomScrollView(
      slivers: [
        // Заголовок с обратным отсчётом
        SliverToBoxAdapter(
          child: _buildHeader(context, state, timeFormat),
        ),

        // Хиджри дата
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              DateFormat('d MMMM yyyy', 'ru').format(DateTime.now()),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.subtleText,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // Список времён молитв
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final prayer = state.prayerTimes!.allPrayers[index];
              final isActive = state.currentPrayer == prayer.key;
              final isNext = state.nextPrayer?.key == prayer.key;

              return PrayerTimeCard(
                prayerName: PrayerNames.russian[prayer.key] ?? prayer.key,
                prayerNameArabic: PrayerNames.arabic[prayer.key] ?? '',
                time: timeFormat.format(prayer.value),
                isActive: isActive,
                isNext: isNext,
              );
            },
            childCount: 6,
          ),
        ),

        // Отступ снизу
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  /// Заголовок с карточкой обратного отсчёта
  Widget _buildHeader(
    BuildContext context,
    PrayerTimesState state,
    DateFormat timeFormat,
  ) {
    return IslamicCard(
      showPattern: true,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Город
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              Text(
                state.cityName.isNotEmpty ? state.cityName : 'Текущее местоположение',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Название следующей молитвы
          if (state.nextPrayer != null) ...[
            Text(
              'До ${PrayerNames.russian[state.nextPrayer!.key]}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),

            // Обратный отсчёт
            Text(
              _formatDuration(state.timeUntilNext),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              timeFormat.format(state.nextPrayer!.value),
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
          ] else
            const Text(
              'Все молитвы на сегодня завершены',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
        ],
      ),
    );
  }

  /// Форматирование Duration в "ЧЧ:ММ:СС"
  String _formatDuration(Duration? duration) {
    if (duration == null) return '--:--:--';
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  /// Состояние загрузки
  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          const ShimmerLoading(height: 180),
          const SizedBox(height: 16),
          ShimmerLoading.listSkeleton(),
        ],
      ),
    );
  }

  /// Экран ошибки
  Widget _buildError(BuildContext context, String error, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.gold),
            const SizedBox(height: 16),
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.read(prayerTimesProvider.notifier).refresh(),
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}
