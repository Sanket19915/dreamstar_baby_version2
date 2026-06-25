import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:dream_baby/services/home_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('FCM background: ${message.messageId}');
  }
}

class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const _androidChannel = AndroidNotificationChannel(
    'daily_reminders',
    'Daily Reminders',
    description: 'Daily Garbhasanskar activity reminders',
    importance: Importance.high,
  );

  static const _dailyReminderId = 1001;

  String? _deviceId;

  void setDeviceId(String? deviceId) {
    _deviceId = deviceId;
  }

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _local.initialize(
      settings: const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: (_) {},
    );

    if (Platform.isAndroid) {
      await _local
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_androidChannel);
    }

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_showForegroundFcm);
    FirebaseMessaging.onMessageOpenedApp.listen(_onFcmOpened);
    FirebaseMessaging.instance.onTokenRefresh.listen(_onTokenRefresh);

    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) _onFcmOpened(initial);
  }

  Future<bool> requestPermissions() async {
    final fcm = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final granted = fcm.authorizationStatus == AuthorizationStatus.authorized ||
        fcm.authorizationStatus == AuthorizationStatus.provisional;

    if (Platform.isIOS) {
      await _local
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    if (Platform.isAndroid) {
      await _local
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    return granted;
  }

  Future<void> scheduleDailyReminder({int hour = 9, int minute = 0}) async {
    await _local.cancel(id: _dailyReminderId);

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _local.zonedSchedule(
      id: _dailyReminderId,
      title: 'DreamStar Baby',
      body: 'Time for today\'s Garbhasanskar activities!',
      scheduledDate: scheduled,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _showForegroundFcm(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _local.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  void _onFcmOpened(RemoteMessage message) {
    if (kDebugMode) {
      print('Notification opened: ${message.data}');
    }
  }

  Future<void> _onTokenRefresh(String token) async {
    try {
      await HomeService.fetchActiveUser(
        deviceId: _deviceId,
        fcmToken: token,
      );
    } catch (_) {}
  }
}

final pushNotificationService = PushNotificationService.instance;
