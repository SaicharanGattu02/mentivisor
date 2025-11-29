import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import '../firebase_options.dart';
import 'SecureStorageService.dart';

// Global Navigator Key
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
  );

  /// Simple logger
  void _log(String tag, dynamic data) {
    debugPrint("[$tag] ${jsonEncode(data)}");
  }

  /// Initialize all Firebase + Notification Services
  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    _log("INIT", {"status": "Firebase Initialized"});

    // Crashlytics Hooks
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      FirebaseCrashlytics.instance.recordFlutterError(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    Isolate.current.addErrorListener(
      RawReceivePort((pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        await FirebaseCrashlytics.instance.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last,
          fatal: true,
        );
      }).sendPort,
    );

    // Orientation
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Firebase Messaging Background Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    final messaging = FirebaseMessaging.instance;

    // Permissions
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    if (Platform.isIOS) {
      await messaging.getAPNSToken();
    }

    // Save FCM Token
    final fcmToken = await messaging.getToken();
    _log("TOKEN", {"fcm_token": fcmToken});
    if (fcmToken != null) {
      await SecureStorageService.instance.setString("fb_token", fcmToken);
    }

    // Foreground Presentation (iOS)
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Local Notifications Init
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: iosInit,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // LOCAL notification tap
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          _log("LOCAL_TAP", data);
          _handleNotificationTap(data);
        }
      },
    );

    // Create Android Channel
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // Foreground Listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _log("FOREGROUND_FCM", message.data);
      final notification = message.notification;
      final android = message.notification?.android;
      if (notification != null && android != null) {
        showNotification(notification, android, message.data);
      }
    });

    // Tray tap (background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _log("BACKGROUND_TAP", message.data);
      _handleNotificationTap(message.data);
    });

    // Terminated app → opened by notification
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _log("TERMINATED_LAUNCH", initialMessage.data);
      _handleNotificationTap(initialMessage.data);
    }
  }

  /// Show local notification for foreground
  Future<void> showNotification(
    RemoteNotification notification,
    AndroidNotification android,
    Map<String, dynamic> data,
  ) async {
    _log("SHOW_LOCAL_NOTIFICATION", data);

    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    final details = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: jsonEncode(data),
    );
  }

  /// Handle navigation
  void _handleNotificationTap(Map<String, dynamic> data) {
    final String? type = data['content_type'];
    final String? role = data['role'];
    final String? id = data['content_id'];
    _log("NOTIFICATION_PAYLOAD", data);
    String? route;
    if (type == null) {
      _log("ERROR", "Missing notification type");
      return;
    }

    switch (type) {
      // -------------------------
      // COMMUNITY
      // -------------------------
      case 'community':
        route = '/community_details/$id';
        break;

      // -------------------------
      // STUDYZONE
      // -------------------------
      case 'studyzone':
        route = '/resource_details_screen/$id';
        break;

      // -------------------------
      // ECC
      // -------------------------
      case 'ecc':
        route = '/view_event/$id';
        break;

      // -------------------------
      // TASK
      // -------------------------
      case 'task':
        route = '/productivity_screen';
        break;
      // -------------------------
      // SESSION
      // -------------------------
      case 'session':
        if (role == 'mentee') {
          route = '/upcoming_session';
        } else if (role == 'mentor') {
          route = '/mentor_dashboard';
        }
        break;

      // -------------------------
      // EXPERTISE
      // -------------------------
      case 'expertise':
        route = '/update_expertise';
        break;
      // -------------------------
      // REWARDS
      // -------------------------
      case 'rewards':
        route = '/wallet_screen';
        break;

      default:
        _log("UNKNOWN_TYPE", type);
        return;
    }

    _log("NAVIGATION_ROUTE", route);

    if (route != null && rootNavigatorKey.currentContext != null) {
      rootNavigatorKey.currentContext!.push(route, extra: data);
    }
  }
}

/// Background FCM handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("[BACKGROUND_HANDLER] ${jsonEncode(message.data)}");
}
