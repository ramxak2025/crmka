// Сервис уведомлений
// Отправляет напоминания о времени намаза

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:noor_muslim/models/prayer_times_model.dart';
import 'package:noor_muslim/core/constants/prayer_constants.dart';

/// Сервис локальных уведомлений для напоминания о намазе.
/// Планирует уведомления на каждую молитву дня.
class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Инициализация сервиса уведомлений
  Future<void> initialize() async {
    // Настройки для Android
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // Настройки для iOS
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  /// Запланировать уведомления для всех молитв дня
  Future<void> schedulePrayerNotifications(PrayerTimesModel prayerTimes) async {
    // Сначала отменяем все предыдущие уведомления
    await _notifications.cancelAll();

    final now = DateTime.now();

    for (final prayer in prayerTimes.allPrayers) {
      // Пропускаем восход — это не молитва
      if (prayer.key == 'sunrise') continue;

      // Планируем только будущие молитвы
      if (prayer.value.isAfter(now)) {
        await _scheduleNotification(
          id: prayer.key.hashCode,
          title: 'Время намаза',
          body: 'Наступило время ${PrayerNames.russian[prayer.key]} (${PrayerNames.arabic[prayer.key]})',
          scheduledTime: prayer.value,
        );
      }
    }
  }

  /// Запланировать одно уведомление
  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'prayer_times', // ID канала
      'Время намаза', // Название канала
      channelDescription: 'Уведомления о времени намаза',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notifications.schedule(
      id,
      title,
      body,
      scheduledTime,
      details,
    );
  }

  /// Отменить все уведомления
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
