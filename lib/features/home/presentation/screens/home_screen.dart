// Главный экран с нижней навигацией
// Переключение между 4 основными разделами приложения

import 'package:flutter/material.dart';
import 'package:noor_muslim/core/theme/app_colors.dart';
import 'package:noor_muslim/features/prayer_times/presentation/screens/prayer_times_screen.dart';
import 'package:noor_muslim/features/qibla/presentation/screens/qibla_screen.dart';
import 'package:noor_muslim/features/hadith/presentation/screens/hadith_screen.dart';
import 'package:noor_muslim/features/quran/presentation/screens/quran_screen.dart';

/// Главный экран приложения с навигацией.
/// Содержит 4 раздела: Намаз, Кибла, Хадисы, Коран.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  /// Экраны разделов
  final List<Widget> _screens = const [
    PrayerTimesScreen(),
    QiblaScreen(),
    HadithScreen(),
    QuranScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.access_time_outlined),
            selectedIcon: Icon(Icons.access_time_filled),
            label: 'Намаз',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Кибла',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories),
            label: 'Хадисы',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Коран',
          ),
        ],
      ),
    );
  }
}
