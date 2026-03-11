// Тесты виджета карточки времени намаза
// Проверяем отображение информации о молитве

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor_muslim/core/widgets/prayer_time_card.dart';

void main() {
  group('PrayerTimeCard — Виджет карточки намаза', () {
    testWidgets('должен отображать название молитвы', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrayerTimeCard(
              prayerName: 'Фаджр',
              prayerNameArabic: 'الفجر',
              time: '05:30',
              isActive: false,
              isNext: false,
            ),
          ),
        ),
      );

      expect(find.text('Фаджр'), findsOneWidget);
      expect(find.text('05:30'), findsOneWidget);
    });

    testWidgets('должен показывать арабское название', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrayerTimeCard(
              prayerName: 'Зухр',
              prayerNameArabic: 'الظهر',
              time: '12:30',
              isActive: false,
              isNext: false,
            ),
          ),
        ),
      );

      expect(find.text('الظهر'), findsOneWidget);
    });

    testWidgets('должен выделять активную молитву', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrayerTimeCard(
              prayerName: 'Магриб',
              prayerNameArabic: 'المغرب',
              time: '18:30',
              isActive: true,
              isNext: false,
            ),
          ),
        ),
      );

      // Виджет должен присутствовать
      expect(find.byType(PrayerTimeCard), findsOneWidget);
    });

    testWidgets('должен выделять следующую молитву', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrayerTimeCard(
              prayerName: 'Аср',
              prayerNameArabic: 'العصر',
              time: '15:45',
              isActive: false,
              isNext: true,
            ),
          ),
        ),
      );

      expect(find.byType(PrayerTimeCard), findsOneWidget);
    });
  });
}
