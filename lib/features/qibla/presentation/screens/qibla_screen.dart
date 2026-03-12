// Экран компаса Киблы
// Показывает направление к Мекке с анимированным компасом

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_muslim/core/theme/app_colors.dart';
import 'package:noor_muslim/core/widgets/city_selection_dialog.dart';
import 'package:noor_muslim/features/qibla/presentation/providers/qibla_provider.dart';

/// Экран направления Киблы с компасом.
/// Компас вращается в реальном времени, указывая на Каабу в Мекке.
class QiblaScreen extends ConsumerWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(qiblaProvider);

    return Scaffold(
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.error != null
                ? _buildError(context, state.error!, ref)
                : _buildCompass(context, state, ref),
      ),
    );
  }

  /// Основной виджет компаса
  Widget _buildCompass(BuildContext context, QiblaState state, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 24),

        // Заголовок
        Text(
          'Направление Киблы',
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),

        // Город — нажимается для выбора
        GestureDetector(
          onTap: () => _showCitySelection(context, ref, state),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: AppColors.subtleText, size: 16),
              const SizedBox(width: 4),
              Text(
                state.cityName.isNotEmpty ? state.cityName : 'Текущее местоположение',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.subtleText,
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: AppColors.subtleText, size: 20),
            ],
          ),
        ),
        const SizedBox(height: 8),

        Text(
          '${state.qiblaDirection.toStringAsFixed(1)}° от севера',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.subtleText,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Расстояние: ${state.distanceToMecca.toStringAsFixed(0)} км до Мекки',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.subtleText,
          ),
        ),

        // Компас
        Expanded(
          child: Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Внешнее кольцо компаса (вращается с устройством)
                  Transform.rotate(
                    angle: -state.compassHeading * (math.pi / 180),
                    child: CustomPaint(
                      size: const Size(300, 300),
                      painter: _CompassPainter(theme: theme),
                    ),
                  ),

                  // Стрелка Киблы (указывает на Мекку)
                  Transform.rotate(
                    angle: state.qiblaAngleOnCompass * (math.pi / 180),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.navigation,
                          size: 60,
                          color: AppColors.primaryGreen,
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),

                  // Центр компаса — иконка Каабы
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.darkBackground,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.gold,
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'الكعبة',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Подсказка
        Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.primaryGreen),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Держите телефон горизонтально. Зелёная стрелка указывает направление Киблы.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Показать диалог выбора города
  Future<void> _showCitySelection(
    BuildContext context,
    WidgetRef ref,
    QiblaState state,
  ) async {
    final city = await CitySelectionDialog.show(
      context,
      currentCity: state.selectedCity,
    );
    if (city != null) {
      ref.read(qiblaProvider.notifier).selectCity(city);
    }
  }

  /// Ошибка
  Widget _buildError(BuildContext context, String error, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.explore_off, size: 64, color: AppColors.gold),
            const SizedBox(height: 16),
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () async {
                final city = await CitySelectionDialog.show(context);
                if (city != null) {
                  ref.read(qiblaProvider.notifier).selectCity(city);
                }
              },
              icon: const Icon(Icons.location_city),
              label: const Text('Выбрать город вручную'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Рисует круговую разметку компаса с делениями и сторонами света
class _CompassPainter extends CustomPainter {
  final ThemeData theme;

  _CompassPainter({required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Внешний круг
    final outerPaint = Paint()
      ..color = AppColors.subtleText.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, outerPaint);

    // Деления каждые 30°
    for (int i = 0; i < 360; i += 30) {
      final angle = i * math.pi / 180;
      final isCardinal = i % 90 == 0;
      final innerRadius = radius - (isCardinal ? 20 : 12);

      final outer = Offset(
        center.dx + radius * math.cos(angle - math.pi / 2),
        center.dy + radius * math.sin(angle - math.pi / 2),
      );
      final inner = Offset(
        center.dx + innerRadius * math.cos(angle - math.pi / 2),
        center.dy + innerRadius * math.sin(angle - math.pi / 2),
      );

      final tickPaint = Paint()
        ..color = isCardinal ? AppColors.gold : AppColors.subtleText
        ..strokeWidth = isCardinal ? 3 : 1;
      canvas.drawLine(inner, outer, tickPaint);

      // Подписи сторон света
      if (isCardinal) {
        final labels = {0: 'С', 90: 'В', 180: 'Ю', 270: 'З'};
        final label = labels[i] ?? '';
        final textPainter = TextPainter(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: i == 0 ? Colors.red : AppColors.subtleText,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final labelRadius = radius - 35;
        final labelOffset = Offset(
          center.dx + labelRadius * math.cos(angle - math.pi / 2) - textPainter.width / 2,
          center.dy + labelRadius * math.sin(angle - math.pi / 2) - textPainter.height / 2,
        );
        textPainter.paint(canvas, labelOffset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
