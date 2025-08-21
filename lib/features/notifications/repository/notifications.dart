import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rent_app/firebase_options.dart';

/// Global [FlutterLocalNotificationsPlugin] instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin =
    FlutterLocalNotificationsPlugin();

/// 🔔 Top-level function for handling notification taps
@pragma('vm:entry-point')
void onNotificationTap(NotificationResponse response) {
  log('User tapped notification with payload: ${response.payload}');
}

/// 🔔 Top-level background handler for FCM
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService._initializeLocalNotification();
  await NotificationService._showFlutterNotification(message);
}

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Initialize notification service
  Future<void> initializeNotification() async {
    // Request permission for notifications
    await _firebaseMessaging.requestPermission();

    // Foreground message listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Foreground message: ${message.notification?.title}');
      _showFlutterNotification(message);
    });

    await _getFcmToken();
    await _initializeLocalNotification();
    await _getInitialNotification();
  }

  /// Fetch FCM token
  Future<void> _getFcmToken() async {
    String? token = await _firebaseMessaging.getToken();
    log('FCM Token: $token');
  }

  /// Show notification using flutter_local_notifications
  static Future<void> _showFlutterNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    Map<String, dynamic> data = message.data;

    String title = notification?.title ?? data['title'] ?? 'No Title';
    String body = notification?.body ?? data['body'] ?? 'No Body';

    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'Notification channel for Rent App',
      priority: Priority.high,
      importance: Importance.high,
    );

    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationPlugin.show(
      0,
      title,
      body,
      platformDetails,
      payload: data.toString(),
    );
  }

  /// Initialize local notifications (Android + iOS)
  static Future<void> _initializeLocalNotification() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@drawable/loginpageimage');

    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await flutterLocalNotificationPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onNotificationTap, // Foreground taps
      onDidReceiveBackgroundNotificationResponse:
          onNotificationTap, // Background taps
    );
  }

  /// Handle app opened from terminated state
  static Future<void> _getInitialNotification() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      log('App launched from terminated state via notification: ${message.data}');
    }
  }
}
