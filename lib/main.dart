// Точка входа приложения Noor Muslim
// Инициализация Riverpod, темы и навигации

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_muslim/core/theme/app_theme.dart';
import 'package:noor_muslim/features/home/presentation/screens/home_screen.dart';

/// Точка входа в приложение
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Устанавливаем портретную ориентацию
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Стиль системной панели
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    // Riverpod — оборачиваем всё приложение в ProviderScope
    const ProviderScope(
      child: NoorMuslimApp(),
    ),
  );
}

/// Корневой виджет приложения.
/// Настраивает тему, локализацию и навигацию.
class NoorMuslimApp extends StatelessWidget {
  const NoorMuslimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noor Muslim',
      debugShowCheckedModeBanner: false,

      // Тема приложения — тёмная по умолчанию (красиво для исламского приложения)
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      // Главный экран
      home: const HomeScreen(),
    );
  }
}
